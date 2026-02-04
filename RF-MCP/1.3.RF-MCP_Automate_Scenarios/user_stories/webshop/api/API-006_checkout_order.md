# API-006: Checkout and Order Creation

| Field       | Value                          |
|-------------|--------------------------------|
| **Story ID**  | API-006                      |
| **Title**     | Checkout and Order Creation  |
| **Priority**  | High                         |
| **Component** | Checkout API                 |
| **Endpoint**  | `POST /api/checkout/`        |

## User Story

**As an** API consumer,
**I want to** submit a checkout,
**So that** an order is created from the current cart contents.

## Acceptance Criteria

### AC-1: Successful checkout creates an order

**Given** the API server is running with seeded data
**And** the cart contains at least one item (e.g., product ID 1 with quantity 1)
**When** I send a `POST` request to `/api/checkout/` with body:
```json
{
  "name": "Test User",
  "email": "test@example.com",
  "address": "123 Test Street"
}
```
**Then** the response status code is `200`
**And** the response body contains `"status": "success"`
**And** the response body contains an `order` object
**And** the response body contains a `documents` array

### AC-2: Order number format

**Given** a successful checkout
**When** I inspect the `order` object
**Then** the `order_number` field matches the pattern `ORD-[A-F0-9]{8}` (e.g., `ORD-1A2B3C4D`)

### AC-3: Order contains correct financial data

**Given** the cart contains product ID 1 (Aurora Neural Headphones, $249.99) with quantity 2
**When** I complete a successful checkout
**Then** the `order.subtotal` is `499.98`
**And** the `order.tax` is `35.0` (7% of subtotal, rounded to 2dp)
**And** the `order.total` is `534.98` (subtotal + tax)

### AC-4: Tax calculated at 7%

**Given** any successful checkout
**When** I inspect the `order` object
**Then** `order.tax` equals `round(order.subtotal * 0.07, 2)`
**And** `order.total` equals `round(order.subtotal + order.tax, 2)`

### AC-5: Order includes item details

**Given** a successful checkout with items in the cart
**When** I inspect the `order.items` array
**Then** each item contains:

| Field          | Type    | Description                           |
|----------------|---------|---------------------------------------|
| `id`           | integer | Order item record ID                  |
| `product_id`   | integer | Product ID                            |
| `product_name` | string  | Product name at time of order         |
| `quantity`     | integer | Quantity ordered                      |
| `unit_price`   | float   | Price per unit                        |
| `total_price`  | float   | `unit_price * quantity`               |

### AC-6: Documents are generated

**Given** a successful checkout
**When** I inspect the `documents` array
**Then** it contains exactly 2 string paths
**And** one path contains `invoice_ORD-` and ends with `.pdf`
**And** one path contains `summary_ORD-` and ends with `.pdf`

### AC-7: Cart is cleared after successful checkout

**Given** a successful checkout
**When** I send a `GET` request to `/api/cart/` with the same session
**Then** the `items` array is empty
**And** the `total` is `0`

### AC-8: Empty cart returns 400

**Given** the API server is running
**And** the cart is empty
**When** I send a `POST` request to `/api/checkout/` with valid customer details
**Then** the response status code is `400`
**And** the response body contains `{"detail": "Cart is empty"}`

### AC-9: Name validation -- minimum 2 characters

**Given** the API server is running
**When** I send a `POST` request to `/api/checkout/` with body `{"name": "A", "email": "test@example.com", "address": "123 Test Street"}`
**Then** the response status code is `422` (validation error)

### AC-10: Email validation -- must be valid format

**Given** the API server is running
**When** I send a `POST` request to `/api/checkout/` with body `{"name": "Test", "email": "not-an-email", "address": "123 Test Street"}`
**Then** the response status code is `422` (validation error)

### AC-11: Address validation -- minimum 5 characters

**Given** the API server is running
**When** I send a `POST` request to `/api/checkout/` with body `{"name": "Test", "email": "test@example.com", "address": "Hi"}`
**Then** the response status code is `422` (validation error)

### AC-12: Session identified by X-Session-ID header

**Given** the cart has items under session `"checkout-test"`
**When** I send a `POST` request to `/api/checkout/` with header `X-Session-ID: checkout-test` and valid customer details
**Then** the order is created from the cart associated with session `"checkout-test"`

### AC-13: Order object includes customer data

**Given** a successful checkout with name "Test User", email "test@example.com", address "123 Test Street"
**When** I inspect the `order` object
**Then** `order.customer_name` is `"Test User"`
**And** `order.customer_email` is `"test@example.com"`
**And** `order.customer_address` is `"123 Test Street"`
**And** `order.status` is `"processing"`

## Example Request -- Successful Checkout

```bash
# First add an item to the cart
curl -s -X POST http://localhost:8000/api/cart/items \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: checkout-test" \
  -d '{"product_id": 1, "quantity": 2}'

# Then checkout
curl -s -X POST http://localhost:8000/api/checkout/ \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: checkout-test" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "address": "123 Test Street, City, ST 12345"
  }' | jq .
```

## Example Response -- Successful Checkout

```json
{
  "status": "success",
  "order": {
    "id": 3,
    "order_number": "ORD-A1B2C3D4",
    "customer_name": "Test User",
    "customer_email": "test@example.com",
    "customer_address": "123 Test Street, City, ST 12345",
    "subtotal": 499.98,
    "tax": 35.0,
    "total": 534.98,
    "status": "processing",
    "created_at": "2026-02-04T12:00:00",
    "user_id": null,
    "shipping_address_id": null,
    "billing_address_id": null,
    "payment_method_id": null,
    "items": [
      {
        "id": 5,
        "product_id": 1,
        "product_name": "Aurora Neural Headphones",
        "quantity": 2,
        "unit_price": 249.99,
        "total_price": 499.98
      }
    ]
  },
  "documents": [
    "generated_pdfs/invoice_ORD-A1B2C3D4.pdf",
    "generated_pdfs/summary_ORD-A1B2C3D4.pdf"
  ]
}
```

## Example Request -- Empty Cart

```bash
curl -s -X POST http://localhost:8000/api/checkout/ \
  -H "Content-Type: application/json" \
  -H "X-Session-ID: empty-cart-session" \
  -d '{
    "name": "Test User",
    "email": "test@example.com",
    "address": "123 Test Street"
  }' | jq .
```

## Example Response -- Empty Cart

```json
{
  "detail": "Cart is empty"
}
```

## Notes

- The `CheckoutRequest` model uses Pydantic: `name` (min_length=2), `email` (EmailStr), `address` (min_length=5).
- Tax rate is hardcoded at 7% in `OrderService.calculate_totals()`.
- Order numbers are generated using UUID hex prefix: `ORD-{uuid4().hex[:8].upper()}`.
- The `documents` array contains file system paths to generated PDFs, not URLs. The PDFs can be downloaded via `/api/docs/orders/{order_id}/invoice.pdf` and `/api/docs/orders/{order_id}/summary.pdf`.
- The cart is cleared after a successful order, so a subsequent `GET /api/cart/` returns empty.
- The `X-Session-ID` header defaults to `"workshop-demo"` if not provided.
- No authentication is required for checkout.
