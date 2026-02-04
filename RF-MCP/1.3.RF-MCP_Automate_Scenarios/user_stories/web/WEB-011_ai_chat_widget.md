# WEB-011: AI Chat Widget

| Field       | Value                                    |
|-------------|------------------------------------------|
| **Story ID**  | WEB-011                                |
| **Title**     | AI Chat Widget                         |
| **Priority**  | Medium                                 |
| **Component** | Web Frontend, API                      |
| **Labels**    | chat, ai, widget, recommendations, api |

## User Story

**As a** shopper,
**I want to** use the AI chat widget,
**So that** I can get product recommendations.

## Acceptance Criteria

### AC-1: Chat toggle button

**Given** a shopper is on any page of the website
**When** the shopper views the page
**Then** a chat toggle button is visible (typically in the bottom-right corner)
**And** the button has the attribute `data-chat-toggle`

### AC-2: Opening the chat widget

**Given** the chat widget is closed
**When** the shopper clicks the chat toggle button (`data-chat-toggle`)
**Then** the chat widget opens and becomes visible
**And** the widget displays a chat interface

### AC-3: Initial greeting message

**Given** the chat widget has just been opened
**When** the shopper views the chat messages area
**Then** an initial greeting message from the assistant is displayed
**And** the greeting message is clearly identified as coming from the assistant (not the user)

### AC-4: Text input for questions

**Given** the chat widget is open
**When** the shopper views the widget
**Then** a text input area is available at the bottom of the widget
**And** the input has placeholder text or a label indicating its purpose

### AC-5: Send button submits question

**Given** the chat widget is open
**And** the shopper has typed a question in the text input
**When** the shopper clicks the send button
**Then** the question is submitted via a POST request to `/api/ai/ask`
**And** the user's question appears in the chat as a user message
**And** a loading indicator may be shown while waiting for the response

### AC-6: AI response displayed as message

**Given** the shopper has submitted a question via the chat widget
**When** the API response is received from `/api/ai/ask`
**Then** the response is displayed as a new message in the chat
**And** the message is clearly identified as coming from the assistant
**And** the chat scrolls to show the latest message

### AC-7: Quick-prompt chips on products page

**Given** the shopper is on the products page (`/products`)
**And** the chat widget is open
**When** the shopper views the chat widget
**Then** quick-prompt chips are displayed with the following suggestions:
  - "Compare ergonomic chairs"
  - "Travel-ready tech under $400"
  - "Wellness accessories"

### AC-8: Clicking a chip pre-fills chat input

**Given** the quick-prompt chips are visible in the chat widget
**When** the shopper clicks on a chip (e.g., "Compare ergonomic chairs")
**Then** the chip text is placed into the chat text input field
**And** the shopper can review the text before sending
**Or** the message is sent automatically (verify actual behavior)

### AC-9: Close button hides widget

**Given** the chat widget is open
**When** the shopper clicks the close button on the widget
**Then** the chat widget is hidden
**And** the chat toggle button remains visible for reopening

### AC-10: Chat history persists during session

**Given** the shopper has exchanged messages with the AI chat
**When** the shopper closes and reopens the chat widget
**Then** the previous messages are still visible in the chat history

## Test Data

### API Endpoints

| Endpoint       | Method | Body                        | Response                          |
|----------------|--------|-----------------------------|-----------------------------------|
| `/api/ai/ask`  | POST   | `{ "question": "..." }`    | `{ "answer": "...", ... }`       |

### Quick-Prompt Chips (exact text)

| Chip Text                          | Expected Behavior              |
|------------------------------------|--------------------------------|
| Compare ergonomic chairs           | Pre-fills or sends as question |
| Travel-ready tech under $400       | Pre-fills or sends as question |
| Wellness accessories               | Pre-fills or sends as question |

### Sample Chat Interactions

| User Question                        | Expected Response Type             |
|--------------------------------------|------------------------------------|
| "What headphones do you recommend?"  | Product recommendation with details|
| "Compare ergonomic chairs"           | Comparison of chair products       |
| "Travel-ready tech under $400"       | List of tech products < $400       |
| "Hello"                              | General greeting or guidance       |

### DOM Selectors

| Element             | Selector                   |
|---------------------|----------------------------|
| Chat toggle button  | `[data-chat-toggle]`       |
| Chat widget         | Chat container element     |
| Text input          | Input/textarea in widget   |
| Send button         | Submit button in widget    |
| Close button        | Close button in widget     |
| Message bubbles     | Message elements in chat   |
| Quick-prompt chips  | Chip/button elements       |

## Notes

- The `data-chat-toggle` attribute is the primary selector for the toggle button in test automation.
- Quick-prompt chips are only available on the products page (`/products`), not on other pages; verify this page-specific behavior.
- The AI chat API (`/api/ai/ask`) response time may vary; tests should use appropriate timeouts (recommend 10-15 seconds for AI responses).
- The chat widget should not obstruct critical page content or navigation elements.
- Chat messages should be visually distinguished between user messages and assistant messages (different alignment, color, or avatar).
- The initial greeting message should appear without any user action beyond opening the widget.
- Verify that the send button is disabled or the input is validated when the text input is empty.
- The chat widget should be accessible: keyboard navigable, proper ARIA labels, and screen reader compatible.
- Consider testing that very long messages do not break the widget layout.
- Quick-prompt chips may be implemented as buttons, links, or custom elements; identify the actual DOM structure for reliable selectors.
- The close button behavior should be distinct from the toggle button: the close button is inside the widget, while the toggle button is outside.
- Cross-reference with WEB-002 for the products page context where quick-prompt chips appear.
- Test that the chat widget works correctly in both light and dark modes (WEB-008).
