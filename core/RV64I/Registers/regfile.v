////////////////////////////////////////////////////////////////////////////////
//                   RISC-V SiMPLE - Banco de Registradores                   //
//                                                                            //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple         //
//                            BSD 3-Clause License                            //
////////////////////////////////////////////////////////////////////////////////


module regfile (
    input clk,
    input rst,

    input  write_en,            // Habilita a escrita no banco de registradores
    input  [4:0] write_reg,     // Endereço do registrador rd       // TODO: renomear wires pra rd, rs1 e rs2
    input  [4:0] read_reg_a,    // Endereço do registrador rs1
    input  [4:0] read_reg_b,    // Endereço do registrador rs2

    input  [63:0] write_data,   // Dado a ser gravado no registrador rd
    output [63:0] reg_a_data,   // Dado lido do registrador rs1
    output [63:0] reg_b_data    // Dado lido do registrador rs2
);


// 32 registradores de 64 bits
reg [63:0] register [0:31];

// Contador para loop de inicialização de registradores
integer i;

// Inicia os registradores
initial begin
    for (i = 0; i <= 31; i = i + 1)
        register[i] <= 64'b0;
    // NOTE: Inserir registradores com valor inicial != 64'b0
end

// Lê os dados dos registradores rs1 e rs2
assign reg_a_data = register[read_reg_a];
assign reg_b_data = register[read_reg_b];

// Grava novos valores no banco de registradores
always @ ( posedge clk ) begin
    // Reseta os registradores
    if (rst) begin
        for (i = 0; i <= 31; i = i + 1)
            register[i] <= 64'b0;
        // NOTE: Inserir registradores com valor inicial != 64'b0
    end
    else if (write_en)
        if (write_reg != 5'b0)
            register[write_reg] <= write_data;
end


endmodule
