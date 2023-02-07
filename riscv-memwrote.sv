// riscv_multi.sv
// menotti@ufscar.br 13 May 2021
// Multi-cycle implementation of a subset of RISC-V

// Based on:
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 26 July 2011 
// Multi-cycle implementation of a subset of MIPS

// 32 32-bit registers
// Common fields for all types (exceptions with * below)
//   Instr[24:20] = rs2
//   Instr[19:15] = rs1
//   Instr[14:12] = Funct3
//   Instr[11: 7] = rd
//   Instr[ 6: 0] = Opcode:
//					R = 0110011
//					I = 0010011 (data-processing)
//					I = 0000011 (data-load)
//					S = 0100011 (data-store)
//					B = 1100011 (branch)
//					J = 1101111 (jal)
//					U = 1100011 (lui)
//					U = 0000011 (auipc)

// Data-processing instructions (register)
//   ADD, SUB, AND, OR
//   INSTR <Rd>, <Rs1>, <Rs2>
//    Rd <- <Rs1> INSTR <Rs2>
//   Instr[31:25] = Funct7
//					SUB, SRA = 0100000
//					others   = 0000000
//   Instr[14:12] = Funct3
//					ADD = 000
//					SUB	= 000
//					AND = 111
//					OR  = 110
//					XOR = 100

// Data-processing instructions (immediate)
//   ADDI, ANDI, ORI
//   INSTR <Rd>, <Rs1>, <Rs2>
//    Rd <- <Rs1> INSTR <Rs2>
//   Instr[31:25] = Funct7
//					SUB, SRA = 0100000
//					others   = 0000000
//   Instr[14:12] = Funct3
//					ADD = 000
//					SUB	= 000
//					AND = 111
//					OR  = 110
//					XOR = 100


module top(
  input  sysclk,
  output [3:0] VGA_R, VGA_G, VGA_B, 
  output VGA_HS_O, VGA_VS_O);
  
  wire pixel_clk,reset,memwrite;
  wire [31:0] writedata, adr, readdata, vdata,vaddr;

  power_on_reset por(sysclk, reset);
  clk_wiz_1 clockdiv(pixel_clk, sysclk);

  // microprocessor (control & datapath)
  riscvmulti riscvmulti(sysclk, reset, adr, writedata, memwrite, readdata);

  // memory 
  mem mem(sysclk, memwrite, adr, writedata, vaddr, readdata, vdata);
  
  vga gpu(pixel_clk, reset, vdata, vaddr,VGA_R, VGA_G, VGA_B, VGA_HS_O, VGA_VS_O);

endmodule


