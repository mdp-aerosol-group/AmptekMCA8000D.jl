using MCA8000d                       # Load the module
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

# Example 0.2 Hz spectrum acquisition
mca8000d.sendCmdConfig("PRER=OFF;")  
mca8000d.enable_MCA_MCS()            
for i = 1:10
    s = mca8000d.spectrum(true,true)  
    p = plot(y=s[1], Geom.line)
    display(p)
    sleep(0.2)
end
mca8000d.disable_MCA_MCS()         
