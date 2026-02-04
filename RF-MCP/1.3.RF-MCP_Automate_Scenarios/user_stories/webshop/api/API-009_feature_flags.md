# API-009: Feature Flag Management

| Field       | Value                                                 |
|-------------|-------------------------------------------------------|
| **Story ID**  | API-009                                             |
| **Title**     | Feature Flag Management                             |
| **Priority**  | Medium                                              |
| **Component** | Admin API                                           |
| **Endpoints** | `GET /api/admin/flags`, `PUT /api/admin/flags/{flag_key}` |

## User Story

**As a** workshop admin,
**I want to** manage feature flags,
**So that** I can control testing scenarios and enable/disable features dynamically.

## Acceptance Criteria

### AC-1: List all feature flags

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/admin/flags`
**Then** the response status code is `200`
**And** the response body is a JSON object mapping flag keys to boolean values
**And** the response contains exactly 13 flags

### AC-2: All 13 flag keys are present

**Given** the API server is running with seeded data
**When** I send a `GET` request to `/api/admin/flags`
**Then** the response contains the following keys:

| Category         | Flag Key             | Default Value |
|------------------|----------------------|---------------|
| Core             | `NEW_CART_UI`        | `false`       |
| Core             | `MOBILE_UI_V1`       | `false`       |
| Core             | `SEARCH_V2`          | `false`       |
| Locator          | `LOCATOR_V2`         | `false`       |
| Locator          | `LOCATOR_V3`         | `false`       |
| Locator          | `LOCATOR_V4`         | `false`       |
| Bug              | `BUG_MISSING_BUTTON` | `false`       |
| Bug              | `BUG_WRONG_PRICE`    | `false`       |
| Bug              | `BUG_BROKEN_LINKS`   | `false`       |
| Bug              | `BUG_SLOW_RESPONSE`  | `false`       |
| AI               | `AI_DETERMINISTIC`   | `true`        |
| AI               | `AI_RANDOM_DELAYS`   | `false`       |
| AI               | `AI_VARIED_RESPONSES`| `false`       |

### AC-3: Enable a feature flag

**Given** the API server is running with seeded data
**And** the flag `LOCATOR_V2` is currently `false`
**When** I send a `PUT` request to `/api/admin/flags/LOCATOR_V2` with body `{"enabled": true}`
**Then** the response status code is `200`
**And** the response body contains `{"flag": "LOCATOR_V2", "enabled": true}`

### AC-4: Disable a feature flag

**Given** the API server is running with seeded data
**And** the flag `AI_DETERMINISTIC` is currently `true`
**When** I send a `PUT` request to `/api/admin/flags/AI_DETERMINISTIC` with body `{"enabled": false}`
**Then** the response status code is `200`
**And** the response body contains `{"flag": "AI_DETERMINISTIC", "enabled": false}`

### AC-5: Flag key is case-insensitive

**Given** the API server is running with seeded data
**When** I send a `PUT` request to `/api/admin/flags/locator_v2` with body `{"enabled": true}`
**Then** the response status code is `200`
**And** the response body contains `{"flag": "LOCATOR_V2", "enabled": true}`

### AC-6: Toggling a flag affects subsequent requests

**Given** the API server is running with seeded data
**And** `SEARCH_V2` is currently `false`
**When** I send a `PUT` request to `/api/admin/flags/SEARCH_V2` with body `{"enabled": true}`
**And** I then send a `GET` request to `/api/search/?query=headphones`
**Then** the search response `mode` field is `"semantic"`

### AC-7: Missing "enabled" field returns 400

**Given** the API server is running
**When** I send a `PUT` request to `/api/admin/flags/LOCATOR_V2` with body `{"value": true}`
**Then** the response status code is `400`
**And** the response body contains `{"detail": "Missing 'enabled' boolean in payload"}`

### AC-8: Setting a new flag key creates it

**Given** the API server is running
**When** I send a `PUT` request to `/api/admin/flags/CUSTOM_FLAG` with body `{"enabled": true}`
**Then** the response status code is `200`
**And** the response contains `{"flag": "CUSTOM_FLAG", "enabled": true}`
**And** a subsequent `GET /api/admin/flags` includes `"CUSTOM_FLAG": true`

### AC-9: Flag listing reflects current state after toggle

**Given** the API server is running with seeded data
**When** I enable `LOCATOR_V2` via `PUT`
**And** I then send a `GET` request to `/api/admin/flags`
**Then** the response contains `"LOCATOR_V2": true`

## Example Request -- List Flags

```bash
curl -s http://localhost:8000/api/admin/flags | jq .
```

## Example Response -- List Flags

```json
{
  "NEW_CART_UI": false,
  "MOBILE_UI_V1": false,
  "SEARCH_V2": false,
  "LOCATOR_V2": false,
  "LOCATOR_V3": false,
  "LOCATOR_V4": false,
  "BUG_MISSING_BUTTON": false,
  "BUG_WRONG_PRICE": false,
  "BUG_BROKEN_LINKS": false,
  "BUG_SLOW_RESPONSE": false,
  "AI_DETERMINISTIC": true,
  "AI_RANDOM_DELAYS": false,
  "AI_VARIED_RESPONSES": false
}
```

## Example Request -- Toggle Flag

```bash
curl -s -X PUT http://localhost:8000/api/admin/flags/LOCATOR_V2 \
  -H "Content-Type: application/json" \
  -d '{"enabled": true}' | jq .
```

## Example Response -- Toggle Flag

```json
{
  "flag": "LOCATOR_V2",
  "enabled": true
}
```

## Example Request -- Case-Insensitive Key

```bash
curl -s -X PUT http://localhost:8000/api/admin/flags/locator_v2 \
  -H "Content-Type: application/json" \
  -d '{"enabled": true}' | jq .
```

## Example Response -- Case-Insensitive Key

```json
{
  "flag": "LOCATOR_V2",
  "enabled": true
}
```

## Notes

- The `GET /api/admin/flags` endpoint returns a flat `{key: bool}` dictionary, not an array of objects.
- The `PUT` endpoint accepts a raw dict payload and checks for the `"enabled"` key manually (not via Pydantic model).
- Flag keys are always stored and returned in uppercase. The `set_feature_flag` function converts the key with `.upper()`.
- Feature flags are cached using a TTL cache (`cachetools.TTLCache`) with a configurable TTL. The cache is invalidated on flag updates.
- If a flag key does not exist in the database, a new `FeatureFlag` record is created.
- The `PUT` response includes the full updated flag map as context (the `enabled` value for the specific flag is extracted from the updated map).
- No authentication is required for the admin endpoints. This is by design for workshop/demo use.
- The 3 core flags, 3 locator flags, 4 bug flags, and 3 AI flags total 13 flags.
