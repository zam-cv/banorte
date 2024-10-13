import requests
from bs4 import BeautifulSoup

def get_banorte_news():
    url = "https://www.google.com/search?q=Banorte+news"
    headers = {"User-Agent": "Mozilla/5.0"}
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.content, "html.parser")
    news_list = soup.find_all("div", class_="BNeawe vvjwJb AP7Wnd")

    for news in news_list:
        print(news.get_text().strip())

get_banorte_news()
