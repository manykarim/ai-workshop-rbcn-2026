*** Settings ***
Library     SeleniumLibrary


*** Test Cases ***
Hello Selenium Firefox
    Open Browser    https://www.example.com    firefox
    ${title}=    Get Title
    Log    The title of the page is: ${title}
    Close Browser


Hello Selenium Chromium
    Open Browser    https://www.example.com    browser=chrome
    ${title}=    Get Title
    Log    The title of the page is: ${title}
    Close Browser