module mem  //alteração original: "memfile.hex" para "memfile.bin"
          (input  logic        sysclk, we,
           input  logic [31:0] a, wd, va,
           output logic [31:0] rd, vd);

  logic  [31:0] RAM[511:0];

  // initialize memory with instructions
  initial
     begin
      RAM[0] = 32'h10400413;
      RAM[1] = 32'hffc42283;
      RAM[2] = 32'h00042303;
      RAM[3] = 32'h005303b3;
      RAM[4] = 32'h006002b3;
      RAM[5] = 32'h00700333;
      RAM[6] = 32'h00440413;
      RAM[7] = 32'h00742023;
      RAM[8] = 32'hfedff06f;
      RAM[9] = 32'h00000000;
      RAM[10] = 32'h00000000;
      RAM[11] = 32'h00000000;
      RAM[12] = 32'h00000000;
      RAM[13] = 32'h00000000;
      RAM[14] = 32'h00000000;
      RAM[15] = 32'h00000000;
      RAM[16] = 32'h00000000;
      RAM[17] = 32'h00000000;
      RAM[18] = 32'h00000000;
      RAM[19] = 32'h00000000;
      RAM[20] = 32'h00000000;
      RAM[21] = 32'h00000000;
      RAM[22] = 32'h00000000;
      RAM[23] = 32'h00000000;
      RAM[24] = 32'h00000000;
      RAM[25] = 32'h00000000;
      RAM[26] = 32'h00000000;
      RAM[27] = 32'h00000000;
      RAM[28] = 32'h00000000;
      RAM[29] = 32'h00000000;
      RAM[30] = 32'h00000000;
      RAM[31] = 32'h00000000;
      RAM[32] = 32'h00000000;
      RAM[33] = 32'h00000000;
      RAM[34] = 32'h00000000;
      RAM[35] = 32'h00000000;
      RAM[36] = 32'h00000000;
      RAM[37] = 32'h00000000;
      RAM[38] = 32'h00000000;
      RAM[39] = 32'h00000000;
      RAM[40] = 32'h00000000;
      RAM[41] = 32'h00000000;
      RAM[42] = 32'h00000000;
      RAM[43] = 32'h00000000;
      RAM[44] = 32'h00000000;
      RAM[45] = 32'h00000000;
      RAM[46] = 32'h00000000;
      RAM[47] = 32'h00000000;
      RAM[48] = 32'h00000000;
      RAM[49] = 32'h00000000;
      RAM[50] = 32'h00000000;
      RAM[51] = 32'h00000000;
      RAM[52] = 32'h00000000;
      RAM[53] = 32'h00000000;
      RAM[54] = 32'h00000000;
      RAM[55] = 32'h00000000;
      RAM[56] = 32'h00000000;
      RAM[57] = 32'h00000000;
      RAM[58] = 32'h00000000;
      RAM[59] = 32'h00000000;
      RAM[60] = 32'h00000000;
      RAM[61] = 32'h00000000;
      RAM[62] = 32'h00000000;
      RAM[63] = 32'h00000000;
      RAM[64] = 32'h00000000;
      RAM[65] = 32'h00000001;
      RAM[66] = 32'h00000000;
      RAM[67] = 32'h00000000;
      RAM[68] = 32'h00000000;
      RAM[69] = 32'h00000000;
      RAM[70] = 32'h00000000;
      RAM[71] = 32'h00000000;
      RAM[72] = 32'h00000000;
      RAM[73] = 32'h00000000;
      RAM[74] = 32'h00000000;
      RAM[75] = 32'h00000000;
      RAM[76] = 32'h00000000;
      RAM[77] = 32'h00000000;
      RAM[78] = 32'h00000000;
      RAM[79] = 32'h00000000;
      RAM[80] = 32'h00000000;
      RAM[81] = 32'h00000000;
      RAM[82] = 32'h00000000;
      RAM[83] = 32'h00000000;
      RAM[84] = 32'h00000000;
      RAM[85] = 32'h00000000;
      RAM[86] = 32'h00000000;
      RAM[87] = 32'h00000000;
      RAM[88] = 32'h00000000;
      RAM[89] = 32'h00000000;
      RAM[90] = 32'h00000000;
      RAM[91] = 32'h00000000;
      RAM[92] = 32'h00000000;
      RAM[93] = 32'h00000000;
      RAM[94] = 32'h00000000;
      RAM[95] = 32'h00000000;
      RAM[96] = 32'h00000000;
      RAM[97] = 32'h00000000;
      RAM[98] = 32'h00000000;
      RAM[99] = 32'h00000000;
      RAM[100] = 32'h00000000;
      RAM[101] = 32'h00000000;
      RAM[102] = 32'h00000000;
      RAM[103] = 32'h00000000;
      RAM[104] = 32'h00000000;
      RAM[105] = 32'h00000000;
      RAM[106] = 32'h00000000;
      RAM[107] = 32'h00000000;
      RAM[108] = 32'h00000000;
      RAM[109] = 32'h00000000;
      RAM[110] = 32'h00000000;
      RAM[111] = 32'h00000000;
      RAM[112] = 32'h00000000;
      RAM[113] = 32'h00000000;
      RAM[114] = 32'h00000000;
      RAM[115] = 32'h00000000;
      RAM[116] = 32'h00000000;
      RAM[117] = 32'h00000000;
      RAM[118] = 32'h00000000;
      RAM[119] = 32'h00000000;
      RAM[120] = 32'h00000000;
      RAM[121] = 32'h00000000;
      RAM[122] = 32'h00000000;
      RAM[123] = 32'h00000000;
      RAM[124] = 32'h00000000;
      RAM[125] = 32'h00000000;
      RAM[126] = 32'h00000000;
      RAM[127] = 32'h00000000;
      RAM[128] = 32'h00000000;
      RAM[129] = 32'h00000000;
      RAM[130] = 32'h00000000;
      RAM[131] = 32'h00000000;
      RAM[132] = 32'h00000000;
      RAM[133] = 32'h00000000;
      RAM[134] = 32'h00000000;
      RAM[135] = 32'h00000000;
      RAM[136] = 32'h00000000;
      RAM[137] = 32'h00000000;
      RAM[138] = 32'h00000000;
      RAM[139] = 32'h00000000;
      RAM[140] = 32'h00000000;
      RAM[141] = 32'h00000000;
      RAM[142] = 32'h00000000;
      RAM[143] = 32'h00000000;
      RAM[144] = 32'h00000000;
      RAM[145] = 32'h00000000;
      RAM[146] = 32'h00000000;
      RAM[147] = 32'h00000000;
      RAM[148] = 32'h00000000;
      RAM[149] = 32'h00000000;
      RAM[150] = 32'h00000000;
      RAM[151] = 32'h00000000;
      RAM[152] = 32'h00000000;
      RAM[153] = 32'h00000000;
      RAM[154] = 32'h00000000;
      RAM[155] = 32'h00000000;
      RAM[156] = 32'h00000000;
      RAM[157] = 32'h00000000;
      RAM[158] = 32'h00000000;
      RAM[159] = 32'h00000000;
      RAM[160] = 32'h00000000;
      RAM[161] = 32'h00000000;
      RAM[162] = 32'h00000000;
      RAM[163] = 32'h00000000;
      RAM[164] = 32'h00000000;
      RAM[165] = 32'h00000000;
      RAM[166] = 32'h00000000;
      RAM[167] = 32'h00000000;
      RAM[168] = 32'h00000000;
      RAM[169] = 32'h00000000;
      RAM[170] = 32'h00000000;
      RAM[171] = 32'h00000000;
      RAM[172] = 32'h00000000;
      RAM[173] = 32'h00000000;
      RAM[174] = 32'h00000000;
      RAM[175] = 32'h00000000;
      RAM[176] = 32'h00000000;
      RAM[177] = 32'h00000000;
      RAM[178] = 32'h00000000;
      RAM[179] = 32'h00000000;
      RAM[180] = 32'h00000000;
      RAM[181] = 32'h00000000;
      RAM[182] = 32'h00000000;
      RAM[183] = 32'h00000000;
      RAM[184] = 32'h00000000;
      RAM[185] = 32'h00000000;
      RAM[186] = 32'h00000000;
      RAM[187] = 32'h00000000;
      RAM[188] = 32'h00000000;
      RAM[189] = 32'h00000000;
      RAM[190] = 32'h00000000;
      RAM[191] = 32'h00000000;
      RAM[192] = 32'h00000000;
      RAM[193] = 32'h00000000;
      RAM[194] = 32'h00000000;
      RAM[195] = 32'h00000000;
      RAM[196] = 32'h00000000;
      RAM[197] = 32'h00000000;
      RAM[198] = 32'h00000000;
      RAM[199] = 32'h00000000;
      RAM[200] = 32'h00000000;
      RAM[201] = 32'h00000000;
      RAM[202] = 32'h00000000;
      RAM[203] = 32'h00000000;
      RAM[204] = 32'h00000000;
      RAM[205] = 32'h00000000;
      RAM[206] = 32'h00000000;
      RAM[207] = 32'h00000000;
      RAM[208] = 32'h00000000;
      RAM[209] = 32'h00000000;
      RAM[210] = 32'h00000000;
      RAM[211] = 32'h00000000;
      RAM[212] = 32'h00000000;
      RAM[213] = 32'h00000000;
      RAM[214] = 32'h00000000;
      RAM[215] = 32'h00000000;
      RAM[216] = 32'h00000000;
      RAM[217] = 32'h00000000;
      RAM[218] = 32'h00000000;
      RAM[219] = 32'h00000000;
      RAM[220] = 32'h00000000;
      RAM[221] = 32'h00000000;
      RAM[222] = 32'h00000000;
      RAM[223] = 32'h00000000;
      RAM[224] = 32'h00000000;
      RAM[225] = 32'h00000000;
      RAM[226] = 32'h00000000;
      RAM[227] = 32'h00000000;
      RAM[228] = 32'h00000000;
      RAM[229] = 32'h00000000;
      RAM[230] = 32'h00000000;
      RAM[231] = 32'h00000000;
      RAM[232] = 32'h00000000;
      RAM[233] = 32'h00000000;
      RAM[234] = 32'h00000000;
      RAM[235] = 32'h00000000;
      RAM[236] = 32'h00000000;
      RAM[237] = 32'h00000000;
      RAM[238] = 32'h00000000;
      RAM[239] = 32'h00000000;
      RAM[240] = 32'h00000000;
      RAM[241] = 32'h00000000;
      RAM[242] = 32'h00000000;
      RAM[243] = 32'h00000000;
      RAM[244] = 32'h00000000;
      RAM[245] = 32'h00000000;
      RAM[246] = 32'h00000000;
      RAM[247] = 32'h00000000;
      RAM[248] = 32'h00000000;
      RAM[249] = 32'h00000000;
      RAM[250] = 32'h00000000;
      RAM[251] = 32'h00000000;
      RAM[252] = 32'h00000000;
      RAM[253] = 32'h00000000;
      RAM[254] = 32'h00000000;
      RAM[255] = 32'h00000000;
      RAM[256] = 32'h00000000;
      RAM[257] = 32'h00000000;
      RAM[258] = 32'h00000000;
      RAM[259] = 32'h00000000;
      RAM[260] = 32'h00000000;
      RAM[261] = 32'h00000000;
      RAM[262] = 32'h00000000;
      RAM[263] = 32'h00000000;
      RAM[264] = 32'h00000000;
      RAM[265] = 32'h00000000;
      RAM[266] = 32'h00000000;
      RAM[267] = 32'h00000000;
      RAM[268] = 32'h00000000;
      RAM[269] = 32'h00000000;
      RAM[270] = 32'h00000000;
      RAM[271] = 32'h00000000;
      RAM[272] = 32'h00000000;
      RAM[273] = 32'h00000000;
      RAM[274] = 32'h00000000;
      RAM[275] = 32'h00000000;
      RAM[276] = 32'h00000000;
      RAM[277] = 32'h00000000;
      RAM[278] = 32'h00000000;
      RAM[279] = 32'h00000000;
      RAM[280] = 32'h00000000;
      RAM[281] = 32'h00000000;
      RAM[282] = 32'h00000000;
      RAM[283] = 32'h00000000;
      RAM[284] = 32'h00000000;
      RAM[285] = 32'h00000000;
      RAM[286] = 32'h00000000;
      RAM[287] = 32'h00000000;
      RAM[288] = 32'h00000000;
      RAM[289] = 32'h00000000;
      RAM[290] = 32'h00000000;
      RAM[291] = 32'h00000000;
      RAM[292] = 32'h00000000;
      RAM[293] = 32'h00000000;
      RAM[294] = 32'h00000000;
      RAM[295] = 32'h00000000;
      RAM[296] = 32'h00000000;
      RAM[297] = 32'h00000000;
      RAM[298] = 32'h00000000;
      RAM[299] = 32'h00000000;
      RAM[300] = 32'h00000000;
      RAM[301] = 32'h00000000;
      RAM[302] = 32'h00000000;
      RAM[303] = 32'h00000000;
      RAM[304] = 32'h00000000;
      RAM[305] = 32'h00000000;
      RAM[306] = 32'h00000000;
      RAM[307] = 32'h00000000;
      RAM[308] = 32'h00000000;
      RAM[309] = 32'h00000000;
      RAM[310] = 32'h00000000;
      RAM[311] = 32'h00000000;
      RAM[312] = 32'h00000000;
      RAM[313] = 32'h00000000;
      RAM[314] = 32'h00000000;
      RAM[315] = 32'h00000000;
      RAM[316] = 32'h00000000;
      RAM[317] = 32'h00000000;
      RAM[318] = 32'h00000000;
      RAM[319] = 32'h00000000;
      RAM[320] = 32'h00000000;
      RAM[321] = 32'h00000000;
      RAM[322] = 32'h00000000;
      RAM[323] = 32'h00000000;
      RAM[324] = 32'h00000000;
      RAM[325] = 32'h00000000;
      RAM[326] = 32'h00000000;
      RAM[327] = 32'h00000000;
      RAM[328] = 32'h00000000;
      RAM[329] = 32'h00000000;
      RAM[330] = 32'h00000000;
      RAM[331] = 32'h00000000;
      RAM[332] = 32'h00000000;
      RAM[333] = 32'h00000000;
      RAM[334] = 32'h00000000;
      RAM[335] = 32'h00000000;
      RAM[336] = 32'h00000000;
      RAM[337] = 32'h00000000;
      RAM[338] = 32'h00000000;
      RAM[339] = 32'h00000000;
      RAM[340] = 32'h00000000;
      RAM[341] = 32'h00000000;
      RAM[342] = 32'h00000000;
      RAM[343] = 32'h00000000;
      RAM[344] = 32'h00000000;
      RAM[345] = 32'h00000000;
      RAM[346] = 32'h00000000;
      RAM[347] = 32'h00000000;
      RAM[348] = 32'h00000000;
      RAM[349] = 32'h00000000;
      RAM[350] = 32'h00000000;
      RAM[351] = 32'h00000000;
      RAM[352] = 32'h00000000;
      RAM[353] = 32'h00000000;
      RAM[354] = 32'h00000000;
      RAM[355] = 32'h00000000;
      RAM[356] = 32'h00000000;
      RAM[357] = 32'h00000000;
      RAM[358] = 32'h00000000;
      RAM[359] = 32'h00000000;
      RAM[360] = 32'h00000000;
      RAM[361] = 32'h00000000;
      RAM[362] = 32'h00000000;
      RAM[363] = 32'h00000000;
      RAM[364] = 32'h00000000;
      RAM[365] = 32'h00000000;
      RAM[366] = 32'h00000000;
      RAM[367] = 32'h00000000;
      RAM[368] = 32'h00000000;
      RAM[369] = 32'h00000000;
      RAM[370] = 32'h00000000;
      RAM[371] = 32'h00000000;
      RAM[372] = 32'h00000000;
      RAM[373] = 32'h00000000;
      RAM[374] = 32'h00000000;
      RAM[375] = 32'h00000000;
      RAM[376] = 32'h00000000;
      RAM[377] = 32'h00000000;
      RAM[378] = 32'h00000000;
      RAM[379] = 32'h00000000;
      RAM[380] = 32'h00000000;
      RAM[381] = 32'h00000000;
      RAM[382] = 32'h00000000;
      RAM[383] = 32'h00000000;
      RAM[384] = 32'h00000000;
      RAM[385] = 32'h00000000;
      RAM[386] = 32'h00000000;
      RAM[387] = 32'h00000000;
      RAM[388] = 32'h00000000;
      RAM[389] = 32'h00000000;
      RAM[390] = 32'h00000000;
      RAM[391] = 32'h00000000;
      RAM[392] = 32'h00000000;
      RAM[393] = 32'h00000000;
      RAM[394] = 32'h00000000;
      RAM[395] = 32'h00000000;
      RAM[396] = 32'h00000000;
      RAM[397] = 32'h00000000;
      RAM[398] = 32'h00000000;
      RAM[399] = 32'h00000000;
      RAM[400] = 32'h00000000;
      RAM[401] = 32'h00000000;
      RAM[402] = 32'h00000000;
      RAM[403] = 32'h00000000;
      RAM[404] = 32'h00000000;
      RAM[405] = 32'h00000000;
      RAM[406] = 32'h00000000;
      RAM[407] = 32'h00000000;
      RAM[408] = 32'h00000000;
      RAM[409] = 32'h00000000;
      RAM[410] = 32'h00000000;
      RAM[411] = 32'h00000000;
      RAM[412] = 32'h00000000;
      RAM[413] = 32'h00000000;
      RAM[414] = 32'h00000000;
      RAM[415] = 32'h00000000;
      RAM[416] = 32'h00000000;
      RAM[417] = 32'h00000000;
      RAM[418] = 32'h00000000;
      RAM[419] = 32'h00000000;
      RAM[420] = 32'h00000000;
      RAM[421] = 32'h00000000;
      RAM[422] = 32'h00000000;
      RAM[423] = 32'h00000000;
      RAM[424] = 32'h00000000;
      RAM[425] = 32'h00000000;
      RAM[426] = 32'h00000000;
      RAM[427] = 32'h00000000;
      RAM[428] = 32'h00000000;
      RAM[429] = 32'h00000000;
      RAM[430] = 32'h00000000;
      RAM[431] = 32'h00000000;
      RAM[432] = 32'h00000000;
      RAM[433] = 32'h00000000;
      RAM[434] = 32'h00000000;
      RAM[435] = 32'h00000000;
      RAM[436] = 32'h00000000;
      RAM[437] = 32'h00000000;
      RAM[438] = 32'h00000000;
      RAM[439] = 32'h00000000;
      RAM[440] = 32'h00000000;
      RAM[441] = 32'h00000000;
      RAM[442] = 32'h00000000;
      RAM[443] = 32'h00000000;
      RAM[444] = 32'h00000000;
      RAM[445] = 32'h00000000;
      RAM[446] = 32'h00000000;
      RAM[447] = 32'h00000000;
      RAM[448] = 32'h00000000;
      RAM[449] = 32'h00000000;
      RAM[450] = 32'h00000000;
      RAM[451] = 32'h00000000;
      RAM[452] = 32'h00000000;
      RAM[453] = 32'h00000000;
      RAM[454] = 32'h00000000;
      RAM[455] = 32'h00000000;
      RAM[456] = 32'h00000000;
      RAM[457] = 32'h00000000;
      RAM[458] = 32'h00000000;
      RAM[459] = 32'h00000000;
      RAM[460] = 32'h00000000;
      RAM[461] = 32'h00000000;
      RAM[462] = 32'h00000000;
      RAM[463] = 32'h00000000;
      RAM[464] = 32'h00000000;
      RAM[465] = 32'h00000000;
      RAM[466] = 32'h00000000;
      RAM[467] = 32'h00000000;
      RAM[468] = 32'h00000000;
      RAM[469] = 32'h00000000;
      RAM[470] = 32'h00000000;
      RAM[471] = 32'h00000000;
      RAM[472] = 32'h00000000;
      RAM[473] = 32'h00000000;
      RAM[474] = 32'h00000000;
      RAM[475] = 32'h00000000;
      RAM[476] = 32'h00000000;
      RAM[477] = 32'h00000000;
      RAM[478] = 32'h00000000;
      RAM[479] = 32'h00000000;
      RAM[480] = 32'h00000000;
      RAM[481] = 32'h00000000;
      RAM[482] = 32'h00000000;
      RAM[483] = 32'h00000000;
      RAM[484] = 32'h00000000;
      RAM[485] = 32'h00000000;
      RAM[486] = 32'h00000000;
      RAM[487] = 32'h00000000;
      RAM[488] = 32'h00000000;
      RAM[489] = 32'h00000000;
      RAM[490] = 32'h00000000;
      RAM[491] = 32'h00000000;
      RAM[492] = 32'h00000000;
      RAM[493] = 32'h00000000;
      RAM[494] = 32'h00000000;
      RAM[495] = 32'h00000000;
      RAM[496] = 32'h00000000;
      RAM[497] = 32'h00000000;
      RAM[498] = 32'h00000000;
      RAM[499] = 32'h00000000;
      RAM[500] = 32'h00000000;
      RAM[501] = 32'h00000000;
      RAM[502] = 32'h00000000;
      RAM[503] = 32'h00000000;
      RAM[504] = 32'h00000000;
      RAM[505] = 32'h00000000;
      RAM[506] = 32'h00000000;
      RAM[507] = 32'h00000000;
      RAM[508] = 32'h00000000;
      RAM[509] = 32'h00000000;
      RAM[510] = 32'h00000000;
      RAM[511] = 32'h00000000;
    end

  assign rd = RAM[a[31:2]]; // word aligned
  assign vd = RAM[va];

  always_ff @(posedge sysclk)
    if (we)
      RAM[a[31:2]] <= wd;
