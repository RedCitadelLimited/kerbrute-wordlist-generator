# Username Wordlist Generator

A Bash script that generates realistic **Active Directory username wordlists** using common first and last name datasets.

The tool builds username lists based on common corporate naming conventions and outputs wordlists suitable for **username enumeration attacks** such as Kerberos user discovery.

The script automatically downloads public datasets and processes them to create optimised username lists of approximately **200000 to 7000000 guesses per format**.

---

# Features

- Automatically downloads name datasets
- Builds ranked lists of the most common names
- Generates multiple common Windows username formats
- Option to gfenerate common **administrator account prefix and suffix variations**
- Produces realistic wordlists sized from ~200k to ~7.4M entries depending on the selected mode- Includes a large "generate everything" mode
- Menu driven interface
- Displays final wordlist sizes

---

# Username Formats Generated

The script supports common corporate username formats including:

```
first.last
first_last
firstlast
f.last
f_last
flast
firstl
last.first
last_first
lastf
first.last1
f.last1
flast1
```

Example output:

```
john.smith
john_smith
johnsmith
j.smith
j_smith
jsmith
johns
smith.john
smith_john
smithj
john.smith1
j.smith1
jsmith1
```

---

# Admin Account Generation

The script can optionally generate **administrator account variations**.

After selecting a username format, the script prompts for the account type:

```
1) User Accounts
2) Admin Accounts
3) All Accounts
```

---

## User Accounts

Generates the standard username list:

```
User-Accounts.txt
```

Typical size:

```
~200,000 usernames
```

---

## Admin Accounts

If **Admin Accounts** are selected, the script asks which format to generate:

```
1) Prefix
2) Suffix
3) Both
```

---

### Admin Prefixes

These prefixes are added to each username:

```
Adm_
Adm-
Adm
Admin_
Admin-
Admin
```

Example output:

```
Admin_john.smith
Adm-johnsmith
Adminjsmith
```

Output file:

```
Prefix-Admin.txt
```

Approximate size:

```
~1,200,000 usernames
```

(6 prefix variants × 200,000 base usernames)

---

### Admin Suffixes

These suffixes are appended to each username:

```
_Adm
-Adm
Adm
_Admin
-Admin
Admin
```

Example output:

```
john.smith_Admin
johnsmithAdm
jsmith-Admin
```

Output file:

```
Suffix-Admin.txt
```

Approximate size:

```
~1,200,000 usernames
```

---

## All Accounts

Selecting **All Accounts** generates:

```
User-Accounts.txt
Prefix-Admin.txt
Suffix-Admin.txt
```

This provides a complete set of **standard users and common administrator naming conventions**.

---

# Data Sources

The script uses two public datasets to build realistic name lists.

## First Names

First names are downloaded from the US Social Security Administration baby name dataset.

Dataset:

https://www.ssa.gov/oact/babynames/names.zip

This dataset contains yearly baby name statistics from **1880 to present**.

Example record:

```
James,M,5927
Mary,F,7065
John,M,9655
```

### Processing Logic

The script:

1. Reads every yearly dataset file
2. Aggregates the total number of births for each name
3. Ranks names by popularity
4. Selects the **top 400 most common names**

Example pipeline used:

```bash
cat ssa/yob*.txt \
| awk -F',' '{count[$1]+=$3} END {for (n in count) print count[n],n}' \
| sort -nr \
| head -n 400 \
| awk '{print tolower($2)}' > first.txt
```

This produces:

```
first.txt
```

---

## Surnames

Surnames are taken from the **2010 US Census surname dataset**.

Dataset:

https://www2.census.gov/topics/genealogy/2010surnames/names.zip

The script extracts the **500 most common surnames** and stores them in:

```
surname.txt
```

---

# Wordlist Size

Using:

```
400 first names
500 surnames
```

Each username format generates approximately:

```
400 × 500 = 200,000 usernames
```

Admin account generation multiplies this by the number of admin variants.

Typical sizes:

```
User-Accounts.txt      ≈ 200,000 usernames
Prefix-Admin.txt       ≈ 1,200,000 usernames
Suffix-Admin.txt       ≈ 1,200,000 usernames
Generate ALL (#14)     ≈ 7,400,000 usernames
```

---

# Installation

Clone the repository:

```
git clone https://github.com/RedCitadelLimited/kerbrute-wordlist-generator.git
cd kerbrute-wordlist-generator
```

Make the script executable:

```
chmod +x *.sh
```

---

# Usage

Run the generator:

```
./make-wordlist.sh
```

You will be presented with a menu to select the username format.

Example:

```
1) first.last
2) first_last
3) firstlast
4) f.last
5) f_last
6) flast
7) firstl
8) last.first
9) last_first
10) lastf
11) first.last1-9
12) f.last1-9
13) flast1-9
14) Generate ALL
```

After selecting the format, you will then choose the **account type**.

At completion the script displays the wordlist size using:

```
wc -l
```

---

# Example Usage with Kerbrute

The generated lists can be used for **Kerberos username enumeration** with Kerbrute.

Example:

```
kerbrute userenum -d domain.local --dc 10.129.2.102 User-Accounts.txt
```

Tool:

https://github.com/ropnop/kerbrute

---

# Disclaimer

This tool is intended for:

- authorised penetration testing
- security research
- lab environments
- CTF challenges

Do not use this tool against systems without permission.
