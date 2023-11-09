# Lists all registered services
# prompts the user to select if they want to view all services, running, or stopped
# Provides and option to quit the program

function select_service()
{
    cls

    Write-Host " * OPTIONS: `n - stopped`n - running`n - all"


    #Prompt the user to view all services, running, stopped, or quit
    $userInput = read-host -Prompt "Please enter an option from the list above to view or 'q' to quit the program"

    if($userInput -match "^[qQ]$")
    {

        break # exits the function and ends the program
    }

    check_service -option $userInput

}


function check_service()
{
    #Get the input passed into the function
    Param([string]$option) #function argument

    if( $option -match "stopped" -Or $option -match "running" -Or $option -match "all")
    {
        write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the service logs. "
        sleep 2

        #Calls the function to view the log 
        view_service -option $option

    }
    else
    {
        write-host -BackgroundColor red -ForegroundColor white "The option " $option " doesn't exist."

        sleep 2

        select_service
    }

}


function view_service()
{
    cls
    if($option -match "running")
    {
         Get-Service | Where-Object {$_.Status -eq "Running"}
    }
    elseif($option -match "stopped")
    {
        Get-Service | Where-Object {$_.Status -eq "Stopped"}
    } 
    else
    {
        Get-Service
    }

   # pause the screen and wait until the user is ready to proceed
    read-host -Prompt "Press enter when you are done"

    # go back to select_log
    select_service
    
}

select_service