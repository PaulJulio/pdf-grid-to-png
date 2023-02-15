#!/bin/sh

# defaults
topgutter=65
leftgutter=65
width=750
height=1050
image='DEFAULT_IMAGE_STRING'
pages=0
total=-1
density=300
quality=90
rows=3
columns=3
border=75x75

while getopts i:t:tg:lg:w:h:p:d:q:b: flag
do
    case "${flag}" in
        tg) topgutter=${OPTARG};;
        lg) leftgutter=${OPTARG};;
        w) width=${OPTARG};;
        h) height=${OPTARG};;
        i) image=${OPTARG};;
        p) pages=${OPTARG};;
        t) total=${OPTARG};;
        d) density=${OPTARG};;
        q) quality=${OPTARG};;
        r) rows=${OPTARG};;
        c) columns=${OPTARG};;
        b) border=${OPTARG};;
    esac
done

if [ $image == 'DEFAULT_IMAGE_STRING' ]
then
  echo "You must pass the image parameter with -i"
  exit 1
fi

if [ $pages -eq 0 ]
then
  echo "You must pass the pages parameter with -p"
  exit 1
fi

if [ $total -lt 1 ]
then
  let total=${pages}*${rows]*${columns}
  echo "No total image count given with -t, creating $total images"
fi

echo "Opening $image and converting it into png files named png-page-X.png (expecting $pages pages)"
convert -density $density $image -quality $quality images/png-page.png

created=0
currentpage=0
while [ $currentpage -lt $pages ]
do
  row=0
  while [ $row -lt $rows ]
  do
    column=0
    while [ $column -lt $columns ]
    do
      if [ $created -lt $total ]
      then
        let left=${width}*${column}+${leftgutter}
        let top=${height}*${row}+${topgutter}
        cmd="magick ./images/png-page-$currentpage.png -crop ${width}x${height}+${left}+${top} -trim ./images/borderless-${currentpage}-row-${row}-col-${column}.png"
        echo "Creating borderless image $created from page $currentpage row $row column $column"
        $cmd
        echo "Adding ${border}px border"
        cmd="convert -bordercolor black -border ${border} ./images/borderless-${currentpage}-row-${row}-col-${column}.png ./images/bordered-${currentpage}-row-${row}-col-${column}.png"
        $cmd
        let created=${created}+1
      fi
      let column=${column}+1
    done
    let row=${row}+1
  done
  let currentpage=${currentpage}+1
done
echo "cleaning up the intermediate pages"
currentpage=0
while [ $currentpage -lt $pages ]
do
  rm -f ./images/png-page-${currentpage}.png
  let currentpage=${currentpage}+1
done
echo "Done."
