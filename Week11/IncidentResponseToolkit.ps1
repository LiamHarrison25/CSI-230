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


