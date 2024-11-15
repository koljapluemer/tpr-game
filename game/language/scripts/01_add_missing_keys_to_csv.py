import os
import csv

CSV_FILE = './game/language/translation_text/tpr-game - Sheet1.csv'
MISSING_KEYS_FILE = 'missing_keys.txt'

# loop missing keys
# if they're not in the first col of the csv file, add them (as new row)

missing_keys = []
with open(MISSING_KEYS_FILE, 'r') as f:
    for line in f:
        missing_keys.append(line.strip())

# make keys unique and sort
missing_keys = list(set(missing_keys))
missing_keys.sort()



with open(CSV_FILE, 'r') as f:
    reader = csv.reader(f)
    rows = list(reader)

    keys = [row[0] for row in rows]

    for key in missing_keys:

        if key not in keys:
            rows.append([key, ''])



with open(CSV_FILE, 'w') as f:
    writer = csv.writer(f)
    writer.writerows(rows)