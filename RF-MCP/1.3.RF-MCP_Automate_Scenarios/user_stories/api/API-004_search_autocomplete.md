# API-004: Search Autocomplete Suggestions

| Field       | Value                                              |
|-------------|----------------------------------------------------|
| **Story ID**  | API-004                                          |
| **Title**     | Search Autocomplete Suggestions                  |
| **Priority**  | Medium                                           |
| **Component** | Search API                                       |
| **Endpoint**  | `GET /api/search/suggest?query={text}&limit={n}` |

## User Story

**As an** API consumer,
**I want to** get autocomplete suggestions,
**So that** I can provide type-ahead search to users.

## Acceptance Criteria

### AC-1: Suggestions returned for partial query

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=aur`
**Then** the response status code is `200`
**And** the response body contains a `results` array
**And** the `results` array includes an entry with `name` containing "Aurora"

### AC-2: Suggestion object structure

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=aur`
**Then** each object in the `results` array contains exactly these fields:

| Field      | Type           | Description              |
|------------|----------------|--------------------------|
| `id`       | integer        | Product identifier       |
| `name`     | string         | Product name             |
| `price`    | float          | Product price            |
| `category` | string or null | Product category         |

**And** no other product fields (e.g., `description`, `sku`, `inventory`) are included

### AC-3: Default limit is 8

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=a` (without specifying `limit`)
**Then** the response status code is `200`
**And** the `results` array contains at most 8 entries

### AC-4: Custom limit is respected

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=a&limit=5`
**Then** the response status code is `200`
**And** the `results` array contains at most 5 entries

### AC-5: Maximum limit is 20

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=a&limit=50`
**Then** the response status code is `422` (validation error)
**And** the response body indicates the limit exceeds the maximum of 20

### AC-6: Minimum limit is 1

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=a&limit=0`
**Then** the response status code is `422` (validation error)
**And** the response body indicates the limit is below the minimum of 1

### AC-7: Minimum query length is 1 character

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=` (empty query)
**Then** the response status code is `422` (validation error)
**And** the response body indicates the query must be at least 1 character

### AC-8: Query parameter is required

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest` (no query parameter)
**Then** the response status code is `422` (validation error)

### AC-9: Suggestions match across name, description, and category

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/search/suggest?query=audio`
**Then** the `results` array includes entries for "Aurora Neural Headphones" and "Echo Conference Speaker"

## Example Request

```bash
curl -s "http://localhost:8000/api/search/suggest?query=aur&limit=5" | jq .
```

## Example Response

```json
{
  "results": [
    {
      "id": 1,
      "name": "Aurora Neural Headphones",
      "price": 249.99,
      "category": "Audio"
    }
  ]
}
```

## Example Request -- Validation Error

```bash
curl -s "http://localhost:8000/api/search/suggest?query=a&limit=0" | jq .
```

## Example Response -- Validation Error

```json
{
  "detail": [
    {
      "type": "greater_than_equal",
      "loc": ["query", "limit"],
      "msg": "Input should be greater than or equal to 1",
      "input": "0"
    }
  ]
}
```

## Notes

- The `query` parameter is aliased from `q` internally but is sent as `query` in the URL.
- The `query` parameter uses `Query(..., min_length=1)` making it required with minimum 1 character.
- The `limit` parameter has constraints: `ge=1, le=20`, default is `8`.
- Suggestions are trimmed versions of full product search results, containing only `id`, `name`, `price`, and `category`.
- The underlying search uses the same `ILIKE` matching as the full search endpoint (matches against name, description, and category).
- No authentication is required.
