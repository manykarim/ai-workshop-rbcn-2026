# AI-006: RAG Context Relevance

| Field       | Value                                             |
|-------------|---------------------------------------------------|
| **Story ID**  | AI-006                                          |
| **Title**     | RAG Context Relevance                           |
| **Priority**  | High                                            |
| **Component** | AI Concierge API, RAG Index                     |
| **Labels**    | ai, rag, relevance, search, products, catalogue |

## User Story

**As a** shopper,
**I want** the AI concierge to provide relevant product information,
**So that** recommendations are useful.

## Acceptance Criteria

### AC-1: Headphones query returns audio products

**Given** the product catalogue has been seeded
**When** the question `"What headphones do you have?"` is submitted to `POST /api/ai/ask`
**Then** the `context_used` field contains text mentioning "Aurora Neural Headphones"
**And** the context includes the price `$249.99`
**And** the context includes the category `Audio`

### AC-2: Desk query returns desk products

**Given** the product catalogue has been seeded
**When** the question `"Tell me about desks"` is submitted
**Then** the `context_used` field contains text mentioning "Atlas Standing Desk"
**And** the context includes relevant desk product details (name, category, price, description)

### AC-3: Non-existent product returns generic overview

**Given** the product catalogue has been seeded
**When** a question about a non-existent product is submitted (e.g., `"Do you sell flying cars?"`)
**Then** the `context_used` field is empty or contains a generic catalogue overview
**And** the mock response provides a general catalogue summary rather than specific product details

### AC-4: Context built from product name, description, category, and price

**Given** a product exists in the catalogue with name, description, category, and price fields
**When** a question matching that product is submitted
**Then** the `context_used` field contains a structured block for the product with the format:
```
Product: {name}
Category: {category}
Price: ${price}
Description: {description}
```

### AC-5: RAG index uses token-based search with bigram matching

**Given** the RAG index has been built from the product catalogue
**When** a query is tokenized
**Then** the search uses individual word tokens (e.g., "head", "phones")
**And** the search uses bigram combinations of consecutive tokens (e.g., "headphones")
**And** token normalization handles plurals (e.g., "headphones" matches "headphone")

### AC-6: Context limited to top-k results

**Given** the RAG index contains multiple products
**When** a broad question is submitted (e.g., `"What products do you sell?"`)
**Then** the `context_used` field contains at most 3 product context blocks (default top-k)
**And** the products returned are the most relevant based on token overlap scoring

### AC-7: Product name matches score higher than description matches

**Given** the RAG index scores results by relevance
**When** a question directly names a product (e.g., `"Aurora Neural Headphones"`)
**Then** that product appears first in the context
**And** the product name match receives a higher weight than description-only matches

### AC-8: Multiple relevant products returned in ranked order

**Given** the product catalogue contains multiple products in a category
**When** a question about that category is submitted (e.g., `"audio products"`)
**Then** the `context_used` field may contain multiple product blocks separated by `---`
**And** the products are ordered by relevance score (highest first)

## Example Request / Response

### Request -- Relevant Product Query

```http
POST /api/ai/ask
Content-Type: application/json

{
  "question": "What headphones do you have?"
}
```

### Response -- Relevant Context Retrieved

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
  "context_used": "Product: Aurora Neural Headphones\nCategory: Audio\nPrice: $249.99\nDescription: Adaptive noise-cancelling headphones with neural interface for focus optimization.\n---\nProduct: Echo Conference Speaker\nCategory: Audio\nPrice: $179.99\nDescription: ...",
  "prompt_header": "Mode: summary | Question: What headphones do you have?",
  "workshop_flags": {
    "deterministic": true,
    "varied": false,
    "delayed": false
  }
}
```

### Request -- Non-Existent Product Query

```http
POST /api/ai/ask
Content-Type: application/json

{
  "question": "Do you sell flying cars?"
}
```

### Response -- No Relevant Context

```json
{
  "question": "Do you sell flying cars?",
  "mode": "summary",
  "provider": "mock",
  "answer": {
    "product": "Catalogue Overview",
    "summary": "(Mock) Based on your question 'Do you sell flying cars?', consider: We offer a curated catalogue of productivity gadgets.",
    "price": null,
    "highlights": [
      "We offer a curated catalogue of productivity gadgets."
    ]
  },
  "context_used": "",
  "prompt_header": "Mode: summary | Question: Do you sell flying cars?",
  "workshop_flags": {
    "deterministic": true,
    "varied": false,
    "delayed": false
  }
}
```

## Test Data

| Attribute              | Value                                                  |
|------------------------|--------------------------------------------------------|
| Default top-k          | 3                                                      |
| Context separator      | `\n---\n`                                              |
| Fallback message       | "We offer a curated catalogue of productivity gadgets."|
| Token normalization    | Plurals (s, es, ies), bigram concatenation              |

### Known Product-to-Query Mappings

| Query Term          | Expected Product(s) in Context         | Key Fields to Verify       |
|---------------------|----------------------------------------|----------------------------|
| "headphones"        | Aurora Neural Headphones               | Price: $249.99, Audio      |
| "desk"              | Atlas Standing Desk                    | Category, Price            |
| "speaker"           | Echo Conference Speaker                | Category: Audio            |
| "flying car"        | (none -- empty context)                | Fallback summary used      |
| "audio"             | Aurora Neural Headphones, Echo Conference Speaker | Multiple results  |

### RAG Scoring Details

| Score Component      | Weight | Description                                          |
|----------------------|--------|------------------------------------------------------|
| Phrase match         | len(phrase) | Exact phrase found in product text blob          |
| Token overlap        | sum(len(token)) | Individual token matches in document tokens |
| Name token match     | 2x weight | Token matches in product name score double       |

## Notes

- The RAG index uses a simple but effective in-memory search. It is not a vector database -- it uses token overlap and bigram matching for relevance scoring.
- The index is built lazily on first query if not already initialized, by loading all products from the database via `ProductService.list_products()`.
- Token normalization handles common English plurals:
  - Words ending in "ies" (length > 4) are normalized to "y" form (e.g., "accessories" to "accessory").
  - Words ending in "ses", "xes", "zes", "ches", "shes" have "es" removed.
  - Words ending in "s" (length > 3) have the trailing "s" removed.
- Bigram matching joins consecutive tokens (e.g., query tokens "head" + "phones" produce bigram "headphones"), which allows matching compound product names.
- The `context_used` field in the API response exposes the raw context string, enabling test assertions on retrieval quality independent of the LLM/mock generation quality.
- Use known product names and categories from the seed data to verify relevance. Avoid testing with ambiguous queries where ranking could reasonably vary.
- When no products match the query, the mock LLM falls back to a generic message: "We offer a curated catalogue of productivity gadgets." The `context_used` field will be an empty string in this case.
