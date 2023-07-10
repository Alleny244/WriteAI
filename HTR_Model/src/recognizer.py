import requests
from pathlib import Path
class postProcessor:
    def postprocessing(fn_img: Path):
        url = "https://ocr-wizard.p.rapidapi.com/ocr"

        files = { "image": open(fn_img, 'rb') }
        headers = {
        "X-RapidAPI-Key": "9363b35933mshc7336bba277f6f6p17a7a1jsn034f098f5d0e",
        "X-RapidAPI-Host": "ocr-wizard.p.rapidapi.com"
        }

        response = requests.post(url, files=files, headers=headers)

        print(response.json()['body']['fullText'])