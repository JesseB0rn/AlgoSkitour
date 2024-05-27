import numpy as np
import metalcompute as mc
import rasterio as rio
import matplotlib.pyplot as plt
import matplotlib.animation as animation

dev = mc.Device()

def get_config():
    config = f"""
#define ENTRAINMENT_COEFF 0.5
#define MUH_ZERO 0.475
//              ^ 0.40 <= MUH_0 <= 0.55
#define XI_ZERO 500.0
//              ^ 300 <= XI_0 <= 800
#define R_ZERO 5.5
//              ^ 4 <= R_0 <= 7
#define alpha 0.20
#define beta 1.0
#define c_sound 350

#define INSIZE 2000
#define SIZE 200
#define resolution 5.0
#define cell_area 25.0
#define dt 0.005

#define NO_CONFIG_FILE 1
"""
    return config

def build_kernels():
    kernel_sources = [["simulation2.metal", ["firstPass", "secondPass"]],
                      ["map_prep.metal", ["prepareMap", "resampleToSize"]]]
    config = get_config()
    kernels = []
    ckfn = []
    for ks, kfns in kernel_sources:
        with open(ks) as k:
            kernels += [dev.kernel(config + k.read())]
            ckfn += [[]]
        for kf in kfns:
            ckfn[-1] += [kernels[-1].function(kf)]
    return ckfn

def load_terrain():
    dataset = rio.open('.tiles/2691_1201_0.5.tif')
    arr = np.array(dataset.read(1))
    return arr

def main():
    [firstPass_fn, secondPass_fn], [prepGrav_fn, prepResize_fn] = build_kernels()
    terrain = load_terrain()

    resizedb = dev.buffer(200 * 200 * 4)
    han_res = prepResize_fn(200 * 200, terrain.ravel(), resizedb)
    del han_res

    gravb = dev.buffer(200 * 200 * 4 * 4)
    han_prep = prepGrav_fn(200 * 200, resizedb, gravb)
    del han_prep

    fracture_depth = 0.45
    snowcover = np.full(200 * 200, 0.70, dtype="f").reshape((200, 200))
    states = np.zeros(200 * 200 * 4, dtype="f").reshape((200, 200, 4))

    x, y = 25, 75
    w, h = 10, 10

    snowcover[int(x):int(x + w), int(y):int(y + h)] = h - fracture_depth
    states[int(x):int(x + w), int(y):int(y + h)] = [fracture_depth, 0.0, 0.0, 0.0]

    snowcoverb = dev.buffer(snowcover)
    newsnowcoverb = dev.buffer(200 * 200 * 4)
    stateb = dev.buffer(states)
    
    interimState = dev.buffer(200 * 200 * 4 * 4)
    newStateb = dev.buffer(200 * 200 * 4 * 4)

    dt = 0.005
    max_steps = int(60.0 // dt)

    fig, ax = plt.subplots()
    ims = []
    for i in range(0, max_steps):
        fp_han = firstPass_fn(200 * 200, gravb, stateb, interimState)
        del fp_han

        sp_han = secondPass_fn(200 * 200, gravb, stateb, interimState, snowcoverb, newStateb, newsnowcoverb)
        del sp_han

        del stateb
        del snowcoverb

        newState = np.frombuffer(newStateb, dtype="f").reshape((200, 200, 4))
        newsnowcover = np.frombuffer(newsnowcoverb, dtype="f").reshape((200, 200))

        stateb = dev.buffer(newState)
        snowcoverb = dev.buffer(newsnowcover)

        im = ax.imshow(newState[:,:,0], animated=True)
        ims.append([im])

    ani = animation.ArtistAnimation(fig, ims, interval=25, blit=True, repeat_delay=0)
    plt.show()

main()
