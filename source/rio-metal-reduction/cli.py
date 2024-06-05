import rasterio
import rasterio.drivers
from rasterio.windows import Window
import argparse
import metalcompute as mc
from math import ceil
import numpy as np
import os

TILESIZE = 2048
OVERLAP = 1

parser = argparse.ArgumentParser()
parser.add_argument("infile", help="Input grid file readable by rasterio")
parser.add_argument("out", help="ouput file to write")
parser.add_argument("--overwrite", help="overwrite ouput file if already exists", action="store_true")
args = parser.parse_args()

try:
  os.unlink(args.out)
except OSError:
  pass

width, height = 0, 0

with rasterio.open(args.infile) as src:
    width, height, nodata = src.profile['width'], src.profile['height'], src.profile['nodata']

    with rasterio.open(args.out, mode="w", driver='GTiff', width=width, height=height, count=1, dtype=rasterio.float32, crs=src.profile['crs'], transform=src.profile['transform']) as dst:

      for i in range(ceil(width / (TILESIZE-2*OVERLAP))):
        for j in range(ceil(height / (TILESIZE-2*OVERLAP))):
          offX, offY = i * (TILESIZE-2*OVERLAP) - OVERLAP, j * (TILESIZE-2*OVERLAP) - OVERLAP

          readingWindow = Window(offX, offY, TILESIZE, TILESIZE)

          data = src.read(1, window=readingWindow)
          read_shape = data.shape

          writingWindow = Window(offX + OVERLAP, offY + OVERLAP, read_shape[1]-2*OVERLAP, read_shape[0]-2*OVERLAP)
          dst.write(data, window=writingWindow, indexes=1)


      if i > 0: exit()
      
