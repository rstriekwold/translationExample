*** Settings ***
Library           Collections
Library           yaml
Library     QWeb
Library     String
Library     OperatingSystem
Suite Setup       Open Browser    about:blank    ${BROWSER}
Suite Teardown    Close All Browsers

*** Variables ***
${LANGUAGE}       english
${LANG_FILE}     ../resources/lang_file.yaml

*** Keywords ***
Get Label
    [Documentation]    Returns the translated label from the language YAML file.
    ...                Arguments:
    ...                - language: top-level language key (e.g. english, nederlands)
    ...                - path: dot-notation path to the label (e.g. new_lead.first_name)
    [Arguments]        ${language}    ${path}
    ${file_content}=   Get File       ${LANG_FILE}
    ${data}=           Evaluate       __import__('yaml').safe_load('''${file_content}''')
    ${lang_data}=      Get From Dictionary    ${data}    ${language}
    @{keys}=           Split String    ${path}    .
    ${value}=          Set Variable    ${lang_data}
    FOR    ${key}    IN    @{keys}
        ${value}=      Get From Dictionary    ${value}    ${key}
    END
    RETURN    ${value}

*** Test Cases ***
Example - Get Labels In English And Dutch
    [Documentation]    Demonstrates retrieving labels from the YAML language file.
    [Tags]             language    labels

    # English labels
    ${label_first_name}=      Get Label    english    new_lead.first_name
    ${label_company}=         Get Label    english    new_lead.company
    ${label_save}=            Get Label    english    buttons.save
    ${label_home}=            Get Label    english    home
    ${label_modal}=           Get Label    english    modal.new_lead

    Log to console    First Name (EN): ${label_first_name}
    Log to console     Company (EN): ${label_company}
    Log to console     Save (EN): ${label_save}
    Log to console     Home (EN): ${label_home}
    Log to console    Modal New Lead (EN): ${label_modal}

    # Dutch labels
    ${label_first_name_nl}=   Get Label    nederlands    new_lead.first_name
    ${label_company_nl}=      Get Label    nederlands    new_lead.company
    ${label_save_nl}=         Get Label    nederlands    buttons.save

    Log to console     First Name (NL): ${label_first_name_nl}
    Log to console     Company (NL): ${label_company_nl}
    Log to console     Save (NL): ${label_save_nl}