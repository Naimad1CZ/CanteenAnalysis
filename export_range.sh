#!/usr/bin/env bash
if [ $# -ne 3 ]; then
    echo "Usage: <start date> <end date> <output dir>" >&2
    exit 1
fi
start=$1
weeks=$2
output="$3"

echo "$1"
echo "$2"
echo "$3"

mkdir -p "$3"
cd "$3"

mkdir tmp
pushd tmp
echo "ahoj"
echo "$weeks"
for i in $(seq $weeks); do
	echo "ahoj 2"
    date1=$(date +%Y-%m-%d -d "$start + $i weeks")
    date2=$(date +%Y-%m-%d -d "$date1 + 6 days")
    curl "https://menzostat.ggu.cz/db.zip?from=$date1&to=$date2" \
         -o export.zip
    unzip -o export.zip
    mv canteens.csv ../canteens.csv
    for f in mealhistory.csv mealhistory_latest.csv \
             meals.csv mealstatistics.csv; do
        if [ -f ../$f ]; then
            tail -n+2 $f >> ../$f
        else
            mv $f ../$f
        fi
    done
done
popd
rm -r tmp
