# asus-fan-curve-ps
powershell script for setting a fan curve for asus laptops that don't have modes (can also work with the ones that have modes)

# why
made using the fan control application at https://github.com/Karmel0x/AsusFanControl, since the author didn't need 
fan curves but I did. 

# usage
extract the zip and run the bat file inside it, doesn't need admin.

you can adjust and add temp thresholds, fan speeds, acceleration, and the delay before setting fan speed in the powershell script:
```
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
$rampDownDelay = 6.9
```

(only reacts to CPU temp as of now)

# compatibility
if your asus laptop has a fan health test in the myasus app, this will probably work.

![image](https://github.com/Undervoltologist/asus-fan-curve-ps/assets/93976452/1cbdc530-a477-4210-991e-a4efed3daaed)