endmodule

module riscvmulti(
            input  logic        sysclk, reset,
            output logic [31:0] adr, writedata,
            output logic        memwrite,
            input  logic [31:0] readdata);

  logic        zero, pcen, irwrite, regwrite,
               iord, memtoreg;
  logic [1:0]  alusrca, pcsrc;
  logic [2:0]  alusrcb, alucontrol, funct3;
  logic [6:0]  op, funct7;

  controller c(sysclk, reset, op, funct7, zero,
               pcen, memwrite, irwrite, regwrite,
               iord, memtoreg, 
               alusrca, pcsrc, alusrcb, alucontrol, funct3);
  datapath dp(sysclk, reset, 
              pcen, irwrite, regwrite,
              iord, memtoreg,
              alusrca, pcsrc, alusrcb, alucontrol, funct3,
              op, funct7, zero,
              adr, writedata, readdata);
endmodule


module controller(input  logic       sysclk, reset,
                  input  logic [6:0] op, funct7,
                  input  logic       zero,
                  output logic       pcen, memwrite, irwrite, regwrite,
                  output logic       iord, memtoreg,
                  output logic [1:0] alusrca, pcsrc,
                  output logic [2:0] alusrcb, alucontrol, 
                  input  logic [2:0] funct3);

  logic [1:0] aluop;
  logic       branch, pcwrite;

  // Main Decoder and ALU Decoder subunits.
  maindec md(sysclk, reset, op,
             pcwrite, memwrite, irwrite, regwrite,
             branch, iord, memtoreg, 
             alusrca, pcsrc, alusrcb, aluop);
  aludec  ad(funct3, aluop, alucontrol);
  assign pcen = pcwrite | branch & zero;
 
