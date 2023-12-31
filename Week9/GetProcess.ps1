﻿# Using Get-Process and Get-Service

Get-Process | Select-Object ProcessName, Path, ID | `
Export-Csv -Path "D:\Projects\Powershell Projects\CSI-230\CSI-230\Week9\myProcess.csv"

Get-Service | Where { $_.Status -eq "Running" } | `
Export-Csv -Path "D:\Projects\Powershell Projects\CSI-230\CSI-230\Week9\myServices.csv"
