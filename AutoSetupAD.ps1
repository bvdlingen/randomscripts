 
#Usage: Just run in powershell or call with a (optional) single parameter: the password for the POC
# eg. ./thiscript.ps1 pocpw
# Note: The password should meet the POC complexity rules  - the default supplied with your automation email is the one to use.
#
#22Jan18 - updates made by nathan.cox@nutanix.com
#
##

##################################################
# Take Password as a VAR when script is launched
##################################################

Param(
  [string]$plainpw
)

##################################################

######################################
# Script Placeholder Variables / parameters
######################################

$ifIndexdefault = 12                       #usually the NIC interface is 12

$markerfile = "C:\scripts\PoCmarker.txt"   #pass information after reboots

$step1 = "STEP1"                           #Next step marker
$step2 = "STEP2"                           #Next step marker
$step3 = "STEP3"                           #Next step marker
$done = "DONE"                             #Termination marker
$op = "===== "                             #Helps with my ocd

######################################

######################################
# Host & Domain Info
######################################

$Hostname ="DC"
$NetBIOSName = "BOOTCAMP"
$DomainName = "bootcamp.local"

######################################

######################################
# Added by Nathan for Group & User Add
######################################

$Users=Import-csv c:\scripts\add-users.csv

$a=1;
$b=1;
$failedUsers = @()
$usersAlreadyExist =@()
$successUsers = @()
$VerbosePreference = "Continue"
$LogFolder = "c:\scripts\logs"
$GroupName = "Bootcamp Users"
$OU = "CN=Users, DC=BOOTCAMP,DC=LOCAL"

######################################


######################################
# Setup Marker File
######################################

write-host "$op Start Script"
#Have we rebooted this host after running this script before?
if ((test-Path $markerfile) -eq $true) {
   #We're back from a reboot and previous running of this script
   #file exists, work out what was the last STEP and go to the next step
   $filein = Get-Content $markerfile
   $fileinsplit = $filein.Split(" ")
   $nextstep = $fileinsplit[0]
   $plainpw = $fileinsplit[1]
   #write-host "$op Next step: $nextstep"
   if ($nextstep -eq $done) {
        write-host "$op All steps executed, nothing more to do, quiting"
        exit
   }
}
Else {
      write-host "$op First Run"
      $nextstep = $step1
}

######################################
# Step 1
######################################

If ($nextstep -eq $step1) {

######################################
# Get Network Info
######################################

# Prompt for IP Address
if (!$IPAddress) {
    $IPAddress = Read-Host "$op Enter The IP Address For DC"
}
<#
# Prompt for Netmask
if (!$Netmask) {
    $Netmask = Read-Host "$op Enter The Netmask For DC"
}
#>
# Prompt for Prefix Length
if (!$Prefix) {
    Write-Host "$op Netmask Prefix Examples: 25 = 255.255.255.128 / 24 = 255.255.255.0 / 23 = 255.255.254.0)"
    $Prefix = Read-Host "Enter The Prefix"
}

# Prompt for Gateway
if (!$Gateway) {
    $Gateway = Read-Host "$op Enter The Gateway For DC"
}

# Prompt for First DNS Server
if (!$dns1) {
    $dns1 = Read-Host "$op Enter The DNS Server For DC"
}

# Prompt for Secondary DNS Server
if (!$dns2) {
    $dns2 = Read-Host "$op Enter The Secondary DNS Server For DC"
}

######################################

######################################
#Get password if not received as a paramter
######################################

#if ($plainpw -eq "") {
if (!$plainpw) {
    $plainpw = Read-Host "$op What is the password to use for all AD & User passwords"
}

$securepw =  $plainpw | ConvertTo-SecureString -AsPlainText -Force

######################################

   #Step 1: Set a Static IP Address
   write-host "$op "
   write-host "Step 1: Set Static IP Address for this host"
   write-host "Here is the network ifIndex for this host (it will have the static IP set)"
   $interface = Get-NetAdapter       #Should only have one ifIndex
   $interface | ft Name,ifIndex -AutoSize
   $ifIndex = $interface.ifIndex
   write-host "$op "

   write-host "$op "
   write-host "The following defaults to setup your AD server."
   write-host "Static IP for AD Server: $IPAddress"
   #write-host "$op Netmask: $Netmask"
   write-host "Prefix: $Prefix"
   write-host "Default Gateway: $Gateway"
   write-host "First DNS: $dns1"
   write-host "Secondary DNS: $dns2"
   write-host "Interface: $ifIndex"
   write-host "Domain: $DomainName"
   write-host "Password: $plainpw"
   write-host "DC hostname: $Hostname"
   write-host "$op "

   $go = read-host "--------- If these are OK hit enter, if not enter q"
   if ($go -eq "q") {exit}
   else { if ($go -eq "") {} }
   $continue = Read-Host "$op Will now change IP address and hostname then reboot, hit enter now to continue"

   New-NetIPAddress –InterfaceIndex $ifIndex –IPAddress $IPAddress –PrefixLength $Prefix -DefaultGateway $Gateway
   Set-DnsClientServerAddress -InterfaceIndex $ifIndex -ServerAddresses ($dns1,$dns2)

   #write a marker for when back from a reboot, pass on the pw too
   $EndStep1 = "Step2 $plainpw"
   $EndStep1 | Out-File $markerfile

   write-host "$op Step 1.1: Set hostname to $Hostname"
   Rename-Computer -NewName $Hostname -Restart
}

