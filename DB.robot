*** Settings ***
Library     DatabaseLibrary
Library     OperatingSystem
Library     AWSSQSLibraryKeywords
Library     MySQLDBConnector
Library     OracleLibrary

*** Test Cases ***
TC01_Connect to MySQL DB Using MySQLDBConnector
    ${db}    MySQLDBConnector.Connect    noti    root    root    localhost    3306
    Set Global Variable    ${db}


TC02_Query MySQL DB  Using MySQLDBConnector
    [Arguments]    ${query-string}
    ${result}    MySQLDBConnector.Query    ${db}    Select channel_name from channel where channel_id='1'
    log to console  ${result}
    [Return]    ${result}

TC03_Connect to MySQL DB Using DatabaseLibrary:
    Connect To Database     pymysql     noti    root    root    localhost    3306

TC04_Connect to DB2 DB Using DatabaseLibrary:
    Connect To Database     ibm_db     noti    root    root    localhost    3306

TC05_Connect to MSSQL DB Using DatabaseLibrary:
    Connect To Database     pymssql     noti    root    root    localhost    3306

TC05_Connect to Postgres DB Using DatabaseLibrary:
    Connect To Database     psycopg2     noti    root    root    localhost    3306

#TC06_Connect to Oracle DB Using DatabaseLibrary:
#    connect to database using custom params     JayDeBeApi      root/root@localhost:3306/noti
#    connect to database using custom params     cx-Oracle
#    Connect To Database Using Custom Params     cx_Oracle   'root','root','localhost:3306/noti'
