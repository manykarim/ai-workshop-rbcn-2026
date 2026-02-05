*** Settings ***
Library     Browser


*** Test Cases ***
Hello Browser Chromium
    [Setup]    New Browser    chromium    headless=False

    New Page    https://www.example.com
    ${title}=    Get Title
    Log    The title of the page is: ${title}

Hello Browser Firefox
    [Setup]    New Browser    firefox    headless=False

    New Page    https://www.example.com
    ${title}=    Get Title
    Log    The title of the page is: ${title}
