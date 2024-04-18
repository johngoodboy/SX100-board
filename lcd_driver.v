module lcd_driver( 
    input clk,//Входной синхросигнал
    input rst_n,//Сброс
    input [23:0] rgb_data,//Входные данные цвета
	 
	 //Интерфейс экрана
    output [7:0] lcd_r,
    output [7:0] lcd_g,
    output [7:0] lcd_b,
    output lcd_vsync,
    output lcd_hsync,
    output lcd_dclk,
    output lcd_disp,
    output lcd_de,
	 //Текущие координаты точки (для рисовалок)
    output [10:0] pixel_x,
    output [9:0] pixel_y 
);								 

//По вертикали
parameter   V_SYNC      = 4, //Ширина импульса 
            V_BKPORCH   = 12    ,//Пауза до
            V_DISPLAY   = 272   ,//Активная высота (из разрешения) кадра
            V_FTPORCH   = 8    ,//Пауза после
            V_ALL       = V_SYNC + V_BKPORCH + V_DISPLAY + V_FTPORCH;//Полный период
//По горизонтали
parameter   H_SYNC      = 4    ,//Ширина импульса 
            H_BKPORCH   = 43    ,//Пауза до
            H_DISPLAY   = 480   ,//Активная ширина (из разрешения) кадра
            H_FTPORCH   = 8    ,//Пауза после
            H_ALL       = H_SYNC + H_BKPORCH + H_DISPLAY + H_FTPORCH;//Полный период  

 // Field frame length counter ?Счётчик для импульсов по вертикали
reg [10:0] cnt_v;
wire add_cnt_v;
wire end_cnt_v;

 // row frame length counter ?Счётчик для импульсов по горизонтали
reg [10:0] cnt_h;//Для моего разрешения хватит и 9 бит, а не 11
wire       add_cnt_h;//Зачем эта переменная, если она всегда=1? Видимо, для одинаковости кода для v и h и лёгкого понимания
wire       end_cnt_h;//Если досчитали до конца

//Счётчик для импульсов по горизонтали 
always @(posedge clk or negedge rst_n)begin 
   if(!rst_n)begin
        cnt_h <= 0;//Сброс
    end 
    else if(add_cnt_h)begin 
            if(end_cnt_h)begin//Если досчитали до конца
                cnt_h <= 0;//Сброс
            end
            else begin 
                cnt_h <= cnt_h + 1;//Иначе считаем дальше
            end 
    end
   else  begin
       cnt_h <= cnt_h;
    end
end 

assign add_cnt_h = 1'b1;
assign end_cnt_h = add_cnt_h && cnt_h == H_ALL - 1;//Достигли конца строки?  

// Счётчик для импульсов по вертикали
always @(posedge clk or negedge rst_n)begin 
   if(!rst_n)begin
        cnt_v <= 0;//Сброс
    end 
    else if(add_cnt_v)begin//Прибавляем 1, если отсчитали целую строку. Т е считаем целые строки 
            if(end_cnt_v)begin //Если досчитали до конца
                cnt_v <= 0;//Сброс
            end
            else begin 
                cnt_v <= cnt_v + 1;//Иначе считаем дальше
            end 
    end
   else  begin
       cnt_v <= cnt_v;
    end
end 

assign add_cnt_v = end_cnt_h;//Прибавляем 1, если отсчитали целую строку. Т е считаем целые строки
assign end_cnt_v = add_cnt_v && cnt_v == V_ALL - 1;//Достигли конца кадра?

 // Формируем Vsync нужной длительности (меньше или равно), (активный низкий уровень)
assign lcd_vsync = (cnt_v <= V_SYNC - 1)?1'b0:1'b1;

 //  Формируем Hsync нужной длительности (меньше или равно), (активный низкий уровень)
assign lcd_hsync = (cnt_h <= H_SYNC - 1)?1'b0:1'b1;

 // LCD_DE display valid
assign lcd_de = (((cnt_v >= V_SYNC + V_BKPORCH - 1) && (cnt_v <= V_SYNC + V_BKPORCH + V_DISPLAY - 1)) && ((cnt_h >= H_SYNC + H_BKPORCH - 1) && (cnt_h <= H_SYNC + H_BKPORCH + H_DISPLAY - 1)))?1'b1:1'b0;

//Если de активен, передаём данные цветов
assign lcd_r = (lcd_de)?rgb_data[7:0]:0;
assign lcd_g = (lcd_de)?rgb_data[15:8]:0;
assign lcd_b = (lcd_de)?rgb_data[23:16]:0;

 // Если de активен, передаём текущие координаты точек
 
assign pixel_y = (lcd_de)?(cnt_v - (V_SYNC + V_BKPORCH)):0;
assign pixel_x = (lcd_de)?(cnt_h - (H_SYNC + H_BKPORCH)):0;

 // Тактовый сигнал
assign lcd_dclk = clk;

 // Normal display high level Это сигнал Disp_ON?
assign lcd_disp = 1'b1;

endmodule