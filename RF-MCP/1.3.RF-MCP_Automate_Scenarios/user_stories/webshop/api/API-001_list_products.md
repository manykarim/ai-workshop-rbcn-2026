# API-001: List All Products

| Field       | Value                          |
|-------------|--------------------------------|
| **Story ID**  | API-001                      |
| **Title**     | List All Products            |
| **Priority**  | High                         |
| **Component** | Product Catalog API          |
| **Endpoint**  | `GET /api/products/`         |

## User Story

**As an** API consumer,
**I want to** list all products,
**So that** I can display them in my frontend.

## Acceptance Criteria

### AC-1: Successful product listing

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/`
**Then** the response status code is `200`
**And** the response body contains a JSON object with an `items` array
**And** the `items` array contains exactly 12 products

### AC-2: Product object structure

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/`
**Then** each item in the `items` array contains the following fields:

| Field          | Type    | Description                        |
|----------------|---------|------------------------------------|
| `id`           | integer | Unique product identifier          |
| `name`         | string  | Product name                       |
| `description`  | string  | Product description                |
| `price`        | float   | Product price in USD               |
| `category`     | string  | Product category                   |
| `rating`       | float   | Average rating (nullable)          |
| `review_count` | integer | Number of reviews (nullable)       |
| `inventory`    | integer | Stock quantity                     |
| `image_url`    | string  | Path to product image (nullable)   |
| `sku`          | string  | Stock keeping unit code            |

### AC-3: Known product prices are correct

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/`
**Then** the product named "Aurora Neural Headphones" has a price of `249.99`
**And** the product named "Atlas Standing Desk" has a price of `799.0`
**And** the product named "Insight Smart Notebook" has a price of `39.5`
**And** the product named "Orbit Drone Camera" has a price of `899.0`
**And** the product named "Cascade Water Bottle" has a price of `79.0`

### AC-4: All seed product categories are represented

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/`
**Then** the products span the following categories: Audio, Productivity, Health, Home Office, Furniture, Travel, Displays, Outdoors, Imaging

### AC-5: Products are ordered by name ascending

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/`
**Then** the `items` array is sorted alphabetically by the `name` field

## Example Request

```bash
curl -s http://localhost:8000/api/products/ | jq .
```

## Example Response

```json
{
  "items": [
    {
      "id": 5,
      "name": "Atlas Standing Desk",
      "sku": "ATL-DSK-005",
      "price": 799.0,
      "description": "Programmable standing desk with posture coaching, ambient wellness reminders, and built-in cable management.",
      "image_url": "/static/img/atlas-desk.jpg",
      "category": "Furniture",
      "inventory": 15,
      "rating": 4.9,
      "review_count": 98
    },
    {
      "id": 1,
      "name": "Aurora Neural Headphones",
      "sku": "AUR-NEU-001",
      "price": 249.99,
      "description": "Spatial audio headphones with adaptive noise control, AI-powered equaliser presets, and all-day comfort for deep work sessions.",
      "image_url": "/static/img/aurora-headphones.jpg",
      "category": "Audio",
      "inventory": 25,
      "rating": 4.8,
      "review_count": 214
    }
  ]
}
```

## Seed Product Reference

| # | Name                       | SKU           | Price    | Category      |
|---|----------------------------|---------------|----------|---------------|
| 1 | Aurora Neural Headphones   | AUR-NEU-001   | 249.99   | Audio         |
| 2 | Insight Smart Notebook     | INS-NOT-002   | 39.50    | Productivity  |
| 3 | Pulse Bio Ring             | PUL-RNG-003   | 189.00   | Health        |
| 4 | Nimbus Desk Light          | NIM-LGT-004   | 129.00   | Home Office   |
| 5 | Atlas Standing Desk        | ATL-DSK-005   | 799.00   | Furniture     |
| 6 | Velocity Travel Backpack   | VEL-BPK-006   | 169.00   | Travel        |
| 7 | Horizon Portable Display   | HOR-DSP-007   | 389.00   | Displays      |
| 8 | Focus Loop Timer           | FCS-TMR-008   | 59.00    | Productivity  |
| 9 | Summit Trail Shoes         | SUM-SHO-009   | 149.00   | Outdoors      |
| 10| Echo Conference Speaker    | ECH-SPK-010   | 219.00   | Audio         |
| 11| Orbit Drone Camera         | ORB-DRN-011   | 899.00   | Imaging       |
| 12| Cascade Water Bottle       | CAS-BOT-012   | 79.00    | Health        |

## Notes

- The product listing endpoint does not require authentication.
- Products are returned sorted by name in ascending order (default behavior in `ProductService.list_products`).
- The `image_url` field is a relative path; frontends must prepend the base URL.
- The `rating` and `review_count` fields may be `null` if not yet populated, but all 12 seed products have values for both.
- No pagination is applied; all products are returned in a single response.
