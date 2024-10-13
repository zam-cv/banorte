const puppeteer = require('puppeteer');
const fs = require('fs')

var result = ""
var result2 = ""

async function scrapeDivs() {
    const browser = await puppeteer.launch({
        args: ['--disable-http2'],
        headless: false,
        defaultViewport: null
    });
    const page = await browser.newPage();
    await page.goto('https://www.banorte.com/wps/portal/gfb/Home/noticias-banorte/noticias-banorte-2024', { waitUntil: 'networkidle2' });

    const h2 = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('h2')).map(div => div.innerText);
    });
    const h3 = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('h3')).map(div => div.innerText);
    });
    const h4 = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('h4')).map(div => div.innerText);
    });
    const h5 = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('h5')).map(div => div.innerText);
    });
    const h6 = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('h6')).map(div => div.innerText);
    });
    const body = await page.evaluate(() => {
        return Array.from(document.querySelectorAll('body')).map(div => div.innerText);
    });




    body.forEach((div, index) => {
        result=" "+div;
        
    });

    //result = result.replace(/\s+[\t\n]+/g, ' ');
    result = result.replace(/\s+/g, ' ');
    result = result.toLowerCase();
    console.log(result);

    fs.writeFile('Output.txt', result, (err) => {

        // In case of a error throw err.
        if (err) throw err;
    })

    await browser.close();
}

scrapeDivs();

