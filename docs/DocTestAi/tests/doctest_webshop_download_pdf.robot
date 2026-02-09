*** Settings ***
Documentation    Test suite generated from session a38f90f3-d4c9-4abd-8dd4-bfebc43ea64a containing 1 test case for web automation.
Library         Browser
Test Tags       web    checkout    automated    generated    web

*** Test Cases ***
Demoshop checkout flow with downloads
    [Documentation]    Add two items, assert cart, checkout, and download PDFs to ${OUTPUT_DIR}. Headless set to False.
    [Tags]    web    checkout
    New Browser    chromium    headless=False    downloadsPath=${OUTPUT_DIR}
    New Context    acceptDownloads=True
    New Page
    Go To    https://demoshop.makrocode.de/
    Click    css=button[data-product='12'][data-test='add-to-cart-btn'] >> nth=0    # Click on css=button[data-product='12'][data-test='add-to-cart-btn'] >> nth=0
    ${cart_count_1} =    Get Text    css=span[data-cart-count]
    Get Text    css=span[data-cart-count]    ==    1
    Click    css=button[data-product='11'][data-test='add-to-cart-btn'] >> nth=0    # Click on css=button[data-product='11'][data-test='add-to-cart-btn'] >> nth=0
    Get Text    css=span[data-cart-count]    ==    2
    Go To    https://demoshop.makrocode.de/cart
    Get Text    role=heading[name="Cascade Water Bottle"]    ==    Cascade Water Bottle
    Get Text    role=heading[name="Orbit Drone Camera"]    ==    Orbit Drone Camera
    Click    role=link[name="Proceed to checkout"]    # Click on role=link[name="Proceed to checkout"]
    Fill Text    css=#checkout-email    test@example.com
    Fill Text    css=#checkout-name    Jamie Product
    Fill Text    css=#checkout-address    123 Flow Street\\nSan Francisco, CA
    Click    role=button[name="Place order"]    # Click on role=button[name="Place order"]
    Get Text    role=alert    contains    confirmed
    ${invoice_href} =    Get Attribute    role=link[name="Download Invoice PDF"]    href
    ${summary_href} =    Get Attribute    role=link[name="Download Order Summary PDF"]    href
    Download    https://demoshop.makrocode.de${invoice_href}    ${OUTPUT_DIR}/invoice.pdf
    Download    https://demoshop.makrocode.de${summary_href}    ${OUTPUT_DIR}/order-summary.pdf
    [Teardown]    Close Browser    
