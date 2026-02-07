*** Settings ***
Documentation    Comprehensive REST API test suite for Restful Booker API
...              This suite tests authentication, GET, POST, and DELETE operations
...              with proper assertions and different payloads
Library          RequestsLibrary
Suite Setup      Authenticate As Admin
Test Tags        api    restful-booker    http

*** Variables ***
${BASE_URL}         https://restful-booker.herokuapp.com
${USERNAME}         admin
${PASSWORD}         password123
${TOKEN}            ${EMPTY}

*** Test Cases ***
Test Health Check
    [Documentation]    Verify API is up and running with ping endpoint
    [Tags]    health-check
    ${response} =    GET    ${BASE_URL}/ping
    Should Be Equal As Numbers    ${response.status_code}    201

Test Get All Bookings
    [Documentation]    Retrieve all booking IDs and verify response structure
    [Tags]    get    bookings
    Create Session    booker    ${BASE_URL}
    ${response} =    GET On Session    booker    /booking    expected_status=200
    Should Be Equal As Numbers    ${response.status_code}    200
    ${bookings} =    Set Variable    ${response.json()}
    Should Be True    len($bookings) > 0
    Log    Found ${bookings.__len__()} bookings

Test Get Specific Booking
    [Documentation]    Get a specific booking by ID and verify data structure
    [Tags]    get    booking-details
    Create Session    booker    ${BASE_URL}
    # Get all bookings first
    ${all_bookings_response} =    GET On Session    booker    /booking    expected_status=200
    ${all_bookings} =    Set Variable    ${all_bookings_response.json()}
    ${first_booking_id} =    Evaluate    $all_bookings[0]['bookingid']
    
    # Get specific booking
    ${response} =    GET On Session    booker    /booking/${first_booking_id}    expected_status=200
    ${booking} =    Set Variable    ${response.json()}
    
    # Verify structure
    Should Be True    isinstance($booking, dict)
    Should Be True    'firstname' in $booking
    Should Be True    'lastname' in $booking
    Should Be True    'totalprice' in $booking
    Should Be True    'depositpaid' in $booking
    Should Be True    'bookingdates' in $booking

Test Get Bookings By Name Filter
    [Documentation]    Filter bookings by firstname and lastname query parameters
    [Tags]    get    filter
    Create Session    booker    ${BASE_URL}
    ${response} =    GET On Session    booker    /booking    
    ...    params={'firstname': 'John', 'lastname': 'Smith'}    
    ...    expected_status=200
    Should Be Equal As Numbers    ${response.status_code}    200
    ${filtered_bookings} =    Set Variable    ${response.json()}
    Log    Found ${filtered_bookings.__len__()} bookings matching filter

Test Create Booking With Full Details
    [Documentation]    POST request to create a new booking with all fields
    [Tags]    post    create
    Create Session    booker    ${BASE_URL}
    
    # Prepare booking payload
    ${booking_data} =    Evaluate    {'firstname': 'Jane', 'lastname': 'Doe', 'totalprice': 150, 'depositpaid': True, 'bookingdates': {'checkin': '2026-03-01', 'checkout': '2026-03-05'}, 'additionalneeds': 'Lunch'}
    
    # Create booking
    ${response} =    POST On Session    booker    /booking    
    ...    json=${booking_data}    
    ...    expected_status=200
    
    # Verify response
    ${created_booking} =    Set Variable    ${response.json()}
    ${booking_id} =    Evaluate    $created_booking['bookingid']
    ${booking} =    Evaluate    $created_booking['booking']
    
    # Assertions
    Should Be True    isinstance($booking_id, int)
    ${firstname} =    Evaluate    $booking['firstname']
    Should Be Equal    ${firstname}    Jane
    ${lastname} =    Evaluate    $booking['lastname']
    Should Be Equal    ${lastname}    Doe
    ${total} =    Evaluate    $booking['totalprice']
    Should Be Equal As Numbers    ${total}    150
    ${deposit} =    Evaluate    $booking['depositpaid']
    Should Be True    ${deposit} == True
    
    # Store booking ID for cleanup
    Set Suite Variable    ${BOOKING_ID_1}    ${booking_id}

