import os
import csv
import json
import time
import shutil

CSV_FILE = './game/language/translation_text/tpr-game - Sheet1.csv'
AUDIO_DIR = './game/language/translation_audio/'
POOL_DIR = './game/language/translation_pool/'

def main():
    with open(CSV_FILE, 'r') as f:
        reader = csv.reader(f)
        header = next(reader)
        language_codes = header[1:]


    for language_code in language_codes:
        os.makedirs(os.path.join(AUDIO_DIR, language_code), exist_ok=True)
        with open(CSV_FILE, 'r') as f:
            reader = csv.reader(f)
            header = next(reader)
            rows = list(reader)
            for row in rows:
                key = row[0]
                try:
                    text = row[header.index(language_code)]
                    if text:
                        audio_file = os.path.join(AUDIO_DIR, language_code, key + '.mp3')
                        if os.path.exists(audio_file):
                            shutil.copyfile(audio_file, os.path.join(POOL_DIR, from_string_to_filename(text) + '.mp3'))
                except:
                    pass



def from_string_to_filename(dirty):
    dirty = dirty.replace("?", "﹖")
    dirty = dirty.replace(":", "﹕")
    dirty = dirty.replace("#", "ⵌ")
    return dirty


if __name__ == "__main__":
    main()