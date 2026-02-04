# WEB-005: Manage Cart

| Field       | Value                                |
|-------------|--------------------------------------|
| **Story ID**  | WEB-005                            |
| **Title**     | Manage Cart                        |
| **Priority**  | Critical                           |
| **Component** | Web Frontend, API                  |
| **Labels**    | cart, checkout-flow, api, session   |

## User Story

**As a** shopper,
**I want to** add products to my cart and manage cart contents,
**So that** I can prepare for checkout.

## Acceptance Criteria

### AC-1: Add to Cart sends API request

**Given** a shopper is viewing a product card on any page (home, products, detail)
**When** the shopper clicks the "Add to Cart" button
**Then** a POST request is sent to `/api/cart/items` with the product ID
**And** the request includes session identification (see AC-8)

### AC-2: Cart badge updates after adding item

**Given** a shopper has clicked "Add to Cart" on a product
**When** the API responds successfully
**Then** the cart count badge in the navigation header updates to reflect the new total item count
**And** the badge is visible in both desktop and mobile navigation

### AC-3: Cart page displays items

**Given** a shopper has added one or more items to the cart
**When** the shopper navigates to the cart page (`/cart`)
**Then** all cart items are listed with the following details for each:
  - Product name
  - Quantity
  - Unit price
  - Line total (quantity x unit price)

### AC-4: Cart summary section

**Given** the cart page is loaded with items in the cart
**When** the shopper views the cart summary section
**Then** the summary displays:
  - Subtotal (sum of all line totals)
  - Shipping: "Complimentary"
  - Tax: "Calculated at checkout"
  - Total (equal to subtotal since shipping is free and tax is deferred)

### AC-5: Proceed to Checkout button

**Given** the cart page is loaded with items
**When** the shopper views the cart actions
**Then** a "Proceed to Checkout" button is visible
**And** clicking it navigates the shopper to `/checkout`

### AC-6: Continue Shopping button

**Given** the cart page is loaded
**When** the shopper views the cart actions
**Then** a "Continue Shopping" button/link is visible
**And** clicking it navigates the shopper to `/products`

### AC-7: Empty cart state

**Given** the shopper has no items in the cart
**When** the shopper navigates to the cart page (`/cart`)
**Then** a message is displayed: "Your cart is still empty"
**And** a "Browse" or equivalent button is shown to navigate to the products page
**And** the cart summary and checkout button are not displayed

### AC-8: Session identification

**Given** a shopper interacts with the cart
**When** any cart API request is made
**Then** the session is identified by one of:
  - `X-Session-ID` request header
  - `session_id` cookie
**And** if neither is provided, the session defaults to `"workshop-demo"`

### AC-9: Adding duplicate product increments quantity

**Given** a shopper has already added product ID 1 to the cart
**When** the shopper clicks "Add to Cart" on product ID 1 again
**Then** the quantity for that item in the cart is incremented by 1
**And** a new line item is NOT created

## Test Data

### Cart API Endpoints

| Endpoint           | Method | Headers/Cookies          | Body                     | Response                    |
|--------------------|--------|--------------------------|--------------------------|-----------------------------|
| `/api/cart/items`  | POST   | `X-Session-ID: test-123` | `{ "product_id": 1 }`   | Updated cart object         |
| `/api/cart`        | GET    | `X-Session-ID: test-123` |                          | Full cart with items/totals |

### Session ID Scenarios

| Scenario                     | Session Source       | Expected Session ID  |
|------------------------------|----------------------|----------------------|
| Header provided              | `X-Session-ID`       | Value from header    |
| Cookie provided              | `session_id` cookie  | Value from cookie    |
| Neither provided             | Default              | `"workshop-demo"`    |
| Both provided (header wins)  | Both                 | Value from header    |

### Cart State Scenarios

| Scenario              | Items in Cart | Expected Display                         |
|-----------------------|---------------|------------------------------------------|
| Empty cart            | 0             | "Your cart is still empty" + browse link |
| Single item           | 1             | One line item + summary                  |
| Multiple items        | 3+            | Multiple line items + correct totals     |
| Duplicate product add | 1 (qty 2)     | Single line, quantity = 2                |

### Sample Cart Calculation

| Product                    | Qty | Unit Price | Line Total |
|----------------------------|-----|------------|------------|
| Aurora Neural Headphones   | 1   | $249.99    | $249.99    |
| Another Product            | 2   | $79.00     | $158.00    |
| **Subtotal**               |     |            | **$407.99**|
| **Shipping**               |     |            | Complimentary |
| **Tax**                    |     |            | Calculated at checkout |
| **Total**                  |     |            | **$407.99**|

## Notes

- The cart badge count in the navigation should reflect the total number of individual items (sum of quantities), not distinct products.
- Session identification priority: `X-Session-ID` header takes precedence over `session_id` cookie, which takes precedence over the default.
- The default session ID `"workshop-demo"` means all anonymous users share the same cart in a demo environment; tests should use unique session IDs to avoid conflicts.
- "Complimentary" shipping and "Calculated at checkout" tax are static display strings, not computed values.
- Verify that the cart state persists across page navigations within the same session.
- Test adding products from different pages (home, products, detail) to ensure all Add to Cart buttons use the same API flow.
- The cart page should handle gracefully if the cart API is unavailable (show an error state, not a blank page).
- Cross-reference with WEB-006 for the checkout flow that follows cart management.
