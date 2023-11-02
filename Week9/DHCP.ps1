#Use the Get-WmiObject cmdlet
# Get the DHCP server's IP address and the DNS server IPs


ipconfig /all | Select-String -Pattern "DHCP Server"

ipconfig /all | Select-String -Pattern "\d\.\d\.\d\.\d"
