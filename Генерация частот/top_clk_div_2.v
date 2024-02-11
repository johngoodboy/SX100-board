module main_clk_div_2//Установим 22 шт делителя  на 2
(
	input CLK_IN,
	output [21:0]CLK_OUT//Шина 22-ух выходов поделенной частоты
);

clk_div_2 clk_div_2_0(//Первый счётчик-делитель на 2
	.clk_in(CLK_IN),
	.clk_out(CLK_OUT[0])
 );
 
//Далее создаём ещё 21 экземпляр счётчиков
genvar n;//Счётчик для цикла
generate
for(n = 1; n < 22; n = n + 1 )
begin : clk_div_2_generation
//имя экземпляра не имеет значения в дальнейшем
  clk_div_2 clk_div_2_insts
  (
   .clk_in(CLK_OUT[n-1]),//На вход подаём выход с прошлого делителя
   .clk_out(CLK_OUT[n]) //
  );
end
endgenerate
endmodule
