# WEB-004: Search Products

| Field       | Value                            |
|-------------|----------------------------------|
| **Story ID**  | WEB-004                        |
| **Title**     | Search Products                |
| **Priority**  | High                           |
| **Component** | Web Frontend, API              |
| **Labels**    | search, discovery, api         |

## User Story

**As a** shopper,
**I want to** search for products,
**So that** I can quickly find what I need.

## Acceptance Criteria

### AC-1: Search form on home page

**Given** a shopper is on the home page (`/`)
**When** the page has loaded
**Then** a search form/input is visible in the hero section
**And** the input has a placeholder or label indicating its purpose

### AC-2: Search form on products page

**Given** a shopper is on the products page (`/products`)
**When** the page has loaded
**Then** a search form/input is visible on the page

### AC-3: Search submission shows results

**Given** a shopper has entered a search query in the search input
**When** the shopper submits the search form (press Enter or click search button)
**Then** a search results section is displayed on the page
**And** the results show products matching the query
**And** the results are displayed in a product grid format (cards with name, image, price)

### AC-4: Search via API

**Given** a shopper submits a search query
**When** the search request is processed
**Then** the frontend makes a call to the `/api/search` endpoint with the query parameter
**And** the API returns matching products in the response

### AC-5: Autocomplete suggestions

**Given** a shopper starts typing in the search input
**When** characters are entered
**Then** autocomplete suggestions appear via a call to `/api/search/suggest`
**And** the suggestions are displayed in a dropdown or list below the input

### AC-6: Clear search results

**Given** search results are currently displayed on the page
**When** the shopper clicks the "Clear search/results" button
**Then** the search results section is hidden
**And** the normal page content (product grid or hero section) is shown again
**And** the search input is cleared

### AC-7: Empty state for no results

**Given** a shopper submits a search query that matches no products
**When** the search results are displayed
**Then** an empty state message is shown (e.g., "No products found")
**And** the message is user-friendly and visible

### AC-8: Search results contain product cards

**Given** a search query returns matching products
**When** the results are displayed
**Then** each result is displayed as a product card
**And** each card includes the product name, price, and image
**And** each card has an "Add to Cart" button
**And** each card links to the product detail page

## Test Data

### Search Queries and Expected Results

| Query          | Expected Result                        | Products Found |
|----------------|----------------------------------------|----------------|
| "headphones"   | Aurora Neural Headphones (ID 1)        | >= 1           |
| "aurora"       | Aurora Neural Headphones (ID 1)        | >= 1           |
| "xyz123"       | No results / empty state               | 0              |
| ""             | All products or validation prompt      | Variable       |
| "audio"        | Products in Audio category             | >= 1           |

### API Endpoints

| Endpoint              | Method | Parameters         | Response                    |
|-----------------------|--------|--------------------|-----------------------------|
| `/api/search`         | GET    | `q` (query string) | Array of matching products  |
| `/api/search/suggest` | GET    | `q` (query string) | Array of suggestion strings |

### API Response Shape (expected)

```json
{
  "results": [
    {
      "id": 1,
      "name": "Aurora Neural Headphones",
      "price": 249.99,
      "category": "Audio",
      "image": "..."
    }
  ]
}
```

## Notes

- Search should be case-insensitive (searching "HEADPHONES" should yield the same results as "headphones").
- Autocomplete suggestions endpoint (`/api/search/suggest`) should respond quickly (target < 200ms) for a good user experience.
- The "Clear search/results" button should only be visible when search results are active.
- Search may match on product name, description, and/or category; clarify which fields are searchable.
- Debounce the autocomplete API calls to avoid excessive requests while the user is typing (typical: 300ms debounce).
- Verify that special characters in the search query are properly encoded and do not cause errors.
- The search results section should overlay or replace the normal content, not append below it.
- Cross-reference with WEB-001 (hero search bar) and WEB-002 (products page search).
