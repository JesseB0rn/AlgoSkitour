"""Simple reading pattern example"""

import riomucho
import numpy as np

def riskfn(slope):
    return np.sqrt(1 / (1 + np.exp(-(slope-28.0) / 3.0))) # + np.power((1/45)*slope, 2)

def calculate_grm_risk(slope):
    # return np.maximum(expterm, expterm + ((slope/300) - 0.15))
    return riskfn(slope) / riskfn(90.0)

def read_function(data, window, ij, g_args):
    """Takes an array, and sets any value above the mean to the max, the rest to 0"""
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