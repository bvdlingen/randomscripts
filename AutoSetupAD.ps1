 #Requires -Modules ActiveDirectory

<#
.SYNOPSIS
    Configures a Windows server as a new AD domain controller.

.DESCRIPTION
    This script:
    - Configures static IP and DNS settings
    - Installs the AD DS role
    - Creates a new AD forest
    - Adds users from a CSV file to the domain

.PARAMETER IpAddress
    Static IP address to configure on the server  

.PARAMETER Prefix
    Subnet prefix length 

.PARAMETER Gateway
    Default gateway IP address

.PARAMETER DomainName
    FQDN of the new AD domain
  
.PARAMETER AdminPassword
    Password for the domain administrator account

.INPUTS
    None. Params provided at script runtime.

.OUTPUTS
    Log files in C:\scripts\logs.

.EXAMPLE
    .\Setup-FirstDC.ps1 -IpAddress 10.0.0.100 -Prefix 24 -Gateway 10.0.0.1 -DomainName corp.contoso.com -AdminPassword Pass@word1

#>

Param(
  [Parameter(Mandatory=$true)]
  [String]$IpAddress,

  [Parameter(Mandatory=$true)] 
  [Int]$Prefix,
  
  [Parameter(Mandatory=$true)]
  [String]$Gateway,

  [Parameter(Mandatory=$true)]
  [String]$DomainName,

  [Parameter(Mandatory=$true)]
  [String]$AdminPassword
)

$ScriptName = $MyInvocation.MyCommand.Name

# Setup logging
$LogFolder = "C:\scripts\logs" 
if (!(Test-Path -Path $LogFolder)) {
  New-Item -ItemType Directory -Path $LogFolder
}
$LogPath = Join-Path -Path $LogFolder -ChildPath "$($ScriptName)_$(Get-Date -Format 'yyyyMMddHHmmss').log" 

# Helper function to write logs
function Write-Log {
  Param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
    [String]$Message
  )
  
  Process {
    $Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'  
    $LogMessage = "[$Timestamp] $Message"
    Write-Verbose $LogMessage
    $LogMessage | Out-File -FilePath $LogPath -Append
  }
}

# Set static IP address and DNS
Write-Log "Setting static IP $IpAddress/$Prefix and DNS on network adapter"

$Params = @{
  InterfaceAlias = 'Ethernet' # Change as needed
  IpAddress = $IpAddress 
  PrefixLength = $Prefix
  DefaultGateway = $Gateway
  DnsServer = '192.168.0.1','8.8.8.8' # Example DNS servers
}

Set-NetIPInterface @Params -Confirm:$false

# Install AD DS role 
Write-Log "Installing Active Directory Domain Services role"

Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Create new AD forest
Write-Log "Creating new Active Directory forest $DomainName"

$DomainParams = @{
  DomainName = $DomainName
  SafeModeAdministratorPassword = $AdminPassword | ConvertTo-SecureString -AsPlainText -Force
  CreateDnsDelegation = $false
  DatabasePath = 'C:\Windows\NTDS'
  DomainMode = 'WinThreshold' 
  ForestMode = 'WinThreshold'
  InstallDns = $true
  LogPath = 'C:\Windows\NTDS'
  SysvolPath = 'C:\Windows\SYSVOL' 
  Force = $true
}

Install-ADDSForest @DomainParams

# Add users
Write-Log "Adding users from CSV file"

Import-Csv -Path .\Users.csv | ForEach-Object {

  $Params = @{
    Name = $_.'Full Name'
    SamAccountName = $_.'Username'
    UserPrincipalName = $_.'Username'@$DomainName
    AccountPassword = (ConvertTo-SecureString $AdminPassword -AsPlainText -Force) 
    Path = 'OU=Employees,DC=corp,DC=contoso,DC=com' # Example OU 
    ChangePasswordAtLogon = $true
    Enabled = $true
  }
  
  try {
    New-ADUser @Params -ErrorAction Stop
    Write-Log "Successfully created user $($Params.SamAccountName)"
  }
  catch {
    Write-Log "Error creating user $($Params.SamAccountName): $_"
  }

}

Write-Log "Script complete!"
