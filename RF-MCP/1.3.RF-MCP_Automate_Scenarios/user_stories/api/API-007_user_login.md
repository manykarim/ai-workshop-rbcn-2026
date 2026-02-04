# API-007: User Login (Authentication)

| Field       | Value                          |
|-------------|--------------------------------|
| **Story ID**  | API-007                      |
| **Title**     | User Login                   |
| **Priority**  | High                         |
| **Component** | Auth API                     |
| **Endpoint**  | `POST /api/auth/login`       |

## User Story

**As an** API consumer,
**I want to** authenticate users,
**So that** they can access their account, order history, and saved details.

## Acceptance Criteria

### AC-1: Successful login with valid credentials

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/auth/login` with body:
```json
{
  "email": "jamie@flowlinesupply.com",
  "password": "demo123"
}
```
**Then** the response status code is `200`
**And** the response body contains `access_token` (non-empty string)
**And** the response body contains `token_type` with value `"bearer"`
**And** the response body contains `expires_at` (ISO 8601 datetime string)
**And** the response body contains a `user` object
**And** the response body contains an `addresses` array
**And** the response body contains a `payment_methods` array
**And** the response body contains an `orders` array

### AC-2: Token validity is 4 hours

**Given** a successful login
**When** I inspect the `expires_at` field
**Then** it is approximately 4 hours in the future from the current UTC time

### AC-3: User object contains correct data

**Given** a successful login with `jamie@flowlinesupply.com`
**When** I inspect the `user` object
**Then** it contains `"email": "jamie@flowlinesupply.com"`
**And** it contains `"full_name": "Jamie Rivera"` (returned via `User.to_dict()`)

### AC-4: Addresses are returned

**Given** a successful login with `jamie@flowlinesupply.com`
**When** I inspect the `addresses` array
**Then** it contains 2 address objects
**And** the first address has `"label": "Home"` and `"city": "San Francisco"`
**And** the second address has `"label": "Studio"` and `"city": "San Francisco"`

### AC-5: Payment methods are returned (masked)

**Given** a successful login with `jamie@flowlinesupply.com`
**When** I inspect the `payment_methods` array
**Then** it contains 2 payment method objects
**And** the first has `"brand": "Visa"` and `"last4": "4242"`
**And** the second has `"brand": "Amex"` and `"last4": "3782"`
**And** each payment method includes a `display` field (masked card string)

### AC-6: Orders are returned with PDF links

**Given** a successful login with `jamie@flowlinesupply.com`
**When** I inspect the `orders` array
**Then** it contains 2 order objects
**And** each order includes: `id`, `order_number`, `status`, `total`, `created_at`
**And** each order includes `invoice_url` matching pattern `/api/docs/orders/{id}/invoice.pdf`
**And** each order includes `summary_url` matching pattern `/api/docs/orders/{id}/summary.pdf`

### AC-7: Orders are sorted by creation date descending

**Given** a successful login with `jamie@flowlinesupply.com`
**When** I inspect the `orders` array
**Then** orders are sorted with the most recent order first

### AC-8: Invalid credentials return 401

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/auth/login` with body:
```json
{
  "email": "jamie@flowlinesupply.com",
  "password": "wrongpassword"
}
```
**Then** the response status code is `401`
**And** the response body contains `{"detail": "Invalid credentials"}`

### AC-9: Non-existent user returns 401

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/auth/login` with body:
```json
{
  "email": "nonexistent@example.com",
  "password": "anything"
}
```
**Then** the response status code is `401`
**And** the response body contains `{"detail": "Invalid credentials"}`

### AC-10: Second test user can log in

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/auth/login` with body:
```json
{
  "email": "alex.productlead@example.com",
  "password": "flowline"
}
```
**Then** the response status code is `200`
**And** the `user` object contains `"full_name": "Alex Morgan"`
**And** the `addresses` array contains 1 address
**And** the `payment_methods` array contains 1 payment method
**And** the `orders` array contains 1 order

### AC-11: Email validation

**Given** the API server is running
**When** I send a `POST` request to `/api/auth/login` with body `{"email": "not-valid", "password": "demo123"}`
**Then** the response status code is `422` (validation error)

## Test User Credentials

| Email                            | Password   | Full Name     | Addresses | Payment Methods | Orders |
|----------------------------------|------------|---------------|-----------|-----------------|--------|
| `jamie@flowlinesupply.com`       | `demo123`  | Jamie Rivera  | 2         | 2               | 2      |
| `alex.productlead@example.com`   | `flowline` | Alex Morgan   | 1         | 1               | 1      |

## Example Request -- Successful Login

```bash
curl -s -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "jamie@flowlinesupply.com",
    "password": "demo123"
  }' | jq .
```

## Example Response -- Successful Login

```json
{
  "access_token": "a1b2c3d4e5f6...",
  "token_type": "bearer",
  "expires_at": "2026-02-04T20:00:00",
  "user": {
    "id": 1,
    "email": "jamie@flowlinesupply.com",
    "full_name": "Jamie Rivera"
  },
  "addresses": [
    {
      "id": 1,
      "label": "Home",
      "line1": "123 Flow Street",
      "line2": "Suite 400",
      "city": "San Francisco",
      "state": "CA",
      "postal_code": "94107",
      "country": "USA"
    },
    {
      "id": 2,
      "label": "Studio",
      "line1": "88 Market Lane",
      "line2": null,
      "city": "San Francisco",
      "state": "CA",
      "postal_code": "94105",
      "country": "USA"
    }
  ],
  "payment_methods": [
    {
      "id": 1,
      "brand": "Visa",
      "last4": "4242",
      "exp_month": 7,
      "exp_year": 2027,
      "billing_address_id": 1,
      "display": "Visa ****4242"
    },
    {
      "id": 2,
      "brand": "Amex",
      "last4": "3782",
      "exp_month": 11,
      "exp_year": 2026,
      "billing_address_id": 2,
      "display": "Amex ****3782"
    }
  ],
  "orders": [
    {
      "id": 2,
      "order_number": "ORD-B2C3D4E5",
      "status": "processing",
      "total": 992.56,
      "created_at": "2026-02-04T10:30:00",
      "invoice_url": "/api/docs/orders/2/invoice.pdf",
      "summary_url": "/api/docs/orders/2/summary.pdf"
    },
    {
      "id": 1,
      "order_number": "ORD-A1B2C3D4",
      "status": "fulfilled",
      "total": 352.15,
      "created_at": "2026-02-03T14:00:00",
      "invoice_url": "/api/docs/orders/1/invoice.pdf",
      "summary_url": "/api/docs/orders/1/summary.pdf"
    }
  ]
}
```

## Example Request -- Invalid Credentials

```bash
curl -s -X POST http://localhost:8000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "jamie@flowlinesupply.com",
    "password": "wrongpassword"
  }' | jq .
```

## Example Response -- Invalid Credentials

```json
{
  "detail": "Invalid credentials"
}
```

## Notes

- The token is generated using SHA-256 hash of email + expiry + random hex. It is not a standard JWT; it is an opaque token.
- Passwords are stored as SHA-256 hashes of the plain-text password.
- The `LoginResponse` Pydantic model enforces the response schema.
- The `user.to_dict()` method returns the user's public fields. The exact fields depend on the `User` model implementation.
- Orders are eagerly loaded with their items via `selectinload`.
- Payment method `display` field uses the `PaymentMethod.masked()` method.
- No rate limiting is implemented on the login endpoint.
