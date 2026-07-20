# Breaking Games — Student Data Reference

This folder contains **two ways to access the data**:

- **`breaking_games.db`** — the pre-built SQLite database. Download this, open it in DB Browser for SQLite, and you're ready to write queries in 60 seconds. This is the recommended path.
- **The six `.csv` files** — the raw, cleaned exports the database was built from. You can use these if you want to practice importing data yourself, or if you ever need to rebuild the database from scratch.

Both contain identical data. Pick whichever path you prefer; you don't need both.

**Data period:** January 1, 2025 – July 29, 2025 (with a few July-only files noted below).
**Currency:** USD throughout.
**Encoding:** UTF-8, comma-separated, headers in the first row.

**Privacy note:** The checkout file originally contained real customer names, emails, and addresses. All of that has been replaced with synthetic values (`customer_001@example.com`, `Customer 001`). The product, geography (city/province/country), and behavioral data is real. Treat the file as you would any production export — keep it in this folder, don't share it outside the externship.

---

## File overview

| File | Rows | What it knows |
|---|---|---|
| `shopify_sales.csv` | 99 | Aggregated sales per product for the period |
| `shopify_orders.csv` | 254 | Individual order line items (July only) |
| `shopify_checkouts.csv` | 1,367 | Checkout line items including ones that didn't complete |
| `referrals.csv` | 8,712 | Site traffic by referrer and landing page |
| `meta_campaigns.csv` | 35 | Facebook + Instagram ad campaign performance |
| `meta_ad_sets.csv` | 8 | Ad set–level performance (a level below campaigns) |

---

## `shopify_sales.csv` — aggregated product sales

One row per product. Useful for top-line questions like "what made us money?"

| Column | Type | Example | Description |
|---|---|---|---|
| `product_title` | TEXT | `Dwellings of Eldervale 2nd Edition: Standard` | The full product name as it appears in Shopify |
| `product_vendor` | TEXT | `Breaking Games` | Almost always "Breaking Games"; occasionally a partner |
| `product_type` | TEXT | `Game` | High-level category: `Game`, `Game Accessory`, etc. |
| `net_items_sold` | INTEGER | `129` | Units sold minus units returned |
| `gross_sales` | REAL | `13098.69` | Revenue before discounts, returns, taxes |
| `discounts` | REAL | `-420.04` | Discounts applied (stored as negative) |
| `returns` | REAL | `-189.98` | Refunded sales (stored as negative) |
| `net_sales` | REAL | `12488.67` | `gross_sales + discounts + returns` |
| `taxes` | REAL | `834.89` | Tax collected |
| `total_sales` | REAL | `13323.56` | `net_sales + taxes`; the final reported number |

**Gotchas:**
- `discounts` and `returns` are stored as **negative** numbers. Be careful when reading them.
- A few rows have `0` for everything — those are products with returns that offset sales exactly.

---

## `shopify_orders.csv` — order line items (July only)

One row per line item within an order. **One order can have multiple rows** (one per product, plus shipping/tax lines).

| Column | Type | Example | Description |
|---|---|---|---|
| `day` | TEXT | `2025-07-01` | Date the sale was recorded |
| `sale_id` | INTEGER | `18571300372527` | Shopify's internal sale identifier |
| `order_name` | TEXT | `BREAKING-GAMES-57826` | Human-readable order reference |
| `product_title` | TEXT | `Dwellings of Eldervale...` | Title at time of sale (may differ from current catalog title) |
| `gross_sales` | REAL | `89.99` | Per-line revenue |
| `discounts` | REAL | `0.0` | Discounts applied to this line |
| `returns` | REAL | `0.0` | Returns on this line |
| `net_sales` | REAL | `89.99` | After discounts and returns |
| `shipping_charges` | REAL | `12.50` | Shipping (typically on its own line) |
| `return_fees` | REAL | `0` | Return processing fees |
| `taxes` | REAL | `0.0` | Tax for this line |
| `total_sales` | REAL | `102.49` | Final line total |

**Gotchas:**
- Some rows have an empty `product_title` — those are non-product lines (shipping, tax, gift wrap).
- This file only covers **July 1–29, 2025**. The other Shopify files cover January–July.

---

## `shopify_checkouts.csv` — anonymized checkout sessions

