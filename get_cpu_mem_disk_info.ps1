Remove-Item $env:USERPROFILE\Documents\MemInfo.csv $env:USERPROFILE\Documents\CpuInfo.csv $env:USERPROFILE\Documents\DiskInfo.csv
Start-Transcript $env:USERPROFILE\Documents\findSysInfo.log
$SystemNames = Get-Content $env:USERPROFILE\Documents\Systemlist.txt
echo "SystemName,BankLabel,Capacity,DeviceLocator,Speed" > $env:USERPROFILE\Documents\MemInfo.csv
foreach ($SystemName in $SystemNames)
{
$CpuInfo = Get-WmiObject -ComputerName $SystemName -class win32_processor -Property SystemName,Manufacturer,DeviceID,MaxClockSpeed,NumberOfCores,NumberOfLogicalProcessors | Select-Object SystemName,Manufacturer,DeviceID,MaxClockSpeed,NumberOfCores,NumberOfLogicalProcessors | Export-Csv -Append -NoTypeInformation $env:USERPROFILE\Documents\CpuInfo.csv
$DiskInfo = Get-WmiObject -ComputerName $SystemName -Class Win32_Volume -Property SystemName,DriveLetter,Label,BootVolume,BlockSize,FileSystem,Capacity,FreeSpace | Select-Object SystemName,DriveLetter,Label,BootVolume,BlockSize,FileSystem,Capacity,FreeSpace | Export-Csv -Append -NoTypeInformation $env:USERPROFILE\Documents\DiskInfo.csv
$MemInfo = Get-WmiObject -ComputerName $SystemName -Class Win32_PhysicalMemory -Property BankLabel,Capacity,DeviceLocator,Speed | Select-Object BankLabel,Capacity,DeviceLocator,Speed
    foreach($Obj in $MemInfo )
    {
       $BankLabel = $Obj.BankLabel
       $Capacity = $Obj.Capacity
       $DeviceLocator = $Obj.DeviceLocator
       $Speed = $Obj.Speed

       echo $SystemName','$BankLabel','$Capacity','$DeviceLocator','$Speed >>$env:USERPROFILE\Documents\MemInfo.csv
    }
}
Stop-Transcript