Function Get-RamUsage{

	[CmdletBinding()]
	
	Param(
		[Parameter(Mandatory,ValueFromPipeline)]
		[String]$RemoteComputer)
		
		Add-Type -AssemblyName Microsoft.VisualBasic
			
		$ErrorActionPreference = 'stop'
	
	Try{
		$Script:Computer=(Get-CIMInstance -classname win32_operatingsystem -computer $RemoteComputer)
	}Catch{
		$Script:Computer=(Get-WmiObject -classname win32_operatingsystem -computer $RemoteComputer)
	}
	$RamUsage=(1-($Computer.FreePhysicalMemory/$Computer.TotalVisibleMemorySize))
	$PercentageUsed= ("{0:P0}" -f $RamUsage)
	If ($RamUsage -gt .94){
		Send-Alert "RAM usage($PercentageUsed) critical on $($Computer.CSName)"			
	}ElseIf ($RamUsage -gt .84){
		Send-Alert "Warning RAM usage ($PercentageUsed) on $($Computer.CSName) high"
	}Else{
		Send-Alert "RAM usage ($PercentageUsed) is fine on $($Computer.CSName)"
	}
}

Function Send-Alert{
	
	Param(
		[String]$Message)
	
	 [Microsoft.VisualBasic.Interaction]::MsgBox("$Message",'OkOnly,MsgBoxSetForeground,Information','Complete!')
}