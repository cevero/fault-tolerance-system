module tb_ft_system();

    localparam ADDR_WIDTH = 5;
    localparam DATA_WIDTH = 2**ADDR_WIDTH;

    logic                  clk_i;
    logic                  we_a_i;
    logic                  we_b_i;
    logic [ADDR_WIDTH-1:0] addr_a_i;
    logic [ADDR_WIDTH-1:0] addr_b_i;
    logic [DATA_WIDTH-1:0] data_a_i;
    logic [DATA_WIDTH-1:0] data_b_i;
    logic [ADDR_WIDTH-1:0] addr_o;
    logic [DATA_WIDTH-1:0] rdata_o;
    logic                  fetch_block_o;
	
	ft_system dut
	(
        .clk_i         (clk_i        ),
        .we_a_i        (we_a_i       ),
        .we_b_i        (we_b_i       ),
        .addr_a_i      (addr_a_i     ),
        .addr_b_i      (addr_b_i     ),
        .data_a_i      (data_a_i     ),
        .data_b_i      (data_b_i     ),
        .addr_o        (addr_o       ),
        .rdata_o       (rdata_o      ),
        .fetch_block_o (fetch_block_o)
	);
	
    initial clk_i = 0;
    always #5 clk_i = ~clk_i;
	initial begin
		$display("time | addr | data | fetch_block |");
		$monitor("%4t | %4d | %4d | %11b |", $time, addr_o, data_o, fetch_block_o);

        #10
        for (int i = 0; i < 32; i++) begin
		    we_a_i   <= 1'b1;
		    we_b_i   <= 1'b1;
		    addr_a_i <= i;
		    addr_b_i <= i;
		    data_a_i <= i*10;
		    data_b_i <= i*10;
            #10;
        end
		    we_a_i   <= 1'b1;
		    we_b_i   <= 1'b0;
		    addr_a_i <= 5'd10;
		    addr_b_i <= 5'd10;
		    data_a_i <= 32'd100;
		    data_b_i <= 32'd100;
		#400 $finish;
	end
endmodule
