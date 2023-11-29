# Login to a remote SSH Server

cls

<#
New-SSHSession -ComputerName '192.168.4.22' -Credential (Get-credential sys320)


while ($CONDITION)

{

    #prompt to run commands
    $command = read-host -Prompt "Please enter a command"

    #run command on remote ssh server
    (Invoke-SSHCommand -index 0 $command).Output

}

#>


Set-SCPFile -ComputerName '192.168.4.22' -Credential (Get-credential sys320) `
-RemotePath 'home/sys320' -LocalFile '.\tedx.jpeg' 









# Close session
Remove-SSHSession -SessionId 0