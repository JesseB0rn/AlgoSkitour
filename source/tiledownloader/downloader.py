import csv
import os
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
from tqdm import tqdm

# Function to download a single file
def download_file(url, download_dir):
    try:
        local_filename = os.path.join(download_dir, url.split('/')[-1])
        if (os.path.isfile(local_filename)): 
            return url, "Already downloaded"
        with requests.get(url, stream=True) as response:
            response.raise_for_status()
            with open(local_filename, 'wb') as f:
                for chunk in response.iter_content(chunk_size=8192):
                    f.write(chunk)
        return url, None
    except Exception as e:
        return url, str(e)

# Function to download files from a CSV in parallel
def download_files_from_csv(csv_file, download_dir, max_workers=4):
    # Ensure download directory exists
    os.makedirs(download_dir, exist_ok=True)
    
    # Read URLs from CSV file
    urls = []
    with open(csv_file, newline='') as csvfile:
        csvreader = csv.reader(csvfile)
        for row in csvreader:
            urls.append(row[0])
    
    # Set up progress bar
    progress = tqdm(total=len(urls), desc="Downloading files", unit="file")

    # Download files in parallel
    with ThreadPoolExecutor(max_workers=max_workers) as executor:
        futures = {executor.submit(download_file, url, download_dir): url for url in urls}
        for future in as_completed(futures):
            url = futures[future]
            try:
                url, error = future.result()
                if error:
                    print(f"Failed to download {url}: {error}")
                else:
                    print(f"Successfully downloaded {url}")
            except Exception as e:
                print(f"Error downloading {url}: {str(e)}")
            progress.update(1)
    
    progress.close()

if __name__ == "__main__":
    csv_file = 'tile_list/2m_ti.csv'  # Path to your CSV file
    download_dir = 'dem_tiled/2m_ti'          # Directory where files will be saved
    max_workers = 8                     # Number of parallel threads
    
    download_files_from_csv(csv_file, download_dir, max_workers)
