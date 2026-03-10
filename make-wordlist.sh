#!/bin/bash

set -e

FIRST_FILE="first.txt"
SURNAME_FILE="surname.txt"

FIRST_COUNT=400
SURNAME_COUNT=500

prepare_datasets() {

echo "[*] Downloading first name dataset..."
wget -q https://www.ssa.gov/oact/babynames/names.zip -O ssa.zip
unzip -q ssa.zip -d ssa

echo "[*] Building ranked first name list..."

cat ssa/yob*.txt \
| awk -F',' '{count[$1]+=$3} END {for (n in count) print count[n],n}' \
| sort -nr \
| head -n $FIRST_COUNT \
| awk '{print tolower($2)}' > $FIRST_FILE

rm -rf ssa ssa.zip

echo "[*] Downloading surname dataset..."
wget -q https://www2.census.gov/topics/genealogy/2010surnames/names.zip -O census.zip
unzip -q census.zip

echo "[*] Building ranked surname list..."

cut -d',' -f1 Names_2010Census.csv \
| tail -n +2 \
| head -n $SURNAME_COUNT \
| tr '[:upper:]' '[:lower:]' > $SURNAME_FILE

rm census.zip Names_2010Census.csv

echo "[+] first.txt and surname.txt created"

}

generate_format() {

FORMAT=$1
OUTPUT="usernames${FORMAT}.txt"
> "$OUTPUT"

while read first; do
    f=${first:0:1}

    while read last; do

        case $FORMAT in
            1) echo "${first}.${last}" ;;
            2) echo "${first}_${last}" ;;
            3) echo "${first}${last}" ;;
            4) echo "${f}.${last}" ;;
            5) echo "${f}_${last}" ;;
            6) echo "${f}${last}" ;;
            7) echo "${first}${last:0:1}" ;;
            8) echo "${last}.${first}" ;;
            9) echo "${last}_${first}" ;;
            10) echo "${last}${f}" ;;
            11) for i in {1..9}; do echo "${first}.${last}${i}"; done ;;
            12) for i in {1..9}; do echo "${f}.${last}${i}"; done ;;
            13) for i in {1..9}; do echo "${f}${last}${i}"; done ;;
        esac

    done < "$SURNAME_FILE"

done < "$FIRST_FILE" >> "$OUTPUT"

COUNT=$(wc -l < "$OUTPUT")

echo "[+] Created $OUTPUT ($COUNT usernames)"

}

generate_all() {

OUTPUT="usernames14.txt"
> "$OUTPUT"

while read first; do
    f=${first:0:1}

    while read last; do

        echo "${first}.${last}"
        echo "${first}_${last}"
        echo "${first}${last}"
        echo "${f}.${last}"
        echo "${f}_${last}"
        echo "${f}${last}"
        echo "${first}${last:0:1}"
        echo "${last}.${first}"
        echo "${last}_${first}"
        echo "${last}${f}"

        for i in {1..9}; do
            echo "${first}.${last}${i}"
            echo "${f}.${last}${i}"
            echo "${f}${last}${i}"
        done

    done < "$SURNAME_FILE"

done < "$FIRST_FILE" >> "$OUTPUT"

COUNT=$(wc -l < "$OUTPUT")

echo "[+] Created $OUTPUT ($COUNT usernames)"

}

if [ ! -f "$FIRST_FILE" ] || [ ! -f "$SURNAME_FILE" ]; then
    prepare_datasets
fi

echo ""
echo "Username Wordlist Generator"
echo ""
echo "Each option will create a wordlist of 200000 guesses, apart from #14"
echo ""
echo "1) first.last"
echo "2) first_last"
echo "3) firstlast"
echo "4) f.last"
echo "5) f_last"
echo "6) flast"
echo "7) firstl"
echo "8) last.first"
echo "9) last_first"
echo "10) lastf"
echo "11) first.last1-9"
echo "12) f.last1-9"
echo "13) flast1-9"
echo "14) Generate ALL - (A regrettable 7400000 usernames!)"
echo ""

read -p "Select option: " option

if [ "$option" -eq 14 ]; then
    generate_all
else
    generate_format "$option"
fi
