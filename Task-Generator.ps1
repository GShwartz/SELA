# Define script to run
$file = ".\open.ps1"

# Define Task's Name
$name = "MyTask"

# Set Task Action
$action = New-ScheduledTaskAction -Execute "powershell" -Argument "$file" "hello.txt"

# Set Task Trigger
$trigger = New-ScheduledTaskTrigger -Daily -At 08:00am 

# Register Task
Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger

# Disable Task
Disable-ScheduledTask -TaskName $name

# Display Tasks By Path
Get-ScheduledTask | where {$_.TaskPath -eq "\"}
