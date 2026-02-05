# API-011: Health Check

| Field       | Value                          |
|-------------|--------------------------------|
| **Story ID**  | API-011                      |
| **Title**     | Health Check Endpoint        |
| **Priority**  | High                         |
| **Component** | Infrastructure               |
| **Endpoint**  | `GET /health`                |

## User Story

**As a** DevOps engineer,
**I want** a health check endpoint,
**So that** I can monitor service availability and integrate with container orchestration health probes.

## Acceptance Criteria

### AC-1: Health check returns 200 OK

**Given** the API server is running
**When** I send a `GET` request to `/health`
**Then** the response status code is `200`

### AC-2: Response body contains status OK

**Given** the API server is running
**When** I send a `GET` request to `/health`
**Then** the response body is exactly `{"status": "ok"}`

### AC-3: Response is JSON

**Given** the API server is running
**When** I send a `GET` request to `/health`
**Then** the response `Content-Type` header is `application/json`

### AC-4: No authentication required

**Given** the API server is running
**When** I send a `GET` request to `/health` without any authentication headers
**Then** the response status code is `200`

### AC-5: Health check is fast

**Given** the API server is running
**When** I send a `GET` request to `/health`
**Then** the response is returned in under 1 second

### AC-6: Health check does not depend on database

**Given** the API server is running
**When** I send a `GET` request to `/health`
**Then** the endpoint responds without querying the database
**And** the response is `{"status": "ok"}`

## Example Request

```bash
curl -s http://localhost:8000/health | jq .
```

## Example Response

```json
{
  "status": "ok"
}
```

## Example Request -- Check HTTP Status Code

```bash
curl -s -o /dev/null -w "%{http_code}" http://localhost:8000/health
# Output: 200
```

## Example Request -- Check Content-Type Header

```bash
curl -s -I http://localhost:8000/health | grep -i content-type
# Output: content-type: application/json
```

## Example Request -- Docker Health Check

```bash
# As used in Dockerfile HEALTHCHECK directive
curl -f http://localhost:8000/health || exit 1
```

## Notes

- The health check endpoint is registered directly on the main `app` object at path `/health`, not under the `/api/` prefix.
- The endpoint is tagged with `["health"]` in the OpenAPI schema.
- The endpoint is a simple synchronous function returning a static dict. It does not perform database queries, external service checks, or any I/O operations.
- This endpoint is suitable for use with Docker `HEALTHCHECK`, Kubernetes liveness/readiness probes, and load balancer health checks.
- The response is a plain JSON dict, not wrapped in any envelope.
- No query parameters, headers, or request body are required.
