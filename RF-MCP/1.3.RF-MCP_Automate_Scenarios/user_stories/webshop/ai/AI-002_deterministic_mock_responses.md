# AI-002: Deterministic Mock Responses

| Field       | Value                                              |
|-------------|----------------------------------------------------|
| **Story ID**  | AI-002                                           |
| **Title**     | Deterministic Mock Responses                     |
| **Priority**  | High                                             |
| **Component** | AI Concierge API, Workshop Flags                 |
| **Labels**    | ai, testing, deterministic, mock, workshop       |

## User Story

**As a** test engineer,
**I want** deterministic AI responses,
**So that** I can write reliable assertions.

## Acceptance Criteria

### AC-1: AI_DETERMINISTIC flag forces mock provider

**Given** the `AI_DETERMINISTIC` feature flag is set to `true` (the default)
**When** a question is submitted to `POST /api/ai/ask`
**Then** the response `provider` field is `"mock"` regardless of any configured AI API key

### AC-2: Same question always produces the same response

**Given** the `AI_DETERMINISTIC` flag is `true`
**When** the question `"What headphones do you have?"` is submitted multiple times
**Then** every response is byte-for-byte identical
**And** the `answer.summary`, `answer.highlights`, and `answer.product` fields do not change between calls

### AC-3: Mock response summary format

**Given** the `AI_DETERMINISTIC` flag is `true`
**When** any question is submitted
**Then** the `answer.summary` starts with `"(Mock) Based on your question"`
**And** the summary follows the template: `"(Mock) Based on your question '{question}', consider: {first_context_line}"`

### AC-4: Highlights contain first line of RAG context

**Given** the `AI_DETERMINISTIC` flag is `true` and the question matches at least one product
**When** the response is returned
**Then** the `answer.highlights` array contains exactly one element
**And** that element is the first line of the RAG context (e.g., `"Product: Aurora Neural Headphones"`)

### AC-5: Workshop flags reflect deterministic state

**Given** the `AI_DETERMINISTIC` flag is `true`
**When** the response is returned
**Then** `workshop_flags.deterministic` is `true`

### AC-6: Deterministic flag overrides API key configuration

**Given** an AI API key is configured in the environment (e.g., `AI_API_KEY` is set)
**And** the `AI_DETERMINISTIC` flag is `true`
**When** a question is submitted
**Then** the response `provider` is still `"mock"`
**And** no request is made to the external AI API

### AC-7: Repeated identical questions return identical responses

**Given** the `AI_DETERMINISTIC` flag is `true`
**When** `"What headphones do you have?"` is submitted 5 times in sequence
**Then** all 5 responses have identical `answer.summary` values
**And** all 5 responses have identical `answer.highlights` arrays
**And** all 5 responses have identical `answer.product` values

## Example Request / Response

### Request (repeated multiple times)

```http
POST /api/ai/ask
Content-Type: application/json

{
  "question": "What headphones do you have?"
}
```

### Response (identical every time)

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
  "context_used": "Product: Aurora Neural Headphones\nCategory: Audio\nPrice: $249.99\nDescription: ...",
  "prompt_header": "Mode: summary | Question: What headphones do you have?",
  "workshop_flags": {
    "deterministic": true,
    "varied": false,
    "delayed": false
  }
}
```

## Test Data

| Attribute                   | Value                                         |
|-----------------------------|-----------------------------------------------|
| Default AI_DETERMINISTIC    | true                                          |
| Mock provider name          | "mock"                                        |
| Summary prefix              | "(Mock) Based on your question"               |
| Template index used         | 0 (always first template in deterministic)    |
| Highlights count            | 1 (first context line only)                   |

### Verification Steps

| Step | Action                                                | Expected Result                              |
|------|-------------------------------------------------------|----------------------------------------------|
| 1    | Ensure `AI_DETERMINISTIC` is `true` (default or set)  | Flag confirmed as active                     |
| 2    | Send POST `/api/ai/ask` with headphones question      | Response with provider "mock"                |
| 3    | Record the `answer.summary` value                     | Starts with "(Mock) Based on your question"  |
| 4    | Send the same request again                           | Response is identical to step 2              |
| 5    | Set an AI API key in environment                      | Key is configured                            |
| 6    | Send the same request again                           | Response is still "mock", key is ignored     |

## Notes

- The `AI_DETERMINISTIC` flag defaults to `true` in the "clean" workshop preset. This ensures tests pass reliably out of the box.
- The mock always uses template index 0 (`"(Mock) Based on your question '{question}', consider: {context_line}"`) when not in varied mode.
- The `answer.product` field is always `"Catalogue Overview"` in mock mode, regardless of which products are in the RAG context.
- Deterministic mode is the recommended starting point for all workshop participants writing their first AI test assertions.
- To disable deterministic mode, set the `AI_DETERMINISTIC` flag to `false` via `POST /api/workshop/flags` or apply the `"ai_chaos"` preset.
