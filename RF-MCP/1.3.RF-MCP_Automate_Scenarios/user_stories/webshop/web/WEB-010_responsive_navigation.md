# WEB-010: Responsive Navigation

| Field       | Value                                      |
|-------------|--------------------------------------------|
| **Story ID**  | WEB-010                                  |
| **Title**     | Responsive Navigation                    |
| **Priority**  | High                                     |
| **Component** | Web Frontend                             |
| **Labels**    | navigation, responsive, mobile, a11y     |

## User Story

**As a** mobile user,
**I want to** use the navigation menu on smaller screens,
**So that** I can access all pages.

## Acceptance Criteria

### AC-1: Hamburger menu button visible on mobile

**Given** a user is viewing the site on a mobile viewport (e.g., width < 768px)
**When** the page loads
**Then** a hamburger menu button is visible in the header
**And** the button has the attribute `data-nav-toggle`
**And** the full desktop navigation links are hidden

### AC-2: Toggle navigation menu visibility

**Given** the hamburger menu button is visible on mobile
**And** the navigation menu is collapsed/hidden
**When** the user clicks the hamburger menu button
**Then** the navigation menu expands and becomes visible
**And** the menu displays navigation links

**Given** the navigation menu is expanded/visible
**When** the user clicks the hamburger menu button again
**Then** the navigation menu collapses and is hidden

### AC-3: Navigation links in mobile menu

**Given** the mobile navigation menu is expanded
**When** the user views the menu contents
**Then** the following links are present:
  - Home (`/`)
  - Products (`/products`)
  - Cart (`/cart`)
  - Checkout (`/checkout`)

### AC-4: Cart badge count in mobile navigation

**Given** the mobile navigation menu is expanded
**And** the user has items in their cart
**When** the user views the Cart link
**Then** the cart badge count is visible showing the number of items

### AC-5: Aria-expanded attribute toggles

**Given** the hamburger menu button is visible on mobile
**And** the navigation menu is collapsed
**When** the user inspects the button
**Then** the `aria-expanded` attribute is `"false"`

**Given** the user clicks the hamburger button to expand the menu
**When** the button state updates
**Then** the `aria-expanded` attribute is `"true"`

**Given** the user clicks the hamburger button again to collapse the menu
**When** the button state updates
**Then** the `aria-expanded` attribute is `"false"`

### AC-6: Navigation links work correctly

**Given** the mobile navigation menu is expanded
**When** the user clicks on a navigation link (e.g., "Products")
**Then** the user is navigated to the corresponding page (`/products`)
**And** the navigation menu collapses after navigation

### AC-7: Desktop navigation remains visible

**Given** a user is viewing the site on a desktop viewport (e.g., width >= 1024px)
**When** the page loads
**Then** the full navigation links are visible in the header
**And** the hamburger menu button is hidden

## Test Data

### Viewport Breakpoints

| Viewport      | Width    | Expected Navigation Style  | Hamburger Visible |
|---------------|----------|----------------------------|-------------------|
| Mobile small  | 375px    | Collapsed/hamburger menu   | Yes               |
| Mobile large  | 414px    | Collapsed/hamburger menu   | Yes               |
| Tablet        | 768px    | Depends on breakpoint      | Verify            |
| Desktop       | 1024px   | Full navigation visible    | No                |
| Desktop large | 1440px   | Full navigation visible    | No                |

### Navigation Links

| Label     | URL         | Test Assertion                    |
|-----------|-------------|-----------------------------------|
| Home      | `/`         | Navigates to home page            |
| Products  | `/products` | Navigates to products catalogue   |
| Cart      | `/cart`     | Navigates to cart page            |
| Checkout  | `/checkout` | Navigates to checkout page        |

### DOM Selectors

| Element             | Selector                       |
|---------------------|--------------------------------|
| Hamburger button    | `[data-nav-toggle]`            |
| Navigation menu     | Navigation element/container   |
| Cart badge          | Badge element within cart link  |

### Toggle State Sequence

| Step | Action               | aria-expanded | Menu Visible |
|------|----------------------|---------------|--------------|
| 1    | Initial load         | false         | No           |
| 2    | Click hamburger      | true          | Yes          |
| 3    | Click hamburger      | false         | No           |
| 4    | Click hamburger      | true          | Yes          |

## Notes

- The `data-nav-toggle` attribute is the primary selector for the hamburger button in test automation.
- `aria-expanded` is critical for accessibility; it informs screen reader users whether the menu is open or closed.
- The hamburger button should be keyboard accessible (focusable with Tab, activatable with Enter or Space).
- Consider testing that the Escape key closes the expanded mobile menu (accessibility best practice).
- The cart badge count in mobile navigation should stay synchronized with the desktop badge (same data source).
- Responsive behavior depends on CSS media queries or container queries; test at specific viewport widths.
- When testing with Robot Framework Browser library, use viewport resizing to simulate mobile and desktop views.
- The mobile menu may use a slide-in drawer, dropdown, or overlay pattern; verify the animation/transition does not interfere with test timing.
- Navigation links in the mobile menu should have the same destinations as their desktop counterparts.
- Cross-reference with WEB-005 for cart badge count behavior and WEB-007 for authentication button behavior in mobile navigation.
