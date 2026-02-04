# WEB-007: User Authentication

| Field       | Value                                    |
|-------------|------------------------------------------|
| **Story ID**  | WEB-007                                |
| **Title**     | User Authentication                    |
| **Priority**  | High                                   |
| **Component** | Web Frontend, API                      |
| **Labels**    | auth, login, logout, session, modal    |

## User Story

**As a** returning customer,
**I want to** log in to my account,
**So that** I can access my saved information and order history.

## Acceptance Criteria

### AC-1: Sign in button in header

**Given** a visitor is on any page of the website
**And** the visitor is not logged in
**When** the visitor views the header/navigation
**Then** a "Sign in" button is visible in the header

### AC-2: Authentication modal opens

**Given** a visitor is not logged in
**When** the visitor clicks the "Sign in" button
**Then** an authentication modal/dialog opens
**And** the modal overlays the current page content
**And** the background content is dimmed or visually de-emphasized

### AC-3: Modal contains login form

**Given** the authentication modal is open
**When** the visitor views the modal content
**Then** the modal contains:
  - An email input field
  - A password input field
  - A submit/login button
  - A close button to dismiss the modal

### AC-4: Successful login

**Given** the authentication modal is open
**When** the visitor enters valid credentials and submits the form
**Then** the modal closes
**And** the "Sign in" button is replaced with an account dropdown/indicator
**And** the account dropdown shows the logged-in user's name

### AC-5: Account dropdown contents

**Given** a user is logged in
**When** the user opens the account dropdown
**Then** the dropdown displays:
  - User name
  - Saved addresses section
  - Payment methods section
  - Recent orders section
**And** order entries include links to invoice/summary PDF documents

### AC-6: Order PDF links in account dropdown

**Given** a user is logged in and has past orders
**When** the user views the recent orders in the account dropdown
**Then** each order entry has links to:
  - Invoice PDF (downloadable)
  - Order summary PDF (downloadable)

### AC-7: Logout functionality

**Given** a user is logged in
**When** the user clicks the "Logout" button in the account dropdown
**Then** the user session is cleared
**And** the account dropdown is replaced with the "Sign in" button
**And** the user is returned to the logged-out state

### AC-8: Invalid credentials error

**Given** the authentication modal is open
**When** the visitor enters invalid credentials (wrong email or password) and submits
**Then** an error alert is displayed within the modal
**And** the error message indicates invalid credentials
**And** the modal remains open for the user to retry

### AC-9: Close modal

**Given** the authentication modal is open
**When** the visitor clicks the close button
**Then** the modal closes
**And** the visitor remains on the current page
**And** no login attempt is made

### AC-10: Login state persists across navigation

**Given** a user has successfully logged in
**When** the user navigates to different pages within the site
**Then** the user remains logged in (account dropdown stays visible)
**And** the session is maintained

## Test Data

### Valid Credentials

| User             | Email                              | Password  | Expected Name          |
|------------------|------------------------------------|-----------|------------------------|
| User 1 (Jamie)   | jamie@flowlinesupply.com          | demo123   | Jamie (or full name)   |
| User 2 (Alex)    | alex.productlead@example.com      | flowline  | Alex (or full name)    |

### Invalid Credentials

| Scenario                | Email                          | Password     | Expected Result          |
|-------------------------|--------------------------------|--------------|--------------------------|
| Wrong password          | jamie@flowlinesupply.com       | wrongpass    | Error alert in modal     |
| Non-existent user       | nobody@example.com             | anypass      | Error alert in modal     |
| Empty email             | (empty)                        | demo123      | Validation error         |
| Empty password          | jamie@flowlinesupply.com       | (empty)      | Validation error         |
| Both empty              | (empty)                        | (empty)      | Validation error         |

### Account Dropdown Verification

| Section             | Expected Content                           |
|---------------------|--------------------------------------------|
| User name           | Display name of logged-in user             |
| Saved addresses     | List of saved addresses (may be empty)     |
| Payment methods     | List of payment methods (may be empty)     |
| Recent orders       | List of orders with PDF links              |

## Notes

- The authentication modal should be accessible: trap focus within the modal when open, return focus to the trigger button when closed.
- The modal should close when pressing the Escape key (accessibility best practice).
- Error alerts within the modal should use `role="alert"` for screen reader accessibility.
- Password field should use `type="password"` to mask input.
- Login API endpoint details should be confirmed; likely `POST /api/auth/login` with `{ email, password }` body.
- Logout API endpoint details should be confirmed; likely `POST /api/auth/logout` or clearing session client-side.
- The account dropdown may be implemented as a disclosure widget or a popover; verify the DOM structure for test selectors.
- PDF links in the account dropdown should be valid URLs that return `200 OK` with `Content-Type: application/pdf`.
- Test both valid user accounts to ensure credentials work independently.
- Cross-reference with WEB-005 for session management (authentication may upgrade the session from anonymous to authenticated).
- The "Sign in" button visibility rule: visible when logged out, hidden when logged in (replaced by account dropdown).
