# Username Wordlist Generator

A simple Bash script that generates username wordlists by prepending letters `a–z` to a list of surnames.

For each surname in `surnames.txt`, the script generates usernames in the format:

```
a.surname
b.surname
c.surname
...
z.surname
```

Example output:

```
a.smith
b.smith
c.smith
...
z.smith
a.johnson
b.johnson
...
```

---

## Requirements

- Bash
- A list of surnames stored in `surnames.txt`

---

## Getting Surname Data

This project uses the **2010 US Census surname dataset**, which contains over **162,000 surnames**.

Download it from:

https://www2.census.gov/topics/genealogy/2010surnames/names.zip

Extract the archive and copy the surname column into `surnames.txt`.

Example extraction:

```bash
unzip names.zip
cut -d',' -f1 Names_2010Census.csv | tail -n +2 > surnames.txt
```

---

## Usage

Make the script executable:

```bash
chmod +x *.sh
```

Run the generator:

```bash
./make-wordlist.sh
```

This will create:

```
usernames.txt
```

---

## Example Use Case

The generated username list can be used for Active Directory username enumeration.

Example with Kerbrute:

```bash
kerbrute userenum -d pirate.htb --dc 10.129.2.102 usernames.txt
```

---

## Output Size

If using the full census dataset:

```
162,253 surnames × 26 letters = 4,218,578 usernames
```

---

## Disclaimer

This tool is intended for authorised security testing, research, and CTF environments only.
