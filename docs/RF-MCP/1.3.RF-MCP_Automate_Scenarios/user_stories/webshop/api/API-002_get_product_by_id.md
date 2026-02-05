# API-002: Get Product by ID

| Field       | Value                                 |
|-------------|---------------------------------------|
| **Story ID**  | API-002                             |
| **Title**     | Get Product by ID                   |
| **Priority**  | High                                |
| **Component** | Product Catalog API                 |
| **Endpoint**  | `GET /api/products/{product_id}`    |

## User Story

**As an** API consumer,
**I want to** get a single product by ID,
**So that** I can show its detail page.

## Acceptance Criteria

### AC-1: Successfully retrieve a product by valid ID

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/1`
**Then** the response status code is `200`
**And** the response body contains a `product` object
**And** the `product.name` is `"Aurora Neural Headphones"`
**And** the `product.sku` is `"AUR-NEU-001"`
**And** the `product.price` is `249.99`
**And** the `product.category` is `"Audio"`

### AC-2: Product object includes all fields

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/1`
**Then** the `product` object contains all of the following fields:

| Field          | Type    | Expected Value (for product 1)            |
|----------------|---------|-------------------------------------------|
| `id`           | integer | `1`                                       |
| `name`         | string  | `"Aurora Neural Headphones"`              |
| `sku`          | string  | `"AUR-NEU-001"`                           |
| `price`        | float   | `249.99`                                  |
| `description`  | string  | Non-empty string                          |
| `image_url`    | string  | `"/static/img/aurora-headphones.jpg"`     |
| `category`     | string  | `"Audio"`                                 |
| `inventory`    | integer | `25`                                      |
| `rating`       | float   | `4.8`                                     |
| `review_count` | integer | `214`                                     |

### AC-3: Non-existent product returns 404

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/999`
**Then** the response status code is `404`
**And** the response body contains a `detail` field with value `"Product not found"`

### AC-4: Each seeded product is retrievable by ID

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/products/{id}` for each ID from 1 to 12
**Then** each response status code is `200`
**And** each response body contains a valid `product` object with all required fields

## Example Request -- Success

```bash
curl -s http://localhost:8000/api/products/1 | jq .
```

## Example Response -- Success

```json
{
  "product": {
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
}
```

## Example Request -- Not Found

```bash
curl -s http://localhost:8000/api/products/999 | jq .
```

## Example Response -- Not Found

```json
{
  "detail": "Product not found"
}
```

## Notes

- The `product_id` path parameter is an integer. FastAPI performs type validation automatically.
- The response wraps the product in a `{"product": {...}}` envelope.
- No authentication is required for this endpoint.
- The error is raised as an `HTTPException` with status 404, so the response body uses FastAPI's standard `{"detail": "..."}` format.
