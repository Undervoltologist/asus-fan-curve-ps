# Fan Curve
$tripPoints = @(
    @{ temp = 20; speed = 22 },
    @{ temp = 56; speed = 40 },
    @{ temp = 70; speed = 55 },
    @{ temp = 75; speed = 69 },
    @{ temp = 85; speed = 75 }

)

# Acceleration Factors
$rampUpAccelerationFactor = 7
$rampDownAccelerationFactor = 3

# Adjustable Delay (in seconds)
$rampUpDelay = 3
$rampDownDelay = 5

# Getting CPU temp
function Get-CPUTemp {
    $output = .\AsusFanControl.exe --get-cpu-temp
    if ($output -match "Current CPU temp: (\d+)") {
        return [int]$matches[1]
    }
    return $null
}

# Getting fan speed
function Get-FanSpeeds {
    $output = .\AsusFanControl.exe --get-fan-speeds
    if ($output -match "Current fan speeds: (\d+) (\d+) RPM") {
        return @([int]$matches[1], [int]$matches[2])
    }
    return $null
}

# Setting fan speed
function Set-FanSpeeds {
    param ($speed)
    .\AsusFanControl.exe --set-fan-speeds=$speed
}

# Fan curve loop
$currentFanSpeed = 0
while ($true) {
    # Get the current CPU temp
    $cpuTemp = Get-CPUTemp
    if ($cpuTemp -eq $null) {
        Write-Output "Failed to get CPU temperature."
        Start-Sleep -Seconds 3
        continue
    }

    # Select the trip point depending on temp
    $targetFanSpeed = 0
    foreach ($tripPoint in $tripPoints) {
        if ($cpuTemp -ge $tripPoint.temp) {
            $targetFanSpeed = $tripPoint.speed
        }
    }

    # Clear console screen
    Clear-Host

    # Fan RPM output
    $fanSpeeds = Get-FanSpeeds
    if ($fanSpeeds -eq $null) {
        Write-Output "Failed to get fan speeds."
    } else {
        Write-Output "Fan speeds: $($fanSpeeds[0]) RPM, $($fanSpeeds[1]) RPM"
    }

    # Adjust fan speed with separate increments
    if ($currentFanSpeed -lt $targetFanSpeed) {
        $currentFanSpeed = [math]::Min($currentFanSpeed + $rampUpAccelerationFactor, $targetFanSpeed)
        # Delay for ramping up
        Start-Sleep -Seconds $rampUpDelay
    } elseif ($currentFanSpeed -gt $targetFanSpeed) {
        $currentFanSpeed = [math]::Max($currentFanSpeed - $rampDownAccelerationFactor, $targetFanSpeed)
        # Delay for ramping down
        Start-Sleep -Seconds $rampDownDelay
    }

    # Set fan speed
    Set-FanSpeeds -speed $currentFanSpeed
}
