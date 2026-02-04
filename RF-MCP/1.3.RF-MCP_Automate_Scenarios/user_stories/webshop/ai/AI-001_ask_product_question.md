# AI-001: Ask Product Question

| Field       | Value                                         |
|-------------|-----------------------------------------------|
| **Story ID**  | AI-001                                      |
| **Title**     | Ask Product Question via AI Concierge       |
| **Priority**  | High                                        |
| **Component** | AI Concierge API                            |
| **Labels**    | ai, concierge, rag, products, recommendations |

## User Story

**As a** shopper,
**I want to** ask the AI concierge about products,
**So that** I can get personalized recommendations.

## Acceptance Criteria

### AC-1: Submit a product question

**Given** a shopper has a question about products
**When** a POST request is sent to `/api/ai/ask` with the body `{"question": "What headphones do you have?"}`
**Then** the response status is `200 OK`
**And** the response body contains a structured JSON object

### AC-2: Response contains all required top-level fields

**Given** a valid question has been submitted to the AI concierge
**When** the response is returned
**Then** the response JSON includes the following fields:
  - `question` (string) -- the original question echoed back
  - `mode` (string) -- the response mode used
  - `provider` (string) -- the AI provider that generated the answer
  - `answer` (object) -- the structured product insight
  - `context_used` (string) -- the RAG context retrieved from the catalogue
  - `prompt_header` (string) -- the formatted prompt header
  - `workshop_flags` (object) -- current workshop feature flag states

### AC-3: Answer object structure

**Given** a valid response has been returned
**When** the `answer` object is inspected
**Then** it contains the following fields:
  - `product` (string) -- the product name matched to the answer
  - `summary` (string) -- a conversational response for the shopper
  - `price` (float or null) -- the product price if relevant, otherwise null
  - `highlights` (string[]) -- key facts extracted from the catalogue

### AC-4: Default mode is "summary"

**Given** a shopper submits a question without specifying a `mode` field
**When** the request `{"question": "What headphones do you have?"}` is sent
**Then** the response `mode` field is `"summary"`

### AC-5: Provider defaults to "mock" when no API key is configured

**Given** no external AI API key is configured in the environment
**When** a question is submitted
**Then** the response `provider` field is `"mock"`

### AC-6: Context is built from RAG index of product catalogue

**Given** the product catalogue has been seeded with products
**When** a question mentioning a product category (e.g., "headphones") is asked
**Then** the `context_used` field contains relevant product information retrieved via the RAG index
**And** the context includes product name, category, price, and description

### AC-7: Prompt header format

**Given** a question is submitted with mode `"summary"`
**When** the response is returned
**Then** the `prompt_header` field follows the format: `"Mode: {mode} | Question: {question}"`
**And** for the question "What headphones do you have?" with mode "summary", the header is:
`"Mode: summary | Question: What headphones do you have?"`

### AC-8: Workshop flags object structure

**Given** a response has been returned
**When** the `workshop_flags` object is inspected
**Then** it contains the following boolean fields:
  - `deterministic` -- whether deterministic mock mode is active
  - `varied` -- whether varied response templates are active
  - `delayed` -- whether random delays are active

## Example Request / Response

### Request

```http
POST /api/ai/ask
Content-Type: application/json

{
  "question": "What headphones do you have?"
}
```

### Response

```json
{
  "question": "What headphones do you have?",
  "mode": "summary",
  "provider": "mock",
  "answer": {
    "product": "Catalogue Overview",
    "summary": "(Mock) Based on your question 'What headphones do you have?', consider: Product: Aurora Neural Headphones",
    "price": null,
    "highlights": [
      "Product: Aurora Neural Headphones"
    ]
  },
  "context_used": "Product: Aurora Neural Headphones\nCategory: Audio\nPrice: $249.99\nDescription: ...\n---\n...",
  "prompt_header": "Mode: summary | Question: What headphones do you have?",
  "workshop_flags": {
    "deterministic": true,
    "varied": false,
    "delayed": false
  }
}
```

## Test Data

| Attribute              | Value                                                    |
|------------------------|----------------------------------------------------------|
| Test question          | "What headphones do you have?"                           |
| Expected product match | Aurora Neural Headphones                                 |
| Expected price         | $249.99                                                  |
| Default mode           | summary                                                  |
| Default provider       | mock (when no API key configured)                        |
| RAG top-k              | 3 (default number of context results)                    |

### Sample Products (for verification)

| ID | Name                       | Price    | Category     |
|----|----------------------------|----------|--------------|
| 1  | Aurora Neural Headphones   | $249.99  | Audio        |

## Notes

- The RAG index is built from product name, description, category, and price fields at query time if not already initialized.
- The `provider_override` field can be passed in the request body to force a specific provider (e.g., `"mock"` or `"openai"`).
- When using the `"openai"` provider with a valid API key, the response structure remains the same but `summary` and `highlights` are generated by the LLM.
- The `context_used` field contains the raw RAG context passed to the LLM or mock, allowing test engineers to verify retrieval quality independently of generation quality.
- Questions about headphones should reliably return context mentioning Aurora Neural Headphones ($249.99) due to token and bigram matching in the RAG index.
