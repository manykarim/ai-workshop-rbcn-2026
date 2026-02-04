# API-010: Workshop Management

| Field       | Value                                                                         |
|-------------|-------------------------------------------------------------------------------|
| **Story ID**  | API-010                                                                     |
| **Title**     | Workshop Preset and Flag Management                                         |
| **Priority**  | Medium                                                                      |
| **Component** | Workshop API                                                                |
| **Endpoints** | `GET /api/workshop/status`, `POST /api/workshop/preset`, `POST /api/workshop/flags`, `GET /api/workshop/presets` |

## User Story

**As a** workshop facilitator,
**I want to** manage workshop presets,
**So that** I can quickly configure testing scenarios for participants.

## Acceptance Criteria

### AC-1: Get workshop status

**Given** the API server is running with seeded data (clean defaults)
**When** I send a `GET` request to `/api/workshop/status`
**Then** the response status code is `200`
**And** the response body contains:
  - `locator_stage`: `"v1"` (when no locator flags are enabled)
  - `active_bugs`: `[]` (empty array when no bug flags are enabled)
  - `ai_mode`: `"deterministic"` (when `AI_DETERMINISTIC` is `true`)
  - `all_flags`: a dictionary of all feature flags with their current values

### AC-2: Apply "buggy" preset

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/workshop/preset` with body `{"preset": "buggy"}`
**Then** the response status code is `200`
**And** the response body contains `"status": "success"`
**And** the response body contains `"preset": "buggy"`
**And** `applied_flags` contains:
  - `"BUG_MISSING_BUTTON": true`
  - `"BUG_WRONG_PRICE": true`
  - `"BUG_BROKEN_LINKS": true`
  - `"BUG_SLOW_RESPONSE": true`
**And** `current_status.active_bugs` lists all 4 bug flags

### AC-3: Apply "clean" preset resets workshop flags

**Given** the API server is running
**And** some workshop flags have been enabled
**When** I send a `POST` request to `/api/workshop/preset` with body `{"preset": "clean"}`
**Then** the response status code is `200`
**And** `current_status.locator_stage` is `"v1"`
**And** `current_status.active_bugs` is `[]`
**And** `current_status.ai_mode` is `"deterministic"`

### AC-4: Apply locator stage presets

**Given** the API server is running with seeded data

**When** I apply preset `"stage2"`
**Then** `current_status.locator_stage` is `"v2"`

**When** I apply preset `"stage3"`
**Then** `current_status.locator_stage` is `"v3"`

**When** I apply preset `"stage4"`
**Then** `current_status.locator_stage` is `"v4"`

### AC-5: Apply "ai_chaos" preset

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/workshop/preset` with body `{"preset": "ai_chaos"}`
**Then** the response status code is `200`
**And** `applied_flags` contains:
  - `"AI_DETERMINISTIC": false`
  - `"AI_RANDOM_DELAYS": true`
  - `"AI_VARIED_RESPONSES": true`

### AC-6: Unknown preset returns error

**Given** the API server is running
**When** I send a `POST` request to `/api/workshop/preset` with body `{"preset": "invalid_preset"}`
**Then** the response status code is `200` (returns error in body, not HTTP error)
**And** the response body contains `"status": "error"`
**And** the response body contains `"message"` indicating unknown preset
**And** the response body contains `"available_presets"` listing all valid preset names

### AC-7: Update specific flags via bulk endpoint

**Given** the API server is running with seeded data
**When** I send a `POST` request to `/api/workshop/flags` with body:
```json
{
  "flags": {
    "LOCATOR_V2": true,
    "BUG_WRONG_PRICE": true
  }
}
```
**Then** the response status code is `200`
**And** the response body contains `"status": "success"`
**And** `updated_flags` contains `{"LOCATOR_V2": true, "BUG_WRONG_PRICE": true}`
**And** `current_status` reflects the updated flag state

### AC-8: List all presets with descriptions

**Given** the API server is running
**When** I send a `GET` request to `/api/workshop/presets`
**Then** the response status code is `200`
**And** the response body contains a `presets` object with 7 entries
**And** each preset entry contains a `description` string and a `flags` dictionary

### AC-9: All 7 presets are available

**Given** the API server is running
**When** I send a `GET` request to `/api/workshop/presets`
**Then** the `presets` object contains the following keys:

| Preset   | Description                                          |
|----------|------------------------------------------------------|
| `clean`  | Reset all workshop features to defaults              |
| `stage1` | Stage 1: Clean slate with standard locators          |
| `stage2` | Stage 2: Changed element IDs and CSS classes         |
| `stage3` | Stage 3: Removed data-test attributes                |
| `stage4` | Stage 4: Restructured DOM hierarchy                  |
| `buggy`  | Enable all intentional bugs for testing              |
| `ai_chaos` | AI with random delays and varied responses         |

### AC-10: Workshop status reflects preset changes

**Given** the API server is running with seeded data
**When** I apply the `"buggy"` preset
**And** I then send a `GET` request to `/api/workshop/status`
**Then** the `active_bugs` array contains `["BUG_MISSING_BUTTON", "BUG_WRONG_PRICE", "BUG_BROKEN_LINKS", "BUG_SLOW_RESPONSE"]`

## Example Request -- Get Status

```bash
curl -s http://localhost:8000/api/workshop/status | jq .
```

## Example Response -- Get Status (Clean)

```json
{
  "locator_stage": "v1",
  "active_bugs": [],
  "ai_mode": "deterministic",
  "all_flags": {
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
}
```

## Example Request -- Apply Preset

```bash
curl -s -X POST http://localhost:8000/api/workshop/preset \
  -H "Content-Type: application/json" \
  -d '{"preset": "buggy"}' | jq .
```

## Example Response -- Apply Preset

```json
{
  "status": "success",
  "preset": "buggy",
  "applied_flags": {
    "BUG_MISSING_BUTTON": true,
    "BUG_WRONG_PRICE": true,
    "BUG_BROKEN_LINKS": true,
    "BUG_SLOW_RESPONSE": true
  },
  "current_status": {
    "locator_stage": "v1",
    "active_bugs": [
      "BUG_MISSING_BUTTON",
      "BUG_WRONG_PRICE",
      "BUG_BROKEN_LINKS",
      "BUG_SLOW_RESPONSE"
    ],
    "ai_mode": "deterministic"
  }
}
```

## Example Request -- Bulk Flag Update

```bash
curl -s -X POST http://localhost:8000/api/workshop/flags \
  -H "Content-Type: application/json" \
  -d '{
    "flags": {
      "LOCATOR_V2": true,
      "BUG_WRONG_PRICE": true
    }
  }' | jq .
```

## Example Response -- Bulk Flag Update

```json
{
  "status": "success",
  "updated_flags": {
    "LOCATOR_V2": true,
    "BUG_WRONG_PRICE": true
  },
  "current_status": {
    "locator_stage": "v2",
    "active_bugs": ["BUG_WRONG_PRICE"],
    "ai_mode": "deterministic"
  }
}
```

## Example Request -- List Presets

```bash
curl -s http://localhost:8000/api/workshop/presets | jq .
```

## Example Response -- List Presets

```json
{
  "presets": {
    "clean": {
      "description": "Reset all workshop features to defaults",
      "flags": {
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
    },
    "stage2": {
      "description": "Stage 2: Changed element IDs and CSS classes",
      "flags": {
        "LOCATOR_V2": true,
        "LOCATOR_V3": false,
        "LOCATOR_V4": false
      }
    },
    "buggy": {
      "description": "Enable all intentional bugs for testing",
      "flags": {
        "BUG_MISSING_BUTTON": true,
        "BUG_WRONG_PRICE": true,
        "BUG_BROKEN_LINKS": true,
        "BUG_SLOW_RESPONSE": true
      }
    }
  }
}
```

## Notes

- The `locator_stage` is derived from active locator flags: `LOCATOR_V4` takes priority over `V3`, which takes priority over `V2`. If none are enabled, the stage is `"v1"`.
- The `ai_mode` reflects the combination of AI flags: base mode is "deterministic" or "live" (based on `AI_DETERMINISTIC`), with optional modifiers "delayed" and "varied" appended in parentheses.
- Presets apply only their specified flags; they do not reset flags outside their scope. Use the `"clean"` preset to reset all workshop-related flags.
- The unknown preset case returns HTTP 200 with an error object in the body (not a 4xx status code).
- The `POST /api/workshop/flags` endpoint accepts a `BulkFlagUpdate` Pydantic model with a `flags` dictionary.
- No authentication is required for workshop management endpoints.
- The preset names are case-insensitive (converted to lowercase before lookup).
