import os
import csv
import requests
import json
import time
import shutil

CSV_FILE = './game/language/translation_text/tpr-game - Sheet1.csv'
AUDIO_DIR = './game/language/translation_audio/'
POOL_DIR = './game/language/translation_pool/'


def main():
    # every colum in the csv is one language code (except first column, 'key')
    # for every language, check for rows that are filled, but for which there is no mp3 file like AUDIO_DIR/language_code/KEY.mp3
    # if there is no mp3 file, download it from speechgen.io

    # get all language codes from the csv file
    with open(CSV_FILE, 'r') as f:
        reader = csv.reader(f)
        header = next(reader)
        language_codes = header[2:]

    # get api data from api.txt
    with open('./game/language/scripts/api.txt', 'r') as f:
        api_email = f.readline().strip()
        api_key = f.readline().strip()


    languages_speakers = {
        "ar": "Ahmed",
        "de": "Amala",
        "it": "Fabiola"
    }


    # loop over all language codes
    for language_code in language_codes:

        # skip en
        if language_code == 'en' or language_code == 'arz':
            continue
        # make folder if it doesn't exist
        os.makedirs(os.path.join(AUDIO_DIR, language_code), exist_ok=True)
        # get all rows for this language
        with open(CSV_FILE, 'r') as f:

            reader = csv.reader(f)
            header = next(reader)
            rows = list(reader)
            for row in rows:
                key = row[0]
                text = row[header.index(language_code)]
                if text:
                    # check if audio file exists
                    audio_file = os.path.join(AUDIO_DIR, language_code, key + '.mp3')
                    if not os.path.exists(audio_file):
                        # check if audio already exists
                        pool_path = os.path.join(POOL_DIR, from_string_to_filename(text))
                        if os.path.exists(pool_path):
                            shutil.copyfile(pool_path, audio_file)
                            print("copying existing file!")
                        else:
                            # if it doesn't exist, only then download

                            # BASE URL https://speechgen.io/index.php?r=api/text
                            # EXAMPLE REQUEST DATA:
                            #{
                            # "token": "your_api_token",
                            # "email": "your_email@example.com",
                            # "voice": "John",
                            # "text": "Short text to be converted to speech.",
                            # "format": "mp3",
                            # "speed": 1.1,
                            # "pitch": 0.8,
                            # "emotion": "good"
                            # }
                            speaker = languages_speakers[language_code]

                            # send request to speechgen.io
                            url = 'https://speechgen.io/index.php?r=api/text'

                            data = {
                                "token": api_key,
                                "email": api_email,
                                "voice": speaker,
                                "text": text,
                                "format": "mp3",
                                "speed": 0.8,
                                "pitch": 0,
                                "emotion": "good"
                            }
                            response = requests.post(url, data=data)
                            time.sleep(1)
                            
                            # Handling the response
                            response = json.loads(response.text)
                            if response['status'] == 1:
                                if 'file' in response and 'format' in response:
                                    file_url = response['file']
                                    file_format = response['format']
                                    file_id = response['id']
                                    file_path = os.path.join(AUDIO_DIR, language_code, key + '.' + file_format)
                                    file_content = requests.get(file_url).content
                                    with open(file_path, 'wb') as file:
                                        # write file to correct path:
                                        file.write(file_content)

                                    shutil.copyfile(file_path, pool_path)
                                    


def from_string_to_filename(dirty):
    dirty = dirty.replace("?", "﹖")
    dirty = dirty.replace(":", "﹕")
    dirty = dirty.replace("#", "ⵌ")
    return dirty



if __name__ == "__main__":
    main()