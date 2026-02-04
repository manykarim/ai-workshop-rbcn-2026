# API-008: Download Order Documents

| Field       | Value                                                      |
|-------------|------------------------------------------------------------|
| **Story ID**  | API-008                                                  |
| **Title**     | Download Order Documents (Invoice and Summary PDFs)      |
| **Priority**  | Medium                                                   |
| **Component** | Documents API                                            |
| **Endpoints** | `GET /api/docs/orders/{order_id}/invoice.pdf`, `GET /api/docs/orders/{order_id}/summary.pdf` |

## User Story

**As an** API consumer,
**I want to** download order documents,
**So that** users can access their invoices and order summaries as PDF files.

## Acceptance Criteria

### AC-1: Download invoice PDF for existing order

**Given** the API server is running with seeded data
**And** an order with ID `1` exists
**When** I send a `GET` request to `/api/docs/orders/1/invoice.pdf`
**Then** the response status code is `200`
**And** the response `Content-Type` header is `application/pdf`
**And** the response body is a valid PDF file

### AC-2: Download summary PDF for existing order

**Given** the API server is running with seeded data
**And** an order with ID `1` exists
**When** I send a `GET` request to `/api/docs/orders/1/summary.pdf`
**Then** the response status code is `200`
**And** the response `Content-Type` header is `application/pdf`
**And** the response body is a valid PDF file

### AC-3: Non-existent order returns 404 for invoice

**Given** the API server is running with seeded data
**And** no order with ID `9999` exists
**When** I send a `GET` request to `/api/docs/orders/9999/invoice.pdf`
**Then** the response status code is `404`
**And** the response body contains `{"detail": "Order not found"}`

### AC-4: Non-existent order returns 404 for summary

**Given** the API server is running with seeded data
**And** no order with ID `9999` exists
**When** I send a `GET` request to `/api/docs/orders/9999/summary.pdf`
**Then** the response status code is `404`
**And** the response body contains `{"detail": "Order not found"}`

### AC-5: order_id must be >= 1

**Given** the API server is running
**When** I send a `GET` request to `/api/docs/orders/0/invoice.pdf`
**Then** the response status code is `422` (validation error)
**And** the response body indicates the order_id must be at least 1

### AC-6: Negative order_id is rejected

**Given** the API server is running
**When** I send a `GET` request to `/api/docs/orders/-1/summary.pdf`
**Then** the response status code is `422` (validation error)

### AC-7: PDFs are generated on demand if not cached

**Given** the API server is running with seeded data
**And** an order exists but its PDFs have not been previously generated
**When** I send a `GET` request to `/api/docs/orders/{order_id}/invoice.pdf`
**Then** the response status code is `200`
**And** the PDF file is generated and returned
**And** subsequent requests for the same document return the cached file

### AC-8: Invoice and summary are distinct documents

**Given** the API server is running with seeded data
**And** an order with ID `1` exists
**When** I download both `/api/docs/orders/1/invoice.pdf` and `/api/docs/orders/1/summary.pdf`
**Then** the two files are different (different content/file size)

## Example Request -- Download Invoice

```bash
curl -s -o invoice.pdf http://localhost:8000/api/docs/orders/1/invoice.pdf
file invoice.pdf  # Should output: invoice.pdf: PDF document
```

## Example Request -- Download Summary

```bash
curl -s -o summary.pdf http://localhost:8000/api/docs/orders/1/summary.pdf
file summary.pdf  # Should output: summary.pdf: PDF document
```

## Example Request -- Check Content-Type Header

```bash
curl -s -I http://localhost:8000/api/docs/orders/1/invoice.pdf | grep -i content-type
# Output: content-type: application/pdf
```

## Example Request -- Not Found

```bash
curl -s http://localhost:8000/api/docs/orders/9999/invoice.pdf | jq .
```

## Example Response -- Not Found

```json
{
  "detail": "Order not found"
}
```

## Notes

- The `order_id` path parameter is validated with `ge=1` via FastAPI's `Path` constraint.
- PDFs are generated using the `PDFService` which renders HTML templates to PDF.
- Generated PDFs are cached on disk in the configured `pdf_output_dir`. File names follow the pattern `invoice_{order_number}.pdf` and `summary_{order_number}.pdf`.
- If the PDF already exists on disk, it is served directly without re-rendering.
- The invoice PDF template is `pdf/invoice.html` and includes order details, customer information, and line items.
- The summary PDF template is `pdf/order_summary.html` and includes a simplified order overview.
- The response uses FastAPI's `FileResponse` with `media_type="application/pdf"`.
- No authentication is required for document downloads.
- These URLs are referenced in the login response (`invoice_url`, `summary_url`) and in the checkout response (`documents` array).
