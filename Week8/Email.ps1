# Send an email

#Email body
$msg = "Please open the attached file for free gift cards!"

#Writes the email to the screen
write-host -BackgroundColor Red -ForegroundColor white $msg

# Sender Email Address
$email = "liam.harrison@mymail.champlain.edu"

# Receiver Email Address
$toEmail = "deployer@csi-web"

#Sending email
Send-MailMessage -From $email -to $toEmail -Subject "Free Gift Cards" -body $msg -SmtpServer 192.168.4.22
