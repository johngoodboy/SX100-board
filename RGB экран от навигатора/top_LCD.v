//Модуль для вывода трёх цветных полос на RGB экран.
module top_LCD(
    input				Clk		,
    input				Rst_n	,
    output  [7:0]       Lcd_r   ,
    output  [7:0]       Lcd_g   ,
    output  [7:0]       Lcd_b   ,
    output              Lcd_vsync,
    output              Lcd_hsync,
    output              Lcd_dclk,
    output              Lcd_disp,
    output              Lcd_de      
);

wire                clk_25m;
wire    [10:0]      pixel_x;
wire    [9:0]       pixel_y;
wire    [23:0]      rgb_data;            


/*pll	pll_inst (
	.areset ( ~rst_n ),
	.inclk0 ( clk ),
	.c0     ( clk_25m ),
	.locked ( locked_sig )
	);
*/
	
pll_for_LCD	pll_for_LCD_inst (
	.inclk0 ( Clk ),
	.c0 ( clk_25m  )
);

lcd_driver u_lcd_driver( 
    /* input				*/.clk		(clk_25m ),
    /* input				*/.rst_n    (Rst_n   ),
    /* input   [23:0]       */.rgb_data (rgb_data),
    /* output  [7:0]        */.lcd_r    (Lcd_r   ),
    /* output  [7:0]        */.lcd_g    (Lcd_g   ),
    /* output  [7:0]        */.lcd_b    (Lcd_b   ),
    /* output               */.lcd_vsync(Lcd_vsync),
    /* output               */.lcd_hsync(Lcd_hsync),
    /* output               */.lcd_dclk (Lcd_dclk),
    /* output               */.lcd_disp (Lcd_disp),
    /* output               */.lcd_de   (Lcd_de  ),
    /* output  [10:0]       */.pixel_x  (pixel_x ),
    /* output  [9:0]        */.pixel_y  (pixel_y )

);


lcd_show u_lcd_show(
    /* input                */.clk       (clk     ),
    /* input                */.rst_n     (rst_n   ),
    /* input   [10:0]       */.pixel_x   (pixel_x ),
    /* input   [9:0]        */.pixel_y   (pixel_y ), 
    /* output  [23:0]       */.rgb_data  (rgb_data)    
);
endmodule