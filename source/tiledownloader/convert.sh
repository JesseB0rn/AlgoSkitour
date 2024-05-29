find dem_tiled -name '*.tif' > files.txt && gdalbuildvrt swissalps.vrt -input_file_list files.txt

gdalwarp -overwrite -t_srs EPSG:3857 -dstnodata 0.0 -r bilinear -of GTiff /Users/jesseb0rn/Documents/repos/Maturaarbeit-AlgoSkitour/source/tiledownloader/swissalps.vrt /Users/jesseb0rn/Documents/repos/Maturaarbeit-AlgoSkitour/source/tiledownloader/cantons/swissalps_reproj.tif

rio rgbify -b -10000 -i 0.10 cantons/swissalps.tif cantons/swissalps_rgb.tif
gdal2tiles --zoom=9-15 --processes=8 --resampling=near cantons/swissalps_rgb.tif ./tiles_swissalps
mb-util --image_format=png --scheme=tms ./tiles_swissalps/ ./tilesets/swissalps.mbtiles
