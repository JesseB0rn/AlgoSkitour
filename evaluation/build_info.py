import os
import json

# Define the directory containing the JSON files
directory = '/Users/jesseb0rn/Documents/repos/Maturaarbeit-AlgoSkitour/evaluation/sac_routen'

aggregate_geojson = {
    "type": "FeatureCollection",
    "crs": {
        "type": "name",
        "properties": {
            "name": "urn:ogc:def:crs:EPSG::2056"
        }
    },
    "features": []
}
exclude_keys = ['geom']

# Loop over all files in the directory
for filename in os.listdir(directory):
    if filename.endswith('.json'):
        file_path = os.path.join(directory, filename)
        with open(file_path, 'r') as json_file:
            data = json.load(json_file)
            try:
              for seg in data['segments']:
                if seg['geom'] and not seg['alternative']:
                   pass
                   aggregate_geojson['features'] += [{'type': 'Feature', 'geometry': seg['geom'].copy(), 'properties': {k: seg[k] for k in set(list(seg.keys())) - set(exclude_keys)}}]
            except:
                raise Exception("Downloaded with expired cookie")
            # Process the JSON data here
        pass
            
print(json.dumps(aggregate_geojson))