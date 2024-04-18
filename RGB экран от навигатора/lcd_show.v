module lcd_show(
    input               clk,
    input               rst_n,
    input   [10:0]      pixel_x,
    input   [9:0]       pixel_y, 
    output  [23:0]      rgb_data    
);      

 // разрешение LCD
parameter   H_DISPLAY = 480,
            V_DISPLAY = 272;

//Коды цветов
parameter   RED     = 24'b11111111_00000000_00000000,
            GREEN   = 24'b00000000_11111111_00000000,
            BLUE    = 24'b00000000_00000000_11111111,
            BLACK   = 24'b00000000_00000000_00000000;

 // хранилище RGB данных
reg     [23:0]      rgb_data_r;
//Рисуем 3 полоски R-G-B
always @(posedge clk or negedge rst_n)begin 
    if(!rst_n)begin
        rgb_data_r <= BLACK;
    end 
    else if((pixel_x >= 0) && (pixel_x < H_DISPLAY/3))begin 
        rgb_data_r <= RED;
    end 
    else if((pixel_x >= H_DISPLAY/3) && (pixel_x < H_DISPLAY/3*2))begin 
        rgb_data_r <= GREEN;
    end 
    else begin
        rgb_data_r <= BLUE;
    end
end

assign rgb_data = rgb_data_r;

endmodule