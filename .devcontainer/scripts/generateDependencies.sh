#!/bin/bash
# Script to resolve apt dependencies for embedded toolchain packages
# Input: packages.txt (one package per line)
# Output: dependencies.txt (package name, version, URL)

set -e
echo "Shell: $SHELL"
echo "Bash version: $BASH_VERSION"
process_package_list() {
    local packages_count=$(wc -l "${PACKAGES_FILE}")
    iterator=0

    # First, collect all packages and their dependencies
    while IFS= read -r package || [ -n "$package" ]; do
        iterator=$((iterator + 1))
        echo -ne "(${iterator}/${packages_count})\t$package\r"
        resolve_dependencies "${package}"
    done < "${PACKAGES_FILE}"

    # Remove duplicates
    sort -u "${TEMP_DEPS}" -o "${TEMP_DEPS}"
}

resolve_dependencies() {
    local package="$1"

    # Skip empty lines and comments
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && return

    # Get dependencies using apt-cache
    apt-cache depends --recurse --no-recommends --no-suggests --no-conflicts --no-breaks --no-replaces --no-enhances "$package" 2>/dev/null \
        |  grep -v "^ " \
        >> "${TEMP_DEPS}" \
        || true

    # Also add the package itself
    echo -e "$package" >> "${TEMP_DEPS}"
}

resolve_url_versions() {
    # Now get URLs and versions for all packages
    while IFS= read -r package; do
        echo -e "Fetching info for: $package"

        # Try to get package info using apt-cache policy first
        version=$(apt-cache policy "$package" 2>/dev/null | grep "Candidate:" | awk '{print $2}')

        if [ -z "$version" ] || [ "$version" = "(none)" ]; then
            echo -e "  Warning: Package $package not found"
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
}

summarize_resolver() {
    echo -e "\nDependencies written to ${OUTPUT_FILE}"
    echo -e "Total packages: $(wc -l < ${OUTPUT_FILE})"
    echo -e "\nPackage summary (name | version | url):"
    column -t -s $'\t' "${OUTPUT_FILE}" | head -20
    if [ $(wc -l < "${OUTPUT_FILE}") -gt 20 ]; then
        echo -e "... (showing first 20 of $(wc -l < ${OUTPUT_FILE}) packages)"
    fi
}

download_dependencies(){
    mkdir -p "${DOWNLOAD_DIR}"

    downloaded=0
    failed=0

    # Read from the file properly
    while IFS=$'\t' read -r package version url; do
        # Skip empty lines
        [ -z "$package" ] && continue

        if [ "$url" = "N/A" ] || [ "$url" = "NO_URL" ]; then
            echo -e "Skipping $package (no URL available)"
            failed=$((failed + 1))
            continue
        fi

        filename=$(basename "$url")

        if [ -f "${DOWNLOAD_DIR}/${filename}" ]; then
            echo -e "Already downloaded: $filename"
            downloaded=$((downloaded + 1))
            continue
        fi

        echo -e "Downloading: $filename"
        if wget -4 -q "$url" -O "${DOWNLOAD_DIR}/${filename}"; then
            echo -e "  Success: $filename"
            downloaded=$((downloaded + 1))
        else
            echo -e "  Failed: $filename"
            rm -f "${DOWNLOAD_DIR}/${filename}"  # Remove partial download
            failed=$((failed + 1))
        fi

    done < "${OUTPUT_FILE}"

    echo -e "\nDownload complete!"
    echo -e "Downloaded: $downloaded packages"
    echo -e "Failed: $failed packages"
    echo -e "Location: ${DOWNLOAD_DIR}"
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_FILE="${1:-${SCRIPT_DIR}/packages.txt}"
OUTPUT_FILE="${SCRIPT_DIR}/dependencies.txt"
TEMP_DEPS="${SCRIPT_DIR}/temp_deps.txt"
TEMP_URLS="${SCRIPT_DIR}/temp_urls.txt"
DOWNLOAD_DIR="${SCRIPT_DIR}/packages"

# Clear output files
# If output file does not exist, it is created as an empty file.
# If output file already exists, it is truncated to zero length.
> "${OUTPUT_FILE}"
> "${TEMP_DEPS}"
> "${TEMP_URLS}"

echo -e "Updating apt cache..."
apt-get update -qq 2>/dev/null || echo -e "Warning: Could not update apt cache (may need sudo)"

echo -e "Resolving dependencies for packages in ${PACKAGES_FILE}..."
process_package_list

echo -e "\nGetting package URLs and versions..."
resolve_url_versions

echo -e "Summary..."
summarize_resolver

echo -e "\nDownloading packages to ${DOWNLOAD_DIR}..."
download_dependencies

# Clean up
# rm -f "${TEMP_DEPS}" "${TEMP_URLS}"
