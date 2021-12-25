# scrape.sh
A stupid simple cURL wrapper to scrape content from websites

# What is this?
This is just a wrapper for the cURL utility that attempts to clean the output to a more human-readable format. --raw* flags will output with HTML tags; Good for targeting specific code by tags. This does not get images, video or downloads from any sites. `scrape.sh` just parses code, but cURL can do much more

# How to Use:
Run bash `scrape.sh <url> <--flag>` or `bash scrape.sh <--flag> <url>`. Since this is just a cURL wrapper, `scrape.sh` accepts all cURL flags
