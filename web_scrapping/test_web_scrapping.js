const axios = require('axios');
const cheerio = require('cheerio');
const fs = require('fs');

async function scrapeBanorteNews() {
    try {
        const response = await axios.get('https://www.google.com/search?q=Banorte+news', {
            headers: {
                'User-Agent': 'Mozilla/5.0'
            }
        });
        console.log(response)

        const $ = cheerio.load(response.data);
        const newsLinks = [];

        $('a').each((index, element) => {
            const link = $(element).attr('href');
            if (link.includes('banorte')) {
                newsLinks.push(`https://www.google.com${link}`);
            }
        });
        return newsLinks

    } catch (error) {
        console.error('Error fetching news:', error);
    }
}

scrapeBanorteNews();
