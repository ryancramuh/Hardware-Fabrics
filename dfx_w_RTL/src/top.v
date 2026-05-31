`timescale 1ns/1ps
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