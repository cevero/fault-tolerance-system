module mem_mod(
  input logic            clk,
  input logic 		       rst_n,

  input logic            port1_req_i,
  output logic           port1_gnt_o,
  output logic           port1_rvalid_o,
  input  logic [31:0]    port1_addr_i,
  input  logic           port1_we_i,
  output logic [31:0]    port1_rdata_o,
  input  logic [31:0]    port1_wdata_i,

  input logic            port2_req_i,
  output logic           port2_gnt_o,
  output logic           port2_rvalid_o,
  input  logic [31:0]    port2_addr_i,
  input  logic           port2_we_i,
  output logic [31:0]    port2_rdata_o,
  input  logic [31:0]    port2_wdata_i,
  
  output logic [31:0]	 mem_flag,
  output logic [31:0]	 mem_result
);

  logic [31:0] mem [0:255]; // instruction memory
//logic [15:0] RAM [0:128]; // data memory

initial begin
  for(int i = 0; i != 255; i = i + 1) begin
    mem[i] = 32'bX;
  end
  $readmemb("instmem.bin",mem);

end
  
always_ff @(posedge clk) begin
    if (port1_we_i) begin
        mem[port1_addr_i] <= port1_wdata_i;
    end else begin
        mem[port1_addr_i] <= mem[port1_addr_i];
    end

    if (port2_we_i) begin
        mem[port2_addr_i] <= port2_wdata_i;
    end else begin
        mem[port2_addr_i] <= mem[port2_addr_i];
    end
end
  
assign port1_rdata_o = mem[port1_addr_i];
assign port2_rdata_o = mem[port2_addr_i];
  
always_comb
  begin
	if(port1_req_i)
      port1_gnt_o = 1'b1;
    else
      port1_gnt_o = 1'b0;
    
    if(port2_req_i)
      port2_gnt_o = 1'b1;
    else
      port2_gnt_o = 1'b0;
end


always_ff @(posedge clk, negedge rst_n)
  begin
    if (rst_n == 1'b0)
    begin
      port1_rvalid_o <= 1'b0;
      port2_rvalid_o <= 1'b0;
    end
    else
    begin
      port1_rvalid_o <= port1_gnt_o;
      port2_rvalid_o <= port2_gnt_o;
    end
end

assign mem_flag = mem[0];
assign mem_result = mem[4];

endmodule