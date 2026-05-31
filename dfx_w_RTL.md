# How to do DFX with RTL design in Vivado 

*note: this will enable you to partially reconfigure your FPGA from Vivado* 

## Steps
 1. [Create a Project](#create-a-project) 
 2. [Enable Dynamic Function Exchange](#enable-dfx)
 3. [Create a Hierarchy with your HDL sources](#create-an-hdl-hierarchy) 
 4. [Create a Partition](#create-a-partition)
 5. [Add DFX Configurations](#add-your-other-dfx-configurations-other-modules) 
 6. [Add DFX Run Configuration](#add-dfx-configurations-to-project)

 7. [Generate Constraints](#generate-your-constraints) 
 
 8. [Synthesize then Draw DFX Pblock Region](#synthesize)

 8. [Generate Bitstreams](#generate-bitstream)  

## Sources 
 1. [LED Shift](#led-shift) 
 2. [LED Count](#led-count)
 3. [LED Passthrough](#led-passthrough) 
 4. [Top Level SSEG Controller + DFX](#top-level-sseg-controller--dfx) 
 5. [Hex2Sseg](#hex2sseg)
## Create A Project

 ### Choose Project Directory
 <img src="proj1.png" alt="Create Project Step 1" width="500"> 

 ### Choose RTL Project (Don't Specify Sources) 
 <img src="proj2.png" alt="Select RTL Project" width="800"> 

 ### Choose XC7A35TICPG236-1L as the part (for Basys 3) 
 <img src="choose_part.png" alt="Select Part" width="800"> 

 ### Correct Project Settings: 
 <img src="correct_project_settings.png" alt="Correct Project Settings" width="500"> 

## Enable DFX

### Go to Tools->Enable Dynamic Function eXchange 

<img src="enable_dfx.png" alt="Enable DFX" width="400"> 

### Convert your project to a DFX project 

<img src="convert_to_dfx.png" alt="Convert Project to DFX" width="600"> 

### Now we have the Configuration Window 

<img src="config_window.png" alt="Configuration Window" width="750"> 

## Create an HDL Hierarchy 

### Overview 
We now have to create our HDL sources. For this demo, our design will spec is a follows: 

 1. Top level controller increments the seven-segment display with a hex count every 1 second. 

 2. Reconfigurable Region will hold designs that will have the buttons and switches as inputs, and the LEDs as outputs 

Essentially, we want to create multiple designs with the same port declaration: 

```
module reconfig_modX(
    input clk,
    input rst,
    input [3:0] btn,
    input [15:0] sw,
    output [15:0] led
);
```

I opted to create my sources as follows: 

 1. [LED Shift](#led-shift) 
 2. [LED Count](#led-count)
 3. [LED Passthrough](#led-passthrough) 
 4. [Top Level SSEG Controller w DFX](#top-level-sseg-controller--dfx) 
 5. [Hex to Seven Segment Decoder](#hex2sseg) 

### Add or Create HDL Source 
<img src="create_hdl_source.png" alt="Create HDL Source" width="280"> 

<img src="create_design_source.png" alt="Add Sources" width="800"> 

### *Note: I recommend just using [my sources](#led-shift) if you're new* 

### Ensure top is set and your design is hierarchical 

<img src="hierarchy_of_sources.png" alt="Hierarchy of Sources" width=800> 

You should instantiate one of the reconfigurable modules in your top. Choose one.  

## Create a Partition 

### Right-Click your submodule you want as the reconfigurable interface and select "Create Partition Definition" 

<img src="create_partition.png" alt="Create a Parition" width=800> 

### *Note: Creating the partition loads the first reconfigurable module with the design instantiated in your top* 

### Name your Partition
 
#### I'd name it something like "Reconfig_Zone"

<img src="create_partition_def.png" alt="Create a Parition" width=400> 

#### You now have a DFX block to which you can add designs to. It appears with a yellow diamond next to it. It will have the same name as the instantiation in the top, so don't worry if it doesn't match your partition name

<img src="dfx_added.png" alt="DFX added" width=400> 

### Now navigate to Partition Definitions Tab in Sources Window 

<img src="select_pd.png" alt="select partition definition window" width=550> 

#### Click on Partition Definitions

#### You can now see that my partition definition "rcfg_block" has a configuration called led_count 

<img src="partition_def_window.png" alt="DFX added" width=550> 

## Add your other DFX configurations (other modules) 

#### Right-Click on your Parition Definition and select "Add Reconfigurable Module..." 

<img src="add_rcfg_mod.png" alt="DFX added" width=550> 

### You will now see the wizard to add reconfigurable modules. Go one at a time 

<img src="add_rcfg_mod_window.png" alt="DFX added" width=800> 

### Select "Add Files" and add one of your sources (add all the sub-sources too if it has sub-modules)

#### I choose led_passthrough because it doesn't have a configuration yet. It wouldn't make sense to select led_count, because it got a configuration when we created the partition ([see above](#click-on-partition-definitions))

<img src="add_passthrough_dfx.png" alt="select LED passthrough" width=700> 

#### I don't have to set a top since the LED Passthrough module is hierarchical 

### Set the Reconfigurable Module Name and click "Next"

<img src="add_passthrough_dfx2.png" alt="add LED Passthrough to DFX" width=700> 

### Now we have two configurations in our partition

<img src="two_dfx_configs_added.png" alt="two configs added to DFX" width=700> 

### Repeat the above for the last module (or more if you made more than 3) 

<img src="add_3rd_dfx.png" alt="add 3rd config to DFX" width=700> 

<img src="dfx3_window.png" alt="Add LED Shift" width=700> 

### Now we have all three designs added to our partition 

<img src="three_dfx_added.png" alt="Three DFX added to Partition" width=400>

## Add DFX configurations to project

###  way we don't have to manually synthesize and implement each configuration 

<img src="add_configurations.png" alt="Go to Window->Configurations" width=400>

### This will pull up the Configurations tab where we can add "child" runs

#### Child Run = synthesis and implementation will be inhereted from another run 

### Select the blue "Dynamic Function eXchange Wizard" text 

<img src="configurations_window.png" alt="Configuration Window" width=800>

### The DFX Wizard will appear. Click "automatically create configurations" 

<img src="dfx_wizard1.png" alt="DFX Wizard" width=800>

### The configurations will appear after you click "automatically create configurations". 

<img src="dfx_wizard2.png" alt="DFX Wizard" width=800> 

### Then hit "Next" and click "automatically create configuration runs"  

<img src="config_run_window.png" alt="Edit Configurations" > 

### You should see something similar  the following: 

<img src="auto_config_runs_setup.png" alt="Edit Configurations" >

### If everything worked, you will have as many configurations as you added to your Partition 

<img src="configs_done.png" alt="Edit Configurations" > 

## Generate Your Constraints 

### [Premade Constraints Can be Found Here](basys3_basic.xdc) 

### Make sure your XDC is added to your project 
<img src="xdc_added.png" alt="XDC added" width=800> 

## Synthesize 

### Click "Run Synthesis" 

#### Ensure your top is set correctly 

<img src="run_synthesis.png" alt="XDC added" width=350> 

#### Just use however many threads (I use 16) 

<img src="synth_window.png" alt="XDC added" width=550> 

### You can watch Synthesis from Design Runs Tab

<img src="watch_synth.png" alt="watch synthesis in design runs" width=800 > 

### Once Synthesis completes, select "Open Synthesized Design"

<img src="open_synth.png" alt="watch synthesis in design runs" width=400 > 

### Find the reconfigurable module in the "Netlist" tab of your synthesized design 

<img src="find_netlist_in_design.png" alt="watch synthesis in design runs" width=800 > 

### Right-click and select Floorplanning->Draw & Create Pblock 

<img src="draw_pblock.png" alt="watch synthesis in design runs" width=800 > 

### Define your Pblock with enough resources (if you don't you will just have to go back and redraw the pblock to be bigger before implementation)

<img src="pblock_area.png" alt="watch synthesis in design runs" width=800 > 

### Once you've selected an area, the Pblock wizard comes up 

<img src="pblock_def.png" alt="watch synthesis in design runs" width=600 > 

### Now your design will be unsaved. You will have to save it, which will add the pblock definitions to the XDC. 

<img src="checkbox.png" alt="watch synthesis in design runs" width=500 > 

### Select which XDC to add the Pblock to:  

<img src="select_xdc.png" alt="watch synthesis in design runs" width=800 > 

### Go to your XDC to ensure the pblock was added to the bottom: 


<img src="updated_xdc.png" alt="watch synthesis in design runs" width=800 > 

## Generate Bitstream 

<img src="gen_bit.png" alt="watch synthesis in design runs" width=400 > 

<img src="gen_bit2.png" alt="watch synthesis in design runs" width=550 > 

#### If you are lucky, your pblock was drawn on a proper boundary. If not, you will get an error telling you to set the SNAPPING_MODE property to ON 

### To avoid SNAPPING_MODE error, add the following to your XDC:

```tcl
set_property SNAPPING_MODE ON [get_pblocks pblock_rcfg_mod]
```
#### Once Bitstream Generation is finished, you will have multiple implementations you can open. You will have one main run and a number of children for each separate configuration 

<img src="impl_designs.png" alt="Bitstream done" width=450> 

### Open the Hardware Manager 

<img src="open_hw_manager.png" alt="Open Hardware Manager" width=450>

### Plug in the Basys 3

<img src="basys_plugged_in.png" alt="Basys 3 Plugged In" width=600>

### Open Target -> Auto Connect 

<img src="auto_open_target.png" alt="Auto Open the Target" width=500> 

### Once connected, program the device 

<img src="program_device.png" alt="Program device" width=500> 

### From the program device wizard, select a top bitstream. 

#### Every configuration has a main and a partial, just choose the main (it will be named the same as your top module)


<img src="program_device_wizard.png" alt="Program device" width=650> 

### Of these runs, choose a Top bitstream: 

<img src="runs.png" alt="Runs" width=300> 

<img src="impl1_top_bit.png" alt="Runs" width=300> 

<img src="child_impl0_top_bit.png" alt="Runs" width=300> 

<img src="child_impl1_top_bit.png" alt="Runs" width=300>

### Now with a top level bitsream selected, program the FPGA 

<img src="top_bit_selected.png" alt="Runs" width=800>

## Watch the counter increment on the board every 1 second: 

<img src="counter_running.png" alt="Runs" width=800>

### Reflash partial bitstreams and observe that the counter continues to increment, yet flashing a partial bitstream changes the LED functionality

<img src="flash_partial.png" alt="Flash partial" width=400>



### LED Shift 

```verilog
module led_shift(
    input wire clk,
    input wire rst,
    input wire [3:0] btn,
    input wire [15:0] sw,
    output reg [15:0] led
    );
    
    reg [31:0] cntr;
    wire en = (cntr >= 32'd33333333);
    
    always@(posedge clk)
        if(rst)
            cntr <= 32'd0;
        else if(en)
            cntr <= 32'd0;
        else 
            cntr <= cntr + 1;
            
    always@(posedge clk)
        if(rst)
            led <= 16'd0;
        else if(btn[0] && en)
            led <= (led == 16'd0) ? ({1'b1, led[15:1]}) : (led >> 1);
        else if(btn[1] && en)
            led <= (led == 16'd0) ? ({led[14:0], 1'b1}) : (led << 1);
            
endmodule
```

### LED Count
```verilog
module led_count(
    input wire clk,
    input wire rst,
    input wire [3:0] btn,
    input wire [15:0] sw,
    output reg [15:0] led
    );
    
    reg [28:0] cntr;
    reg [28:0] max_cnt;
    
    always@(posedge clk)
        if(rst)
            cntr <= 27'd0;
        else if(cntr >= max_cnt)
            cntr <= 27'd0;
        else
            cntr <= cntr + 1;
            
    always@(posedge clk)
        if(rst)
            max_cnt <= 27'd100000000;
        else if(btn[0])
            max_cnt <= max_cnt - 1;
        else if(btn[1])
            max_cnt <= max_cnt + 1; 
            
    always@(posedge clk)
        if(rst)
            led <= 16'd0;
        else if(cntr >= max_cnt)
            led 
```

### LED Passthrough 
```verilog
module led_passthrough(
    input wire clk,
    input wire rst,
    input wire [3:0] btn,
    input wire [15:0] sw,
    output reg [15:0] led
    );
    
    always@(posedge clk)
        if(rst)
            led <= 0;
        else
            led <= {sw[11:0],btn};
endmodule
``` 

### Top Level SSEG Controller + DFX

```verilog
module top(
    input wire clk,
    input wire rst,
    input wire [3:0] btn,
    input wire [15:0] sw,
    output wire [15:0] led,
    output reg [3:0] sseg_an,
    output wire [6:0] sseg_disp
    );
    
    reg [26:0] cntr;
    
    wire incr_tick;
    reg [15:0] tick;
    
    reg [19:0] seg_cntr;
    reg [1:0] curr_an;
    wire next_seg;
    
    reg [3:0] hex_in;
    wire [3:0] seg_out;
    
    assign incr_tick = (cntr >= 27'd100000000);
    assign next_seg = (seg_cntr >= 19'd416666);
    
    always@(posedge clk)
        if(rst)
            curr_an <= 0;
        else if(next_seg)
            curr_an <= curr_an + 1;
    
    always@(*) begin
        case(curr_an)
            2'b00: begin
                sseg_an = 4'hE;
                hex_in = tick[3:0];
            end
            2'b01: begin
                sseg_an = 4'hD;
                hex_in = tick[7:4];
            end
            2'b10: begin 
                sseg_an = 4'hB;
                hex_in = tick[11:8];
            end
            2'b11: begin
                sseg_an = 4'h7;
                hex_in = tick[15:12];
            end
        endcase
    end
   
    always@(posedge clk)
        if(rst)
            cntr <= 0;
        else if(incr_tick)
            cntr <= 0;
        else 
            cntr <= cntr + 1;
            
    always@(posedge clk)
        if(rst)
            seg_cntr <= 0;
        else if(next_seg)
            seg_cntr <= 0;
        else 
            seg_cntr <= seg_cntr + 1;
            
    always@(posedge clk)
        if(rst)
            tick <= 0;
        else if(incr_tick)
            tick <= tick + 1;
            
    hex2sseg sseg_dcdr(
        .hex(hex_in),
        .seg(sseg_disp)
    );
    
    rm0 rcfg_mod(
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .sw(sw),
        .led(led)
    );
    
    
    
endmodule

```

### Hex2Sseg

``` verilog 
module hex2sseg(
    input wire [3:0] hex,
    output reg [6:0] seg
    );
    
    always@(*) begin
        case(hex)
            4'h0: seg = 7'b1000000;
            4'h1: seg = 7'b1111001;
            4'h2: seg = 7'b0100100;
            4'h3: seg = 7'b0110000;
            4'h4: seg = 7'b0011001;
            4'h5: seg = 7'b0010010;
            4'h6: seg = 7'b0000010;
            4'h7: seg = 7'b1111000;
            4'h8: seg = 7'b0000000;
            4'h9: seg = 7'b0010000;
            4'hA: seg = 7'b0001000;
            4'hB: seg = 7'b0000011;
            4'hC: seg = 7'b1000110;
            4'hD: seg = 7'b0100001;
            4'hE: seg = 7'b0000110;
            4'hF: seg = 7'b0001110;
        endcase
    end
endmodule
``` 

