#!/bin/bash
cd /ext/phavekes.github.io/amstel
git pull
echo "" > dates.txt
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
Op onderstaande foto's is te zien dat de parkeerplaatsen druk bezet zijn buiten openingstijden van de winkels, 
en dat er overdag nog plaats beschikbaar is.
<h2>
<h3>
Overdag is er dus altijd een parkeerplaats beschikbaar voor bewoners binnen de acceptabele loopafstand van 100m (Nota Parkeernormen Waalwijk 2015).<br/>
Er is wel een hoge parkeerdruk in deze wijk, maar niet tijdens de openingstijden van de winkels in het centrum, maar juist in de avonduren.
Het invoeren van parkeervergunningen zal de druk in de avonduren niet verlagen, omdat er dan voornamelijk bewoners parkeren in de wijk. 
Het winkelend publiek en het personeel van de bedrijven in het centrum zorgen overdag niet voor een te hoge parkeerdruk in de deze wijk.<br/>
</h3>


" > index.html
echo "Finding files"
find /ext/gphotos-sync/albums/* -path "*Parkeren Amstel*" -name "*.jpg" -exec cp -Lfr {} . \;
echo "Creating website content"
for file in ./0*.jpg ; do
   imgdate=$(exiftool -T -DateTimeOriginal $file)
   if [ "$imgdate" != "-" ]; then
   	filename=$(basename -- "$file")
   	echo "Checking $filename"
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
	echo "$imgdate" >> dates.txt
   fi
done

uniek=$(cat dates.txt | cut -c1-13 | sort | uniq | wc -l)
echo "<h2>Aantal unieke meetmomenten : $uniek</h2>" >> index.html

echo "
</div>
</body>
</html>
">> index.html

if [[ `git status --porcelain` ]]; then
  git status
  git add .
  git commit -m "New 'amstel' images"
  git push
else
  echo "Nothing new"
fi

