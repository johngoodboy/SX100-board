module clk_div_2//Делитель частоты на 2
(
input clk_in, 
output clk_out
);

reg cnt=1'b0;

always @(posedge clk_in)	
begin
	cnt <= cnt+1'b1;
end

assign clk_out = cnt;
endmodule
