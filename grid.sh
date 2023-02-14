#!/bin/sh

# defaults
topgutter=65
leftgutter=65
width=750
height=1050
image=''
pages=0
total=-1

while getopts i:t:tg:lg:w:h:p: flag
do
    case "${flag}" in
        tg) topgutter=${OPTARG};;
        lg) leftgutter=${OPTARG};;
        w) width=${OPTARG};;
        h) height=${OPTARG};;
        i) image=${OPTARG};;
        p) pages==${OPTARG};;
        t) total=${OPTARG};;
    esac
done

if ($image eq '')
  echo 'You must pass the image parameter with -i'
fi

if ($pages eq 0)
  echo 'You must pass the pages parameter with -p'
fi
