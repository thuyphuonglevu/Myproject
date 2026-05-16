# =========================================
# IMPORT LIBRARIES
# =========================================

import random
import time
import re
import pandas as pd

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.wait import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from bs4 import BeautifulSoup


# =========================================
# CONNECT TO EXISTING CHROME
# (Chrome must be opened with remote debugging port)
# =========================================
#Chạy cmd mở chrome trước: "C:\Program Files\Google\Chrome\Application\chrome.exe" --remote-debugging-port=9222 --user-data-dir="C:\chrome_debug"
chrome_options = Options()
chrome_options.add_experimental_option("debuggerAddress", "127.0.0.1:9222")

driver = webdriver.Chrome(options=chrome_options)

print("Connected to Chrome")


# =========================================
# CONFIGURATION (CHANGE EACH PROJECT)
# =========================================

BASE_URL = "https://batdongsan.com.vn/ban-can-ho-chung-cu-vinhomes-ocean-park-gia-lam"

PROJECT = "Vinhomes Ocean Park"
CITY = "Hà Nội"
BRAND = "Vinhomes"


# =========================================
# HELPER FUNCTIONS
# =========================================

def safe_text(el):
    """Safely get text from a BeautifulSoup element"""
    return el.text.strip() if el else None


def get_number(text):
    """Extract first number from text"""
    if not text:
        return None

    match = re.search(r"\d+\.?\d*", text.replace(",", "."))
    return float(match.group()) if match else None


def parse_price(text):
    """Convert price text (tỷ / triệu) to VND"""
    if not text:
        return None

    num = get_number(text)

    if num is None:
        return None

    if "tỷ" in text.lower():
        num *= 1_000_000_000

    elif "triệu" in text.lower():
        num *= 1_000_000

    return int(num)


# =========================================
# GET LISTINGS FROM SEARCH PAGE
# =========================================

def get_listings():

    cards = driver.find_elements(
        By.CSS_SELECTOR,
        "#product-lists-web .re__card-full"
    )

    listings = []

    for card in cards:

        try:

            # ===== SKIP PROMOTED ADS =====
            card_class = card.get_attribute("class")

            # skip quảng cáo
            if "promoted" in card_class:
                continue

            # ===== SKIP NATIVE SPONSORED ADS =====
            if card.find_elements(By.CSS_SELECTOR, ".re__native-sponsored-ad"):
                continue

            # ===== GET LINK =====
            link = card.find_element(
                By.CSS_SELECTOR,
                "a.js__product-link-for-product-id"
            )

            url = link.get_attribute("href")

            if not url:
                continue

            if "batdongsan.com.vn" not in url:
                continue

            # ===== SKIP EXPIRED =====
            expired = card.find_elements(By.CSS_SELECTOR, "img[src*='expired']")

            if expired:
                continue

            listings.append({
                "listing_type": card.get_attribute("vtp"),
                "url": url
            })

        except:
            pass

    return listings

# =========================================
# COLLECT ALL LISTING URLS
# =========================================

all_listings = []
seen_urls = set()

page = 1

while True:

    url = BASE_URL if page == 1 else f"{BASE_URL}/p{page}"

    print("Page:", page)

    driver.get(url)

    time.sleep(random.uniform(3, 6))

    listings = get_listings()

    new_count = 0

    for item in listings:

        if item["url"] not in seen_urls:

            seen_urls.add(item["url"])
            all_listings.append(item)

            new_count += 1

    print("New listings:", new_count)
    print("Total unique:", len(all_listings))

    # Stop if no new listings
    if new_count == 0:
        print("No new listings. Stop.")
        break

    page += 1


df_urls = pd.DataFrame(all_listings).drop_duplicates(subset="url")

print("Total URLs:", len(df_urls))


# =========================================
# CRAWL DETAIL PAGE
# =========================================

def crawl_listing(url):

    try:

        driver.get(url)

        WebDriverWait(driver, 10).until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "#product-detail-web"))
        )

        soup = BeautifulSoup(driver.page_source, "html.parser")

        # ===== TITLE =====
        titles = soup.select("h1.re__pr-title")

        listing_title = None

        for t in titles:
            text = safe_text(t)
            if text and "mã tin" not in text.lower():
                listing_title = text
                break


        # ===== DESCRIPTION =====
        description = safe_text(
            soup.select_one("#product-detail-web .re__pr-description .re__section-body")
        )


        # ===== POSTED / EXPIRED DATE =====
        posted_date = None
        expired_date = None

        rows = soup.select(".re__pr-short-info-item")

        for row in rows:

            label = safe_text(row.select_one(".title"))
            value = safe_text(row.select_one(".value"))

            if not label or not value:
                continue

            label = label.lower()

            if "ngày đăng" in label:
                posted_date = value

            elif "ngày hết hạn" in label:
                expired_date = value


        # ===== PROPERTY SPECS =====
        price_vnd = None
        area_m2 = None
        bedrooms = None
        bathrooms = None
        direction = None
        balcony_direction = None
        furnishing = None
        legal_status = None

        rows = soup.select(".re__pr-specs-content-item")

        for row in rows:

            key = safe_text(row.select_one(".re__pr-specs-content-item-title"))
            val = safe_text(row.select_one(".re__pr-specs-content-item-value"))

            if not key or not val:
                continue

            key = key.lower()

            if "giá" in key:
                price_vnd = parse_price(val)

            elif "diện tích" in key:
                area_m2 = get_number(val)

            elif "phòng ngủ" in key:
                bedrooms = get_number(val)

            elif "phòng tắm" in key or "vệ sinh" in key:
                bathrooms = get_number(val)

            elif "hướng nhà" in key:
                direction = val

            elif "hướng ban công" in key:
                balcony_direction = val

            elif "nội thất" in key:
                furnishing = val

            elif "pháp lý" in key:
                legal_status = val


        # ===== PRICE PER M2 =====
        price_per_m2 = None

        if price_vnd and area_m2:
            price_per_m2 = int(price_vnd / area_m2)


        # ===== RETURN DATA =====
        return {

            "brand": BRAND,
            "project": PROJECT,
            "city": CITY,

            "url": url,
            "title": listing_title,

            "price_vnd": price_vnd,
            "area_m2": area_m2,
            "price_per_m2": price_per_m2,

            "bedrooms": bedrooms,
            "bathrooms": bathrooms,

            "direction": direction,
            "balcony_direction": balcony_direction,

            "furnishing": furnishing,
            "legal_status": legal_status,

            "posted_date": posted_date,
            "expired_date": expired_date,

            "description": description
        }

    except Exception as e:

        print("Error:", url)
        print(e)

        return None


# =========================================
# CRAWL ALL DETAIL PAGES
# =========================================

details = []

for i, row in df_urls.iterrows():

    print("Crawling:", i)

    data = crawl_listing(row["url"])

    if data:

        data["listing_type"] = row["listing_type"]
        details.append(data)

    time.sleep(random.uniform(0.8, 1.5))


# =========================================
# SAVE DATASET
# =========================================

df_final = pd.DataFrame(details)

df_final.to_csv("Vinhomes_Ocean_Park.csv", index=False,
                encoding="utf-8-sig")

print("DONE:", len(df_final))