######################################
# Step 2 - Add AD/DNS Role and also the AD Doman and Forest
######################################

if ($nextstep -like $step2 ) {

   write-host "$op Step 2: Add AD/DNS Role to server and add $DomainName Domain/Forest"
   $continue = Read-Host "$op just hit enter now to continue"

   install-windowsfeature AD-Domain-Services -IncludeManagementTools

   write-host "$op Step 2.1: Add AD Domain and Forest, there will be a reboot!!!!!!"

   #make plain password a secure one
   $securepw =  $plainpw | ConvertTo-SecureString -AsPlainText -Force


   Install-ADDSForest -SafeModeAdministratorPassword $securepw -CreateDnsDelegation:$false -DatabasePath “C:\Windows\NTDS” -DomainMode “Win2012R2” -DomainName $DomainName -DomainNetbiosName $NetBIOSName -ForestMode “Win2012R2” -InstallDns:$true -LogPath “C:\Windows\NTDS” -SysvolPath “C:\Windows\SYSVOL” -Force:$true

   #write a marker for when back from a reboot, pass on the pw too
   $EndStep2 = "Step3 $plainpw"
   $EndStep2 | Out-File $markerfile
}

######################################
# Step 3 - Add Users and Group
######################################

if ($nextstep -like $step3) {
   #$domain = $nextstep
   write-host "$op Step 3: Add Users and Groups"
   $continue = Read-Host "$op just hit enter now to continue"

   Import-module activedirectory

   #Add Groups and Users to the Groups
    NEW-ADGroup -name $GroupName -GroupScope Global

    ForEach($User in $Users)
    {
    $User.FirstName = $User.FirstName.substring(0,1).toupper()+$User.FirstName.substring(1).tolower()
    $FullName = $User.FirstName
    $Sam = $User.FirstName
    $dnsroot = '@' + (Get-ADDomain).dnsroot
    $SAM = $sam.tolower()
    $UPN = $SAM + "$dnsroot"
    $email = $Sam + "$dnsroot"
    #$password = $user.password
    $password = $plainpw
    try {
        if (!(get-aduser -Filter {samaccountname -eq "$SAM"})){
            New-ADUser -Name $FullName -AccountPassword (ConvertTo-SecureString $password -AsPlainText -force) -GivenName $User.FirstName  -Path $OU -SamAccountName $SAM -UserPrincipalName $UPN -EmailAddress $Email -Enabled $TRUE
            Add-ADGroupMember -Identity $GroupName -Members $Sam
            Write-Verbose "[PASS] Created $FullName"
            $successUsers += $FullName
        }

    }
    catch {
        Write-Warning "[ERROR]Can't create user [$($FullName)] : $_"
        $failedUsers += $FullName
        }
    }
    if ( !(test-path $LogFolder)) {
        Write-Verbose "Folder [$($LogFolder)] does not exist, creating"
        new-item $LogFolder -type directory -Force
        }

    Write-verbose "Writing logs"
    $failedUsers |ForEach-Object {"$($b).) $($_)"; $b++} | out-file -FilePath  $LogFolder\FailedUsers.log -Force -Verbose
    $successUsers | ForEach-Object {"$($a).) $($_)"; $a++} |out-file -FilePath  $LogFolder\successUsers.log -Force -Verbose

   #write a marker for when back from a reboot, pass on the pw too
   $EndStep3 = "DONE $plainpw"
   $EndStep3 | Out-File $markerfile
}
