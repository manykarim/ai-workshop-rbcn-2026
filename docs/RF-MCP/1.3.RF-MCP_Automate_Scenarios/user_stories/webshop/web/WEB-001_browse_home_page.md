# WEB-001: Browse Home Page

| Field       | Value                          |
|-------------|--------------------------------|
| **Story ID**  | WEB-001                      |
| **Title**     | Browse Home Page             |
| **Priority**  | High                         |
| **Component** | Web Frontend                 |
| **Labels**    | homepage, discovery, browsing |

## User Story

**As a** visitor,
**I want to** see the home page with featured products, popular products, and premium picks,
**So that** I can discover items quickly.

## Acceptance Criteria

### AC-1: Page loads with hero section

**Given** a visitor navigates to the home page (`/`)
**When** the page finishes loading
**Then** a hero section is displayed containing:
  - A search bar input for product search
  - Trending category links/tags for quick navigation

### AC-2: Featured this week section

**Given** the home page has loaded
**When** the visitor scrolls to the "Featured this week" section
**Then** exactly 4 product cards are displayed
**And** each card shows the product name, product image, and price
**And** each card has a visible "Add to Cart" button
**And** each card links to the product detail page (`/products/{id}`)

### AC-3: Popular with product teams section

**Given** the home page has loaded
**When** the visitor scrolls to the "Popular with product teams" section
**Then** exactly 4 products are displayed in compact card format
**And** each compact card shows at minimum the product name and price
**And** each card has a visible "Add to Cart" button
**And** each card links to the product detail page

### AC-4: Premium creator picks section

**Given** the home page has loaded
**When** the visitor scrolls to the "Premium creator picks" section
**Then** exactly 4 products are displayed
**And** the products are sorted by price in descending order (highest first)
**And** each card shows the product name, image, and price
**And** each card has a visible "Add to Cart" button
**And** each card links to the product detail page

### AC-5: Product card Add to Cart functionality

**Given** the home page has loaded with product cards visible
**When** the visitor clicks an "Add to Cart" button on any product card
**Then** the product is added to the cart via a POST request
**And** the cart badge count in the navigation header updates accordingly

### AC-6: Product card links to detail page

**Given** the home page has loaded with product cards visible
**When** the visitor clicks on a product card (excluding the Add to Cart button)
**Then** the visitor is navigated to the product detail page at `/products/{product_id}`

### AC-7: Newsletter subscription form visible

**Given** the home page has loaded
**When** the visitor scrolls to the bottom of the page
**Then** a newsletter subscription form is visible
**And** the form contains an email input field and a submit/join button

## Test Data

| Attribute         | Value                                        |
|-------------------|----------------------------------------------|
| Total seed products | 12                                          |
| Total categories  | 9                                            |
| Featured count    | 4                                            |
| Popular count     | 4                                            |
| Premium count     | 4                                            |
| Price range       | $39.50 - $899.00                             |

### Sample Products (for verification)

| ID | Name                       | Price    | Category     |
|----|----------------------------|----------|--------------|
| 1  | Aurora Neural Headphones   | $249.99  | Audio        |

## Notes

- The hero section search bar should be functional and trigger product search (see WEB-004).
- Premium creator picks must be sorted by price descending; verify sort order in assertions.
- All three product sections (featured, popular, premium) should render independently; failure in one should not block the others.
- Product images may use placeholder URLs in the seed data; validate that `img` elements have a valid `src` attribute.
- The newsletter form is covered in detail by WEB-009.
- Verify page loads within acceptable performance thresholds (target < 3 seconds).
