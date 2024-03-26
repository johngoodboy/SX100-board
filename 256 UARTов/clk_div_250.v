module clk_div_250( 
   input clk_in, 
	output reg clk_out
); 
 
//Инвертируем состояние выхода дважды за период. ПОлучается частотаниже в 2 раза. ПОэтому 250/2=125
parameter MODULE = 125;

reg [7:0]count = 1'b0; //счетчик

always @(posedge clk_in) 
begin 
	if(count==MODULE-1)
		begin
			count <= 0; //обнуляем счетчик
			clk_out <= ~clk_out; //Инвертируем состояние выхода
		end
    else 
       count <= count + 1'b1; //увеличиваем счетчик 
end 
endmodule 
