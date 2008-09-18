SOUNDS=`wget -O /dev/stdout "http://api.staging.iknow.co.jp/items/extract.xml?text=$*" 2> /dev/null |  ruby -ne 'puts $_.gsub(/<sentences>[^<\/sentences>]+/, "").scan(/<sound>([^<]+)/).flatten.join("\n")'`
for sound in $SOUNDS; do
	mplayer $sound
done
