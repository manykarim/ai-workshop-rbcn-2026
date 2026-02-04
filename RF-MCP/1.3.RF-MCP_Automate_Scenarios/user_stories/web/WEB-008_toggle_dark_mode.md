# WEB-008: Toggle Dark Mode

| Field       | Value                              |
|-------------|------------------------------------|
| **Story ID**  | WEB-008                          |
| **Title**     | Toggle Dark Mode                 |
| **Priority**  | Medium                           |
| **Component** | Web Frontend                     |
| **Labels**    | theme, dark-mode, accessibility, ui |

## User Story

**As a** user,
**I want to** toggle between light and dark themes,
**So that** I can use the site comfortably in any lighting.

## Acceptance Criteria

### AC-1: Theme toggle button visible in header

**Given** a user is on any page of the website
**When** the user views the header/navigation
**Then** a theme toggle button is visible
**And** the button displays a sun or moon icon (indicating the current or target theme)

### AC-2: Toggle switches theme

**Given** the site is in light mode (default)
**When** the user clicks the theme toggle button
**Then** the site switches to dark mode
**And** the visual appearance of the page changes (background, text colors, etc.)

**Given** the site is in dark mode
**When** the user clicks the theme toggle button
**Then** the site switches back to light mode

### AC-3: Aria-pressed state toggles

**Given** the theme toggle button is in the light mode state
**When** the user inspects the button's accessibility attributes
**Then** the `aria-pressed` attribute is `"false"` (or the button reflects the unpressed state)

**Given** the user clicks the toggle button to activate dark mode
**When** the button state updates
**Then** the `aria-pressed` attribute is `"true"` (or the button reflects the pressed state)

### AC-4: Theme label updates

**Given** the site is in light mode
**When** the user views the theme toggle area
**Then** the label or tooltip reflects the current mode (e.g., "Light mode" or "Switch to dark mode")

**Given** the user switches to dark mode
**When** the toggle label updates
**Then** the label reflects dark mode (e.g., "Dark mode" or "Switch to light mode")

### AC-5: Theme persists across page navigation

**Given** the user has switched to dark mode
**When** the user navigates to a different page (e.g., from home to products)
**Then** the dark mode theme remains active
**And** the toggle button reflects the dark mode state

**Given** the user has switched back to light mode
**When** the user navigates to a different page
**Then** the light mode theme remains active

## Test Data

### Toggle State Matrix

| Initial State | Action         | Expected State | aria-pressed | Icon    |
|---------------|----------------|----------------|--------------|---------|
| Light mode    | Click toggle   | Dark mode      | true         | Sun     |
| Dark mode     | Click toggle   | Light mode     | false        | Moon    |
| Light mode    | No action      | Light mode     | false        | Moon    |

### Pages to Verify Persistence

| Page       | URL          |
|------------|--------------|
| Home       | `/`          |
| Products   | `/products`  |
| Cart       | `/cart`      |
| Checkout   | `/checkout`  |

### CSS Properties to Verify (examples)

| Element         | Light Mode        | Dark Mode          |
|-----------------|-------------------|--------------------|
| Body background | Light color       | Dark color         |
| Body text       | Dark color        | Light color        |
| Card background | White or light    | Dark gray or dark  |

## Notes

- Theme persistence is likely implemented via `localStorage` or a cookie; tests should verify the storage mechanism if needed.
- The default theme should be light mode for first-time visitors.
- The icon swap (sun/moon) convention: typically a moon icon means "currently light, click for dark" and a sun icon means "currently dark, click for light." Verify the actual implementation.
- `aria-pressed` is the correct ARIA attribute for toggle buttons; ensure the button element has `role="button"` or is a native `<button>` element.
- Dark mode should apply consistently to all page elements: headers, footers, cards, forms, modals, etc.
- Consider testing that dark mode does not break readability (sufficient contrast ratios for text).
- Theme toggle should be keyboard accessible (focusable and activatable with Enter/Space keys).
- The toggle should work independently of user authentication state (works for both anonymous and logged-in users).
- Verify that the toggle does not cause a full page reload; the transition should be smooth (CSS class or data attribute change on `<html>` or `<body>`).
