# Lists all registered services
# prompts the user to select if they want to view all services, running, or stopped
# Provides and option to quit the program


function select_log()
{
    cls
    # list all event logs
    $theLogs = Get-EventLog -list | select Log
    $theLogs | Out-Host 

    #initialize the array to store the logs
    $arrLog = @()

    foreach($tempLog in $theLogs)
    {
        #add each log to the array
        $arrLog += $tempLog;

    }

    # Tests to make sure that it is working properly
    #$arrLog
    #$arrLog[0] #// accessing a specific index in the array 

    # prompt the user for the log to view or to quit 

    $userInput = read-host -Prompt "Please enter a log from the list above to view or 'q' to quit the program"

    if($userInput -match "^[qQ]$")
    {

        break # exits the function and ends the program
    }

    log_check -logToSearch $userInput

}


# The purpose of this function is to get the logs
function log_check()
{
    #Get the input passed into the function
    Param([string]$logToSearch) #function argument

    #Format the user input
    $theLog = "^@{Log=" + $logToSearch + "}$"

    #Search the array for the input
    if($arrLog -match $theLog)
    {
        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the log entries. "
        sleep 2

        #Calls the function to view the log 
        view_log -logToSearch $logToSearch

    }
}

function view_log()
{


}

select_log # runs the select log
