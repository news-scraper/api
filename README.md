NewsScraper API
---

[![CircleCI](https://circleci.com/gh/news-scraper/api/tree/master.svg?style=svg)](https://circleci.com/gh/news-scraper/api/tree/master)

A Dashboard and API interface to interact with scheduler query scraping using the [news_scraper gem](https://github.com/news-scraper/news_scraper).

Postgres User for Blazer
---
```
BEGIN;
CREATE ROLE blazer LOGIN PASSWORD 'Ejson Password';
GRANT CONNECT ON DATABASE news_scraper_production TO blazer;
GRANT USAGE ON SCHEMA public TO blazer;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO blazer;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO blazer;
COMMIT;
```
