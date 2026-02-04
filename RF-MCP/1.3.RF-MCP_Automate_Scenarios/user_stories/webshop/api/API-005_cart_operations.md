# API-005: Cart Operations

| Field       | Value                                                  |
|-------------|--------------------------------------------------------|
| **Story ID**  | API-005                                              |
| **Title**     | Shopping Cart Management                             |
| **Priority**  | High                                                 |
| **Component** | Cart API                                             |
| **Endpoints** | `GET /api/cart/`, `POST /api/cart/items`, `DELETE /api/cart/` |

## User Story

**As an** API consumer,
**I want to** manage the shopping cart,
**So that** users can add, view, and clear items before checkout.

## Acceptance Criteria

### AC-1: Get empty cart state

**Given** the API server is running
**And** the cart is empty for the current session
**When** I send a `GET` request to `/api/cart/`
**Then** the response status code is `200`
**And** the response body contains:
  - `session`: the session key string (defaults to `"workshop-demo"`)
  - `items`: an empty array (`[]`)
  - `total`: `0`

### AC-2: Add item to cart

**Given** the API server is running with seeded data
**And** product with ID `1` exists (Aurora Neural Headphones, $249.99)
**When** I send a `POST` request to `/api/cart/items` with body `{"product_id": 1, "quantity": 2}`
**Then** the response status code is `200`
**And** the response body contains the updated cart state
**And** the `items` array contains an entry with:
  - `product_id`: `1`
  - `name`: `"Aurora Neural Headphones"`
  - `quantity`: `2`
  - `unit_price`: `249.99`
  - `total_price`: `499.98`
**And** the `total` field equals `499.98`

### AC-3: Adding same product increments quantity

**Given** the API server is running with seeded data
**And** the cart already contains product ID `1` with quantity `2`
**When** I send a `POST` request to `/api/cart/items` with body `{"product_id": 1, "quantity": 1}`
**Then** the response status code is `200`
**And** the cart item for product ID `1` has quantity `3`
**And** the `total_price` for that item is `749.97`

### AC-4: Maximum quantity per item is 20

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/cart/items` with body `{"product_id": 1, "quantity": 21}`
**Then** the response status code is `422` (validation error)
**And** the response body indicates quantity must be at most 20

### AC-5: Minimum quantity is 1

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/cart/items` with body `{"product_id": 1, "quantity": 0}`
**Then** the response status code is `422` (validation error)
**And** the response body indicates quantity must be at least 1

### AC-6: product_id must be >= 1

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/cart/items` with body `{"product_id": 0, "quantity": 1}`
**Then** the response status code is `422` (validation error)
**And** the response body indicates product_id must be at least 1

### AC-7: Adding non-existent product returns 404

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/cart/items` with body `{"product_id": 999, "quantity": 1}`
**Then** the response status code is `404`
**And** the response body contains `{"detail": "Product not found"}`

### AC-8: Clear cart

**Given** the API server is running
**And** the cart contains one or more items
**When** I send a `DELETE` request to `/api/cart/`
**Then** the response status code is `200`
**And** the response body is `{"status": "cleared", "session": "workshop-demo"}`

### AC-9: Session identified by X-Session-ID header

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/cart/items` with header `X-Session-ID: test-session-123` and body `{"product_id": 1, "quantity": 1}`
**And** I then send a `GET` request to `/api/cart/` with header `X-Session-ID: test-session-123`
**Then** the response contains `"session": "test-session-123"`
**And** the cart items reflect the previously added product

### AC-10: Default session key is "workshop-demo"

**Given** the API server is running
**When** I send a `GET` request to `/api/cart/` without an `X-Session-ID` header
**Then** the response contains `"session": "workshop-demo"`

### AC-11: Cart item response structure

**Given** the API server is running with items in the cart
**When** I send a `GET` request to `/api/cart/`
**Then** each item in the `items` array contains:

| Field          | Type    | Description                              |
|----------------|---------|------------------------------------------|
| `product_id`   | integer | ID of the product                        |
| `name`         | string  | Product name                             |
| `quantity`     | integer | Number of units                          |
| `unit_price`   | float   | Price per single unit                    |
| `total_price`  | float   | `unit_price * quantity`, rounded to 2dp  |

## Example Request -- Get Cart

```bash
curl -s http://localhost:8000/api/cart/ \
  -H "X-Session-ID: test-session" | jq .
```

## Example Response -- Empty Cart

```json
{
  "session": "test-session",
  "items": [],
  "total": 0
}
```

## Example Request -- Add Item

```bash
curl -s -X POST http://localhost:8000/api/cart/items \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: test-session" \
  -d '{"product_id": 1, "quantity": 2}' | jq .
```

## Example Response -- Add Item

```json
{
  "session": "test-session",
  "items": [
    {
      "product_id": 1,
      "name": "Aurora Neural Headphones",
      "quantity": 2,
      "unit_price": 249.99,
      "total_price": 499.98
    }
  ],
  "total": 499.98
}
```

## Example Request -- Clear Cart

```bash
curl -s -X DELETE http://localhost:8000/api/cart/ \
  -H "X-Session-ID: test-session" | jq .
```

## Example Response -- Clear Cart

```json
{
  "status": "cleared",
  "session": "test-session"
}
```

## Notes

- The `X-Session-ID` header is optional. When absent, the session defaults to `"workshop-demo"`.
- The `AddToCartRequest` model enforces `product_id >= 1` and `1 <= quantity <= 20` via Pydantic `Field` constraints.
- When the same product is added again, its quantity is incremented rather than creating a duplicate entry.
- The `total` field on the cart state is the sum of all item `total_price` values, rounded to 2 decimal places.
- The `image_url` field is mentioned in the user story requirements but is not currently included in the cart state response from `CartService.get_cart_state()`. This is a known gap between the cart API and the frontend cart page (which accesses product details separately).
- No authentication is required for cart operations.
