#!/bin/bash
git pull
echo "
<HTML>
<HEAD>
    <title>Parkeren Amstel</title>
    <meta charset='utf-8'>
    <meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\">
    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\" />

<style media=\"all\">
    img {width: -webkit-fill-available;}
    div {width: 60%; left: 10%; position: absolute; max-width: 800px}
    h3 {margin-top :1px;}
</style>

<style media=\"screen and (max-device-width: 1200px)\">
    div {width:80%}
</style>
</HEAD>
<BODY>
<div>
<H1>Parkeren in de wijk de Amstel, Waalwijk</H1>
<h2>
Op onderstaande foto's is te zien dat de parkeerplaatsen druk bezet zijn buiten openingstijden van de winkels, en dat er nog plaats beschikbaar is als alleen de bewoners in de wijk zijn.
</h2>

" > index.html
echo "Finding files"
find /ext/gphotos-sync/albums/* -path "*Parkeren Amstel*" -name "*.jpg" -exec cp -Lfr {} . \;
echo "Converting"
for file in ./0*.jpg ; do
   imgdate=$(exiftool -T -DateTimeOriginal $file)
   if [ "$imgdate" != "-" ]; then
   	filename=$(basename -- "$file")
   	echo "$filename"
   	if [ ! -f ./thumb_$filename ]
   	then
   		echo "Create thumb for $file"
   		convert -resize 50% $file ./thumb_$filename
   	fi
   	echo "<br/>
   	<A href=\"$filename\"><img src=\"thumb_$filename\" alt=\"$imgdate\"></a><br/>
   	<h3>$imgdate</h3>
   	</br>
" >> index.html
   fi
done

if [[ `git status --porcelain` ]]; then
  git add .
  git commit -m "New 'amstel' images"
  git push
else
  echo "Nothing new"
fi

echo "
</div>
</body>
</html>
">> index.html