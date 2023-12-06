#Parse threat intel

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

#Get the IP addresses discovered, loop through and replace the beginning of the line with the IPTables syntax
#After the IP address, add the remaining IPTables syntax and save the results to a file
# iptables -A INPUT -s 108.191.2.72 -j DROP

(Get-Content -Path ".\ips-bad.tmp") | % `
{ $_ -replace "^", "iptables -A INPUT -s " -replace "$", " -j DROP"} | `
Out-File -FilePath "iptables.bash"
