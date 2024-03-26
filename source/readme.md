## Binaries

| Bin        | Job                                                        | Input                          | Output                                        |
| ---------- | ---------------------------------------------------------- | ------------------------------ | --------------------------------------------- |
| Lenz       | Downloads Alti3d tiles from a CSV List                     | CSV List with hrefs from STDIN | ~/AlgTour/tmp/tiles/[tile]                    |
| Pollux     | Generates a CSV from a start- and endpoint coord in LV95+  | Point A, Point B               | CSV List with refs to STDOUT                  |
| Finsteraar | Generates the shaded relief for a certain tile             | Path to a tile                 | PNG to ~/AlgTour/out/relief/[tile]            |
| Munter     | Produce danger geotiff                                     | Path to Tile, path to LLB      | ~/AlgTour/tmp/dm/[tile]                       |
| Bernina    | find path through danger map -> waypoints list             | Point A, Point B               | CSV with waypoints in LV95+                   |
| Allalin    | optimize waypoints list                                    | CSV with waypoints in LV95+    | CSV with waypoints in LV95+                   |
| Monch      | Waypoints list to GPX route                                | CSV with waypoints in LV95+    | GPX file to ~/AlgTour/out/tour/[datetime].gpx |
| Strahl     | builds forestation tile from corresponding Alti3d filename | CSV List with hrefs from STDIN | ~/AlgTour/tmp/forestation/[tile]              |
| henry      | Downloads basedata / swisstlm3d                            |                                |                                               |
| **mtour**  | Calls into above                                           | Point A, Point B               | GPX file to ~/AlgTour/out/tour/[datetime].gpx |

# Files and where they live

| Filename        |  job                | Path               |
| --------------- | ------------------- | ------------------ |
| swisstlm3d.gpkg | SwissTLM unpackaged | ~/AlgTour/basedata |
|                 |                     |                    |
