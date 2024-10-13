const puppeteer = require('puppeteer');
const fs = require('fs');
const axios = require('axios');
const cheerio = require('cheerio');

async function scrapeBanorteNews() {
    try {
        const response = await axios.get('https://www.google.com/search?q=Banorte+news', {
            headers: {
                'User-Agent': 'Mozilla/5.0'
            }
        });

        const $ = cheerio.load(response.data);
        const newsLinks = [];

        $('a').each((index, element) => {
            const link = $(element).attr('href');
            if (link && link.includes('banorte')) {
                newsLinks.push(`https://www.google.com${link}`);
            }
        });

        return newsLinks;

    } catch (error) {
        console.error('Error fetching news:', error);
        return [];
    }
}

async function scrape(url) {
    const browser = await puppeteer.launch({
        args: ['--disable-http2'],
        headless: false,  // Run in headless mode
        defaultViewport: null
    });
    const page = await browser.newPage();
    await page.goto(url, { waitUntil: 'networkidle2' });

    const body = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('body')).map(div => div.innerText);
    });

    let result = "";
    body.forEach((div) => {
        result += " " + div;
    });

    result = result.replace(/\s+/g, ' ');
    result = result.toLowerCase();
    console.log(result);

    await browser.close();
    return result;
}

async function main() {
    const newsLinks = await scrapeBanorteNews();
    let result = "";
    count = 0

    for (const link of newsLinks) {
        try {
            result += await scrape(link);
            count++;
            if (count >= 15) {
                break;
            }
        } catch (err) {
            console.error(`Error scraping ${link}:`, err);
        }
    }

    fs.appendFile('Output.txt', result, (err) => {
        if (err) throw err;
        console.log('Content appended to file.');
    });

    return result;
}

main().then((result) => {
    console.log(result);
}).catch((err) => {
    console.error(err);
});