module control
#(
    parameter ADDR_WIDTH = 5
)
(
    input  logic                  clk_i,
    input  logic                  error_i,
    output logic                  reset_o,
    output logic                  halt_o,
    output logic                  resume_o,
    output logic                  shift_o,
    output logic                  we_sgpr_o,
    output logic                  we_spc_o,
    output logic [ADDR_WIDTH-1:0] replay_addr_o
);

    localparam NUM_REG = 2**ADDR_WIDTH;

    localparam WAIT      = 3'b000;
    localparam RESET     = 3'b001;
    localparam HALT      = 3'b010;
    localparam WORK_SPC  = 3'b011;
    localparam WORK_SGPR = 3'b100;
    localparam DONE      = 3'b101;

    logic [2:0]            state;
    logic [ADDR_WIDTH-1:0] iterator;
    logic [ADDR_WIDTH-1:0] addr;

    initial state = 3'b000;

    always_ff @(posedge clk_i)
        case (state)
            WAIT:
                if (error_i)
                    state <= RESET;
            RESET:
                state <= HALT;
            HALT:
                state <= WORK_SPC;
            WORK_SPC:
                state <= WORK_SGPR;
            WORK_SGPR:
                if (iterator < NUM_REG-1) begin
                    iterator = iterator + 1;
                    addr = iterator;
                end else 
                    state <= DONE;
            DONE: begin
                state <= WAIT;
            end
        endcase

    always @(state)
        case (state)
            WAIT: begin
                halt_o <= 0;
                resume_o <= 0;
                iterator <= 0;
                shift_o <= 0;
                reset_o <= 1;
                we_sgpr_o <= 0;
                we_spc_o <= 0;
            end
            RESET:
                reset_o <= 0;
            HALT: begin
                reset_o <= 1;
                halt_o <= 1;
                shift_o <= 1;
            end
            WORK_SPC: begin
                halt_o <= 0;
                we_spc_o <= 1;
            end
            WORK_SGPR: begin
                shift_o <= 0;
                we_sgpr_o <= 1;
                we_spc_o <= 0;
            end
            DONE: begin
                we_sgpr_o <= 0;
                we_spc_o <= 0;
                resume_o <= 1;
            end
        endcase
            
    assign replay_addr_o = addr;
endmodule
