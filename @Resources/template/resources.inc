[MemoryTotal]
Measure=PhysicalMemory
Total=1

[MemoryUsed]
Measure=PhysicalMemory
UpdateDivider=1

[CDrive]
Measure=FreeDiskSpace
Drive=C:
UpdateDivider=5

[CDriveTotal]
Measure=FreeDiskSpace
Drive=C:
Total=1

[CDrivePercent]
Measure=Calc
Formula=(CDrive / CDriveTotal) * 100
DynamicVariables=1

[DDrive]
Measure=FreeDiskSpace
Drive=D:
UpdateDivider=5

[DDriveTotal]
Measure=FreeDiskSpace
Drive=D:
Total=1

[DDrivePercent]
Measure=Calc
Formula=(DDrive / (DDriveTotal + 0.000001)) * 100
DynamicVariables=1

[MemoryPercent]
Measure=Calc
Formula=(MemoryUsed / MemoryTotal) * 100
UpdateDivider=1

[CPUUsage]
Measure=Plugin
Plugin=UsageMonitor
Alias=CPU
Index=-1
Percent=1
UpdateDivider=1

[CPUPercent]
Measure=Calc
Formula=[CPUUsage:]
DynamicVariables=1
UpdateDivider=1

[GPUUsage]
Measure=Plugin
Plugin=UsageMonitor
Alias=GPU
Index=-1
UpdateDivider=1

[GPUPercent]
Measure=Calc
Formula=[GPUUsage:]
DynamicVariables=1
UpdateDivider=1