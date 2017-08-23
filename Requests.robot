*** Settings ***
Library  RequestsLibrary
Library  Collections
Library  String
Library  DateTime
Library  XML
Library  OperatingSystem
Library  StringKeyword.py

*** Test Cases ***
TC01_Get Request 1
    [Documentation]  This is a basic test case to test the get request from google and check the response code is 200
        # Create session
    create session      google      http://google.com
        # Send a get request to the session and get the response status code
    ${resp}     get request     google      /
    Log     ${resp.status_code}
        # Verify that the response status code is 200
    should be equal as strings      ${resp.status_code}     200

TC02_Get Request Json
    [Documentation]  This test case is used to test the get request, access and implement fields in the json response file
        # Create session
    create session  tmt   https://ascendtmt.tmn-dev.net
        # Send a get request to the session
    ${json_txt}     get request  tmt    /remote/query_test_results?te_ids=45
        # Convert response file to json
    ${json}    set variable  ${json_txt.json()}
        # initiate sum variable
    ${sum}      set variable  0
        # Loop the items in the response json file, get the 'test_case_result' and sum all of this number
    :FOR    ${item}     IN      @{json}
    \   log to console  ${item['test_result']['test_case_count']}
    \   ${sum}  evaluate  ${sum}+${item['test_result']['test_case_count']}
    log to console  ${sum}

TC3_Get Request XML
    [Documentation]     This test case is used to test the get request, access and implement fields in the xml response file
        # create session
    create session  bayer  http://www.thomas-bayer.com
        # Send the get request to the session and get the respond
    ${resp}   get request  bayer  /sqlrest/PRODUCT/
        # Get all the <PRODUCT> item in response file
    ${products}   get elements  ${resp.text}  PRODUCT
        # initiate the total_price variable
    ${total_price}    set variable  0
        # loop all the <PRODUCT> item in the response file, get the value of link attribute in each of them, send get request with that link, get the <PRICE> of each link and sum all of them together.
    :FOR  ${item}     IN      @{products}
    \     ${product_link}     set variable    &{item.attrib}[{http://www.w3.org/1999/xlink}href]
    \     create session      product_detail     ${product_link}
    \     ${product_detail}      get request      product_detail     ${EMPTY}
    \     ${product_price}    get element  ${product_detail.text}     PRICE
    \     ${total_price}     evaluate    ${total_price}+${product_price.text}
    log  ${total_price}


TC4_POST Request Json
    [Documentation]  This test case is quite complex test case about post, we will send the POST request with json file 1, check the response, extract data from the response file then send another POST request with the json file 2, check the response status code is 200
    # Step 1: Send verify request to server and get the response result
        # Note:
            # 1. verify_request.json file is the body file
            # 2. verify_request_header.json is the header file
            # 3. Although 2 above files have the .json but actually, they are still the text files
            # 4. In body file, there are 2 fields are changed real time: signature and req_transaction_id --> we need to set them as variable and implement
            # 5. In body file, field signature is combined by fields: partner_name + amount + ref1 + reqtransaction_id. After combine, we need to use the encode_hex_SHA256 in StringKeyword.py file to encode it.
        # Create session to verify
    create session   bpay   https://10.224.100.36/billpays/biller/v1/payment/verify
        # get body file
    ${verify_rqs_body_txt}      get file    verify_request.json
        # change the ${transaction_req_id} in body file dynamically by current date ecause it has format as the current date.
    ${transaction_req_id}=   Get Current Date
    log  ${transaction_req_id}
        # Combine and encode the signature field
    ${signature}    encode_hex_SHA256    8FKN4S27466C7R0U     TMX10.005407169458012961${transaction_req_id}
    log  ${signature}
        # replace 2 variables in body file
    ${verify_rqs_body_txt}     replace variables    ${verify_rqs_body_txt}
    log   ${verify_rqs_body_txt}
        # get header file and convert it to json
    ${verify_rqs_header_txt}    get file    verify_request_header.json
    ${verify_rqs_header_json}   to json     ${verify_rqs_header_txt}
    log  ${verify_rqs_header_json}
        # send the post request with body and header fiedls to the verify session and get the response. Note that the data accepts the palin text but the headers only accept the json file
    ${verify_rqs_resp}  post request  bpay  ${EMPTY}    data=${verify_rqs_body_txt}     headers=${verify_rqs_header_json}
    log  ${verify_rqs_resp.text}

    # Step 2: From the response file in step 1, get the value of transaction id field
        # Convert the response file to json
    ${verify_rqs_resp_json}  set variable    ${verify_rqs_resp.json()}
    log  ${verify_rqs_resp_json}
        # Get value of transaction id from response file
    ${transaction_id}   set variable  ${verify_rqs_resp_json['transaction_id']}
    log  ${transaction_id}

    # Step 3: use value of transaction id in step 2 to set the
        # Note:
            # 1. The header of this request is the same as header in verify request
            # 2. In body file, field signature is combined by fields: partner_name + amount + ref1 + req_transaction_id + transaction id (from the response file). After combine, we need to use the encode_hex_SHA256 in StringKeyword.py file to encode it.
        # Create session to confirm
    create session  bpay_confirm    https://10.224.100.36/billpays/biller/v1/payment/confirm
        # get body file
    ${confirm_rqs_body_txt}     get file    confirm_req.json
         # change the ${confirm_request_transaction_id} in body file dynamically by current date ecause it has format as the current date.
    ${confirm_request_transaction_id}   Get current Date
         # Combine and encode confirm_signature field
    ${confirm_signature}    set variable  TMX10.005407169458012961${confirm_request_transaction_id}${transaction_id}
    log     ${confirm_signature}
        # replace 2 variables in body file
    ${confirm_rqs_body_txt}     replace variables  ${confirm_rqs_body_txt}
    log     ${confirm_rqs_body_txt}
        # send the post request with body and header fiedls to the confirm session
    ${confirm_resp}     post request    bpay_confirm    ${EMPTY}    data=${confirm_rqs_body_txt}    headers=${verify_rqs_header_json}
        # verify that status code response is 200
     should be equal as integers     ${confirm_resp.status_code}      200

*** Keywords ***
