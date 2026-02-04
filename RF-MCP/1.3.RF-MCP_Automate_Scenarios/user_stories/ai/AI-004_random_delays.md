# AI-004: Random Delays

| Field       | Value                                           |
|-------------|------------------------------------------------ |
| **Story ID**  | AI-004                                        |
| **Title**     | Random AI Response Delays                     |
| **Priority**  | Medium                                        |
| **Component** | AI Concierge API, Workshop Flags              |
| **Labels**    | ai, testing, delays, timeouts, workshop       |

## User Story

**As a** test engineer,
**I want to** test with random AI response delays,
**So that** I can verify timeout handling.

## Acceptance Criteria

### AC-1: AI_RANDOM_DELAYS flag introduces response latency

**Given** the `AI_RANDOM_DELAYS` feature flag is set to `true`
**When** a question is submitted to `POST /api/ai/ask`
**Then** the response is delayed by a random duration between 0.5 and 2.0 seconds

### AC-2: Workshop flags reflect delayed state

**Given** the `AI_RANDOM_DELAYS` flag is `true`
**When** the response is returned
**Then** `workshop_flags.delayed` is `true`

### AC-3: Response content is unaffected by delay

**Given** the `AI_RANDOM_DELAYS` flag is `true`
**When** a question is submitted and the response is returned
**Then** the `answer` object structure and content are identical to what they would be without the delay
**And** the `provider`, `mode`, `context_used`, and `prompt_header` fields are unchanged

### AC-4: Delay applied before RAG context retrieval

**Given** the `AI_RANDOM_DELAYS` flag is `true`
**When** a question is submitted
**Then** the artificial delay is applied before the RAG index is queried and the response is generated
**And** the total response time includes both the artificial delay and the normal processing time

### AC-5: Multiple requests show varying response times

**Given** the `AI_RANDOM_DELAYS` flag is `true`
**When** 5 identical questions are submitted in sequence
**Then** the response times vary between requests
**And** each response time is at least 500ms
**And** each response time does not exceed approximately 2500ms (2.0s delay + processing overhead)

### AC-6: Delay disabled by default

**Given** the workshop is in the default "clean" preset
**When** a question is submitted
**Then** no artificial delay is applied
**And** `workshop_flags.delayed` is `false`

## Example Request / Response

### Request

```http
POST /api/ai/ask
Content-Type: application/json

{
  "question": "What headphones do you have?"
}
```

### Response (with delay -- content identical to non-delayed response)

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
    "delayed": true
  }
}
```

### Timing Observations

| Request # | Response Time (example) |
|-----------|-------------------------|
| 1         | 1,247ms                 |
| 2         | 683ms                   |
| 3         | 1,891ms                 |
| 4         | 512ms                   |
| 5         | 1,534ms                 |

## Test Data

| Attribute              | Value                          |
|------------------------|--------------------------------|
| Minimum delay          | 0.5 seconds (500ms)            |
| Maximum delay          | 2.0 seconds (2000ms)           |
| Delay distribution     | Uniform random                 |
| Default flag state     | false (disabled)               |
| Content impact         | None (delay only)              |

### How to Enable

```http
POST /api/workshop/flags
Content-Type: application/json

{
  "flags": {
    "AI_RANDOM_DELAYS": true
  }
}
```

## Notes

- Workshop participants should learn to set appropriate timeouts in their test configurations. A default timeout of 5 seconds is recommended when delays are enabled.
- Participants should also learn to use retry mechanisms for flaky timing-dependent assertions.
- The delay uses `random.uniform(0.5, 2.0)` which produces a continuous uniform distribution -- every value in the range is equally likely.
- The delay is applied at the start of the `ask()` method in `AIService`, before RAG context retrieval and mock/LLM invocation.
- When combined with `AI_VARIED_RESPONSES`, both timing and content will vary, simulating a more realistic AI integration scenario.
- This flag can be enabled independently or as part of the `"ai_chaos"` preset.
- Suggested test patterns:
  - Use `expect(...).toPass({ timeout: 5000 })` or equivalent polling assertions.
  - Measure response time with `Date.now()` before and after the request.
  - Assert response time falls within the expected 500-2500ms range.
  - Never assert exact response times -- only ranges.
