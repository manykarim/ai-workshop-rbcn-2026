# API-003: Search Products

| Field       | Value                                    |
|-------------|------------------------------------------|
| **Story ID**  | API-003                                |
| **Title**     | Search Products by Keyword             |
| **Priority**  | High                                   |
| **Component** | Search API                             |
| **Endpoint**  | `GET /api/search/?query={keyword}`     |

## User Story

**As an** API consumer,
**I want to** search products by keyword,
**So that** I can implement search functionality.

## Acceptance Criteria

### AC-1: Search returns matching products by name

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/?query=headphones`
**Then** the response status code is `200`
**And** the response body contains a `results` array
**And** the `results` array includes a product with name containing "Headphones"
**And** the response contains a `mode` field with value `"keyword"`

### AC-2: Search matches products by category

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/?query=audio`
**Then** the response status code is `200`
**And** the `results` array includes products in the "Audio" category
**And** the results include "Aurora Neural Headphones" and "Echo Conference Speaker"

### AC-3: Search matches products by description

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/?query=drone`
**Then** the response status code is `200`
**And** the `results` array includes "Orbit Drone Camera"

### AC-4: Empty query returns all products

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/?query=`
**Then** the response status code is `200`
**And** the `results` array contains all 12 products
**And** the `mode` field is `"keyword"`

### AC-5: No matching results returns empty array

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/?query=zzzznonexistent`
**Then** the response status code is `200`
**And** the `results` array is empty (`[]`)
**And** the `mode` field is `"keyword"`

### AC-6: SEARCH_V2 flag enables semantic mode

**Given** the API server is running with seeded data
**And** the `SEARCH_V2` feature flag is enabled
**When** I send a `GET` request to `/api/search/?query=headphones`
**Then** the response status code is `200`
**And** the `mode` field is `"semantic"`
**And** the response contains a `context` field (string)
**And** the response still contains a `results` array

### AC-7: Search is case-insensitive

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/?query=HEADPHONES`
**Then** the response status code is `200`
**And** the `results` array includes products matching "headphones" regardless of case

### AC-8: Each result object has full product fields

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/?query=headphones`
**Then** each object in `results` contains: `id`, `name`, `sku`, `price`, `description`, `image_url`, `category`, `inventory`, `rating`, `review_count`

## Example Request -- Keyword Search

```bash
curl -s "http://localhost:8000/api/search/?query=headphones" | jq .
```

## Example Response -- Keyword Mode

```json
{
  "mode": "keyword",
  "results": [
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

## Example Response -- Semantic Mode (SEARCH_V2 enabled)

```json
{
  "mode": "semantic",
  "results": [
    {
      "id": 1,
      "name": "Aurora Neural Headphones",
      "sku": "AUR-NEU-001",
      "price": 249.99,
      "description": "Spatial audio headphones with adaptive noise control...",
      "image_url": "/static/img/aurora-headphones.jpg",
      "category": "Audio",
      "inventory": 25,
      "rating": 4.8,
      "review_count": 214
    }
  ],
  "context": "Based on the product catalog, here are the most relevant matches for 'headphones'..."
}
```

## Example Request -- Enable SEARCH_V2 flag first

```bash
# Enable SEARCH_V2
curl -s -X PUT http://localhost:8000/api/admin/flags/SEARCH_V2 \
  -H "Content-Type: application/json" \
  -d '{"enabled": true}' | jq .

# Then search
curl -s "http://localhost:8000/api/search/?query=headphones" | jq .
```

## Notes

- The search query parameter is aliased as `query` (mapped from `q` in code).
- Search uses SQL `ILIKE` against `name`, `description`, and `category` columns.
- When `SEARCH_V2` is enabled, the `RAGIndex` builds an in-memory index of all products and provides a `context` field alongside the keyword results.
- The search does not support pagination; all matching results are returned.
- No authentication is required.
