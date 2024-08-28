# Define the service names you want to monitor
$servicesToMonitor = @("McAfeeService1", "McAfeeService2") # Replace with actual service names

# Define the event log to monitor (Security, Application, System, etc.)
$eventLog = "System"

# Define the filter for the event log (you can customize this as needed)
$eventFilter = @{
    LogName = $eventLog
    ProviderName = "Service Control Manager" # Modify this if necessary
    ID = 7036 # This ID represents service state changes
}

# Function to monitor the event log
function Monitor-EventLog {
    param (
        [string]$serviceName
    )

    # Get the latest events related to the specified service
    Get-WinEvent -FilterHashtable $eventFilter | Where-Object {
        $_.Message -like "*$serviceName*"
    } | ForEach-Object {
        # Output the relevant information
        Write-Host "Time: $($_.TimeCreated) • Service: $serviceName • Message: $($_.Message)"
    }
}

# Main loop to monitor logs
while ($true) {
    foreach ($service in $servicesToMonitor) {
        Monitor-EventLog -serviceName $service
    }
    # Wait for a specified interval before checking again
    Start-Sleep -Seconds 60 # Adjust the interval as needed
}
