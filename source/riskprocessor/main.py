import riomucho
import numpy as np

def riskfn(slope):
    return np.sqrt(1 / (1 + np.exp(-(slope-28.0) / 3.0)))

def calculate_grm_risk(slope: np.ndarray) -> np.ndarray:
    # mask the returned array with nodata if slope is negative/nodata
    rm = riskfn(slope) / riskfn(90.0)
    
    return np.where(slope < 0, -9999.0, rm)

def read_function(data, window, ij, g_args):
    output = calculate_grm_risk(data[0])
    return output

def main():
# Open w/ simple read mode, and work in parallel.
    with riomucho.RioMucho(
        ['/Users/jesseb0rn/Documents/repos/Maturaarbeit-AlgoSkitour/source/tiledownloader/slope.tif'], "./riskmap.tif", read_function, global_args={}
    ) as rm:
        rm.run(4)

if __name__ == '__main__':
    main()