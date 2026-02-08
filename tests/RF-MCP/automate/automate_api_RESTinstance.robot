*** Settings ***
Documentation    Comprehensive REST API test suite for Restful Booker API
...              This suite tests all main CRUD operations: POST, GET, PUT, PATCH, DELETE
...              API Documentation: https://restful-booker.herokuapp.com/apidoc/index.html
Library          REST
Suite Setup      Get Admin Authorization Token
Test Tags        api    restful-booker

*** Variables ***
${BASE_URL}              https://restful-booker.herokuapp.com
${ADMIN_USER}            admin
${ADMIN_PASSWORD}        password123
${AUTH_TOKEN}            ${EMPTY}
${BOOKING_ID}            ${EMPTY}

*** Test Cases ***
TC01 - Create Booking With Full Details
    [Documentation]    Test POST /booking endpoint with complete booking information
    [Tags]    create    post
    ${booking_data} =    Set Variable    { "firstname": "Jim", "lastname": "Brown", "totalprice": 111, "depositpaid": true, "bookingdates": { "checkin": "2026-01-01", "checkout": "2026-01-02" }, "additionalneeds": "Breakfast" }
    
    ${response} =    POST    ${BASE_URL}/booking    ${booking_data}
    Integer    response status    200
    Integer    response body bookingid
    
    # Extract and store the booking ID for later tests
    ${id_value} =    Output    response body bookingid
    Set Suite Variable    ${BOOKING_ID}    ${id_value}
    
    # Assert response body structure
    Object    response body
    Integer    response body bookingid
    String     response body booking firstname    Jim
    String     response body booking lastname    Brown
    Integer    response body booking totalprice    111
    Boolean    response body booking depositpaid    true

TC02 - Create Booking With Minimal Details
    [Documentation]    Test POST /booking with minimal required fields
    [Tags]    create    post
    ${booking_data} =    Set Variable    { "firstname": "Jane", "lastname": "Doe", "totalprice": 200, "depositpaid": false, "bookingdates": { "checkin": "2026-02-01", "checkout": "2026-02-05" } }
    
    ${response} =    POST    ${BASE_URL}/booking    ${booking_data}
    Integer    response status    200
    Integer    response body bookingid
    String     response body booking firstname    Jane

TC03 - Get All Bookings
    [Documentation]    Test GET /booking endpoint to retrieve all booking IDs
    [Tags]    get    list
    ${response} =    GET    ${BASE_URL}/booking
    
    Integer    response status    200
    Array      response body
    Object     response body 0
    Integer    response body 0 bookingid

TC04 - Get Specific Booking By ID
    [Documentation]    Test GET /booking/{id} endpoint to retrieve a specific booking
    [Tags]    get    retrieve
    # Use a known existing booking ID or the one just created
    ${test_id} =    Set Variable If    '${BOOKING_ID}' != '${EMPTY}'    ${BOOKING_ID}    1
    ${response} =    GET    ${BASE_URL}/booking/${test_id}
    
    Integer    response status    200
    Object     response body
    String     response body firstname
    String     response body lastname
    Integer    response body totalprice
    Boolean    response body depositpaid
    Object     response body bookingdates

TC05 - Update Booking Completely (PUT)
    [Documentation]    Test PUT /booking/{id} endpoint to replace entire booking
    [Tags]    update    put
    ${update_data} =    Set Variable    { "firstname": "Susan", "lastname": "Johnson", "totalprice": 250, "depositpaid": false, "bookingdates": { "checkin": "2026-05-01", "checkout": "2026-05-10" }, "additionalneeds": "Dinner" }
    
    ${response} =    PUT    ${BASE_URL}/booking/${BOOKING_ID}    ${update_data}    headers={ "Cookie": "token=${AUTH_TOKEN}" }
    
    Integer    response status    200
    String     response body firstname    Susan
    String     response body lastname    Johnson
    Integer    response body totalprice    250
    Boolean    response body depositpaid    false
    String     response body additionalneeds    Dinner

TC06 - Update Booking Partially (PATCH)
    [Documentation]    Test PATCH /booking/{id} endpoint to update specific fields
    [Tags]    update    patch
    ${patch_data} =    Set Variable    { "firstname": "Mary", "totalprice": 300 }
    
    ${response} =    PATCH    ${BASE_URL}/booking/${BOOKING_ID}    ${patch_data}    headers={ "Cookie": "token=${AUTH_TOKEN}" }
    
    Integer    response status    200
    String     response body firstname    Mary
    String     response body lastname    Johnson
    Integer    response body totalprice    300

TC07 - Update With Different Payload
    [Documentation]    Test PATCH with different field combinations
    [Tags]    update    patch    variations
    ${patch_data} =    Set Variable    { "lastname": "Williams", "depositpaid": true }
    
    ${response} =    PATCH    ${BASE_URL}/booking/${BOOKING_ID}    ${patch_data}    headers={ "Cookie": "token=${AUTH_TOKEN}" }
    
    Integer    response status    200
    String     response body lastname    Williams
    Boolean    response body depositpaid    true

TC08 - Delete Booking
    [Documentation]    Test DELETE /booking/{id} endpoint to remove a booking
    [Tags]    delete
    ${response} =    DELETE    ${BASE_URL}/booking/${BOOKING_ID}    body={}    headers={ "Cookie": "token=${AUTH_TOKEN}" }
    
    Integer    response status    201

TC09 - Verify Deleted Booking Returns 404
    [Documentation]    Verify that deleted booking cannot be retrieved
    [Tags]    delete    negative
    ${response} =    GET    ${BASE_URL}/booking/${BOOKING_ID}    validate=false
    
    Integer    response status    404

*** Keywords ***
Get Admin Authorization Token
    [Documentation]    Suite Setup keyword to obtain admin authentication token
    Set Headers    { "Content-Type": "application/json", "Accept": "application/json" }
    
    ${auth_payload} =    Set Variable    { "username": "${ADMIN_USER}", "password": "${ADMIN_PASSWORD}" }
    ${response} =    POST    ${BASE_URL}/auth    ${auth_payload}
    
    Integer    response status    200
    String    response body token
    
    # Extract token value from the response body
    ${token_value} =    Output    response body token
    Set Suite Variable    ${AUTH_TOKEN}    ${token_value}
    
    Log    Admin token obtained successfully: ${AUTH_TOKEN}    INFO
