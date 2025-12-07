#!/bin/bash
# Script to resolve apt dependencies for embedded toolchain packages
# Input: packages.txt (one package per line)
# Output: dependencies.txt (package name, version, URL)

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="${1:-${SCRIPT_DIR}/packages.txt}"
OUTPUT_FILE="${SCRIPT_DIR}/dependencies.txt"
TEMP_DEPS="${SCRIPT_DIR}/temp_deps.txt"
TEMP_URLS="${SCRIPT_DIR}/temp_urls.txt"
DOWNLOAD_DIR="${SCRIPT_DIR}/packages"

echo "Resolving dependencies for packages in ${PACKAGES_FILE}..."

# Clear output files
> "${OUTPUT_FILE}"
> "${TEMP_DEPS}"
> "${TEMP_URLS}"

# First, collect all packages and their dependencies
while IFS= read -r package || [ -n "$package" ]; do
    # Skip empty lines and comments
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue

    echo "Processing: $package"

    # Get dependencies using apt-cache
    apt-cache depends "$package" 2>/dev/null | \
        grep "Depends:" | \
        awk '{print $2}' | \
        grep -v "^<" >> "${TEMP_DEPS}" || true

    # Also add the package itself
    echo "$package" >> "${TEMP_DEPS}"

done < "${PACKAGES_FILE}"

# Remove duplicates
sort -u "${TEMP_DEPS}" -o "${TEMP_DEPS}"

echo -e "\nGetting package URLs and versions..."

# Update apt cache first
echo "Updating apt cache..."
apt-get update -qq 2>/dev/null || echo "Warning: Could not update apt cache (may need sudo)"

# Now get URLs and versions for all packages
while IFS= read -r package; do
    echo "Fetching info for: $package"

    # Try to get package info using apt-cache policy first
    version=$(apt-cache policy "$package" 2>/dev/null | grep "Candidate:" | awk '{print $2}')

    if [ -z "$version" ] || [ "$version" = "(none)" ]; then
        echo "  Warning: Package $package not found"
        printf "%s\t%s\t%s\n" "$package" "NOT_FOUND" "N/A" >> "${TEMP_URLS}"
        continue
    fi

    # Use apt-get download --print-uris (works better than apt download)
    url=$(apt-get download --print-uris "$package" 2>/dev/null | awk -F"'" '{print $2}' | head -1)

    if [ -z "$url" ]; then
        # Fallback: construct URL from package name and version
        printf "%s\t%s\t%s\n" "$package" "$version" "NO_URL" >> "${TEMP_URLS}"
    else
        printf "%s\t%s\t%s\n" "$package" "$version" "$url" >> "${TEMP_URLS}"
    fi

done < "${TEMP_DEPS}"

# Sort and output
sort -u "${TEMP_URLS}" > "${OUTPUT_FILE}"

# Clean up
rm -f "${TEMP_DEPS}" "${TEMP_URLS}"

echo -e "\nDependencies written to ${OUTPUT_FILE}"
echo "Total packages: $(wc -l < ${OUTPUT_FILE})"

# Show summary
echo -e "\nPackage summary (name | version | url):"
column -t -s $'\t' "${OUTPUT_FILE}" | head -20
if [ $(wc -l < "${OUTPUT_FILE}") -gt 20 ]; then
    echo "... (showing first 20 of $(wc -l < ${OUTPUT_FILE}) packages)"
fi

# Download packages
echo -e "\nDownloading packages to ${DOWNLOAD_DIR}..."
mkdir -p "${DOWNLOAD_DIR}"

downloaded=0
failed=0

# Read from the file properly
while IFS=$'\t' read -r package version url; do
    # Skip empty lines
    [ -z "$package" ] && continue

    if [ "$url" = "N/A" ] || [ "$url" = "NO_URL" ]; then
        echo "Skipping $package (no URL available)"
        failed=$((failed + 1))
        continue
    fi

    filename=$(basename "$url")

    if [ -f "${DOWNLOAD_DIR}/${filename}" ]; then
        echo "Already downloaded: $filename"
        downloaded=$((downloaded + 1))
        continue
    fi

    echo "Downloading: $filename"
    if wget -4 -q "$url" -O "${DOWNLOAD_DIR}/${filename}"; then
        echo "  Success: $filename"
        downloaded=$((downloaded + 1))
    else
        echo "  Failed: $filename"
        rm -f "${DOWNLOAD_DIR}/${filename}"  # Remove partial download
        failed=$((failed + 1))
    fi

done < "${OUTPUT_FILE}"

echo -e "\nDownload complete!"
echo "Downloaded: $downloaded packages"
echo "Failed: $failed packages"
echo "Location: ${DOWNLOAD_DIR}"
