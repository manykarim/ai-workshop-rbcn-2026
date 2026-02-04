# WEB-009: Newsletter Subscription

| Field       | Value                                  |
|-------------|----------------------------------------|
| **Story ID**  | WEB-009                              |
| **Title**     | Newsletter Subscription              |
| **Priority**  | Medium                               |
| **Component** | Web Frontend                         |
| **Labels**    | newsletter, email, subscription, a11y |

## User Story

**As a** visitor,
**I want to** subscribe to the newsletter,
**So that** I can receive updates.

## Acceptance Criteria

### AC-1: Newsletter form on home page

**Given** a visitor is on the home page (`/`)
**When** the visitor scrolls to the newsletter section
**Then** a newsletter subscription form is displayed
**And** the form contains an email input field
**And** the form contains a "Join" button

### AC-2: Hint text displayed

**Given** the newsletter form is visible
**When** the visitor views the form area
**Then** hint text is displayed: "We send one thoughtful email each week. No noise."

### AC-3: Successful subscription with valid email

**Given** the newsletter form is visible
**When** the visitor enters a valid email address (e.g., "user@example.com")
**And** the visitor clicks the "Join" button
**Then** a success alert is displayed confirming the subscription

### AC-4: Validation error with invalid email

**Given** the newsletter form is visible
**When** the visitor enters an invalid email address (e.g., "notanemail")
**And** the visitor clicks the "Join" button
**Then** a validation error is displayed
**And** the form is not submitted

### AC-5: Validation error with empty email

**Given** the newsletter form is visible
**When** the visitor clicks the "Join" button without entering an email
**Then** a validation error is displayed
**And** the form is not submitted

### AC-6: Alert area uses role="alert"

**Given** a success or error alert is displayed after form interaction
**When** the alert element is inspected
**Then** the alert element has `role="alert"` attribute
**And** the alert content is announced to screen readers

## Test Data

### Email Validation Scenarios

| Input                    | Action       | Expected Result            | Alert Type |
|--------------------------|--------------|----------------------------|------------|
| user@example.com         | Click Join   | Success alert              | Success    |
| newsletter@test.org      | Click Join   | Success alert              | Success    |
| notanemail               | Click Join   | Validation error           | Error      |
| @example.com             | Click Join   | Validation error           | Error      |
| user@                    | Click Join   | Validation error           | Error      |
| (empty)                  | Click Join   | Validation error           | Error      |

### DOM Selectors (expected)

| Element              | Selector Hint                        |
|----------------------|--------------------------------------|
| Newsletter form      | Form element in newsletter section   |
| Email input          | `input[type="email"]` within form    |
| Join button          | Submit button within form            |
| Alert area           | Element with `role="alert"`          |
| Hint text            | Text element near the form           |

### Hint Text (exact)

```
We send one thoughtful email each week. No noise.
```

## Notes

- The `role="alert"` attribute is essential for WCAG accessibility compliance; screen readers will announce the alert content when it appears.
- Success and error alerts should be visually distinct (e.g., green for success, red for error).
- The alert should appear dynamically after form interaction, not be pre-rendered on page load.
- Email validation can be client-side (HTML5 `type="email"` validation) and/or via JavaScript.
- Consider testing that submitting the same email twice does not cause errors (idempotent subscription).
- The newsletter form may or may not make an API call; it could be a client-side-only demo. Verify the actual behavior.
- The "Join" button text should be exactly "Join" (verify casing and label).
- The hint text acts as a description or helper text for the form; it should be associated with the form or input for accessibility (e.g., via `aria-describedby`).
- Cross-reference with WEB-001 which mentions the newsletter form is visible at the bottom of the home page.
