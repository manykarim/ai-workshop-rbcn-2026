# WEB-002: Browse Product Catalogue

| Field       | Value                                  |
|-------------|----------------------------------------|
| **Story ID**  | WEB-002                              |
| **Title**     | Browse Product Catalogue             |
| **Priority**  | High                                 |
| **Component** | Web Frontend                         |
| **Labels**    | catalogue, filters, browsing, search |

## User Story

**As a** shopper,
**I want to** browse the full product catalogue with filters,
**So that** I can find products matching my criteria.

## Acceptance Criteria

### AC-1: Full product grid display

**Given** a shopper navigates to the products page (`/products`)
**When** the page finishes loading
**Then** all 12 seed products are displayed in a grid layout
**And** each product card shows name, image, price, and an "Add to Cart" button

### AC-2: Category filter checkboxes

**Given** the products page has loaded
**When** the shopper views the filter sidebar/section
**Then** a "Category" filter group is displayed with checkboxes
**And** checkboxes are available for all 9 categories present in the seed data
**And** no category checkbox is pre-selected by default

### AC-3: Price range filter

**Given** the products page has loaded
**When** the shopper views the filter sidebar/section
**Then** a "Price range" filter is displayed with a dual slider (min and max handles)
**And** the minimum value corresponds to the lowest product price ($39.50)
**And** the maximum value corresponds to the highest product price ($899.00)
**And** the slider labels or input fields show the current min/max values

### AC-4: Rating filter

**Given** the products page has loaded
**When** the shopper views the filter sidebar/section
**Then** a rating filter is displayed with a "4 stars & up" checkbox option
**And** the checkbox is unchecked by default

### AC-5: Availability filter

**Given** the products page has loaded
**When** the shopper views the filter sidebar/section
**Then** an availability filter is displayed with a "Show in-stock only" checkbox
**And** the checkbox is unchecked by default

### AC-6: Apply filters updates product list

**Given** the shopper has selected one or more filter criteria
**When** the shopper clicks the "Apply filters" button
**Then** the product grid is updated to show only products matching all selected criteria
**And** the product count reflects the filtered results

### AC-7: Category filter application

**Given** the shopper is on the products page
**When** the shopper checks the "Audio" category checkbox and clicks "Apply filters"
**Then** only products in the "Audio" category are displayed in the grid

### AC-8: Price range filter application

**Given** the shopper is on the products page
**When** the shopper sets the price range to $100-$300 and clicks "Apply filters"
**Then** only products with prices between $100.00 and $300.00 (inclusive) are displayed

### AC-9: Combined filters

**Given** the shopper is on the products page
**When** the shopper selects a category filter AND a price range AND clicks "Apply filters"
**Then** only products matching ALL selected criteria are displayed
**And** products outside the intersection of all filters are hidden

### AC-10: Reset filters

**Given** the shopper has applied one or more filters
**When** the shopper clicks the "Reset" link
**Then** all filter checkboxes are unchecked
**And** price range sliders return to their default min/max values
**And** the product grid shows all 12 products again

### AC-11: Collections to explore section

**Given** the products page has loaded
**When** the shopper scrolls to the "Collections to explore" section
**Then** category previews are displayed
**And** each category preview shows up to 3 products from that category

### AC-12: Handpicked highlights sidebar

**Given** the products page has loaded
**When** the shopper views the "Handpicked highlights" sidebar section
**Then** the top 3 products sorted by price (highest first) are displayed

### AC-13: Empty state for no results

**Given** the shopper has applied filters that match zero products
**When** the product grid updates
**Then** a message is displayed indicating no products match the current filters
**And** the message suggests adjusting filters or resetting

## Test Data

| Attribute           | Value              |
|---------------------|--------------------|
| Total products      | 12                 |
| Total categories    | 9                  |
| Min price           | $39.50             |
| Max price           | $899.00            |
| Highlights count    | 3 (top by price)   |
| Collection preview  | 3 per category     |

### Filter Combinations for Testing

| Scenario                        | Expected Count | Notes                          |
|---------------------------------|----------------|--------------------------------|
| No filters (default)            | 12             | All products visible           |
| Category: Audio only            | >= 1           | At least headphones product    |
| Price: $0 - $50                 | >= 1           | Lowest priced products         |
| Price: $900 - $1000             | 0              | No products above $899         |
| Rating: 4 stars & up            | Variable       | Depends on seed data ratings   |
| In-stock only                   | Variable       | Depends on seed stock status   |
| Category + Price combined       | Variable       | Intersection of both filters   |

## Notes

- Filter state should be reflected in the URL query parameters for shareability and bookmarkability.
- The "Apply filters" button implies a form submission pattern rather than live filtering; verify the form element and submit action.
- The dual price slider requires testing of both handles independently and together.
- Category checkboxes should allow multi-select (e.g., Audio AND Accessories simultaneously).
- Collections section is supplementary content below the main product grid.
- Empty state message should be user-friendly and actionable.
- Verify that the product grid layout is responsive (adapts to different viewport widths).
