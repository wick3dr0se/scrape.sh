#!/bin/bash

#proxy="" // append -x to curl to use proxy
url=${@//--*}
scrape() {
	curl -Lks $url
}
cut_html() {
	sed 's|</b>|-|g;s|<[^>]*>||g' | tr -d '\n' | sed 's/  */ /g'
}
trim() {
	tr -d '\n' | sed 's/  */ /g'
}
get() { 
	grep -oP "(?<=<$1).*?(?=</$1>)" | sed "s/^/<$1&/"
}
grab() {
	sed -n "/<$1/,/$1>/p"
}
del() {
	sed "/<\/$1/,/<\/$2/d"
}
beg() {
	sed "s/<$1.*//"
}
end() {
	sed "s/.*$1>//"
}

[[ $@ = $url ]] && scrape | trim ||
while [[ ! -z "$#" ]] ; do
	case $@ in
		*--raw|--raw*) scrape ; exit ;;
		*--raw-head|--raw-head*) scrape | grab head | del head html | trim ; exit ;;
		*--head|--head*) scrape | grab head | del head html | cut_html ; exit ;;
		*--raw-header|--raw-header*) scrape | get header | trim ; exit ;;
		*--header|--header*) scrape | get header | cut_html ; exit ;;
		*--raw-body|--raw-body*) scrape | grab body | end header | beg footer | trim ; exit ;;
		*--body|--body*) scrape | grab body | end header | beg footer | cut_html ; exit ;;
		*--raw-footer|--raw-footer*) scrape | get footer | trim ; exit ;;
		*--footer|--footer*) scrape | get footer | cut_html ; exit ;;
		*--help|*--usage|--help*|--usage*|*)
			tabs 2
			printf '\t%s\t %s\n' \
			'usage:' 'bash scrape <url> <--flag>' \
		       	'or:' 'bash scrape <--flag> <url>' \
			'----------------------------------'
			printf '\t%s\t %s\n' \
			'--raw:' 'scrape url without any intervention' \
			'--raw-head:' 'scrape raw head output' \
			'--head:' 'scrape and trim head' \
			'--raw-header:' 'scrape raw header' \
			'--header:' 'scrape and trim header' \
			'--raw-body:' 'scrape raw body, removing header and footer' \
			'--body:' 'scrape and trime body, removing header and footer' \
			'--raw-footer:' 'scrape raw footer' \
			'--footer:' 'scrape and trim footer' ; exit ;;
	esac
done
