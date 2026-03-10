---

## Getting First Name Data

The script automatically downloads the US baby name dataset published by the Social Security Administration.

Dataset:

https://www.ssa.gov/oact/babynames/names.zip

This dataset contains yearly files such as:

```
yob1880.txt
yob1881.txt
...
yob2023.txt
```

Each row follows this format:

```
firstname,gender,count
```

Example:

```
James,M,5927
Mary,F,7065
John,M,9655
```

### Processing Logic

To build a realistic first name list, the script:

1. Reads every yearly dataset file
2. Aggregates the total number of births for each first name
3. Ranks names by popularity
4. Selects the most common names

Example processing pipeline:

```bash
cat ssa/yob*.txt \
| awk -F',' '{count[$1]+=$3} END {for (n in count) print count[n],n}' \
| sort -nr \
| head -n 400 \
| awk '{print tolower($2)}' > first.txt
```

This produces a list of the **400 most common first names across all recorded years**, stored in:

```
first.txt
```

Example output:

```
james
john
mary
robert
michael
william
david
```

### Why This Approach Is Used

Using the most common names:

- avoids rare historical names
- reduces dataset size
- produces more realistic corporate usernames
- keeps generated wordlists around **~200,000 entries per format**

---

## Generated Name Lists

The script produces two primary datasets:

```
first.txt      → 400 most common first names
surname.txt    → 500 most common surnames
```

These sizes generate approximately:

```
400 × 500 ≈ 200,000 usernames per format
```

which is ideal for fast username enumeration.

---
