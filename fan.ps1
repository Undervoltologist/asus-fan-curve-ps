# fan curve
$tripPoints = @(
    @{ temp = 40; speed = 0 },
    @{ temp = 48; speed = 22 },
    @{ temp = 55; speed = 40 },
    @{ temp = 64; speed = 55 },
    @{ temp = 77; speed = 80 },
    @{ temp = 86; speed = 100 }
)

# getting CPU temp
function Get-CPUTemp {
    $output = .\AsusFanControl.exe --get-cpu-temp
    if ($output -match "Current CPU temp: (\d+)") {
        return [int]$matches[1]
    }
    return $null
}

# getting fan speed
function Get-FanSpeeds {
    $output = .\AsusFanControl.exe --get-fan-speeds
    if ($output -match "Current fan speeds: (\d+) (\d+) RPM") {
        return @([int]$matches[1], [int]$matches[2])
    }
    return $null
}

# setting fan speed
function Set-FanSpeeds {
    param ($speed)
    .\AsusFanControl.exe --set-fan-speeds=$speed
}

# fan curve loop
while ($true) {
    # get the current CPU temp
    $cpuTemp = Get-CPUTemp
    if ($cpuTemp -eq $null) {
        Write-Output "Failed to get CPU temperature."
        Start-Sleep -Seconds 3
        continue
    }

    # select the trip point depending on temp
    $fanSpeed = 0
    foreach ($tripPoint in $tripPoints) {
        if ($cpuTemp -ge $tripPoint.temp) {
            $fanSpeed = $tripPoint.speed
        }
    }

    # clear console screen
    Clear-Host

    # get current fan RPM for output
    $fanSpeeds = Get-FanSpeeds
    if ($fanSpeeds -eq $null) {
        Write-Output "Failed to get fan speeds."
    } else {
        Write-Output "Fan speeds: $($fanSpeeds[0]) RPM, $($fanSpeeds[1]) RPM"
    }

    # wait for 3 secs before the next check
    Start-Sleep -Seconds 2

    # set fan speed
    Set-FanSpeeds -speed $fanSpeed

    # wait for 1 sec
    Start-Sleep -Seconds 1

}