endmodule

module maindec(input  logic       sysclk, reset, 
               input  logic [6:0] op, 
               output logic       pcwrite, memwrite, irwrite, regwrite,
               output logic       branch, iord, memtoreg,
               output logic [1:0] alusrca, pcsrc,
               output logic [2:0] alusrcb, 
               output logic [1:0] aluop);

  parameter   FETCH   = 4'b0000; 	// State 0
  parameter   DECODE  = 4'b0001; 	// State 1
  parameter   MEMADR  = 4'b0010;	// State 2
  parameter   MEMRD   = 4'b0011;	// State 3
  parameter   MEMWB   = 4'b0100;	// State 4
  parameter   MEMWR   = 4'b0101;	// State 5
  parameter   RTYPEEX = 4'b0110;	// State 6
  parameter   RTYPEWB = 4'b0111;	// State 7
  parameter   BEQEX   = 4'b1000;	// State 8
  parameter   ADDIEX  = 4'b1001;	// State 9
  parameter   ADDIWB  = 4'b1010;	// state 10
  parameter   JEX     = 4'b1011;	// State 11

  parameter   LW      = 7'b0000011;	// Opcode for lw
  parameter   SW      = 7'b0100011;	// Opcode for sw
  parameter   RTYPE   = 7'b0110011;	// Opcode for R-type
  parameter   BEQ     = 7'b1100011;	// Opcode for beq
  parameter   ADDI    = 7'b0010011;	// Opcode for addi
  parameter   JAL     = 7'b1101111;	// Opcode for jal  
  
  logic [3:0]  state, nextstate;
  logic [15:0] controls;

  // state register
  always_ff @(posedge sysclk or posedge reset)			
    if(reset) state <= FETCH;
    else state <= nextstate;

  // next state logic
  always_comb
    case(state)
      FETCH:   nextstate <= DECODE;
      DECODE:  case(op)
                 LW:      nextstate <= MEMADR;
                 SW:      nextstate <= MEMADR;
                 RTYPE:   nextstate <= RTYPEEX;
                 BEQ:     nextstate <= BEQEX;
                 ADDI:    nextstate <= ADDIEX;
                 JAL:     nextstate <= JEX;
                 default: nextstate <= 4'bx; // should never happen
               endcase
 		// Add code here
      MEMADR: case(op)
                 LW:      nextstate <= MEMRD;
                 SW:      nextstate <= MEMWR;
                 default: nextstate <= 4'bx;
               endcase
      MEMRD:   nextstate <= MEMWB;
      MEMWB:   nextstate <= FETCH;
      MEMWR:   nextstate <= FETCH;
      RTYPEEX: nextstate <= RTYPEWB;
      RTYPEWB: nextstate <= FETCH;
      BEQEX:   nextstate <= FETCH;
      ADDIEX:  nextstate <= ADDIWB;
      ADDIWB:  nextstate <= FETCH;
      JEX:     nextstate <= FETCH;
      default: nextstate <= 4'bx; // should never happen
    endcase

  // output logic
  assign {pcwrite, memwrite, irwrite, regwrite, 
          alusrca, branch, iord, memtoreg,
          pcsrc, alusrcb, aluop} = controls;
