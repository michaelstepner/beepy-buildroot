#!/usr/bin/env python3
from bs4 import BeautifulSoup
import fileinput
import re
import subprocess

def fetch_html_with_curl(url: str) -> str:
    try:
        result = subprocess.run(
            ["curl", "-sL", url],  # Silent, follow redirects
            capture_output=True,
            text=True,
            check=True,
        )
        return result.stdout  # HTML content
    except subprocess.CalledProcessError as e:
        raise RuntimeError(f"Failed to fetch URL with curl: {e}")

def find_latest_buildroot_LTS(url: str = "https://buildroot.org/downloads/") -> str:
    # Scrape URL
    print(f"## Checking releases at {url}")
    html = fetch_html_with_curl(url)

    # Parse the HTML
    soup = BeautifulSoup(html, 'html.parser')

    # Regex to match the filenames corresponding to a buildroot LTS release
    buildroot_pattern = re.compile(r"^buildroot-(\d{4})\.02(?:\.(\d+))?\.tar\.xz$")

    # Extract all releases matching the pattern
    buildroot_versions = []
    for link in soup.find_all('a', href=True):
        match = buildroot_pattern.match(link['href'])
        if match:
            year = int(match.group(1))
            patch = int(match.group(2)) if match.group(2) else 0
            filename = link['href']
            release_date = link.parent.find_next('td').get_text()
            # print(f"Found {filename} released on {release_date}")
            buildroot_versions.append((year, patch, filename, release_date))

    # Find the latest version
    if buildroot_versions:
        latest_version = max(buildroot_versions, key=lambda x: (x[0], x[1]))
        print(f"- Latest LTS version: {latest_version[2]}")
        print(f"- Released on: {latest_version[3]}")
        if latest_version[1] == 0:
            return f"{latest_version[0]}.02"
        else:
            return f"{latest_version[0]}.02.{latest_version[1]}"
    else:
        raise ValueError("No matching versions found.")


def update_script(latest_version: str, script_path: str = "build-image.sh") -> None:
    # Update the build-image.sh script with the latest version
    version_pattern = re.compile(r'^(buildroot_version=")\d{4}\.02(?:\.\d+)?(")$')
    
    updated = False
    changed = False
    with fileinput.FileInput(script_path, inplace=True) as file:
        for line in file:
            match = version_pattern.match(line)
            if match:
                updated_line = f'{match.group(1)}{latest_version}{match.group(2)}'
                print(updated_line, end='\n')
                updated = True
                if match.group(0) != updated_line:
                    changed = True
            else:
                print(line, end='')

    if updated:
        if changed:
            print(f"\n🆕 {script_path} updated to use the latest buildroot LTS version")
        else:
            print(f"\n✅ Already using the latest buildroot LTS version in {script_path}")
    else:
        raise ValueError(f"Could not find the buildroot_version line in {script_path}")


if __name__ == "__main__":
    latest_version = find_latest_buildroot_LTS()
    update_script(latest_version)
