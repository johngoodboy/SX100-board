//Модуль создания сотен Юартов. В данном случае будет 255.
module top_100s_of_UARTs(
    input CLK_IN,
	 output CLK_100k,//Выведем сигнал, чтобы проверить осциллографом
    output [255:0]UART_OUT//Шина 255-ти выходов UART      
);

wire                clk_100k;//Выход частоты 100 кГц

clk_div_250 clk_div_250_0(//Счётчик-делитель на 250
	.clk_in(CLK_IN),
	.clk_out(clk_100k)
);

//Далее создаём 255 экземпляров UART передатчика (cycled_uart_transmitter)
genvar n;//Счётчик для цикла
generate
for(n = 0; n < 256; n = n + 1 )
begin : cycled_uart_transmitter_generation
//имя экземпляра не имеет значения в дальнейшем
//Здесь переопределяем параметр каждого экземпляра Юарт знаком #
//Все юарты передают число n от 0 до 255.
//Каждый новый Юарт будет передавать своё число.
  cycled_uart_transmitter #(n) cycled_uart_transmitter_insts
  (
		.clk(clk_100k),//На вход подаём 100 кГц
		.Tx(UART_OUT[n]) //Выход UART
  );
end
endgenerate

assign CLK_100k = clk_100k;

endmodule