//Install the following packages
const puppeteer = require('puppeteer');
const fs = require('fs');
const axios = require('axios');
const cheerio = require('cheerio');
//Get links from google search related to Banorte
async function scrapeBanorteNews() {
    try {
        // Fetch the HTML content of the google search page
        const response = await axios.get('https://www.google.com/search?q=Banorte+news', {
            headers: {
                'User-Agent': 'Mozilla/5.0'
            }
        });
        // Load the HTML content into cheerio
        const $ = cheerio.load(response.data);
        const newsLinks = [];
        // Extract the links from the search results
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
//Scrape the content of the news articles
async function scrape(url) {
    // Launch a new browser instance
    const browser = await puppeteer.launch({
        args: ['--disable-http2'],
        headless: false,  // Run in headless mode
        defaultViewport: null
    });
    // Create a new page
    const page = await browser.newPage();
    await page.goto(url, { waitUntil: 'networkidle2' });
    // Extract the text content of the page
    const body = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('body')).map(div => div.innerText);
    });
    // Combine the text content into a single string
    let result = "";
    // Concatenate the text content of the page

    
    body.forEach((div) => {
        result += " " + div;
    });
    // Clean up the text content
    result = result.replace(/\s+/g, ' ');
    result = result.toLowerCase();
    console.log(result);

    await browser.close();
    return result;
}
//Main function to scrape the news articles
async function main() {
    // Scrape the news links
    const newsLinks = await scrapeBanorteNews();
    let result = "";
    count = 0
    // Scrape the content of the news articles
    for (const link of newsLinks) {
        try {
            result += await scrape(link);
            count++;
            // Limit the number of articles to scrape
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
//Run the main function
main().then((result) => {
    console.log(result);
}).catch((err) => {
    console.error(err);
});