Test Create Booking Without Deposit
    [Documentation]    POST request with depositpaid set to False
    [Tags]    post    create    no-deposit
    Create Session    booker    ${BASE_URL}
    
    # Different payload
    ${booking_data} =    Evaluate    {'firstname': 'Bob', 'lastname': 'Builder', 'totalprice': 200, 'depositpaid': False, 'bookingdates': {'checkin': '2026-04-10', 'checkout': '2026-04-15'}, 'additionalneeds': 'Parking'}
    
    # Create booking
    ${response} =    POST On Session    booker    /booking    
    ...    json=${booking_data}    
    ...    expected_status=200
    
    # Verify response
    ${created_booking} =    Set Variable    ${response.json()}
    ${booking_id} =    Evaluate    $created_booking['bookingid']
    ${booking} =    Evaluate    $created_booking['booking']
    
    # Assertions for no deposit
    ${deposit} =    Evaluate    $booking['depositpaid']
    Should Be True    ${deposit} == False
    ${firstname} =    Evaluate    $booking['firstname']
    Should Be Equal    ${firstname}    Bob
    
    # Store booking ID for cleanup
    Set Suite Variable    ${BOOKING_ID_2}    ${booking_id}

Test Create Booking Minimal Data
    [Documentation]    POST request with minimal required fields
    [Tags]    post    create    minimal
    Create Session    booker    ${BASE_URL}
    
    # Minimal payload
    ${booking_data} =    Evaluate    {'firstname': 'Alice', 'lastname': 'Smith', 'totalprice': 100, 'depositpaid': True, 'bookingdates': {'checkin': '2026-05-01', 'checkout': '2026-05-05'}, 'additionalneeds': 'None'}
    
    ${response} =    POST On Session    booker    /booking    
    ...    json=${booking_data}    
    ...    expected_status=200
    
    ${created_booking} =    Set Variable    ${response.json()}
    ${booking_id} =    Evaluate    $created_booking['bookingid']
    Should Be True    isinstance($booking_id, int)
    
    # Store booking ID for cleanup
    Set Suite Variable    ${BOOKING_ID_3}    ${booking_id}

Test Delete Booking
    [Documentation]    DELETE a booking and verify it's removed
    [Tags]    delete
    Create Session    booker    ${BASE_URL}
    
    # Create auth headers with token
    ${auth_headers} =    Evaluate    {'Cookie': 'token=${TOKEN}'}
    
    # Delete the first booking
    ${response} =    DELETE On Session    booker    
    ...    /booking/${BOOKING_ID_1}    
    ...    headers=${auth_headers}    
    ...    expected_status=201
    
    # Verify deletion
    Should Be Equal As Numbers    ${response.status_code}    201
    Should Be Equal    ${response.text}    Created
    
    # Verify booking is gone
    ${verify_response} =    GET On Session    booker    
    ...    /booking/${BOOKING_ID_1}    
    ...    expected_status=404
    Should Be Equal As Numbers    ${verify_response.status_code}    404

Test Delete Multiple Bookings
    [Documentation]    DELETE multiple bookings created during the test
    [Tags]    delete    cleanup
    Create Session    booker    ${BASE_URL}
    ${auth_headers} =    Evaluate    {'Cookie': 'token=${TOKEN}'}
    
    # Delete second booking
    ${response2} =    DELETE On Session    booker    
    ...    /booking/${BOOKING_ID_2}    
    ...    headers=${auth_headers}    
    ...    expected_status=201
    Should Be Equal As Numbers    ${response2.status_code}    201
    
    # Delete third booking
    ${response3} =    DELETE On Session    booker    
    ...    /booking/${BOOKING_ID_3}    
    ...    headers=${auth_headers}    
    ...    expected_status=201
    Should Be Equal As Numbers    ${response3.status_code}    201

Test Delete Without Authentication Fails
    [Documentation]    Verify DELETE requires authentication
    [Tags]    delete    negative    security
    Create Session    booker    ${BASE_URL}
    
    # Try to delete without auth header (should fail but API may not enforce)
    DELETE On Session    booker    /booking/1    expected_status=403

*** Keywords ***
Authenticate As Admin
    [Documentation]    Suite setup to authenticate and get auth token
    Create Session    booker    ${BASE_URL}
    
    # Create auth payload
    ${auth_body} =    Evaluate    {"username": "${USERNAME}", "password": "${PASSWORD}"}
    
    # Get token
    ${auth_response} =    POST On Session    booker    /auth    
    ...    json=${auth_body}    
    ...    expected_status=200
    
    # Extract and set token
    ${auth_json} =    Set Variable    ${auth_response.json()}
    ${token} =    Evaluate    $auth_json['token']
    Set Suite Variable    ${TOKEN}    ${token}
    Log    Successfully authenticated with token: ${TOKEN}
