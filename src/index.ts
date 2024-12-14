import express, { Request, Response } from "express";
import puppeteer from "puppeteer";

const app = express();
const PORT = 3000;

type Query = {
  [key: string]: string;
};

app.get("/scrape", async ({ query }: Request, res: Response): Promise<any> => {
  const { url, selector } = query as Query;

  if (!url || !selector) {
    return res.status(400).json({ error: "URL and selector are required" });
  }

  try {
    const browser = await puppeteer.launch({
      args: ["--no-sandbox", "--disable-setuid-sandbox"],
    });

    const page = await browser.newPage();
    await page.goto(url, { waitUntil: "domcontentloaded" });
    await page.waitForSelector(selector);

    const html = await page.$eval(selector, (el) => el.outerHTML);

    await browser.close();

    res.status(200).json({ html });
  } catch (error) {
    res.status(500).json({ error });
  }
});

app.listen(PORT, () => {
  console.log(`Server is running`);
});
