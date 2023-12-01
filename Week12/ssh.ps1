# Login to a remote SSH Server

#gets the ssh server from the user
function getSshServer()
{
    
    cls

    Write-Host "Recommended Address: 192.168.4.22"

    $userInput = Read-Host -Prompt "Please enter the address of the ssh server you want to connect to, or enter q to quit"

    if($userInput -match "^[qQ]$")
    {

        break # exits the function and ends the program
    }

    login -option $userInput


}


#logs into the chosen server
function login()
{
    Param([string]$option) #function argument

    cls

    Write-Host "Logging into server. Credentials Required"

    sleep 2

    #Login to ssh server
    New-SSHSession -ComputerName $option -Credential (Get-credential sys320)

    Write-Host "Credential login successful"

    sleep 2

    getFile -option $option

}

# gets a file from the chosen server
function getFile()
{

    
    # //TODO: Get user input for the name of the file

    Param([string]$option) #function argument

    while ($CONDITION)

    {

        #prompt to run commands
        $command = read-host -Prompt "Please enter a command"

        #run command on remote ssh server
        (Invoke-SSHCommand -index 0 $command).Output

    }


    Set-SCPFile -ComputerName $userInput -Credential (Get-credential sys320) `
    -RemotePath 'home/sys320' -LocalFile '.\tedx.jpeg' 


}

#begin program

$userInput = ''

getSshServer

# Close session
Remove-SSHSession -SessionId 0