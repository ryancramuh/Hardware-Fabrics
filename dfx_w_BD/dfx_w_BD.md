# How to do DFX with a Block Design Project in Vivado 

## Steps
 1. [Create a Project](#create-a-project)

 2. [Enable Dynamic Function Exchange](#enable-dfx)

 3. [Add Sources](#add-sources)

 4. [Create a Block Design](#create-a-block-design) 

 5. [Create a Block Design Heirarchy](#create-a-block-design-heirarchy) 

 6. [Add DFX Configurations](#add-dfx-configurations) 
 7. [Add DFX Run Configurations](#add-dfx-run-configurations)

 8. [Create HDL Wrapper and Generate Output Products](#create-hdl-wrapper-and-generate-output-products) 
 
 9. [Synthesize then Draw DFX Pblock Region](#synthesize)

 10. [Generate Bitstream](#generate-bitstream) 

 11. [Flash the board](#flash-the-board) 

## Sources 
 1. [LED Shift](src/led_shift.v) 
 2. [LED Count](src/led_count.v)
 3. [LED Passthrough](src/led_passthrough.v) 
 4. [Top Level SSEG Controller + DFX](src/sseg_hex_cntr.v) 
 5. [Hex2Sseg](src/hex2sseg.v) 

## Create a Project 

### Select "Create Project" after opening Vivado
<img src="img/proj1.png" alt="" width=400>

### Name your project 
<img src="img/proj2.png" alt="" width=800>

### Select RTL Project
<img src="img/proj3.png" alt="" width=800>

### Select Basys 3 from the *Boards* tab (don't select a parts)
<img src="img/proj4.png" alt="" width=800>

### The final project settings should look like this: 
<img src="img/proj5.png" alt="" width=600>

### Once your project is created view the "Project Summary" window to ensure you have the Basys 3 part selected.
<img src="img/proj6.png" alt="" width=400> 

## Enable DFX 

### Go to Tools->Enable Dynamic Function eXchange 

<img src="img/enable_dfx.png" alt="Enable DFX" width="400"> 

### Convert your project to a DFX project 

<img src="img/convert_to_dfx.png" alt="Convert Project to DFX" width="600"> 

## Add Sources 

### Add all the [rtl sources](#sources) 

<img src="img/add_source1.png" alt="Add source pt 1" width=500> 

<img src="img/add_source2.png" alt="Add source pt 1" width=500>

## Create a Block Design 

### Click "Create Block Design" under Flow Navigator 
<img src="img/bd_setup1.png" alt="" width=400> 

### Name your Block Design 
<img src="img/bd_setup2.png" alt="" width=400>

### Vivado should now pull up the block desing window. You should see something like this:
<img src="img/bd_setup3.png" alt="" width=800>

### Click Add IP 
<img src="img/bd1.png" alt="" width=800> 

### Add a Clock Wizard IP
<img src="img/bd2.png" alt="" width=800>

### Click "run connection automation" in the green banner. This will create external ports (that you won't add to your constraints file)
<img src="img/bd3.png" alt="" width=800>

### In the connection automation window, click on the clk_in1 port to see what the Board Interface is. It should be sys_clock (System Clock). That is the 100Mhz clock
<img src="img/bd4.png" alt="" width=800>

### In the connection automation window, click on the reset port to see what the Board Interface is. It should be reset (BTNC). That is the center button of the 5 Basys 3 buttons. 

<img src="img/bd5.png" alt="" width=800>

### Select all automation and continue 
<img src="img/bd6.png" alt="" width=800>

### Now you will have external sys_clock and reset ports (which Vivado internally manages as constraints)
<img src="img/bd7.png" alt="" width=500>

### Now add a Processor System Reset IP (this synchronizes the button reset to our clock)
<img src="img/bd9.png" alt="" width=800>

### If you look, the external reset is active low
<img src="img/bd10.png" alt="" width=800>

### You cannot change it
<img src="img/bd10_2.png" alt="" width=700>

### Run connection automation and select  all automation 
<img src="img/bd10_3.png" alt="" width=500>

### Now validate your design and the external reset port becomes active high
<img src="img/bd11.png" alt="" width=800>

### (note the demo will appear out of sync based on the pictures but don't worry, just follow along)

### Right click and Create an External Port for your buttons 

<img src="img/bd13.png" alt="" width=400>

### Define the "btn" port as a 4 bit input 


<img src="img/create_port_btn.png" alt="" width=600>

### Now add the next port once btn[3:0] is created

<img src="img/create_port_next1.png" alt="" width=400>

### Define the "sw" port as a 16 bit input 


<img src="img/create_port_sw.png" alt="" width=600>

### Now add the next port once sw[15:0] is created

<img src="img/create_port_next2.png" alt="" width=400>

### Define the "led" port as a 16 bit output 


<img src="img/create_port_led.png" alt="" width=600>

### Now do the same for the seven segment outputs

<img src="img/create_port_next3.png" alt="" width=400>

### For the 7 bit SSEG display output
<img src="img/create_port_sseg_disp.png" alt="" width=600>

<img src="img/create_port_next4.png" alt="" width=400>

### and the 4 bit SSEG anode output 
<img src="img/create_port_sseg_an.png" alt="" width=600>

### Now it should look like this (with your processor system reset too )

<img src="img/create_ports_done.png" alt="" width=600>

### Ignoring the out-of-sync diagram, right-click and "Add Module" 

<img src="img/add_mod1.png" alt="" width=400>

### Now add the sseg_hex_cntr.v module to the block design (only .v/.vhd can be added)
<img src="img/add_mod1_sseg_cntr.png" alt="" width=500>

### The RTL source will have a circle that says RTL letting you know that it was HDL that was written. 

### Click on the ports and drag to other modules ports to connects 

### Connect the peripheral reset (not aresetn) to the rst port of the sseg_hex_cntr 
<img src="img/conn_1.png" alt="" width=800>

### Connect the clock wizard clock to the sseg_hex_cntr clk port 

<img src="img/conn_2.png" alt="" width=800>

## Create a Block Design Heirarchy 
<img src="img/dfx1.png" alt="" width=400>

### Name your block design heirarchy
<img src="img/dfx2.png" alt="" width=400>

### You block design heirarchy will appear as a dark blue box 
<img src="img/dfx3.png" alt="" width=800>

### Add one of the LED modules (reconfigurable modules) and drag it into the hierarchy 
<img src="img/dfx4.png" alt="" width=800>

### Drag the module into the hierarchy
<img src="img/rcf1.png" alt="" width=800>

### Now it should look like this: 
<img src="img/rcf2.png" alt="" width=800>

### The reset is active low by default, so you will have to change that
<img src="img/rcf3.png" alt="" width=500>
<img src="img/fix_rst_active_high.png" alt="" width=600> 

### Now connect your module, right click it, and select "Create a Block Design Container" 
<img src="img/dfx8.png" alt="" width=800>

### Name your block design container the same as what you want your first reconfigurable module to be 

<img src="img/dfx9.png" alt="" width=800> 

### You will now see the heirarchy symbol appear, confirming your design is a Block Design Container 

<img src="img/dfx10.png" alt="" width=800>

### Double click on the block design container: configure it as a DFX block and freeze the interface. 
<img src="img/dfx11.png" alt="" width=800>

### After, your heirarchy should have the DFX logo, confirming it is now recognized as a DFX block 
<img src="img/dfx12_setup_done.png" alt="" width=400>

## Add DFX Configurations

### Right click on your DFX Heirarchy to "create reconfigurable module". This will allow you to add configuration 
<img src="img/dfx13.png" alt="" width=600>

### Vivado will complain and say block design is not in a validated state, so validate and try again
<img src="img/dfx14.png" alt="" width=600>

### Now name the next reconfigurable module and proceed
<img src="img/dfx15.png" alt="" width=600>

### This will create a new empty block design with the external ports already defined
<img src="img/dfx16.png" alt="" width=600>

### Add one of the LED modules to the new block design 
<img src="img/dfx17.png" alt="" width=500>

### Select one of the LED modules in the window 
<img src="img/dfx18.png" alt="" width=500>

### Now connect it
<img src="img/dfx19.png" alt="" width=500>
<img src="img/dfx20.png" alt="" width=500>

### Finally, validate the inner block design

### Then go validate the main block design. 

### Then add as many configurations as you want
<img src="img/dfx22.png" alt="" width=500>

<img src="img/dfx23.png" alt="" width=600>

### Don't forget to validate your block designs before adding a new configuration 
<img src="img/dfx24.png" alt="" width=600>

### If you didn't add the processor system reset, you will get this error: 

<img src="img/err2.png" alt="" width=600>

### If everything went smoothly, you should see this: 

<img src="img/dfx_validation_successful.png" alt="" width=600>

## Add DFX Run Configurations 

### Start by going to Window->Configurations 

<img src="img/dfx_config_wiz_0.png" alt="" width=400>

### Then launch the "Dynamic Function eXchange Wizard" by clicking the blue text in the "Configurations" window 
<img src="img/dfx_config_wiz0_1.png" alt="" width=800>

### You will be greeted by the DFX Wizard 

<img src="img/dfx_config_wiz1.png" alt="" width=800>

### Select "automatically create configurations" 
<img src="img/dfx_config_wiz2.png" alt="" width=800>

### Then you will have to select "automatically create configuration runs"  
<img src="img/dfx_config_wiz3.png" alt="" width=800>

### It will autopopulate "child" runs. AKA runs that inherit most of the implementation from another run. 

### Select "automatically create configurations" 
<img src="img/dfx_config_wiz4.png" alt="" width=800>

### If everything went smoothly, you will see three configurations added 
<img src="img/dfx_config_wiz5.png" alt="" width=800>

## Create HDL Wrapper and Generate Output Products 

### You have to generate output products for your design and create a top level wrapper before you can synthesize 

### Create an HDL Wrapper by right-clicking on your block design and selecting "Create HDL Wrapper" 
<img src="img/output1.png" alt="" width=600>

### Let Vivado manage the wrapper (trust me)
<img src="img/output2.png" alt="" width=600>

### Now right click and select generate output products for your block design 
<img src="img/output3.png" alt="" width=600>

### I recommend using 4 threads if you're on a laptop (it is less likely to crash)
<img src="img/output4.png" alt="" width=500>

### It will notify you that "Out-of-context module runs were launched" and you will see "Running multiple block runs" in the top right corner 
<img src="img/output5.png" alt="" width=500>

### Once you are done, you can proceed to generate your constraints and launch synthesis

## Synthesize 

### Now that you've added DFX configurations and finished your block design, it's time to synthesize 

### Add the constraints 
<img src="img/constr1.png" alt="" width=600>
<img src="img/constr2.png" alt="" width=700>

### You should see the constraints in your design sources now 

<img src="img/constr3.png" alt="" width=700>

### Click "Run Synthesis" 
<img src="img/synth1.png" alt="" width=300>

### Proceed with default settings (16 threads recommended) 
<img src="img/synth2.png" alt="" width=500>

### You should see the modules completing in the Design Runs Window 
<img src="img/synth3.png" alt="" width=600>

### Once synthesis has finished, "Open Synthesized Design" 
<img src="img/open_synth.png" alt="" width=350>

### In the Device View, find your "Netlist" tab and find your block design 
<img src="img/synth4.png" alt="" width=800> 

### Now find your Block Design Heirarchy in the netlist heirarchy 
<img src="img/synth5.png" alt="" width=500> 

### Right click the reconfigurable hierarchy and select Floorplanning->Draw & Create Pblock 
<img src="img/synth6.png" alt="" width=500> 

### Draw a pblock region appropriate for the design (the area I drew in the picture is probably too generous)

### (think in terms of 1 slice per 4 flip-flops in your design) 

<img src="img/synth7.png" alt="" width=800> 

### You will now have a pblock where your DFX modules will be placed 

<img src="img/synth8.png" alt="" width=600> 

### Press Ctrl+S to save, which will bring up this window. It will warn you that your Synthesis is out of date. Click ok. 
<img src="img/synth9.png" alt="" width=500> 

### It will then ask where you want to save the new Pblock constraints. Put them in your constraints you made. 
<img src="img/synth10.png" alt="" width=800> 

### You will now see a checkbox on the reconfigurable module, designating it's been marked as "placed" (even though we haven't ran Implementation with Place & Route) since you manually placed it. 
<img src="img/synth11.png" alt="" width=500> 

### Your constraints will need to be reloaded to see the changes (the changes will appear at the bottom)
<img src="img/synth12.png" alt="" width=500> 

### The changes will define a new pblock region as seen below: 
<img src="img/synth13.png" alt="" width=800> 

### To avoid SNAPPING_MODE error, add the following to your XDC:

```tcl
set_property SNAPPING_MODE ON [get_pblocks pblock_rcfg_mod]
```

<img src="img/synth14.png" alt="" width=800> 

## Generate Bitstream 

### Once you have your pblock configured, run generate bitstream. 
<img src="img/bit1.png" alt="" width=300> 

### You can launch runs with 16 threads

<img src="img/bit2.png" alt="" width=600> 

### You can watch the runs (and child runs) occur from the "Design Runs" tab

<img src="img/bit3.png" alt="" width=800> 

### You should slowly see the bistreams complete 
<img src="img/bit4.png" alt="" width=800> 

### If you get errors generating the bitstream, make sure all the input ports are constrained on your modules

<img src="img/err1.png" alt="" width=800> 

### If you don't make it through implementation, you either forgot to add SNAPPING_MODE to your constraints, or it's because the pblock is too small

## Flash the board 

### Plug in the Basys 3

<img src="img/basys3_plugged.png" alt="" width=300> 

### Open hardware manager, connect to target, and program board (a full bitstream will be selected by default)
<img src="img/flash1.png" alt="" width=800> 

### You can either choose a full bitstream or a partial bitstream. The full bistreams will have the same name as your top level block design. The partials will have the reconfigurable module block design name and "partial" in its name 

### Each DFX configuration run's implementation folder will have the full and partial bitstreams

<img src="img/flash2.png" alt="" width=800> 

### Now try flashing the partials 
<img src="img/flash3.png" alt="" width=800> 

<img src="img/flash4.png" alt="" width=800> 

### *Note: All the partials will be in the main implementation or child implementation under PROJECT/PROJECT.runs/impl_X*

### Watch the counter tick up while you reflash the partials. The counter won't reset

<img src="img/basys3_plugged.png" alt="" width=300> 