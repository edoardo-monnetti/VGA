//
// Module generating the images to send to the VGA monitor
//


`timescale 10 ns / 1 ns


module RGB_signal (

       input clk_25,
       input active_pixel,
       input [9:0] x_count,
       input [9:0] y_count,
       
       output reg [3:0] vga_r,
       output reg [3:0] vga_g,
       output reg [3:0] vga_b
);

     reg q_draw; 
          
    always @(posedge clk_25) begin
        q_draw = ((x_count <  32 ) && (y_count < 32 )) ? 1'b1 : 1'b0;
        if (!active_pixel) begin
            vga_r <= 4'h0;
            vga_g <= 4'h0;
            vga_b <= 4'h0;
        end
        else begin
            vga_r <= q_draw ? 4'hF : 4'h0;
            vga_g <= 4'h8;
            vga_b <= q_draw ? 4'h0 : 4'hF;
        end
    end          


endmodule