//                                          pcsrc
  always_comb//                                alusrcb
    case(state)//                    alusrca       aluop
      FETCH:    controls <= 16'b1010_00_000_00_001_00;
      DECODE:   controls <= 16'b0000_00_000_00_011_00;
      MEMADR:   controls <= 16'b0000_01_000_00_010_00;
      MEMRD:    controls <= 16'b0000_00_010_00_000_00;
      MEMWB:    controls <= 16'b0001_00_001_00_000_00;
      MEMWR:    controls <= 16'b0100_00_010_00_000_00;
      RTYPEEX:  controls <= 16'b0000_01_000_00_000_10;
      RTYPEWB:  controls <= 16'b0001_00_000_00_000_00;
      BEQEX:    controls <= 16'b0000_01_100_01_000_01;
      ADDIEX:   controls <= 16'b0000_01_000_00_010_00;
      ADDIWB:   controls <= 16'b0001_00_000_00_000_00;
      JEX:      controls <= 16'b1000_10_000_00_100_00;      
      default:  controls <= 16'bxxxx_xx_xxx_xx_xx_xx; // should never happen
    endcase
endmodule

module aludec(input  logic [2:0] funct3,
              input  logic [1:0] aluop,
              output logic [2:0] alucontrol);

  always_comb
    case(aluop)
      2'b00: alucontrol <= 3'b010;  // add (fetch, memaddr, addi, etc.)
      2'b01: alucontrol <= 3'b110;  // sub (beq)
      default: case(funct3)         // RTYPE 
           3'b000: alucontrol <= 3'b010; // ADD
           3'b111: alucontrol <= 3'b000; // AND
           3'b110: alucontrol <= 3'b001; // OR
           3'b010: alucontrol <= 3'b111; // SLT
          default: alucontrol <= 3'bxxx; // ???
        endcase
    endcase

