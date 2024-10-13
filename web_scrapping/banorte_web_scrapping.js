const puppeteer = require('puppeteer');
const fs = require('fs');
const axios = require('axios');
const cheerio = require('cheerio');
const express = require('express');

const app = express();
const port = 3000;

// Middleware to parse JSON bodies
app.use(express.json());

// Get links from google search related to Banorte
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

// Scrape the content of the news articles
async function scrape(url) {
    const browser = await puppeteer.launch({
        args: ['--disable-http2'],
        headless: false,
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

// Main function to scrape the news articles
async function main() {
    const newsLinks = await scrapeBanorteNews();
    let result = "";
    let count = 0;
    for (const link of newsLinks) {
        try {
            result += await scrape(link);
            count++;
            if (count >= 20) {
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

app.post('/scrape', async (req, res) => {
    try {
        const result = await main();
        // Send the result to another API
        const jsonObject = {
            model: "summary",
            values: {
                prompt: result,
                category: "seguridad financiera",
                information_context: "La salud financiera es felicidad",
                user_context: "El usuario se llama eduardo y tiene 20 años. Quiere ahorrar dinero"
            }
        };
        const apiResponse = await axios.post('http://127.0.0.1:8000/model/selection/', jsonObject);
        console.log("Response from target API:", apiResponse.data);
        res.status(200).send(apiResponse.data);
    } catch (err) {
        console.error('Error occurred while scraping:', err);
        res.status(500).send('Error occurred while scraping.');
    }
});

// Start the Express server and run the main function
app.listen(port, async () => {
    console.log(`Server is running on http://localhost:${port}`);
    try {

        // Make a request to the /scrape endpoint after initial scraping
        const response = await axios.post(`http://localhost:${port}/scrape`);
        console.log('Response from /scrape endpoint:', response.data);
    } catch (err) {
        console.error('Error occurred during initial scraping:', err);
    }
});