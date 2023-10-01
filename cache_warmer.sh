#!/bin/bash

# This script is used to warm up the cache of a website.
# The function takes a URL as argument.
# Start with a sitemap file URL to recursively crawl all the links in the sitemap file.
 
# For Mac OS
# Needs: brew install grep


crawl() {
    # The URL is passed as argument.
    URL=$1

    # Check if the URL is a sitemap file.
    # If so, curl all the locations/loc's in the sitemap file.
    # If not, curl the URL.
    if [[ $URL == *".xml" ]] ; then
        printf "Crawling sitemap file: $URL"
        printf "\n"

        # Getting the links in the sitemap file
        curl $URL | ggrep -oP '(?<=loc>)[^<]+' | while read line; do
            # Recursively crawling the URL
            crawl $line
        done
    else
        printf "Crawling URL: $URL\n"
        curl -sIXGET -r 0-1 -o /dev/null -w "Status code: %{http_code}" $URL
        printf "\n\n"
    fi
}

# Call the crawl function with the provided URL argument
crawl "$1"
