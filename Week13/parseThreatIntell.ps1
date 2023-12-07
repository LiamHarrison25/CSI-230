#Parse threat intel

function getIPS()
{
    cls
    Write-Host "Getting data from the url"

    #Arrays of websites containing threat intell
    $drop_urls =@('https://rules.emergingthreats.net/blockrules/emerging-botcc.rules', 'https://rules.emergingthreats.net/blockrules/compromised-ips.txt')

    #loop through the URLs for the rules list
    foreach ($u in $drop_urls)
    {
        #extract the filename
        $temp = $u.split("/") #takes the string and turns it into an array

        $file_name = $temp[-1]  #The last element in the array plucked off is the filename
  
        if(Test-Path $file_name)
        {
            continue
        }
        else
        {
            #download the rules list
            Invoke-WebRequest -Uri $u -OutFile $file_Name
        }
    }

    #Array containing the filename
    $input_paths =@('.\compromised-ips.txt','.\emerging-botcc.rules')

    #Extract the IP Addresses
    $regex_drop = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b' #used to extract the IP addresses

    #Append the IP addresses to the temporary IP list
    select-string -Path $input_paths -Pattern $regex_drop | `
    ForEach-Object { $_.Matches } | `
    ForEach-Object { $_.Value } | Sort-Object | Get-Unique | `
    Out-File -FilePath "ips-bad.tmp"
}


function userOptions()
{
    cls
    Write-Host "OPTIONS:"
    Write-Host "Block using bash [bash]"
    Write-Host "Block using batch [batch]"
    Write-Host "Quit [q]"
    $userOption = Read-Host -Prompt "What would you like to do"

    switch($userOption)
    {
        "bash"
        {
            getIPS

            Write-Host "Creating bash file"

            #Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
            #After the IP address, add the remaining IPTables syntax and save the results to a file
            # iptables -A INPUT -s 108.191.2.72 -j DROP

            (Get-Content -Path ".\ips-bad.tmp") | % `
            { $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP" } | `
            Out-File -FilePath "iptables.bash"

            Write-Host "File Created. Going back to menu"
            sleep 3
            userOptions
        }
        "batch"
        {
            getIPS

            Write-Host "Creating batch file"

            #Get the IP addresses discovered, loop through and replace the beginning of the line with the netsh syntax
            # netsh advfirewall firewall add rule name="BLOCK IP ADDRESS - 108.191.2.72" dir=in action=block remoteip=108.191.2.72

            (Get-Content -Path '.\ips-bad.tmp') | ForEach-Object `
            { Write-Output "netsh advfirewall firewall add rule name=`"BLOCK IP ADDRESS - $_`" dir=in action=block remoteip=$_" } | `
            Out-File -FilePath 'netshrules.bat'

             Write-Host "File Created. Going back to menu"
             sleep 2
             userOptions
        }
        "q"
        {
            break
        }
        "Q"
        {
            break
        }
        default
        {
            Write-Host "Please enter a valid string"

            sleep 2

            userOptions

        }
    }

}

#begin program

userOptions