One row per line item across all checkout sessions (including ones that didn't complete). Use this for cart abandonment analysis.

| Column | Type | Example | Description |
|---|---|---|---|
| `name` | TEXT | `#44051427229743` | Cart/checkout reference number |
| `email` | TEXT | `customer_001@example.com` | **Anonymized** — synthetic email, not real |
| `customer_id` | INTEGER | `1` | Synthetic stable customer identifier |
| `customer_name` | TEXT | `Customer 001` | **Anonymized** — synthetic name |
| `financial_status` | TEXT | `paid`, `pending`, NULL | Payment state (NULL = unfinished checkout) |
| `fulfillment_status` | TEXT | `unfulfilled`, `fulfilled` | Shipping state |
| `accepts_marketing` | TEXT | `yes`, `no` | Did they opt into marketing? |
| `currency` | TEXT | `USD` | Always USD in this dataset |
| `subtotal` | REAL | `60.00` | Pre-tax/shipping total |
| `shipping` | REAL | `44.97` | Shipping cost |
| `taxes` | REAL | `0.0` | Tax |
| `total` | REAL | `104.97` | Final cart total |
| `discount_code` | TEXT | `SAVE10`, NULL | Code applied (NULL if none) |
| `discount_amount` | REAL | `0.0` | Discount in dollars |
| `shipping_method` | TEXT | `FedEx International Connect Plus` | Carrier + service |
| `created_at` | TEXT | `2025-07-29 08:20:35 -0400` | Timestamp, includes timezone offset |
| `lineitem_quantity` | INTEGER | `1` | How many of this product in the cart |
| `lineitem_name` | TEXT | `Expancity \| Family Strategy City Building Game...` | Product name (variants suffixed after `\|`) |
| `lineitem_price` | REAL | `60.00` | Per-unit price |
| `lineitem_sku` | TEXT | `BGZ110192` | Stock keeping unit |
| `lineitem_discount` | INTEGER | `0` | Discount on this line |
| `billing_city` | TEXT | `Barsha Heights` | City for billing |
| `billing_province` | TEXT | `DU` | State/province code |
| `billing_country` | TEXT | `AE` | ISO country code |
| `shipping_city` | TEXT | `Barsha Heights` | City for shipping |
| `shipping_province` | TEXT | `DU` | Shipping state/province |
| `shipping_country` | TEXT | `AE` | Shipping country |
| `payment_method` | TEXT | `shopify_payments`, NULL | Payment processor used |
| `refunded_amount` | REAL | `0.0`, NULL | Amount refunded (NULL if none) |
| `vendor` | TEXT | `Breaking Games` | Almost always "Breaking Games" |
| `risk_level` | TEXT | `Low`, `Medium`, `High` | Shopify's fraud risk score |
| `source` | TEXT | `web`, `pos`, NULL | Where the checkout originated |

**Gotchas:**
- 1,367 rows are **line items**, not unique sessions. Some carts have multiple line items.
- A `name` (cart reference) repeats across rows when a cart has multiple products.
- Empty `financial_status` typically means the checkout was abandoned.
- A small number of carts have suspiciously high `lineitem_quantity` values. We'll investigate those in Week 5.

---

## `referrals.csv` — site traffic by referrer and landing page

One row per (referrer × landing page) combination. Tells you where visitors come from and what they land on.

| Column | Type | Example | Description |
|---|---|---|---|
| `referrer` | TEXT | `facebook`, `google`, `direct` | Source of the visit |
| `landing_page` | TEXT | `/products/dwellings-of-eldervale-...` | First page they landed on |
| `pageviews` | INTEGER | `62447` | Pageviews from this combo |
| `added_to_cart_rate` | REAL | `0.0030` | Fraction of sessions that added to cart |
| `pageviews_per_session` | REAL | `1.14` | Average page depth |
| `conversion_rate` | REAL | `0.0007` | Fraction of sessions that purchased |
| `bounce_rate` | REAL | `0.9428` | Fraction that bounced |
| `checkout_sessions` | INTEGER | `41` | Sessions that completed checkout |
| `pageviews_previous_year` | INTEGER | `16` | Year-over-year comparison data |
| `added_to_cart_rate_previous_year` | REAL | `0.0` | Year-over-year add-to-cart rate |
| `pageviews_per_session_previous_year` | REAL | `2.0` | YoY page depth |
| `conversion_rate_previous_year` | REAL | `0.0` | YoY conversion rate |
| `bounce_rate_previous_year` | REAL | `0.625` | YoY bounce rate |
| `sessions_that_completed_checkout_previous_year` | INTEGER | `0` | YoY checkout sessions |

**Gotchas:**
- Rates are stored as **fractions**, not percentages. `0.003` means 0.3%, not 3%.
- Landing pages include `/products/`, `/collections/`, `/`, `/cart`, etc. The `/products/<slug>` ones are individual product pages.
- The product slug in the URL doesn't always match the product title in `shopify_sales` cleanly — variants and historical pages cause ~10–15% miss rate.

---

## `meta_campaigns.csv` — campaign-level Meta ad performance

One row per campaign for the full period.

| Column | Type | Example | Description |
|---|---|---|---|
| `reporting_starts` | TEXT | `2025-01-01` | Start of reporting window |
| `reporting_ends` | TEXT | `2025-07-29` | End of reporting window |
| `campaign_name` | TEXT | `Klask Videos` | Campaign name as set in Meta Ads Manager |
| `delivery_status` | TEXT | `active`, `inactive`, `completed` | Was this campaign running? |
| `results` | REAL | `32` | Number of optimization results (purchases, link clicks, etc.) |
| `result_indicator` | TEXT | `actions:offsite_conversion.fb_pixel_purchase` | What "result" was being optimized for |
| `reach` | INTEGER | `73549` | Unique people who saw the ad |
| `frequency` | REAL | `2.22` | Average impressions per person |
| `cost_per_result` | REAL | `50.81` | Spend per result |
| `spend_usd` | REAL | `1625.80` | **Total dollars spent** on this campaign |
| `impressions` | INTEGER | `163619` | Total times the ad was shown |
| `cpm_usd` | REAL | `9.94` | Cost per 1,000 impressions |
| `link_clicks` | INTEGER | `1448` | Clicks on links in the ad |
| `shop_clicks` | INTEGER | NULL | Clicks specifically to the shop (mostly null) |
| `cpc_usd` | REAL | `1.12` | Cost per link click |
| `ctr_link` | REAL | `0.0088` | Link click-through rate (fraction) |
| `clicks_all` | INTEGER | `2711` | All clicks (including non-link) |
| `ctr_all` | REAL | `0.0166` | All-click CTR |
| `cpc_all_usd` | REAL | `0.60` | Cost per any click |

**Gotchas:**
- Many campaigns have NULL `results` — those didn't produce conversions during the window.
- `delivery_status = inactive` means the campaign was paused at some point. Spend may still be > 0.
- `spend_usd` was originally called `Amount spent (USD)` in the source — renamed for SQL friendliness.

---

## `meta_ad_sets.csv` — ad set–level performance

One row per ad set (a level below campaigns in Meta's hierarchy). Same columns as `meta_campaigns.csv` plus `ad_set_name` instead of `campaign_name`.

Only 8 rows. Useful for understanding which **targeting** worked within larger campaigns.

---

## A few things to know about all six files

### Number formatting

All currency values are stored as **plain decimal numbers** (e.g., `13098.69`, not `$13,098.69`). Earlier Shopify exports sometimes included dollar signs in revenue columns; this dataset is already clean.

### Missing values

Real-world data has gaps. You'll see NULL (empty) values in many columns. Some are expected (e.g., `financial_status` is NULL for abandoned carts); some are noise. We'll talk about handling NULLs explicitly in Week 2.

### Joining across files

There's no shared customer ID across the Shopify files and the Meta files — those are separate systems. The natural bridges are:

- `shopify_sales.product_title` ⇆ `shopify_orders.product_title` ⇆ `shopify_checkouts.lineitem_name` (fuzzy text match)
- `referrals.landing_page` ⇆ product slugs in `shopify_sales` (via the `/products/<slug>` URL pattern)
- `meta_campaigns.campaign_name` ⇆ targeted products (loose match by name only)

You'll be designing a real schema in Week 2 to make these joins clean. For now, just know the data is *almost* connected but not perfectly.

### When something looks wrong

Real exports come with quirks. A small percentage of rows in any file may look odd — empty fields, suspiciously round numbers, products that don't appear in any other file. That's normal. If a query result surprises you, your first instinct should be *"what's wrong with the data?"* before *"I made a breakthrough discovery."* Most surprises are bugs. Sometimes they're real. Always check first.
