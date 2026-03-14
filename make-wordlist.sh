#!/bin/bash

set -e

FIRST_FILE="first.txt"
SURNAME_FILE="surname.txt"

FIRST_COUNT=400
SURNAME_COUNT=500

ADMIN_PREFIXES=("Adm_" "Adm-" "Adm" "Admin_" "Admin-" "Admin")
ADMIN_SUFFIXES=("_Adm" "-Adm" "Adm" "_Admin" "-Admin" "Admin")

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
OUTPUT=$2
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

}

generate_all() {

OUTPUT=$1
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

}

generate_prefix_admin() {

INPUT=$1
OUTPUT="Prefix-Admin.txt"
> "$OUTPUT"

while read user; do
    for p in "${ADMIN_PREFIXES[@]}"; do
        echo "${p}${user}"
    done
done < "$INPUT" >> "$OUTPUT"

echo ""
echo "[+] Created $OUTPUT"
wc -l "$OUTPUT"

}

generate_suffix_admin() {

INPUT=$1
OUTPUT="Suffix-Admin.txt"
> "$OUTPUT"

while read user; do
    for s in "${ADMIN_SUFFIXES[@]}"; do
        echo "${user}${s}"
    done
done < "$INPUT" >> "$OUTPUT"

echo ""
echo "[+] Created $OUTPUT"
wc -l "$OUTPUT"

}

if [ ! -f "$FIRST_FILE" ] || [ ! -f "$SURNAME_FILE" ]; then
    prepare_datasets
fi

RED='\033[31m'
WHITE='\033[97m'
NC='\033[0m'
echo ""
echo ""
echo -e "            ${RED}██████${WHITE}╗${RED} ███████${WHITE}╗${RED}██████${WHITE}╗"
echo -e "            ${RED}██${WHITE}╔══${RED}██╗${RED}██${WHITE}╔════╝${RED}██${WHITE}╔══${RED}██${WHITE}╗"
echo -e "            ${RED}██████${WHITE}╔╝${RED}█████${WHITE}╗  ${RED}██${WHITE}║  ${RED}██${WHITE}║"
echo -e "            ${RED}██${WHITE}╔══${RED}██${WHITE}╗${RED}██${WHITE}╔══╝  ${RED}██${WHITE}║  ${RED}██${WHITE}║"
echo -e "            ${RED}██${WHITE}║  ${RED}██${WHITE}║${RED}███████${WHITE}╗${RED}██████${WHITE}╔╝"
echo -e "            ${WHITE}╚═╝  ╚═╝╚══════╝╚═════╝"

echo -e " ${RED}██████${WHITE}╗${RED}██${WHITE}╗${RED}████████${WHITE}╗ ${RED}█████${WHITE}╗ ${RED}██████${WHITE}╗ ${RED}███████${WHITE}╗${RED}██${WHITE}╗"
echo -e "${RED}██${WHITE}╔════╝${RED}██${WHITE}║╚══${RED}██${WHITE}╔══╝${RED}██${WHITE}╔══${RED}██${WHITE}╗${RED}██${WHITE}╔══${RED}██${WHITE}╗${RED}██${WHITE}╔════╝${RED}██${WHITE}║"
echo -e "${RED}██${WHITE}║     ${RED}██${WHITE}║   ${RED}██${WHITE}║   ${RED}███████${WHITE}║${RED}██${WHITE}║  ${RED}██${WHITE}║${RED}█████${WHITE}╗  ${RED}██${WHITE}║"
echo -e "${RED}██${WHITE}║     ${RED}██${WHITE}║   ${RED}██${WHITE}║   ${RED}██${WHITE}╔══${RED}██${WHITE}║${RED}██${WHITE}║  ${RED}██${WHITE}║${RED}██${WHITE}╔══╝  ${RED}██${WHITE}║"
echo -e "${WHITE}╚${RED}██████${WHITE}╗${RED}██${WHITE}║   ${RED}██${WHITE}║   ${RED}██${WHITE}║  ${RED}██${WHITE}║${RED}██████${WHITE}╔╝${RED}███████${WHITE}╗${RED}███████${WHITE}╗"
echo -e " ${WHITE}╚═════╝╚═╝   ╚═╝   ╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝"
echo ""
echo -e " ${RED}Affordable Penetration Testing ${WHITE}|${RED} redcitadel${WHITE}.${RED}co${WHITE}.${RED}uk"

echo -e "${NC}"

echo "Username Wordlist Generator"
echo ""
echo "======================================================================="
echo "1) first.last     - Users: 200000  | Admin: 1200000  | Both: 2600000"
echo "2) first_last     - Users: 200000  | Admin: 1200000  | Both: 2600000"
echo "3) firstlast      - Users: 200000  | Admin: 1200000  | Both: 2600000"
echo "4) f.last         - Users: 11000   | Admin: 66000    | Both: 143000"
echo "5) f_last         - Users: 11000   | Admin: 66000    | Both: 143000"
echo "6) flast          - Users: 11000   | Admin: 66000    | Both: 143000"
echo "7) firstl         - Users: 10400   | Admin: 62400    | Both: 135200"
echo "8) last.first     - Users: 200000  | Admin: 1200000  | Both: 2600000"
echo "9) last_first     - Users: 200000  | Admin: 1200000  | Both: 2600000"
echo "10) lastf         - Users: 13000   | Admin: 78000    | Both: 169000"
echo "11) first.last1-9 - Users: 1800000 | Admin: 10800000 | Both: 23400000"
echo "12) f.last1-9     - Users: 99000   | Admin: 594000   | Both: 1287000"
echo "13) flast1-9      - Users: 99000   | Admin: 594000   | Both: 1287000"
echo "14) Generate ALL  - Users: 7400000 | Admin: 44400000 | Both: 96200000"
echo "======================================================================="

read -p "Select option: " option

echo ""
echo "Account Type"
echo ""
echo "1) User Accounts"
echo "2) Admin Accounts"
echo "3) All Accounts"
echo ""

read -p "Select option: " account_type

BASE_FILE="base_usernames.tmp"

if [ "$option" -eq 14 ]; then
    generate_all "$BASE_FILE"
else
    generate_format "$option" "$BASE_FILE"
fi

sort -u "$BASE_FILE" -o "$BASE_FILE"

if [ "$account_type" -eq 1 ]; then

    mv "$BASE_FILE" "User-Accounts.txt"

    echo ""
    echo "[+] Created User-Accounts.txt"
    wc -l "User-Accounts.txt"

elif [ "$account_type" -eq 2 ]; then

    echo ""
    echo "Admin Format"
    echo ""
    echo "1) Prefix"
    echo "2) Suffix"
    echo "3) Both"
    echo ""

    read -p "Select option: " admin_type

    if [ "$admin_type" -eq 1 ]; then
        generate_prefix_admin "$BASE_FILE"

    elif [ "$admin_type" -eq 2 ]; then
        generate_suffix_admin "$BASE_FILE"

    elif [ "$admin_type" -eq 3 ]; then
        generate_prefix_admin "$BASE_FILE"
        generate_suffix_admin "$BASE_FILE"
    fi

    rm "$BASE_FILE"

elif [ "$account_type" -eq 3 ]; then

    mv "$BASE_FILE" "User-Accounts.txt"

    generate_prefix_admin "User-Accounts.txt"
    generate_suffix_admin "User-Accounts.txt"

    echo ""
    echo "[+] Created User-Accounts.txt"
    wc -l "User-Accounts.txt"

fi
