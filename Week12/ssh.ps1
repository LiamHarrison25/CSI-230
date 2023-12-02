# Login to a remote SSH Server

#gets the ssh server from the user
function getSshServer()
{
    cls

    Write-Host "Recommended Address: 192.168.4.22"

    $addressInput = Read-Host -Prompt "Please enter the address of the ssh server you want to connect to, or enter q to quit"

    if($addressInput -match "^[qQ]$")
    {
        break # exits the function and ends the program
    }

    Write-Host "Default Port is 22"

    $portInput = Read-Host -Prompt "Please enter the port of the ssh server you want to connect to, or enter q to quit"
    if($portInput -match "^[qQ]$")
    {
        break # exits the function and ends the program
    }
    if($portInput -or $portInput){}#detects if the input is not null
    else
    {
        Write-Host "Using default port of 22"
        $portInput = 22;
    }

    #Gets the credentials from the user
    $credentialInput = Get-Credential -Message "Please enter the SSH credentials to login"

    login -option $addressInput, $portInput, $credentialInput 
}


#logs into the chosen server
function login()
{
    Param([string]$option) #function argument

    cls

    Write-Host "Attempting to login to SSH server. Please wait."

     # Creates a new SSH session
    $newSession = New-SSHSession -ComputerName $addressInput -Port $portInput -Credential $credentialInput    

    sleep 2

    #Login to ssh server
    #New-SSHSession -ComputerName $option -Credential (Get-credential sys320)

    if($newSession.Connected)
    {
         Write-Host "Credential login successful"

         sleep 2

         getFile -option $option
    }
    else
    {
        Write-Host "Connection attempt failed."
        $userInput = Read-Host -Prompt "Would you like to attempt another login? y/N"

        if($userInput -match"^[yY]$")
        {
            getSshServer #loops back to first function
        }
        else
        {
            break # exits the function and ends the program
        }
    }
}

# gets a file from the chosen server
function getFile()
{

    # //TODO: Get user input for the name of the file

    Param([string]$option) #function argument

    $command = ""

    while (-Not $command -match"^[cC]$")

    {
        #prompt to run commands
        $command = read-host -Prompt "Please enter a command or type c to continue"

        #run command on remote ssh server
        (Invoke-SSHCommand -index 0 $command).Output
    } 

    $fileInput = Read-Host -Prompt "Enter the path to the file you want to upload to the server"
     
    $PathInput = Read-Host -Prompt "Enter the path on the server where you want to upload the file"

    Set-SCPFile -ComputerName $addressInput -Credential $credentialInput -RemotePath $pathInput -LocalFile $fileInput

}

#begin program

getSshServer

# Close session
Remove-SSHSession -SessionId 0
