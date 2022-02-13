import hashlib
from virustotal_python import Virustotal
from pprint import pprint

sha256 = hashlib.sha256(open("file.txt", "rb").read())
FILE_ID = sha256.hexdigest()
print(FILE_ID)

api_key = input("Enter your VirusTotal API key: ")
vtotal = Virustotal(API_KEY=api_key)
resp = vtotal.request("file/report", {"resource": FILE_ID})

pprint(resp.json())