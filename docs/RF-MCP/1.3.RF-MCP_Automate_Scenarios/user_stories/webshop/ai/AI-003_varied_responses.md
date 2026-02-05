# AI-003: Varied Responses

| Field       | Value                                                  |
|-------------|--------------------------------------------------------|
| **Story ID**  | AI-003                                               |
| **Title**     | Varied AI Response Templates                         |
| **Priority**  | Medium                                               |
| **Component** | AI Concierge API, MockLLM, Workshop Flags            |
| **Labels**    | ai, testing, non-determinism, variation, workshop    |

## User Story

**As a** test engineer,
**I want to** test AI response variation,
**So that** I can verify my test automation handles non-deterministic output.

## Acceptance Criteria

### AC-1: AI_VARIED_RESPONSES flag enables template rotation

**Given** the `AI_VARIED_RESPONSES` feature flag is set to `true`
**When** questions are submitted to `POST /api/ai/ask`
**Then** the mock LLM cycles through 5 different response templates

### AC-2: Five distinct response templates

**Given** the `AI_VARIED_RESPONSES` flag is `true`
**When** responses are generated
**Then** the templates include these distinct phrasings in the summary:
  - `"(Mock) Based on your question '{question}', consider:"`
  - `"(Mock) Great question about '{question}'! Here's what I found:"`
  - `"(Mock) Looking at '{question}', I'd recommend:"`
  - `"(Mock) For '{question}', our catalogue suggests:"`
  - `"(Mock) Regarding '{question}':"`

### AC-3: Template selection uses call counter and question seed

**Given** the `AI_VARIED_RESPONSES` flag is `true`
**When** a question is submitted
**Then** the template is selected using the formula: `(call_count + question_seed) % 5`
**And** `question_seed` is derived from `hash(question) % 1000`
**And** different questions produce different template selections

### AC-4: Highlights include up to 3 context lines

**Given** the `AI_VARIED_RESPONSES` flag is `true`
**And** the RAG context contains multiple product entries
**When** the response is returned
**Then** the `answer.highlights` array contains up to 3 non-empty lines from the context
**And** this is in contrast to deterministic mode which returns only 1 highlight

### AC-5: Workshop flags reflect varied state

**Given** the `AI_VARIED_RESPONSES` flag is `true`
**When** the response is returned
**Then** `workshop_flags.varied` is `true`

### AC-6: Different questions produce visibly different formats

**Given** the `AI_VARIED_RESPONSES` flag is `true`
**When** the following questions are submitted in sequence:
  - "What headphones do you have?"
  - "Tell me about desks"
  - "Do you sell keyboards?"
**Then** at least 2 of the 3 responses use different template phrasings
**And** each response summary starts with `"(Mock)"` but continues with a different phrase

### AC-7: Varied mode still uses mock provider

**Given** the `AI_VARIED_RESPONSES` flag is `true`
**And** the `AI_DETERMINISTIC` flag is `true`
**When** a question is submitted
**Then** the response `provider` is `"mock"`
**And** variation only affects the template selection, not the provider

## Example Request / Response

### Request

```http
POST /api/ai/ask
Content-Type: application/json

{
  "question": "What headphones do you have?"
}
```

### Response (varied mode -- template may differ on each call)

```json
{
  "question": "What headphones do you have?",
  "mode": "summary",
  "provider": "mock",
  "answer": {
    "product": "Catalogue Overview",
    "summary": "(Mock) Great question about 'What headphones do you have?'! Here's what I found: Product: Aurora Neural Headphones",
    "price": null,
    "highlights": [
      "Product: Aurora Neural Headphones",
      "Category: Audio",
      "Price: $249.99"
    ]
  },
  "context_used": "Product: Aurora Neural Headphones\nCategory: Audio\nPrice: $249.99\nDescription: ...",
  "prompt_header": "Mode: summary | Question: What headphones do you have?",
  "workshop_flags": {
    "deterministic": true,
    "varied": true,
    "delayed": false
  }
}
```

### Alternate Response (different template on a different call)

```json
{
  "question": "What headphones do you have?",
  "mode": "summary",
  "provider": "mock",
  "answer": {
    "product": "Catalogue Overview",
    "summary": "(Mock) Regarding 'What headphones do you have?': Product: Aurora Neural Headphones",
    "price": null,
    "highlights": [
      "Product: Aurora Neural Headphones",
      "Category: Audio",
      "Price: $249.99"
    ]
  },
  "context_used": "...",
  "prompt_header": "Mode: summary | Question: What headphones do you have?",
  "workshop_flags": {
    "deterministic": true,
    "varied": true,
    "delayed": false
  }
}
```

## Test Data

| Attribute                  | Value                                                |
|----------------------------|------------------------------------------------------|
| Number of templates        | 5                                                    |
| Template selection formula | `(call_count + hash(question) % 1000) % 5`          |
| Highlights count (varied)  | Up to 3 (non-empty context lines)                    |
| Highlights count (default) | 1 (first context line only)                          |
| All summaries start with   | `"(Mock)"`                                           |

### Template Reference

| Index | Template Phrasing                                |
|-------|--------------------------------------------------|
| 0     | `"Based on your question '{q}', consider:"`      |
| 1     | `"Great question about '{q}'! Here's what I found:"` |
| 2     | `"Looking at '{q}', I'd recommend:"`             |
| 3     | `"For '{q}', our catalogue suggests:"`           |
| 4     | `"Regarding '{q}':"`                             |

## Notes

- This story simulates real-world LLM non-determinism for testing purposes. Workshop participants should learn to write assertions that validate structure and content rather than exact text matching.
- Recommended assertion strategies for varied responses:
  - Assert `answer.summary` starts with `"(Mock)"` (all templates share this prefix).
  - Assert `answer.summary` contains the original question text.
  - Assert `answer.highlights` is a non-empty array of strings.
  - Assert `answer.product` is a non-empty string.
  - Avoid asserting exact summary text -- it will change between calls.
- The `MockLLM` creates a new instance per request with `seed=hash(question) % 1000`, so the same question on the same call count will select the same template. However, the internal call counter increments per invocation, making repeated identical questions cycle through templates.
- Enable varied responses via: `POST /api/workshop/flags` with `{"flags": {"AI_VARIED_RESPONSES": true}}`.
