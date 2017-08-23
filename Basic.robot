*** Settings ***
Library  Collections
Library  OperatingSystem


*** Test Cases ***
TC01_Add Operation
    [Documentation]  This test case is used to test the add operation
    # Use the Add Operation keyword defined in the end of this file and store the result in result variable
   ${result}=      Add operation       10      20
   log  ${result}
   should be equal as integers      ${result}   30

TC02_Minus Operation
    [Documentation]  This test case is used to test the minus operation
    # Use the Minus Operation keyword defined in the end of this file and store the result in result variable
    ${result}=  Minus Operation    20   5
    should be equal as integers  ${result}  15

TC03_If else
    [Documentation]     This test case is used to test the case with condition
    ${x}    set variable  20
    run keyword if  ${x}==10    log     Correct     ELSE    log     Incorect

TC04_ForLoop
    [Documentation]     This test case is used to test the case with loop
    :FOR    ${i}    IN RANGE    1   10
     \  log  ${i}

TC05_List
    [Documentation]     This test case is used to test the case with list
        # Create list
    ${list}     create list     1   2   3   4
        # this $ sign will log the list normally
    log     ${list}
        # this log many command with @ sign will log the list with each line
    log many  @{list}
        # access item in the list
    log  ${list[2]}
        # append more items to the list
    append to list  ${list}     a   b   c
    log many  @{list}
        # loop through the list from the 1 to 3 item
    :FOR    ${item}     IN RANGE     1  3
    \   log    ${item}
    \   log    ${list[${item}]}

TC06_Dictionary
    [Documentation]     This test case is used to test the case with Dictionary
        # Create dictionary
    ${dict}  create dictionary  a=100    b=200   c=300
        # this $ sign logs the dictionary normally
    log     ${dict}
        # this log many command with the @ sign will log each line but only the key of the dictionary
    log many    @{dict}
        # this log many command with the & sign will log each line with key and value of the dictionary
    log many    &{dict}
        # get the value of a key in the dictionary
    ${itema}    set variable    &{dict}[a]
    log  ${itema}
    should be equal as integers     ${itema}    100
        # log all value in the dictionary based on the keys
    :FOR    ${i}    IN      @{dict}
    \   log     &{dict}[${i}]

TC07_Create JSON message
    [Documentation]  This test case is to create a Json file
    ${jackson}  create dictionary  name=jackson     age=28
    ${friends}  create list
    ${mary}     create dictionary  name=Mary    age=20
    ${john}     create dictionary  name=John    age=22
    append to list  ${friends}  ${mary}     ${john}
    log many  ${friends}
    log many  &{jackson}

TC08_Replace variable in JSON file
    [Documentation]  This test case is to replace the variables in the json file
        # get the file
    ${json_txt}     get file   jackson.json
    log to console   ${json_txt}
        # set variable in this file with new value
    ${name}     set variable    Tu
        # replace all variables in the file and log the file
    ${json_txt}     replace variables  ${json_txt}
    log to console  ${json_txt}

*** Keywords ***
Add operation
    [Arguments]  ${number1}    ${number2}
    Log     ${number1}
    Log     ${number2}
    ${result}    Evaluate     ${number1} + ${number2}
    Log     ${result}
    [Return]  ${result}

Minus Operation
    [Arguments]     ${n1}   ${n2}
    ${result}   EVALUATE  ${n1} - ${n2}
    [Return]    ${result}
    log  ${result}

