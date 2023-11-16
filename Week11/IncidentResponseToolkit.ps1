# Write a script that retrieves:
# 1: Running Processes and the path for each project
# 2: All registered services and the path to the excecutable controlling the service (Use WMI)
# 3: All TCP network sockets
# 4: All user account information (use WMI)
# 5: All network adapter configuration information
# 6: use powershell cmdlets to save 4 other artifacts that would be useful in an incident. 


#extra cmdlet ideas:

# Stop-Computer //shuts down the computer
# Stop-Process or Stop-Service //stops a process. Can be used to stop an "unsafe" application
# Get-Job and Stop-Job //used to find and stop running powershell jobs
# Remove-Item //used to delete an item. Can be used to delete an "unsafe" file (Create a file and then delete it)

function selectDirectory()
{
    Write-Host "Recommended Directory: D:\Projects\Powershell Projects\CSI-230\CSI-230\Week11\"
    $directory = read-host -Prompt "Please enter the directory to put the data in"

    selectOption
}

function selectOption()
{
    cls
    
    Write-Host " *OPTIONS: "
    Write-Host "-Running Processes"
    Write-Host "-All registered services" 
    Write-Host "-All TCP network sockets"
    Write-Host "-All user account information"
    Write-Host "-All network adapter configuration information"
    Write-Host "-Stop Computer"
    Write-Host "-Stop unsafe process"
    Write-Host "-Stop unsafe powershell job"
    Write-Host "-Delete unsafe item"

    $userInput = Read-Host -Prompt "Please enter an option from the list above to view or 'q' to quit the program"

    if($userInput -match "^[qQ]$")
    {
        break
    }

    checkOption -option $userInput
}


function checkOption()
{
    Param([string]$option)

    Switch ($option)
    {
        "Running Processes" 
        {
            $fullDirectory = Join-Path -Path $directory -ChildPath "processes.csv"
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the running processes. "
            Get-Process | Export-Csv -Path "$fullDirectory"
        }
        "All registered services" 
        {
            $fullDirectory = Join-Path -Path $directory -ChildPath "services.csv"
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the registered services. "
            Get-Service | Export-Csv -Path "$fullDirectory"
        }
        "All TCP network sockets" 
        {
            $fullDirectory = Join-Path -Path $directory -ChildPath "networkSockets.csv"
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the TCP network sockets. "
            Get-NetTCPConnection | Export-Csv -Path "$fullDirectory"
        }
        "All user account information" 
        {
            $fullDirectory = Join-Path -Path $directory -ChildPath "userInfo.csv"
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the user account information. "
            Get-LocalUser | Export-Csv -Path "$fullDirectory"
        }
        "All network adapter configuration information" 
        {
            $fullDirectory = Join-Path -Path $directory -ChildPath "networkAdapter.csv"
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the network adapter configuration information. "
            Get-NetAdapter | Export-Csv -Path "$fullDirectory"
        }
        "Stop Computer" 
        {
            write-host -BackgroundColor Green -ForegroundColor white "Powering down the computer. "
            Stop-Computer
        }
        "Stop unsafe process" 
        {
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, attempting to shut down the harmful program. "

            # Stopping calculator for example. Maybe someone embedded malicious code into calc.exe

            Stop-Process -FilePath C:\Windows\System32\calc.exe

        }
        "Stop unsafe powershell job" 
        {
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, attempting to shut down the harmful powershell job. "
            Stop-Job "UnsafeProcessExample"

        }
        "Delete unsafe item" 
        { 
            write-host -BackgroundColor Green -ForegroundColor white "Please wait, attempting to delete the unsafe item. "

            remove-item -Path "D:\Project\Powershell Projects\CSI-230\CSI-230\Week11\unsafeFile.txt" -Force

        }
        default 
        {
            Write-Host "Please enter a valid option"
                
            sleep 2

            selectOption
        }
    }

    # pause the screen and wait until the user is ready to proceed
    read-host -Prompt "Press enter when you are done"

    selectOption


}

function zipFiles()
{
    #//TODO: 
}

selectDirectory
