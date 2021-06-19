from bs4 import BeautifulSoup
import urllib.request

def get_number_of_apps1(url, word):
  html = urllib.request.urlopen(url).read()
  soup = BeautifulSoup(html, features="html.parser")
  soup = soup.get_text()
  #print(soup)
  return soup.count(word)

print(get_number_of_apps1("https://note.nkmk.me/en/python-type-isinstance/", "type"))


