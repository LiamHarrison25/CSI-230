# Review the Security Event Log

# list all the available windows event logs
Get-EventLog -list 

#Create a prompt to allow the user to select the log they want to view from the list
$input = Read-Host -Prompt "Please select a log to view from the list above"

#Create a promt to allow the user to select the search they want to use
$searchInput = Read-Host -Prompt "Please select the string you want to search for"

# Print the log corresponding to the user input
Get-EventLog -LogName $input -Newest 40 | where {$_.Message -ilike "*$searchInput*" } | Export-Csv -NoTypeInformation `
-Path "D:\Projects\Powershell Projects\CSI-230\CSI-230\Week8\Logs.csv"



#TODO: Create a prompt that allows the user to specify a search string
# Find a string from your event logs to search on
