// $Id: $
// File name:   controller.sv
// Created:     3/1/2022
// Author:      Jared Botte
// Lab Section: 337-02
// Version:     1.0  Initial Design Entry
// Description: The FIR Filter controller implementation

module controller
(
    input logic clk,
    input logic n_rst,
    input logic dr,
    input logic lc,
    input logic nss_fall,
    input logic overflow,
    output logic cnt_up,
    output logic clear,
    output logic modwait,
    output logic [2:0] op,
    output logic [3:0] src1,
    output logic [3:0] src2,
    output logic [3:0] dest,
    output logic err
);

    typedef enum logic [4:0] {IDLE, SHIFT1, SHIFT2, SHIFT3, SHIFT4, 
                            LOAD, STORE, ZERO, SORT1, SORT2, SORT3, 
                            SORT4, MUL1, ADD1, MUL2, SUB1, MUL3, 
                            ADD2, MUL4, SUB2, EIDLE} state_type;

    state_type state, next_state;

    logic next_modwait;

    always_ff @ (posedge clk, negedge n_rst)
    begin
        if (n_rst == 1'b0) begin
            state <= IDLE;
            modwait <= 0;
        end else begin
            state <= next_state;
            modwait <= next_modwait;
        end
    end

    /*---------REGISTER-MAP---------*:
    *       R0      |     total     *
    *       R1      |    sample1    *
    *       R2      |    sample2    *
    *       R3      |    sample3    *
    *       R4      |    sample4    *
    *       R5      |     temp      *
    *       R6      |               *
    *       R7      |               *
    *       R8      |               *
    *       R9      |               *
    *       R10     |               *
    *       R11     |               *
    *       R12     |       F0      *
    *       R13     |       F1      *
    *       R14     |       F2      *
    *       R15     |       F3      *
    *-------------------------------*/

    always_comb begin : nextstate_logic
        op = 3'b000;
        src1 = 4'd0;
        src2 = 4'd0;
        dest = 4'd0;
        next_state = state;
        case (state)
        IDLE: begin
            next_state = lc ? LOAD : dr ? STORE : IDLE; 
        end
        LOAD: begin
            // Load EX1 into temp
            op = 3'b010;
            dest = 4'd5;
            next_state = SHIFT1;
        end
        SHIFT1: begin
            // Copy F1 into F0
            op = 3'b001;
            src1 = 4'd13;
            dest = 4'd12;
            next_state = SHIFT2;
        end
        SHIFT2: begin
            // Copy F2 into F1
            op = 3'b001;
            src1 = 4'd14;
            dest = 4'd13;
            next_state = SHIFT3;
        end
        SHIFT3: begin
            // Copy F3 into F2
            op = 3'b001;
            src1 = 4'd15;
            dest = 4'd14;
            next_state = SHIFT4;
        end
        SHIFT4: begin
            // store temp in F3
            op = 3'b001;
            src1 = 4'd5;
            dest = 4'd15;
            next_state = IDLE;
        end
        STORE: begin
            // Store ext in temp
            op = 3'b011;
            dest = 4'd5;
            next_state = dr ? ZERO : EIDLE;
        end
        ZERO: begin
            // R0 = R0 - R0 (Set it to zero)
            op = 3'b101;
            src1 = 4'd0;
            src2 = 4'd0;
            dest = 4'd0;
            next_state = SORT1;
        end 
        SORT1: begin
            // sample 4 = sample 3
            op = 3'b001;
            src1 = 4'd3;
            dest = 4'd4;
            next_state = SORT2;
        end
        SORT2: begin
            // Sample 3 = sample 2
            op = 3'b001;
            src1 = 4'd2;
            dest = 4'd3;
            next_state = SORT3;
        end
        SORT3: begin 
            // Sample 2 = sample 1
            op = 3'b001;
            src1 = 4'd1;
            dest = 4'd2;
            next_state = SORT4;
        end
        SORT4: begin
            // Sample 1 = temp
            op = 3'b001;
            src1 = 4'd5;
            dest = 4'd1;
            next_state = MUL1;
        end
        MUL1: begin
            // Multiply sample1 by f0
            op = 3'b110;
            src1 = 4'd1;
            src2 = 4'd12;
            dest = 4'd5;
            next_state = overflow ? EIDLE : SUB1;
        end
        SUB1: begin
            // subtract temp from r0
            op = 3'b101;
            src1 = 4'd0;
            src2 = 4'd5;
            dest = 4'd0;
            next_state = overflow ? EIDLE : MUL2;
        end
        MUL2: begin
            // Multiply sample2 by f1
            op = 3'b110;
            src1 = 4'd2;
            src2 = 4'd13;
            dest = 4'd5;
            next_state = overflow ? EIDLE : ADD1;
        end
        ADD1: begin
            // Add temp to r0
            op = 3'b100;
            src1 = 4'd0;
            src2 = 4'd5;
            dest = 4'd0;
            next_state = overflow ? EIDLE : MUL3;
        end
        MUL3: begin
            // Multiply sample3 by f2
            op = 3'b110;
            src1 = 4'd3;
            src2 = 4'd14;
            dest = 4'd5;
            next_state = overflow ? EIDLE : SUB2;
        end
        SUB2: begin
            // Sub temp from r0
            op = 3'b101;
            src1 = 4'd0;
            src2 = 4'd5;
            dest = 4'd0;
            next_state = overflow ? EIDLE : MUL4;
        end
        MUL4: begin
            // Multiply sample4 by f3
            op = 3'b110;
            src1 = 4'd4;
            src2 = 4'd15;
            dest = 4'd5;
            next_state = overflow ? EIDLE : ADD2;
        end
        ADD2: begin
            // Add temp to r0
            op = 3'b100;
            src1 = 4'd0;
            src2 = 4'd5;
            dest = 4'd0;
            next_state = overflow ? EIDLE : IDLE;
        end
        EIDLE: begin
            // We're here if there's an error
            next_state = dr ? STORE : lc ? LOAD : EIDLE;
        end
        endcase

        err = state == EIDLE;
        cnt_up = state == ZERO;
        clear = state == LOAD;
        next_modwait = (next_state == IDLE || next_state == EIDLE) ? 1'b0 : 1'b1;
    end

endmodule