endmodule

module datapath(input  logic        sysclk, reset,
                input  logic        pcen, irwrite, regwrite,
                input  logic        iord, memtoreg,
                input  logic [1:0]  alusrca, pcsrc, 
                input  logic [2:0]  alusrcb, alucontrol,
                output logic [2:0]  funct3,
                output logic [6:0]  op, funct7,
                output logic        zero,
                output logic [31:0] adr, writedata, 
                input  logic [31:0] readdata);

  // Below are the internal signals of the datapath module.
  logic [4:0]  rd, rs1, rs2;
  logic [31:0] pcnext, pc, pca;
  logic [31:0] instr, data, srca, srcb;
  logic [31:0] a;
  logic [31:0] aluresult, aluout;
  logic [31:0] signimm;   // the sign-extended immediate
  logic [31:0] signimmsh; // the sign-extended immediate shifted left by 2
  logic [31:0] wd3, rd1, rd2;
  logic [31:0] immI, immS, immB, immU, immJ;

  // instruction fields to controller
  assign op     = instr[ 6: 0];
  assign rd     = instr[11: 7];
  assign funct3 = instr[14:12];
  assign rs1    = instr[19:15];
  assign rs2    = instr[24:20];
  assign funct7 = instr[31:25];
  // immediate fields
  assign immI = {{20{instr[31]}},instr[31:20]};
  assign immS = {{20{instr[31]}},instr[31:25],instr[11:7]};
  assign immB = {{19{instr[31]}},instr[31],instr[7],instr[30:25],instr[11:8],1'b0};
  assign immU = {instr[31:12],12'b0};
  assign immJ = {{19{instr[31]}},instr[31],instr[19:12],instr[20],instr[30:21],1'b0};

  // datapath
  flopenr #(32) pcregn(sysclk, reset, pcen, pcnext, pc);
  flopenr #(32) pcrega(sysclk, reset, pcen, pc, pca);
  mux2    #(32) adrmux(pc, aluout, iord, adr);
  flopenr #(32) instrreg(sysclk, reset, irwrite, readdata, instr);
  flopr   #(32) datareg(sysclk, reset, readdata, data);
  mux2    #(32) wdmux(aluout, data, memtoreg, wd3);
  regfile       rf(sysclk, regwrite, rs1, rs2, rd, wd3, rd1, rd2);
  flopr   #(32) areg(sysclk, reset, rd1, a);
  flopr   #(32) breg(sysclk, reset, rd2, writedata);
  mux3    #(32) srcamux(pc, a, pca, alusrca, srca);
  mux5    #(32) srcbmux(writedata, 32'b100, immI, immI<<2, immJ, alusrcb, srcb);
  alu           alu(srca, srcb, alucontrol, aluresult, zero);
  flopr   #(32) alureg(sysclk, reset, aluresult, aluout);
  mux2    #(32) pcmux(aluresult, aluout, pcsrc[0], pcnext);
endmodule


// building blocks
module regfile(input  logic        sysclk, 
               input  logic        we3, 
               input  logic [4:0]  ra1, ra2, wa3, 
               input  logic [31:0] wd3, 
               output logic [31:0] rd1, rd2);

  logic [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of sysclk
  // register 0 hardwired to 0
  // note: for pipelined processor, write third port
  // on falling edge of sysclk

  always_ff @(posedge sysclk)
    if (we3) 
       rf[wa3] <= wd3;	

  assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule


/*
module sl2(input  logic [31:0] a,
           output logic [31:0] y);

  // shift left by 2
  assign y = {a[29:0], 2'b00};
endmodule

module signext(input  logic [15:0] a,
               output logic [31:0] y);
              
  assign y = {{16{a[15]}}, a};
endmodule
*/
module alu(input  logic [31:0] a, b,
           input  logic [2:0]  alucontrol,
           output logic [31:0] result,
           output logic        zero);

  logic [31:0] condinvb, sum;

  assign condinvb = alucontrol[2] ? ~b : b;
  assign sum = a + condinvb + alucontrol[2];

  always_comb
    case (alucontrol[1:0])
      2'b00: result = a & b;
      2'b01: result = a | b;
      2'b10: result = sum;
      2'b11: result = sum[31];
    endcase

  assign zero = (result == 32'b0);
endmodule

module mux2 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, 
              input  logic             s, 
              output logic [WIDTH-1:0] y);

  assign y = s ? d1 : d0; 
endmodule

module mux3 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

  assign #1 y = s[1] ? d2 : (s[0] ? d1 : d0); 
endmodule

module mux4 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2, d3,
              input  logic [1:0]       s, 
              output logic [WIDTH-1:0] y);

   always_comb
      case(s)
         2'b00: y <= d0;
         2'b01: y <= d1;
         2'b10: y <= d2;
         2'b11: y <= d3;
      endcase
endmodule

module mux5 #(parameter WIDTH = 8)
             (input  logic [WIDTH-1:0] d0, d1, d2, d3, d4, 
              input  logic [2:0]       s, 
              output logic [WIDTH-1:0] y);

   always_comb
      casex(s)
         3'b000: y <= d0;
         3'b001: y <= d1;
         3'b010: y <= d2;
         3'b011: y <= d3;
         3'b1xx: y <= d4;
      endcase
endmodule

module flopr #(parameter WIDTH = 8)
              (input  logic             sysclk, reset,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge sysclk, posedge reset)
    if (reset) q <= 0;
    else       q <= d;
endmodule

module flopenr #(parameter WIDTH = 8)
              (input  logic             sysclk, reset, en,
               input  logic [WIDTH-1:0] d, 
               output logic [WIDTH-1:0] q);

  always_ff @(posedge sysclk, posedge reset)
    if (reset)   q <= 0;
    else if (en) q <= d;
endmodule


module vga( // 20x15 
  input sysclk, reset,
  input  [31:0] vdata,
  output [ 6:0] vaddr, 
  output [3:0] VGA_R, VGA_G, VGA_B, 
  output VGA_HS_O, VGA_VS_O);

  reg [9:0] CounterX, CounterY;
  reg inDisplayArea;
  reg vga_HS, vga_VS;

  wire CounterXmaxed = (CounterX == 800); // 16 + 48 + 96 + 640
  wire CounterYmaxed = (CounterY == 525); // 10 +  2 + 33 + 480
  wire [4:0] col;
  wire [3:0] row;
  wire [7:0] vbyte;

  always @(posedge sysclk or posedge reset)
    if (reset)
      CounterX <= 0;
    else 
      if (CounterXmaxed)
        CounterX <= 0;
      else
        CounterX <= CounterX + 1;

  always @(posedge sysclk or posedge reset)
    if (reset)
      CounterY <= 0;
    else 
      if (CounterXmaxed)
        if(CounterYmaxed)
          CounterY <= 0;
        else
          CounterY <= CounterY + 1;

  assign row = (CounterY>>5); // 32 pixels x
  assign col = (CounterX>>5); // 32 pixels (x4 bytes)
  assign vaddr = 65 + (col>>2) + (row<<2) + row; // addr = col / 4 + row * 5 
  assign vbyte = col[1] ? (col[0] ? vdata[7:0] : vdata[15:8]) : (col[0] ? vdata[23:16] : vdata[31:24]); // byte select 

  always @(posedge sysclk)
  begin
    vga_HS <= (CounterX > (640 + 16) && (CounterX < (640 + 16 + 96)));   // active for 96 clocks
    vga_VS <= (CounterY > (480 + 10) && (CounterY < (480 + 10 +  2)));   // active for  2 clocks
    inDisplayArea <= (CounterX < 640) && (CounterY < 480);
  end

  assign VGA_HS_O = ~vga_HS;
  assign VGA_VS_O = ~vga_VS;  

  assign VGA_R = inDisplayArea ? {vbyte[5:4], 2'b00} : 4'b0000;
  assign VGA_G = inDisplayArea ? {vbyte[3:2], 2'b00} : 4'b0000;
  assign VGA_B = inDisplayArea ? {vbyte[1:0], 2'b00} : 4'b0000;
endmodule

module power_on_reset(
  input sysclk, 
  output reset);

  reg q0 = 1'b0;
  reg q1 = 1'b0;
  reg q2 = 1'b0;
 
  always@(posedge sysclk)
  begin
       q0 <= 1'b1;
       q1 <= q0;
       q2 <= q1;
  end

  assign reset = !(q0 & q1 & q2);
endmodule