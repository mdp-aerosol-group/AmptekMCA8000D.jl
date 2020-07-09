# AmptekMCA8000D.jl

A julia package to communicate with the MCA8000D device. The package wraps the python code written by Henning Fo (https://github.com/HenningFo/mca8000d). The code was modifed to be compatible with python3. Specifically python3 enforces encoding of str/bytearray conversions, which was fixed in a few places. 

Author: Markus Petters
        Department of Marine, Earth, and Atmospheric Sciences
        NC State University
        mdpetter@ncsu.edu

## Installation

```julia
pkg> add https://github.com/mdpetters/AmptekMCA8000D.jl.git
```

To allow any user access to the mca8000d device, copy the file ```mca8000d.rules``` to ```/etc/udev/rules.d```

You have to reload the rules after you copied the file to have any effect. You also could restart the computer, after reboot the rules will take effect too. 

You need to install the python-usb library (pip install pyusb) with the python distribution invoked by PyCall.jl

## Example usage

```julia
using AmptekMCA8000D                 # Load the module
using Gadfly                         # For plotting

mca8000d = device()                  # Open the device

status=mca8000d.reqStatus()          # Read the configuration
printStatus(status)                  # Print status

config=mca8000d.reqHWConfig()        # Read hardware config
display(config)                      # Lists current hardware settings

mca8000d.sendCmdConfig("PRER=1;")    # Send configuration to device (time = 1s)
config=mca8000d.reqHWConfig()        # Verify new setting
display(config)                       

mca8000d.enable_MCA_MCS()            # Start 
s = mca8000d.spectrum(true,true)     # Sample spectrum

display(s[1])                        # Acquired spectrum
mca8000d.disable_MCA_MCS()           # Turn off

# Example 5 Hz spectrum acquisition
mca8000d.sendCmdConfig("PRER=OFF;")  
mca8000d.enable_MCA_MCS()            
for i = 1:10
    s = mca8000d.spectrum(true,true)  
    p = plot(y=s[1], Geom.line)
    display(p)
    sleep(0.2)
end
mca8000d.disable_MCA_MCS() 
```

This is a list of config parameters

```py
configParameters = {"RESC" : "Reset Configuration",\
                    "PURE" : "PUR Interval on/off",\
                    "MCAS" : "MCA Source",\
                    "MCAC" : "MCA/MCS Channels",\
                    "SOFF" : "Set Spectrum Offset",\
                    "GAIA" : "Analog Gain Index",\
                    "PDMD" : "Peak Detect Mode (min/max)",\
                    "THSL" : "Slow Threshold",\
                    "TLLD" : "LLD Threshold",\
                    "GATE" : "Gate Control",\
                    "AUO1" : "AUX OUT Selection",\
                    "PRER" : "Preset Real Time",\
                    "PREL" : "Preset Life Time",\
                    "PREC" : "Preset Counts",\
                    "PRCL" : "Preset Counts Low Threshold",\
                    "PRCH" : "Preset Counts High Threshold",\
                    "SCOE" : "Scope Trigger Edge",\
                    "SCOT" : "Scope Trigger Position",\
                    "SCOG" : "Digital Scope Gain",\
                    "MCSL" : "MCS Low Threshold",\
                    "MCSH" : "MCS High Threshold",\
                    "MCST" : "MCS Timebase",\
                    "AUO2" : "AUX OUT 2 Selection",\
                    "GPED" : "G.P.Counter Edge",\
                    "GPIN" : "G.P. Counter Input",\
                    "GPME" : "G.P. Counter Uses MCA_EN",\
                    "GPGA" : "G.P. Counter Uses Gate",\
                    "GPMC" : "G.P. Counter Cleared With MCA",\
                    "MCAE" : "MCA/MCS Enable",\
                    "TPEA" : "peaking time",\
                    "TFLA" : "Flat Top Width",\
                    "TPFA" : "Fast channel peaking time",\
                    "AINP" : "Analog input pos/neg"}
```
