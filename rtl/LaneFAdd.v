module ShiftRightJam(
  input  [13:0] io_in, // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
  input  [3:0]  io_shamt, // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
  output [13:0] io_out, // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
  output        io_sticky // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
);
  wire  exceed_max_shift = io_shamt > 4'he; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 15:35]
  wire [15:0] _sticky_mask_T = 16'h1 << io_shamt; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:11]
  wire [15:0] _sticky_mask_T_2 = _sticky_mask_T - 16'h1; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:28]
  wire [13:0] _sticky_mask_T_5 = exceed_max_shift ? 14'h3fff : 14'h0; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:53]
  wire [13:0] sticky_mask = _sticky_mask_T_2[13:0] | _sticky_mask_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:47]
  wire [13:0] _io_out_T = io_in >> io_shamt; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 19:46]
  wire [13:0] _io_sticky_T = io_in & sticky_mask; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 20:23]
  assign io_out = exceed_max_shift ? 14'h0 : _io_out_T; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 19:16]
  assign io_sticky = |_io_sticky_T; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 20:38]
endmodule
module FAdd_extSig(
  input         clock,
  input         reset,
  input         io_valid_in, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_is_fp16, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_sign, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [7:0]  io_a_exp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [13:0] io_a_sig, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_sign, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [7:0]  io_b_exp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [13:0] io_b_sig, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_is_posInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_is_posInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_is_negInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_is_negInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_is_nan, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_is_nan, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_sign, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output [7:0]  io_res_exp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output [14:0] io_res_sig, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_is_posInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_is_negInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_is_nan, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_valid_out // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
`endif // RANDOMIZE_REG_INIT
  wire [13:0] shiftRight_out_shiftRightJam_io_in; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire [3:0] shiftRight_out_shiftRightJam_io_shamt; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire [13:0] shiftRight_out_shiftRightJam_io_out; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire  shiftRight_out_shiftRightJam_io_sticky; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire [8:0] exp_diff_a_minus_b = io_a_exp - io_b_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 62:34]
  wire [8:0] exp_diff_b_minus_a = io_b_exp - io_a_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 63:34]
  wire  exp_a_gte_b = ~exp_diff_a_minus_b[8]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 66:21]
  wire  a_dominates = exp_a_gte_b & |exp_diff_a_minus_b[8:4]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 69:33]
  wire  b_dominates = ~exp_diff_b_minus_a[8] & |exp_diff_b_minus_a[8:4]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 70:51]
  wire [3:0] _GEN_0 = exp_a_gte_b ? exp_diff_a_minus_b[3:0] : 4'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 78:28 79:20 82:20]
  wire [3:0] _GEN_1 = exp_a_gte_b ? 4'h0 : exp_diff_b_minus_a[3:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 78:28 80:20 83:20]
  wire [3:0] _GEN_2 = b_dominates ? 4'h0 : _GEN_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 75:28 76:20]
  wire [3:0] _GEN_3 = b_dominates ? 4'hf : _GEN_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 75:28 77:20]
  wire [3:0] shift_amount_b = a_dominates ? 4'hf : _GEN_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 72:22 73:20]
  wire [3:0] shift_amount_a = a_dominates ? 4'h0 : _GEN_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 72:22 74:20]
  wire  _shiftRight_out_T_2 = shiftRight_out_shiftRightJam_io_out[0] | shiftRight_out_shiftRightJam_io_sticky; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 92:86]
  wire [13:0] shiftRight_out = {shiftRight_out_shiftRightJam_io_out[13:1],_shiftRight_out_T_2}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 92:8]
  wire [10:0] sigPart_a = io_a_sig[13:3]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 101:43]
  wire [10:0] sigPart_b = io_b_sig[13:3]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 101:65]
  wire  exp_a_eq_b = exp_diff_a_minus_b == 9'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 102:39]
  wire  sigPart_a_gt_b = sigPart_a > sigPart_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 104:34]
  wire  abs_expSigPart_a_gt_b = exp_diff_b_minus_a[8] | exp_a_eq_b & sigPart_a_gt_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 106:42]
  wire  res_is_nan_S0 = io_a_is_nan | io_b_is_nan | io_a_is_posInf & io_b_is_negInf | io_a_is_negInf & io_b_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 122:86]
  wire  _res_is_posInf_S0_T = ~res_is_nan_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 123:26]
  wire  res_is_posInf_S0 = ~res_is_nan_S0 & (io_a_is_posInf | io_b_is_posInf); // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 123:41]
  wire  res_is_negInf_S0 = _res_is_posInf_S0_T & (io_a_is_negInf | io_b_is_negInf); // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 124:41]
  reg  io_valid_out_REG; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 129:26]
  reg  is_fp16_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 130:29]
  reg  sign_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 133:28]
  reg  sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 134:28]
  reg [7:0] exp_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 135:27]
  reg [7:0] exp_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 136:27]
  reg  abs_a_gt_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 137:32]
  reg [13:0] adderIn_a_S1_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 138:43]
  wire [14:0] adderIn_a_S1 = {1'h0,adderIn_a_S1_r}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 138:31]
  reg [13:0] adderIn_b_S1_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 139:43]
  wire [14:0] adderIn_b_S1 = {1'h0,adderIn_b_S1_r}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 139:31]
  reg  exp_a_gte_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 140:33]
  wire  a_n_b_n = sign_a_S1 & sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 142:27]
  wire  a_p_b_n = ~sign_a_S1 & sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 143:28]
  wire  a_n_b_p = sign_a_S1 & ~sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 144:27]
  wire  a_b_diffSign = a_n_b_p | a_p_b_n; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 145:30]
  wire [14:0] _adderIn_a_inv_T_2 = ~adderIn_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 152:59]
  wire [14:0] adderIn_a_inv = a_b_diffSign & ~abs_a_gt_b_S1 ? _adderIn_a_inv_T_2 : adderIn_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 152:26]
  wire [14:0] _adderIn_b_inv_T_1 = ~adderIn_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 153:58]
  wire [14:0] adderIn_b_inv = a_b_diffSign & abs_a_gt_b_S1 ? _adderIn_b_inv_T_1 : adderIn_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 153:26]
  wire [15:0] _adderOut_temp_T = {adderIn_a_inv,a_b_diffSign}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 157:26]
  wire [15:0] _adderOut_temp_T_1 = {adderIn_b_inv,a_b_diffSign}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 157:60]
  wire [15:0] adderOut_temp = _adderOut_temp_T + _adderOut_temp_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 157:55]
  wire [14:0] adderOut = adderOut_temp[15:1]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 159:31]
  wire  _sign_adderOut_T = abs_a_gt_b_S1 ? sign_a_S1 : sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 161:44]
  wire  sign_adderOut = a_b_diffSign ? _sign_adderOut_T : a_n_b_n; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 161:26]
  wire [7:0] exp_adderOut = exp_a_gte_b_S1 ? exp_a_S1 : exp_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 162:25]
  wire [1:0] adderOut_int_part = adderOut[14:13]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 163:40]
  wire [7:0] exp_adderOut_over_1 = exp_adderOut - 8'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 172:42]
  wire [13:0] _lzd_adderOut_T_1 = {adderOut[12:0],1'h1}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:58]
  wire [7:0] _GEN_41 = {{4'd0}, _lzd_adderOut_T_1[7:4]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_6 = _GEN_41 & 8'hf; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_8 = {_lzd_adderOut_T_1[3:0], 4'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_10 = _lzd_adderOut_T_8 & 8'hf0; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_11 = _lzd_adderOut_T_6 | _lzd_adderOut_T_10; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _GEN_42 = {{2'd0}, _lzd_adderOut_T_11[7:2]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_16 = _GEN_42 & 8'h33; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_18 = {_lzd_adderOut_T_11[5:0], 2'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_20 = _lzd_adderOut_T_18 & 8'hcc; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_21 = _lzd_adderOut_T_16 | _lzd_adderOut_T_20; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _GEN_43 = {{1'd0}, _lzd_adderOut_T_21[7:1]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_26 = _GEN_43 & 8'h55; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_28 = {_lzd_adderOut_T_21[6:0], 1'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_30 = _lzd_adderOut_T_28 & 8'haa; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_31 = _lzd_adderOut_T_26 | _lzd_adderOut_T_30; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [13:0] _lzd_adderOut_T_48 = {_lzd_adderOut_T_31,_lzd_adderOut_T_1[8],_lzd_adderOut_T_1[9],_lzd_adderOut_T_1[10],
    _lzd_adderOut_T_1[11],_lzd_adderOut_T_1[12],_lzd_adderOut_T_1[13]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [3:0] _lzd_adderOut_T_63 = _lzd_adderOut_T_48[12] ? 4'hc : 4'hd; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_64 = _lzd_adderOut_T_48[11] ? 4'hb : _lzd_adderOut_T_63; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_65 = _lzd_adderOut_T_48[10] ? 4'ha : _lzd_adderOut_T_64; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_66 = _lzd_adderOut_T_48[9] ? 4'h9 : _lzd_adderOut_T_65; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_67 = _lzd_adderOut_T_48[8] ? 4'h8 : _lzd_adderOut_T_66; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_68 = _lzd_adderOut_T_48[7] ? 4'h7 : _lzd_adderOut_T_67; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_69 = _lzd_adderOut_T_48[6] ? 4'h6 : _lzd_adderOut_T_68; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_70 = _lzd_adderOut_T_48[5] ? 4'h5 : _lzd_adderOut_T_69; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_71 = _lzd_adderOut_T_48[4] ? 4'h4 : _lzd_adderOut_T_70; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_72 = _lzd_adderOut_T_48[3] ? 4'h3 : _lzd_adderOut_T_71; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_73 = _lzd_adderOut_T_48[2] ? 4'h2 : _lzd_adderOut_T_72; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] _lzd_adderOut_T_74 = _lzd_adderOut_T_48[1] ? 4'h1 : _lzd_adderOut_T_73; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [3:0] lzd_adderOut = _lzd_adderOut_T_48[0] ? 4'h0 : _lzd_adderOut_T_74; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [7:0] _adderOut_is_inf_T_1 = is_fp16_S1 ? 8'h1e : 8'hfe; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 176:44]
  wire [7:0] _GEN_44 = {{4'd0}, lzd_adderOut}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:30]
  wire [7:0] _shiftLeft_amount_T_1 = exp_adderOut_over_1 + 8'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 192:47]
  wire [3:0] _shiftLeft_amount_T_3 = lzd_adderOut + 4'h2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 197:40]
  wire [3:0] _exp_adderOut_tobe_subtracted_T_2 = lzd_adderOut + 4'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 198:52]
  wire [7:0] _GEN_22 = exp_adderOut_over_1 <= _GEN_44 ? _shiftLeft_amount_T_1 : {{4'd0}, _shiftLeft_amount_T_3}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:47 192:24 197:24]
  wire [7:0] _GEN_23 = exp_adderOut_over_1 <= _GEN_44 ? exp_adderOut_over_1 : {{4'd0}, _exp_adderOut_tobe_subtracted_T_2
    }; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:47 193:36 198:36]
  wire  _GEN_24 = exp_adderOut_over_1 <= _GEN_44 ? 1'h0 : lzd_adderOut == 4'hd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:47 194:23 199:23]
  wire [7:0] _GEN_27 = adderOut_int_part[0] ? 8'h1 : _GEN_22; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 183:37 186:22]
  wire [7:0] _GEN_28 = adderOut_int_part[0] ? 8'h0 : _GEN_23; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 183:37 187:34]
  wire  _GEN_29 = adderOut_int_part[0] ? 1'h0 : _GEN_24; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 183:37 188:21]
  wire  adderOut_is_inf = adderOut_int_part[1] & exp_adderOut == _adderOut_is_inf_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 176:21]
  wire [7:0] _GEN_32 = adderOut_int_part[1] ? 8'h0 : _GEN_27; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 179:22]
  wire [7:0] exp_adderOut_tobe_subtracted = adderOut_int_part[1] ? 8'hff : _GEN_28; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 181:34]
  wire  adderOut_isZero = adderOut_int_part[1] ? 1'h0 : _GEN_29; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 182:21]
  wire [3:0] shiftLeft_amount = _GEN_32[3:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 170:30]
  wire [29:0] _GEN_4 = {{15'd0}, adderOut}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 204:40]
  wire [29:0] _sig_adderOut_shifted_T = _GEN_4 << shiftLeft_amount; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 204:40]
  wire [14:0] sig_adderOut_shifted = _sig_adderOut_shifted_T[14:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 204:60]
  wire [7:0] exp_adderOut_shifted = exp_adderOut - exp_adderOut_tobe_subtracted; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 206:43]
  reg  io_res_is_nan_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:29]
  reg  io_res_is_posInf_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:32]
  reg  io_res_is_negInf_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:32]
  ShiftRightJam shiftRight_out_shiftRightJam ( // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
    .io_in(shiftRight_out_shiftRightJam_io_in),
    .io_shamt(shiftRight_out_shiftRightJam_io_shamt),
    .io_out(shiftRight_out_shiftRightJam_io_out),
    .io_sticky(shiftRight_out_shiftRightJam_io_sticky)
  );
  assign io_res_sign = adderOut_isZero ? 1'h0 : sign_adderOut; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 209:26 210:17 214:17]
  assign io_res_exp = adderOut_isZero ? 8'h0 : exp_adderOut_shifted; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 209:26 211:16 215:16]
  assign io_res_sig = adderOut_isZero ? 15'h0 : sig_adderOut_shifted; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 209:26 212:16 216:16]
  assign io_res_is_posInf = io_res_is_posInf_r | adderOut_is_inf & ~sign_adderOut; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:64]
  assign io_res_is_negInf = io_res_is_negInf_r | adderOut_is_inf & sign_adderOut; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:64]
  assign io_res_is_nan = io_res_is_nan_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:17]
  assign io_valid_out = io_valid_out_REG; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 129:16]
  assign shiftRight_out_shiftRightJam_io_in = exp_a_gte_b ? io_b_sig : io_a_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 86:26]
  assign shiftRight_out_shiftRightJam_io_shamt = exp_a_gte_b ? shift_amount_b : shift_amount_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 87:30]
  always @(posedge clock) begin
    if (reset) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 129:26]
      io_valid_out_REG <= 1'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 129:26]
    end else begin
      io_valid_out_REG <= io_valid_in; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 129:26]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 130:29]
      is_fp16_S1 <= io_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 130:29]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 133:28]
      sign_a_S1 <= io_a_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 133:28]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 134:28]
      sign_b_S1 <= io_b_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 134:28]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 135:27]
      exp_a_S1 <= io_a_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 135:27]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 136:27]
      exp_b_S1 <= io_b_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 136:27]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 137:32]
      abs_a_gt_b_S1 <= abs_expSigPart_a_gt_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 137:32]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 138:43]
      if (exp_a_gte_b) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 118:22]
        adderIn_a_S1_r <= io_a_sig;
      end else begin
        adderIn_a_S1_r <= shiftRight_out;
      end
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 139:43]
      if (~exp_a_gte_b) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 119:22]
        adderIn_b_S1_r <= io_b_sig;
      end else begin
        adderIn_b_S1_r <= shiftRight_out;
      end
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 140:33]
      exp_a_gte_b_S1 <= exp_a_gte_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 140:33]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:29]
      io_res_is_nan_r <= res_is_nan_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:29]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:32]
      io_res_is_posInf_r <= res_is_posInf_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:32]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:32]
      io_res_is_negInf_r <= res_is_negInf_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:32]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  io_valid_out_REG = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  is_fp16_S1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  sign_a_S1 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  sign_b_S1 = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  exp_a_S1 = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  exp_b_S1 = _RAND_5[7:0];
  _RAND_6 = {1{`RANDOM}};
  abs_a_gt_b_S1 = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  adderIn_a_S1_r = _RAND_7[13:0];
  _RAND_8 = {1{`RANDOM}};
  adderIn_b_S1_r = _RAND_8[13:0];
  _RAND_9 = {1{`RANDOM}};
  exp_a_gte_b_S1 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  io_res_is_nan_r = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  io_res_is_posInf_r = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  io_res_is_negInf_r = _RAND_12[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module ShiftRightJam_1(
  input  [26:0] io_in, // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
  input  [4:0]  io_shamt, // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
  output [26:0] io_out, // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
  output        io_sticky // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 9:14]
);
  wire  exceed_max_shift = io_shamt > 5'h1b; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 15:35]
  wire [31:0] _sticky_mask_T = 32'h1 << io_shamt; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:11]
  wire [31:0] _sticky_mask_T_2 = _sticky_mask_T - 32'h1; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:28]
  wire [26:0] _sticky_mask_T_5 = exceed_max_shift ? 27'h7ffffff : 27'h0; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:53]
  wire [26:0] sticky_mask = _sticky_mask_T_2[26:0] | _sticky_mask_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 18:47]
  wire [26:0] _io_out_T = io_in >> io_shamt; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 19:46]
  wire [26:0] _io_sticky_T = io_in & sticky_mask; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 20:23]
  assign io_out = exceed_max_shift ? 27'h0 : _io_out_T; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 19:16]
  assign io_sticky = |_io_sticky_T; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 20:38]
endmodule
module FAdd_extSig_1(
  input         clock,
  input         io_valid_in, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_is_fp16, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_sign, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [7:0]  io_a_exp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [26:0] io_a_sig, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_sign, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [7:0]  io_b_exp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input  [26:0] io_b_sig, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_is_posInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_is_posInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_is_negInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_is_negInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_a_is_nan, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  input         io_b_is_nan, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_sign, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output [7:0]  io_res_exp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output [27:0] io_res_sig, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_is_posInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_is_negInf, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
  output        io_res_is_nan // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 40:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
`endif // RANDOMIZE_REG_INIT
  wire [26:0] shiftRight_out_shiftRightJam_io_in; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire [4:0] shiftRight_out_shiftRightJam_io_shamt; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire [26:0] shiftRight_out_shiftRightJam_io_out; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire  shiftRight_out_shiftRightJam_io_sticky; // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
  wire [8:0] exp_diff_a_minus_b = io_a_exp - io_b_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 62:34]
  wire [8:0] exp_diff_b_minus_a = io_b_exp - io_a_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 63:34]
  wire  exp_a_gte_b = ~exp_diff_a_minus_b[8]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 66:21]
  wire  a_dominates = exp_a_gte_b & |exp_diff_a_minus_b[8:5]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 69:33]
  wire  b_dominates = ~exp_diff_b_minus_a[8] & |exp_diff_b_minus_a[8:5]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 70:51]
  wire [4:0] _GEN_0 = exp_a_gte_b ? exp_diff_a_minus_b[4:0] : 5'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 78:28 79:20 82:20]
  wire [4:0] _GEN_1 = exp_a_gte_b ? 5'h0 : exp_diff_b_minus_a[4:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 78:28 80:20 83:20]
  wire [4:0] _GEN_2 = b_dominates ? 5'h0 : _GEN_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 75:28 76:20]
  wire [4:0] _GEN_3 = b_dominates ? 5'h1f : _GEN_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 75:28 77:20]
  wire [4:0] shift_amount_b = a_dominates ? 5'h1f : _GEN_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 72:22 73:20]
  wire [4:0] shift_amount_a = a_dominates ? 5'h0 : _GEN_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 72:22 74:20]
  wire  _shiftRight_out_T_2 = shiftRight_out_shiftRightJam_io_out[0] | shiftRight_out_shiftRightJam_io_sticky; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 92:86]
  wire [26:0] shiftRight_out = {shiftRight_out_shiftRightJam_io_out[26:1],_shiftRight_out_T_2}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 92:8]
  wire [23:0] sigPart_a = io_a_sig[26:3]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 101:43]
  wire [23:0] sigPart_b = io_b_sig[26:3]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 101:65]
  wire  exp_a_eq_b = exp_diff_a_minus_b == 9'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 102:39]
  wire  sigPart_a_gt_b = sigPart_a > sigPart_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 104:34]
  wire  abs_expSigPart_a_gt_b = exp_diff_b_minus_a[8] | exp_a_eq_b & sigPart_a_gt_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 106:42]
  wire  res_is_nan_S0 = io_a_is_nan | io_b_is_nan | io_a_is_posInf & io_b_is_negInf | io_a_is_negInf & io_b_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 122:86]
  wire  _res_is_posInf_S0_T = ~res_is_nan_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 123:26]
  wire  res_is_posInf_S0 = ~res_is_nan_S0 & (io_a_is_posInf | io_b_is_posInf); // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 123:41]
  wire  res_is_negInf_S0 = _res_is_posInf_S0_T & (io_a_is_negInf | io_b_is_negInf); // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 124:41]
  reg  is_fp16_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 130:29]
  reg  sign_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 133:28]
  reg  sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 134:28]
  reg [7:0] exp_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 135:27]
  reg [7:0] exp_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 136:27]
  reg  abs_a_gt_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 137:32]
  reg [26:0] adderIn_a_S1_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 138:43]
  wire [27:0] adderIn_a_S1 = {1'h0,adderIn_a_S1_r}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 138:31]
  reg [26:0] adderIn_b_S1_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 139:43]
  wire [27:0] adderIn_b_S1 = {1'h0,adderIn_b_S1_r}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 139:31]
  reg  exp_a_gte_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 140:33]
  wire  a_n_b_n = sign_a_S1 & sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 142:27]
  wire  a_p_b_n = ~sign_a_S1 & sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 143:28]
  wire  a_n_b_p = sign_a_S1 & ~sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 144:27]
  wire  a_b_diffSign = a_n_b_p | a_p_b_n; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 145:30]
  wire [27:0] _adderIn_a_inv_T_2 = ~adderIn_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 152:59]
  wire [27:0] adderIn_a_inv = a_b_diffSign & ~abs_a_gt_b_S1 ? _adderIn_a_inv_T_2 : adderIn_a_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 152:26]
  wire [27:0] _adderIn_b_inv_T_1 = ~adderIn_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 153:58]
  wire [27:0] adderIn_b_inv = a_b_diffSign & abs_a_gt_b_S1 ? _adderIn_b_inv_T_1 : adderIn_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 153:26]
  wire [28:0] _adderOut_temp_T = {adderIn_a_inv,a_b_diffSign}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 157:26]
  wire [28:0] _adderOut_temp_T_1 = {adderIn_b_inv,a_b_diffSign}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 157:60]
  wire [28:0] adderOut_temp = _adderOut_temp_T + _adderOut_temp_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 157:55]
  wire [27:0] adderOut = adderOut_temp[28:1]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 159:31]
  wire  _sign_adderOut_T = abs_a_gt_b_S1 ? sign_a_S1 : sign_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 161:44]
  wire  sign_adderOut = a_b_diffSign ? _sign_adderOut_T : a_n_b_n; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 161:26]
  wire [7:0] exp_adderOut = exp_a_gte_b_S1 ? exp_a_S1 : exp_b_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 162:25]
  wire [1:0] adderOut_int_part = adderOut[27:26]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 163:40]
  wire [7:0] exp_adderOut_over_1 = exp_adderOut - 8'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 172:42]
  wire [26:0] _lzd_adderOut_T_1 = {adderOut[25:0],1'h1}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:58]
  wire [15:0] _GEN_41 = {{8'd0}, _lzd_adderOut_T_1[15:8]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_6 = _GEN_41 & 16'hff; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_8 = {_lzd_adderOut_T_1[7:0], 8'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_10 = _lzd_adderOut_T_8 & 16'hff00; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_11 = _lzd_adderOut_T_6 | _lzd_adderOut_T_10; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _GEN_42 = {{4'd0}, _lzd_adderOut_T_11[15:4]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_16 = _GEN_42 & 16'hf0f; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_18 = {_lzd_adderOut_T_11[11:0], 4'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_20 = _lzd_adderOut_T_18 & 16'hf0f0; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_21 = _lzd_adderOut_T_16 | _lzd_adderOut_T_20; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _GEN_43 = {{2'd0}, _lzd_adderOut_T_21[15:2]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_26 = _GEN_43 & 16'h3333; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_28 = {_lzd_adderOut_T_21[13:0], 2'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_30 = _lzd_adderOut_T_28 & 16'hcccc; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_31 = _lzd_adderOut_T_26 | _lzd_adderOut_T_30; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _GEN_44 = {{1'd0}, _lzd_adderOut_T_31[15:1]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_36 = _GEN_44 & 16'h5555; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_38 = {_lzd_adderOut_T_31[14:0], 1'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_40 = _lzd_adderOut_T_38 & 16'haaaa; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [15:0] _lzd_adderOut_T_41 = _lzd_adderOut_T_36 | _lzd_adderOut_T_40; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _GEN_45 = {{4'd0}, _lzd_adderOut_T_1[23:20]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_47 = _GEN_45 & 8'hf; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_49 = {_lzd_adderOut_T_1[19:16], 4'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_51 = _lzd_adderOut_T_49 & 8'hf0; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_52 = _lzd_adderOut_T_47 | _lzd_adderOut_T_51; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _GEN_46 = {{2'd0}, _lzd_adderOut_T_52[7:2]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_57 = _GEN_46 & 8'h33; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_59 = {_lzd_adderOut_T_52[5:0], 2'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_61 = _lzd_adderOut_T_59 & 8'hcc; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_62 = _lzd_adderOut_T_57 | _lzd_adderOut_T_61; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _GEN_47 = {{1'd0}, _lzd_adderOut_T_62[7:1]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_67 = _GEN_47 & 8'h55; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_69 = {_lzd_adderOut_T_62[6:0], 1'h0}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_71 = _lzd_adderOut_T_69 & 8'haa; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [7:0] _lzd_adderOut_T_72 = _lzd_adderOut_T_67 | _lzd_adderOut_T_71; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [26:0] _lzd_adderOut_T_81 = {_lzd_adderOut_T_41,_lzd_adderOut_T_72,_lzd_adderOut_T_1[24],_lzd_adderOut_T_1[25],
    _lzd_adderOut_T_1[26]}; // @[src/main/scala/vpu/exu/yunsuan/Utils.scala 7:54]
  wire [4:0] _lzd_adderOut_T_109 = _lzd_adderOut_T_81[25] ? 5'h19 : 5'h1a; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_110 = _lzd_adderOut_T_81[24] ? 5'h18 : _lzd_adderOut_T_109; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_111 = _lzd_adderOut_T_81[23] ? 5'h17 : _lzd_adderOut_T_110; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_112 = _lzd_adderOut_T_81[22] ? 5'h16 : _lzd_adderOut_T_111; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_113 = _lzd_adderOut_T_81[21] ? 5'h15 : _lzd_adderOut_T_112; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_114 = _lzd_adderOut_T_81[20] ? 5'h14 : _lzd_adderOut_T_113; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_115 = _lzd_adderOut_T_81[19] ? 5'h13 : _lzd_adderOut_T_114; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_116 = _lzd_adderOut_T_81[18] ? 5'h12 : _lzd_adderOut_T_115; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_117 = _lzd_adderOut_T_81[17] ? 5'h11 : _lzd_adderOut_T_116; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_118 = _lzd_adderOut_T_81[16] ? 5'h10 : _lzd_adderOut_T_117; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_119 = _lzd_adderOut_T_81[15] ? 5'hf : _lzd_adderOut_T_118; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_120 = _lzd_adderOut_T_81[14] ? 5'he : _lzd_adderOut_T_119; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_121 = _lzd_adderOut_T_81[13] ? 5'hd : _lzd_adderOut_T_120; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_122 = _lzd_adderOut_T_81[12] ? 5'hc : _lzd_adderOut_T_121; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_123 = _lzd_adderOut_T_81[11] ? 5'hb : _lzd_adderOut_T_122; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_124 = _lzd_adderOut_T_81[10] ? 5'ha : _lzd_adderOut_T_123; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_125 = _lzd_adderOut_T_81[9] ? 5'h9 : _lzd_adderOut_T_124; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_126 = _lzd_adderOut_T_81[8] ? 5'h8 : _lzd_adderOut_T_125; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_127 = _lzd_adderOut_T_81[7] ? 5'h7 : _lzd_adderOut_T_126; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_128 = _lzd_adderOut_T_81[6] ? 5'h6 : _lzd_adderOut_T_127; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_129 = _lzd_adderOut_T_81[5] ? 5'h5 : _lzd_adderOut_T_128; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_130 = _lzd_adderOut_T_81[4] ? 5'h4 : _lzd_adderOut_T_129; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_131 = _lzd_adderOut_T_81[3] ? 5'h3 : _lzd_adderOut_T_130; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_132 = _lzd_adderOut_T_81[2] ? 5'h2 : _lzd_adderOut_T_131; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] _lzd_adderOut_T_133 = _lzd_adderOut_T_81[1] ? 5'h1 : _lzd_adderOut_T_132; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [4:0] lzd_adderOut = _lzd_adderOut_T_81[0] ? 5'h0 : _lzd_adderOut_T_133; // @[src/main/scala/chisel3/util/Mux.scala 50:70]
  wire [7:0] _adderOut_is_inf_T_1 = is_fp16_S1 ? 8'h1e : 8'hfe; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 176:44]
  wire [7:0] _GEN_48 = {{3'd0}, lzd_adderOut}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:30]
  wire [7:0] _shiftLeft_amount_T_1 = exp_adderOut_over_1 + 8'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 192:47]
  wire [4:0] _shiftLeft_amount_T_3 = lzd_adderOut + 5'h2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 197:40]
  wire [4:0] _exp_adderOut_tobe_subtracted_T_2 = lzd_adderOut + 5'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 198:52]
  wire [7:0] _GEN_22 = exp_adderOut_over_1 <= _GEN_48 ? _shiftLeft_amount_T_1 : {{3'd0}, _shiftLeft_amount_T_3}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:47 192:24 197:24]
  wire [7:0] _GEN_23 = exp_adderOut_over_1 <= _GEN_48 ? exp_adderOut_over_1 : {{3'd0}, _exp_adderOut_tobe_subtracted_T_2
    }; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:47 193:36 198:36]
  wire  _GEN_24 = exp_adderOut_over_1 <= _GEN_48 ? 1'h0 : lzd_adderOut == 5'h1a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 190:47 194:23 199:23]
  wire [7:0] _GEN_27 = adderOut_int_part[0] ? 8'h1 : _GEN_22; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 183:37 186:22]
  wire [7:0] _GEN_28 = adderOut_int_part[0] ? 8'h0 : _GEN_23; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 183:37 187:34]
  wire  _GEN_29 = adderOut_int_part[0] ? 1'h0 : _GEN_24; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 183:37 188:21]
  wire  adderOut_is_inf = adderOut_int_part[1] & exp_adderOut == _adderOut_is_inf_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 176:21]
  wire [7:0] _GEN_32 = adderOut_int_part[1] ? 8'h0 : _GEN_27; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 179:22]
  wire [7:0] exp_adderOut_tobe_subtracted = adderOut_int_part[1] ? 8'hff : _GEN_28; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 181:34]
  wire  adderOut_isZero = adderOut_int_part[1] ? 1'h0 : _GEN_29; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 174:31 182:21]
  wire [4:0] shiftLeft_amount = _GEN_32[4:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 170:30]
  wire [58:0] _GEN_4 = {{31'd0}, adderOut}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 204:40]
  wire [58:0] _sig_adderOut_shifted_T = _GEN_4 << shiftLeft_amount; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 204:40]
  wire [27:0] sig_adderOut_shifted = _sig_adderOut_shifted_T[27:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 204:60]
  wire [7:0] exp_adderOut_shifted = exp_adderOut - exp_adderOut_tobe_subtracted; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 206:43]
  reg  io_res_is_nan_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:29]
  reg  io_res_is_posInf_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:32]
  reg  io_res_is_negInf_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:32]
  ShiftRightJam_1 shiftRight_out_shiftRightJam ( // @[src/main/scala/vpu/exu/laneexu/fp/FpUtils.scala 25:31]
    .io_in(shiftRight_out_shiftRightJam_io_in),
    .io_shamt(shiftRight_out_shiftRightJam_io_shamt),
    .io_out(shiftRight_out_shiftRightJam_io_out),
    .io_sticky(shiftRight_out_shiftRightJam_io_sticky)
  );
  assign io_res_sign = adderOut_isZero ? 1'h0 : sign_adderOut; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 209:26 210:17 214:17]
  assign io_res_exp = adderOut_isZero ? 8'h0 : exp_adderOut_shifted; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 209:26 211:16 215:16]
  assign io_res_sig = adderOut_isZero ? 28'h0 : sig_adderOut_shifted; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 209:26 212:16 216:16]
  assign io_res_is_posInf = io_res_is_posInf_r | adderOut_is_inf & ~sign_adderOut; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:64]
  assign io_res_is_negInf = io_res_is_negInf_r | adderOut_is_inf & sign_adderOut; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:64]
  assign io_res_is_nan = io_res_is_nan_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:17]
  assign shiftRight_out_shiftRightJam_io_in = exp_a_gte_b ? io_b_sig : io_a_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 86:26]
  assign shiftRight_out_shiftRightJam_io_shamt = exp_a_gte_b ? shift_amount_b : shift_amount_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 87:30]
  always @(posedge clock) begin
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 130:29]
      is_fp16_S1 <= io_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 130:29]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 133:28]
      sign_a_S1 <= io_a_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 133:28]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 134:28]
      sign_b_S1 <= io_b_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 134:28]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 135:27]
      exp_a_S1 <= io_a_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 135:27]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 136:27]
      exp_b_S1 <= io_b_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 136:27]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 137:32]
      abs_a_gt_b_S1 <= abs_expSigPart_a_gt_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 137:32]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 138:43]
      if (exp_a_gte_b) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 118:22]
        adderIn_a_S1_r <= io_a_sig;
      end else begin
        adderIn_a_S1_r <= shiftRight_out;
      end
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 139:43]
      if (~exp_a_gte_b) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 119:22]
        adderIn_b_S1_r <= io_b_sig;
      end else begin
        adderIn_b_S1_r <= shiftRight_out;
      end
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 140:33]
      exp_a_gte_b_S1 <= exp_a_gte_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 140:33]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:29]
      io_res_is_nan_r <= res_is_nan_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 219:29]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:32]
      io_res_is_posInf_r <= res_is_posInf_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 220:32]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:32]
      io_res_is_negInf_r <= res_is_negInf_S0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_extSig.scala 221:32]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  is_fp16_S1 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  sign_a_S1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  sign_b_S1 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  exp_a_S1 = _RAND_3[7:0];
  _RAND_4 = {1{`RANDOM}};
  exp_b_S1 = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  abs_a_gt_b_S1 = _RAND_5[0:0];
  _RAND_6 = {1{`RANDOM}};
  adderIn_a_S1_r = _RAND_6[26:0];
  _RAND_7 = {1{`RANDOM}};
  adderIn_b_S1_r = _RAND_7[26:0];
  _RAND_8 = {1{`RANDOM}};
  exp_a_gte_b_S1 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  io_res_is_nan_r = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  io_res_is_posInf_r = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  io_res_is_negInf_r = _RAND_11[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module FAdd_16_32(
  input         clock,
  input         reset,
  input         io_valid_in, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  input         io_is_bf16, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  input         io_is_fp16, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  input         io_is_fp32, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  input         io_is_widen, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  input         io_a_already_widen, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  input  [31:0] io_a, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  input  [31:0] io_b, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  output [31:0] io_res, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  output        io_valid_out, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
  output        io_valid_S1 // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 29:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
`endif // RANDOMIZE_REG_INIT
  wire  fadd_extSig_fp19_clock; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_reset; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_valid_in; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_a_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire [7:0] fadd_extSig_fp19_io_a_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire [13:0] fadd_extSig_fp19_io_a_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_b_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire [7:0] fadd_extSig_fp19_io_b_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire [13:0] fadd_extSig_fp19_io_b_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_a_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_b_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_a_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_b_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_a_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_b_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_res_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire [7:0] fadd_extSig_fp19_io_res_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire [14:0] fadd_extSig_fp19_io_res_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_res_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_res_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_res_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp19_io_valid_out; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
  wire  fadd_extSig_fp32_clock; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_valid_in; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_a_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire [7:0] fadd_extSig_fp32_io_a_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire [26:0] fadd_extSig_fp32_io_a_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_b_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire [7:0] fadd_extSig_fp32_io_b_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire [26:0] fadd_extSig_fp32_io_b_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_a_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_b_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_a_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_b_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_a_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_b_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_res_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire [7:0] fadd_extSig_fp32_io_res_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire [27:0] fadd_extSig_fp32_io_res_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_res_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_res_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  fadd_extSig_fp32_io_res_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
  wire  is_16 = io_is_fp16 | io_is_bf16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 41:23]
  wire  res_is_32 = io_is_widen | io_is_fp32; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 43:25]
  wire  _res_is_bf16_T = ~io_is_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 44:32]
  wire  res_is_fp16 = io_is_fp16 & _res_is_bf16_T; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 45:29]
  wire  sign_low_a = io_a[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:65]
  wire  sign_low_b = io_b[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:75]
  wire  sign_high_a = io_a[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:85]
  wire  sign_high_b = io_b[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:95]
  wire [7:0] exp_high_a = io_is_fp16 ? {{3'd0}, io_a[30:26]} : io_a[30:23]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 49:20]
  wire [7:0] exp_low_a = io_is_fp16 ? {{3'd0}, io_a[14:10]} : io_a[14:7]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 50:19]
  wire [7:0] exp_high_b = io_is_fp16 ? {{3'd0}, io_b[30:26]} : io_b[30:23]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 51:20]
  wire [7:0] exp_low_b = io_is_fp16 ? {{3'd0}, io_b[14:10]} : io_b[14:7]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 52:19]
  wire [9:0] _frac_high_a_16_T_2 = {io_a[22:16],3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 56:56]
  wire [9:0] frac_high_a_16 = io_is_fp16 ? io_a[25:16] : _frac_high_a_16_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 56:24]
  wire [9:0] _frac_low_a_16_T_2 = {io_a[6:0],3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 57:53]
  wire [9:0] frac_low_a_16 = io_is_fp16 ? io_a[9:0] : _frac_low_a_16_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 57:23]
  wire [9:0] _frac_high_b_16_T_2 = {io_b[22:16],3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 58:56]
  wire [9:0] frac_high_b_16 = io_is_fp16 ? io_b[25:16] : _frac_high_b_16_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 58:24]
  wire [9:0] _frac_low_b_16_T_2 = {io_b[6:0],3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 59:53]
  wire [9:0] frac_low_b_16 = io_is_fp16 ? io_b[9:0] : _frac_low_b_16_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 59:23]
  wire [22:0] frac_a_32 = io_a[22:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 60:23]
  wire [22:0] frac_b_32 = io_b[22:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 61:23]
  wire  exp_is_0_0 = exp_low_a == 8'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 69:65]
  wire  exp_is_0_1 = exp_low_b == 8'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 69:65]
  wire  exp_is_0_2 = exp_high_a == 8'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 69:65]
  wire  exp_is_0_3 = exp_high_b == 8'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 69:65]
  wire  frac_is_0_16_0 = frac_low_a_16 == 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 70:75]
  wire  frac_is_0_16_1 = frac_low_b_16 == 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 70:75]
  wire  frac_is_0_16_2 = frac_high_a_16 == 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 70:75]
  wire  frac_is_0_16_3 = frac_high_b_16 == 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 70:75]
  wire [7:0] _exp_is_all1s_0_T = io_is_fp16 ? 8'h1f : 8'hff; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 72:28]
  wire  exp_is_all1s_0 = exp_low_a == _exp_is_all1s_0_T; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 72:21]
  wire  exp_is_all1s_1 = exp_low_b == _exp_is_all1s_0_T; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 72:21]
  wire  exp_is_all1s_2 = exp_high_a == _exp_is_all1s_0_T; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 72:21]
  wire  exp_is_all1s_3 = exp_high_b == _exp_is_all1s_0_T; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 72:21]
  wire  frac_is_0_32_0 = frac_a_32 == 23'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 76:75]
  wire  frac_is_0_32_1 = frac_b_32 == 23'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 76:75]
  wire  is_inf_16_0 = exp_is_all1s_0 & frac_is_0_16_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 84:93]
  wire  is_inf_16_1 = exp_is_all1s_1 & frac_is_0_16_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 84:93]
  wire  is_inf_16_2 = exp_is_all1s_2 & frac_is_0_16_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 84:93]
  wire  is_inf_16_3 = exp_is_all1s_3 & frac_is_0_16_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 84:93]
  wire  is_inf_32_0 = exp_is_all1s_2 & frac_is_0_32_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 85:101]
  wire  is_inf_32_1 = exp_is_all1s_3 & frac_is_0_32_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 85:101]
  wire  is_nan_16_2 = exp_is_all1s_2 & ~frac_is_0_16_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 86:93]
  wire  is_nan_16_3 = exp_is_all1s_3 & ~frac_is_0_16_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 86:93]
  wire  is_nan_32_0 = exp_is_all1s_2 & ~frac_is_0_32_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 87:101]
  wire  is_nan_32_1 = exp_is_all1s_3 & ~frac_is_0_32_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 87:101]
  wire  is_subnorm_0 = is_16 & exp_is_0_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 89:23]
  wire  is_subnorm_1 = is_16 & exp_is_0_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 89:23]
  wire  is_fp16_widen = io_is_fp16 & io_is_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 93:31]
  wire [7:0] _exp_adjust_subnorm_2_T = exp_is_0_2 ? 8'h1 : exp_high_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 97:31]
  wire  _exp_adjust_subnorm_2_T_1 = ~io_a_already_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 97:86]
  wire [6:0] _exp_adjust_subnorm_2_T_3 = is_fp16_widen & ~io_a_already_widen ? 7'h70 : 7'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 97:68]
  wire [7:0] _GEN_18 = {{1'd0}, _exp_adjust_subnorm_2_T_3}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 97:63]
  wire [7:0] _exp_adjust_subnorm_3_T = exp_is_0_3 ? 8'h1 : exp_high_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 98:31]
  wire [6:0] _exp_adjust_subnorm_3_T_1 = is_fp16_widen ? 7'h70 : 7'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 98:68]
  wire [7:0] _GEN_19 = {{1'd0}, _exp_adjust_subnorm_3_T_1}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 98:63]
  wire  _sig_adjust_subnorm_16_0_T = is_subnorm_0 ? 1'h0 : 1'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 104:36]
  wire [10:0] sig_adjust_subnorm_16_0 = {_sig_adjust_subnorm_16_0_T,frac_low_a_16}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 104:72]
  wire  _sig_adjust_subnorm_16_1_T = is_subnorm_1 ? 1'h0 : 1'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 104:36]
  wire [10:0] sig_adjust_subnorm_16_1 = {_sig_adjust_subnorm_16_1_T,frac_low_b_16}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 104:72]
  wire  _sig_adjust_subnorm_16_2_T = exp_is_0_2 ? 1'h0 : 1'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 104:36]
  wire  _sig_adjust_subnorm_16_3_T = exp_is_0_3 ? 1'h0 : 1'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 104:36]
  wire [23:0] sig_adjust_subnorm_32_0 = {_sig_adjust_subnorm_16_2_T,frac_a_32}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 109:74]
  wire [23:0] sig_adjust_subnorm_32_1 = {_sig_adjust_subnorm_16_3_T,frac_b_32}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 109:74]
  wire [23:0] _sig_adjust_subnorm_high_a_T_2 = {_sig_adjust_subnorm_16_2_T,frac_high_a_16,13'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 132:94]
  wire [23:0] sig_adjust_subnorm_high_a = is_16 & _exp_adjust_subnorm_2_T_1 ? _sig_adjust_subnorm_high_a_T_2 :
    sig_adjust_subnorm_32_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 132:38]
  wire [23:0] _sig_adjust_subnorm_high_b_T = {_sig_adjust_subnorm_16_3_T,frac_high_b_16,13'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 133:71]
  wire [23:0] sig_adjust_subnorm_high_b = is_16 ? _sig_adjust_subnorm_high_b_T : sig_adjust_subnorm_32_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 133:38]
  wire  _fadd_extSig_fp32_io_a_is_posInf_T = is_16 ? is_inf_16_2 : is_inf_32_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 140:41]
  wire  _fadd_extSig_fp32_io_b_is_posInf_T = is_16 ? is_inf_16_3 : is_inf_32_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 142:41]
  reg  res_is_32_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 161:31]
  reg  res_is_fp16_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 163:33]
  reg  valid_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 168:25]
  reg  res_extSig_fp19_S2_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
  reg [7:0] res_extSig_fp19_S2_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
  reg [14:0] res_extSig_fp19_S2_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
  reg  res_extSig_fp32_S2_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
  reg [7:0] res_extSig_fp32_S2_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
  reg [27:0] res_extSig_fp32_S2_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
  reg  res_is_32_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 171:31]
  reg  res_is_fp16_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 173:33]
  reg  res_is_posInf_high_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 175:40]
  reg  res_is_negInf_high_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 176:40]
  reg  res_is_nan_high_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 177:37]
  reg  res_is_posInf_low_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 178:39]
  reg  res_is_negInf_low_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 179:39]
  reg  res_is_nan_low_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 180:36]
  wire  lsb_adderOut_low_fp16 = res_extSig_fp19_S2_sig[4]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 189:50]
  wire  g_adderOut_low_fp16 = res_extSig_fp19_S2_sig[3]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 190:48]
  wire  s_adderOut_low_fp16 = |res_extSig_fp19_S2_sig[2:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 191:75]
  wire [10:0] sig_adderOut_low_fp16 = res_extSig_fp19_S2_sig[14:4]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 192:55]
  wire  lsb_adderOut_low_bf16 = res_extSig_fp19_S2_sig[7]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 194:50]
  wire  g_adderOut_low_bf16 = res_extSig_fp19_S2_sig[6]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 195:48]
  wire  s_adderOut_low_bf16 = |res_extSig_fp19_S2_sig[5:3] | s_adderOut_low_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 196:99]
  wire  lsb_adderOut_high_fp32 = res_extSig_fp32_S2_sig[4]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 201:51]
  wire  g_adderOut_high_fp32 = res_extSig_fp32_S2_sig[3]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 202:49]
  wire  s_adderOut_high_fp32 = |res_extSig_fp32_S2_sig[2:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 203:76]
  wire [23:0] sig_adderOut_high_fp32 = res_extSig_fp32_S2_sig[27:4]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 204:56]
  wire  lsb_adderOut_high_fp16 = res_extSig_fp32_S2_sig[17]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 206:51]
  wire  g_adderOut_high_fp16 = res_extSig_fp32_S2_sig[16]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 207:49]
  wire  s_adderOut_high_fp16 = |res_extSig_fp32_S2_sig[15:3] | s_adderOut_high_fp32; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 208:101]
  wire  lsb_adderOut_high_bf16 = res_extSig_fp32_S2_sig[20]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 212:51]
  wire  g_adderOut_high_bf16 = res_extSig_fp32_S2_sig[19]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 213:49]
  wire  s_adderOut_high_bf16 = |res_extSig_fp32_S2_sig[18:16] | s_adderOut_high_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 214:106]
  wire  _rnd_cin_low_fp16_T_1 = s_adderOut_low_fp16 | lsb_adderOut_low_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 221:30]
  wire  rnd_cin_low_fp16 = ~g_adderOut_low_fp16 ? 1'h0 : _rnd_cin_low_fp16_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 220:29]
  wire  _rnd_cin_low_bf16_T_1 = s_adderOut_low_bf16 | lsb_adderOut_low_bf16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 223:30]
  wire  rnd_cin_low_bf16 = ~g_adderOut_low_bf16 ? 1'h0 : _rnd_cin_low_bf16_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 222:29]
  wire [3:0] _sig_res_low_tmp_T = {rnd_cin_low_bf16, 3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 225:82]
  wire [3:0] _sig_res_low_tmp_T_1 = res_is_fp16_S2 ? {{3'd0}, rnd_cin_low_fp16} : _sig_res_low_tmp_T; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 225:16]
  wire [10:0] _GEN_20 = {{7'd0}, _sig_res_low_tmp_T_1}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 224:47]
  wire [11:0] sig_res_low_tmp = sig_adderOut_low_fp16 + _GEN_20; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 224:47]
  wire [10:0] sig_res_low = sig_res_low_tmp[11] ? sig_res_low_tmp[11:1] : sig_res_low_tmp[10:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 226:24]
  wire [7:0] _GEN_21 = {{7'd0}, sig_res_low_tmp[11]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 228:48]
  wire [7:0] exp_adjust_res_low = res_extSig_fp19_S2_exp + _GEN_21; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 228:48]
  wire  _isInf_res_low_T_1 = ~res_is_fp16_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 230:17]
  wire  _isInf_res_low_T_4 = ~res_is_fp16_S2 ? res_extSig_fp19_S2_exp == 8'hfe : res_extSig_fp19_S2_exp == 8'h1e; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 230:16]
  wire  isInf_res_low = sig_res_low_tmp[11] & _isInf_res_low_T_4; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 229:53]
  wire [7:0] exp_res_low = exp_adjust_res_low == 8'h1 & ~sig_res_low[10] ? 8'h0 : exp_adjust_res_low; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 231:24]
  wire  _rnd_cin_high_fp32_T_1 = s_adderOut_high_fp32 | lsb_adderOut_high_fp32; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 235:30]
  wire  rnd_cin_high_fp32 = ~g_adderOut_high_fp32 ? 1'h0 : _rnd_cin_high_fp32_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 234:30]
  wire  _rnd_cin_high_fp16_T_1 = s_adderOut_high_fp16 | lsb_adderOut_high_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 237:30]
  wire  rnd_cin_high_fp16 = ~g_adderOut_high_fp16 ? 1'h0 : _rnd_cin_high_fp16_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 236:30]
  wire  _rnd_cin_high_bf16_T_1 = s_adderOut_high_bf16 | lsb_adderOut_high_bf16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 239:30]
  wire  rnd_cin_high_bf16 = ~g_adderOut_high_bf16 ? 1'h0 : _rnd_cin_high_bf16_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 238:30]
  wire [13:0] _sig_res_high_tmp_T = {rnd_cin_high_fp16, 13'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 241:58]
  wire [16:0] _sig_res_high_tmp_T_1 = {rnd_cin_high_bf16, 16'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 241:90]
  wire [16:0] _sig_res_high_tmp_T_2 = res_is_fp16_S2 ? {{3'd0}, _sig_res_high_tmp_T} : _sig_res_high_tmp_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 241:16]
  wire [16:0] _sig_res_high_tmp_T_3 = res_is_32_S2 ? {{16'd0}, rnd_cin_high_fp32} : _sig_res_high_tmp_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 240:55]
  wire [23:0] _GEN_22 = {{7'd0}, _sig_res_high_tmp_T_3}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 240:49]
  wire [24:0] sig_res_high_tmp = sig_adderOut_high_fp32 + _GEN_22; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 240:49]
  wire [23:0] sig_res_high = sig_res_high_tmp[24] ? sig_res_high_tmp[24:1] : sig_res_high_tmp[23:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 242:25]
  wire [7:0] _GEN_23 = {{7'd0}, sig_res_high_tmp[24]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 244:49]
  wire [7:0] exp_adjust_res_high = res_extSig_fp32_S2_exp + _GEN_23; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 244:49]
  wire  _isInf_res_high_T_4 = _isInf_res_low_T_1 ? res_extSig_fp32_S2_exp == 8'hfe : res_extSig_fp32_S2_exp == 8'h1e; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 246:16]
  wire  isInf_res_high = sig_res_high_tmp[24] & _isInf_res_high_T_4; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 245:55]
  wire [7:0] exp_res_high = exp_adjust_res_high == 8'h1 & ~sig_res_high[23] ? 8'h0 : exp_adjust_res_high; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 247:25]
  wire [15:0] resFinal_fp16_low_tmp = {res_extSig_fp19_S2_sign,exp_res_low[4:0],sig_res_low[9:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 252:34]
  wire [15:0] resFinal_bf16_low_tmp = {res_extSig_fp19_S2_sign,exp_res_low,sig_res_low[9:3]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 253:34]
  wire [31:0] resFinal_32_high_tmp = {res_extSig_fp32_S2_sign,exp_res_high,sig_res_high[22:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 254:33]
  wire [15:0] resFinal_fp16_high_tmp = {res_extSig_fp32_S2_sign,exp_res_high[4:0],sig_res_high[22:13]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 255:35]
  wire [15:0] resFinal_bf16_high_tmp = {res_extSig_fp32_S2_sign,exp_res_high,sig_res_high[22:16]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 256:35]
  wire [31:0] _resFinal_32_high_T_2 = {res_extSig_fp32_S2_sign,8'hff,23'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 267:63]
  wire [31:0] _resFinal_32_high_T_3 = isInf_res_high ? _resFinal_32_high_T_2 : resFinal_32_high_tmp; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _resFinal_32_high_T_4 = res_is_negInf_high_S2 ? 32'hff800000 : _resFinal_32_high_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _resFinal_32_high_T_5 = res_is_posInf_high_S2 ? 32'h7f800000 : _resFinal_32_high_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] resFinal_32_high = res_is_nan_high_S2 ? 32'h7fc00000 : _resFinal_32_high_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_bf16_high_T_2 = {res_extSig_fp32_S2_sign,8'hff,7'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 273:63]
  wire [15:0] _resFinal_bf16_high_T_3 = isInf_res_high ? _resFinal_bf16_high_T_2 : resFinal_bf16_high_tmp; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_bf16_high_T_4 = res_is_negInf_high_S2 ? 16'hff80 : _resFinal_bf16_high_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_bf16_high_T_5 = res_is_posInf_high_S2 ? 16'h7f80 : _resFinal_bf16_high_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] resFinal_bf16_high = res_is_nan_high_S2 ? 16'h7fc0 : _resFinal_bf16_high_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_fp16_high_T_2 = {res_extSig_fp32_S2_sign,5'h1f,10'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 279:63]
  wire [15:0] _resFinal_fp16_high_T_3 = isInf_res_high ? _resFinal_fp16_high_T_2 : resFinal_fp16_high_tmp; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_fp16_high_T_4 = res_is_negInf_high_S2 ? 16'hfc00 : _resFinal_fp16_high_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_fp16_high_T_5 = res_is_posInf_high_S2 ? 16'h7c00 : _resFinal_fp16_high_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] resFinal_fp16_high = res_is_nan_high_S2 ? 16'h7e00 : _resFinal_fp16_high_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_bf16_low_T_2 = {res_extSig_fp19_S2_sign,8'hff,7'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 285:62]
  wire [15:0] _resFinal_bf16_low_T_3 = isInf_res_low ? _resFinal_bf16_low_T_2 : resFinal_bf16_low_tmp; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_bf16_low_T_4 = res_is_negInf_low_S2 ? 16'hff80 : _resFinal_bf16_low_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_bf16_low_T_5 = res_is_posInf_low_S2 ? 16'h7f80 : _resFinal_bf16_low_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] resFinal_bf16_low = res_is_nan_low_S2 ? 16'h7fc0 : _resFinal_bf16_low_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_fp16_low_T_2 = {res_extSig_fp19_S2_sign,5'h1f,10'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 291:62]
  wire [15:0] _resFinal_fp16_low_T_3 = isInf_res_low ? _resFinal_fp16_low_T_2 : resFinal_fp16_low_tmp; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_fp16_low_T_4 = res_is_negInf_low_S2 ? 16'hfc00 : _resFinal_fp16_low_T_3; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] _resFinal_fp16_low_T_5 = res_is_posInf_low_S2 ? 16'h7c00 : _resFinal_fp16_low_T_4; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [15:0] resFinal_fp16_low = res_is_nan_low_S2 ? 16'h7e00 : _resFinal_fp16_low_T_5; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  wire [31:0] _io_res_T = {resFinal_fp16_high,resFinal_fp16_low}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 300:36]
  wire [31:0] _io_res_T_1 = {resFinal_bf16_high,resFinal_bf16_low}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 301:20]
  wire [31:0] _io_res_T_2 = res_is_fp16_S2 ? _io_res_T : _io_res_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 300:16]
  FAdd_extSig fadd_extSig_fp19 ( // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 113:32]
    .clock(fadd_extSig_fp19_clock),
    .reset(fadd_extSig_fp19_reset),
    .io_valid_in(fadd_extSig_fp19_io_valid_in),
    .io_is_fp16(fadd_extSig_fp19_io_is_fp16),
    .io_a_sign(fadd_extSig_fp19_io_a_sign),
    .io_a_exp(fadd_extSig_fp19_io_a_exp),
    .io_a_sig(fadd_extSig_fp19_io_a_sig),
    .io_b_sign(fadd_extSig_fp19_io_b_sign),
    .io_b_exp(fadd_extSig_fp19_io_b_exp),
    .io_b_sig(fadd_extSig_fp19_io_b_sig),
    .io_a_is_posInf(fadd_extSig_fp19_io_a_is_posInf),
    .io_b_is_posInf(fadd_extSig_fp19_io_b_is_posInf),
    .io_a_is_negInf(fadd_extSig_fp19_io_a_is_negInf),
    .io_b_is_negInf(fadd_extSig_fp19_io_b_is_negInf),
    .io_a_is_nan(fadd_extSig_fp19_io_a_is_nan),
    .io_b_is_nan(fadd_extSig_fp19_io_b_is_nan),
    .io_res_sign(fadd_extSig_fp19_io_res_sign),
    .io_res_exp(fadd_extSig_fp19_io_res_exp),
    .io_res_sig(fadd_extSig_fp19_io_res_sig),
    .io_res_is_posInf(fadd_extSig_fp19_io_res_is_posInf),
    .io_res_is_negInf(fadd_extSig_fp19_io_res_is_negInf),
    .io_res_is_nan(fadd_extSig_fp19_io_res_is_nan),
    .io_valid_out(fadd_extSig_fp19_io_valid_out)
  );
  FAdd_extSig_1 fadd_extSig_fp32 ( // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 129:32]
    .clock(fadd_extSig_fp32_clock),
    .io_valid_in(fadd_extSig_fp32_io_valid_in),
    .io_is_fp16(fadd_extSig_fp32_io_is_fp16),
    .io_a_sign(fadd_extSig_fp32_io_a_sign),
    .io_a_exp(fadd_extSig_fp32_io_a_exp),
    .io_a_sig(fadd_extSig_fp32_io_a_sig),
    .io_b_sign(fadd_extSig_fp32_io_b_sign),
    .io_b_exp(fadd_extSig_fp32_io_b_exp),
    .io_b_sig(fadd_extSig_fp32_io_b_sig),
    .io_a_is_posInf(fadd_extSig_fp32_io_a_is_posInf),
    .io_b_is_posInf(fadd_extSig_fp32_io_b_is_posInf),
    .io_a_is_negInf(fadd_extSig_fp32_io_a_is_negInf),
    .io_b_is_negInf(fadd_extSig_fp32_io_b_is_negInf),
    .io_a_is_nan(fadd_extSig_fp32_io_a_is_nan),
    .io_b_is_nan(fadd_extSig_fp32_io_b_is_nan),
    .io_res_sign(fadd_extSig_fp32_io_res_sign),
    .io_res_exp(fadd_extSig_fp32_io_res_exp),
    .io_res_sig(fadd_extSig_fp32_io_res_sig),
    .io_res_is_posInf(fadd_extSig_fp32_io_res_is_posInf),
    .io_res_is_negInf(fadd_extSig_fp32_io_res_is_negInf),
    .io_res_is_nan(fadd_extSig_fp32_io_res_is_nan)
  );
  assign io_res = res_is_32_S2 ? resFinal_32_high : _io_res_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 299:16]
  assign io_valid_out = valid_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 302:16]
  assign io_valid_S1 = fadd_extSig_fp19_io_valid_out; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 303:15]
  assign fadd_extSig_fp19_clock = clock;
  assign fadd_extSig_fp19_reset = reset;
  assign fadd_extSig_fp19_io_valid_in = io_valid_in; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 114:32]
  assign fadd_extSig_fp19_io_is_fp16 = io_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 115:31]
  assign fadd_extSig_fp19_io_a_sign = io_a[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:65]
  assign fadd_extSig_fp19_io_a_exp = is_subnorm_0 ? 8'h1 : exp_low_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 95:35]
  assign fadd_extSig_fp19_io_a_sig = {sig_adjust_subnorm_16_0,3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 118:57]
  assign fadd_extSig_fp19_io_b_sign = io_b[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:75]
  assign fadd_extSig_fp19_io_b_exp = is_subnorm_1 ? 8'h1 : exp_low_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 95:35]
  assign fadd_extSig_fp19_io_b_sig = {sig_adjust_subnorm_16_1,3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 121:57]
  assign fadd_extSig_fp19_io_a_is_posInf = is_inf_16_0 & ~sign_low_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 122:51]
  assign fadd_extSig_fp19_io_b_is_posInf = is_inf_16_1 & ~sign_low_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 124:51]
  assign fadd_extSig_fp19_io_a_is_negInf = is_inf_16_0 & sign_low_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 123:51]
  assign fadd_extSig_fp19_io_b_is_negInf = is_inf_16_1 & sign_low_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 125:51]
  assign fadd_extSig_fp19_io_a_is_nan = exp_is_all1s_0 & ~frac_is_0_16_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 86:93]
  assign fadd_extSig_fp19_io_b_is_nan = exp_is_all1s_1 & ~frac_is_0_16_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 86:93]
  assign fadd_extSig_fp32_clock = clock;
  assign fadd_extSig_fp32_io_valid_in = io_valid_in; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 130:32]
  assign fadd_extSig_fp32_io_is_fp16 = io_is_fp16 & _res_is_bf16_T; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 45:29]
  assign fadd_extSig_fp32_io_a_sign = io_a[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:85]
  assign fadd_extSig_fp32_io_a_exp = _exp_adjust_subnorm_2_T + _GEN_18; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 97:63]
  assign fadd_extSig_fp32_io_a_sig = {sig_adjust_subnorm_high_a,3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 136:58]
  assign fadd_extSig_fp32_io_b_sign = io_b[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 46:95]
  assign fadd_extSig_fp32_io_b_exp = _exp_adjust_subnorm_3_T + _GEN_19; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 98:63]
  assign fadd_extSig_fp32_io_b_sig = {sig_adjust_subnorm_high_b,3'h0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 139:58]
  assign fadd_extSig_fp32_io_a_is_posInf = _fadd_extSig_fp32_io_a_is_posInf_T & ~sign_high_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 140:77]
  assign fadd_extSig_fp32_io_b_is_posInf = _fadd_extSig_fp32_io_b_is_posInf_T & ~sign_high_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 142:77]
  assign fadd_extSig_fp32_io_a_is_negInf = _fadd_extSig_fp32_io_a_is_posInf_T & sign_high_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 141:77]
  assign fadd_extSig_fp32_io_b_is_negInf = _fadd_extSig_fp32_io_b_is_posInf_T & sign_high_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 143:77]
  assign fadd_extSig_fp32_io_a_is_nan = is_16 ? is_nan_16_2 : is_nan_32_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 144:38]
  assign fadd_extSig_fp32_io_b_is_nan = is_16 ? is_nan_16_3 : is_nan_32_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 145:38]
  always @(posedge clock) begin
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 161:31]
      res_is_32_S1 <= res_is_32; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 161:31]
    end
    if (io_valid_in) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 163:33]
      res_is_fp16_S1 <= res_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 163:33]
    end
    if (reset) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 168:25]
      valid_S2 <= 1'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 168:25]
    end else begin
      valid_S2 <= fadd_extSig_fp19_io_valid_out; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 168:25]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
      res_extSig_fp19_S2_sign <= fadd_extSig_fp19_io_res_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
      res_extSig_fp19_S2_exp <= fadd_extSig_fp19_io_res_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
      res_extSig_fp19_S2_sig <= fadd_extSig_fp19_io_res_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 169:37]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
      res_extSig_fp32_S2_sign <= fadd_extSig_fp32_io_res_sign; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
      res_extSig_fp32_S2_exp <= fadd_extSig_fp32_io_res_exp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
      res_extSig_fp32_S2_sig <= fadd_extSig_fp32_io_res_sig; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 170:37]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 171:31]
      res_is_32_S2 <= res_is_32_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 171:31]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 173:33]
      res_is_fp16_S2 <= res_is_fp16_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 173:33]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 175:40]
      res_is_posInf_high_S2 <= fadd_extSig_fp32_io_res_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 175:40]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 176:40]
      res_is_negInf_high_S2 <= fadd_extSig_fp32_io_res_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 176:40]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 177:37]
      res_is_nan_high_S2 <= fadd_extSig_fp32_io_res_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 177:37]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 178:39]
      res_is_posInf_low_S2 <= fadd_extSig_fp19_io_res_is_posInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 178:39]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 179:39]
      res_is_negInf_low_S2 <= fadd_extSig_fp19_io_res_is_negInf; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 179:39]
    end
    if (fadd_extSig_fp19_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 180:36]
      res_is_nan_low_S2 <= fadd_extSig_fp19_io_res_is_nan; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/FAdd_16_32.scala 180:36]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  res_is_32_S1 = _RAND_0[0:0];
  _RAND_1 = {1{`RANDOM}};
  res_is_fp16_S1 = _RAND_1[0:0];
  _RAND_2 = {1{`RANDOM}};
  valid_S2 = _RAND_2[0:0];
  _RAND_3 = {1{`RANDOM}};
  res_extSig_fp19_S2_sign = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  res_extSig_fp19_S2_exp = _RAND_4[7:0];
  _RAND_5 = {1{`RANDOM}};
  res_extSig_fp19_S2_sig = _RAND_5[14:0];
  _RAND_6 = {1{`RANDOM}};
  res_extSig_fp32_S2_sign = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  res_extSig_fp32_S2_exp = _RAND_7[7:0];
  _RAND_8 = {1{`RANDOM}};
  res_extSig_fp32_S2_sig = _RAND_8[27:0];
  _RAND_9 = {1{`RANDOM}};
  res_is_32_S2 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  res_is_fp16_S2 = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  res_is_posInf_high_S2 = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  res_is_negInf_high_S2 = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  res_is_nan_high_S2 = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  res_is_posInf_low_S2 = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  res_is_negInf_low_S2 = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  res_is_nan_low_S2 = _RAND_16[0:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module LaneFAdd(
  input         clock,
  input         reset,
  input         io_in_valid, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [4:0]  io_in_bits_uop_ctrl_lsrc_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [4:0]  io_in_bits_uop_ctrl_lsrc_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [4:0]  io_in_bits_uop_ctrl_ldest, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_vm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [5:0]  io_in_bits_uop_ctrl_funct6, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [2:0]  io_in_bits_uop_ctrl_funct3, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_illegal, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_lsrcVal_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_lsrcVal_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_lsrcVal_2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_ldestVal, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_rdVal, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_load, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_store, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_arith, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_crossLane, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_alu, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_mul, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_fp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_div, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_fixP, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_redu, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_mask, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_perm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_vfadd, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_vfma, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_vfcvt, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_widen, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_widen2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_narrow, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ctrl_narrow_to_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [8:0]  io_in_bits_uop_csr_vstart, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [9:0]  io_in_bits_uop_csr_vl, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [1:0]  io_in_bits_uop_csr_vxrm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [2:0]  io_in_bits_uop_csr_frm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [2:0]  io_in_bits_uop_csr_vlmul, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [2:0]  io_in_bits_uop_csr_vsew, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_csr_vill, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_csr_ma, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_csr_ta, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_robIdx_flag, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [7:0]  io_in_bits_uop_robIdx_value, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [2:0]  io_in_bits_uop_veewVd, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [2:0]  io_in_bits_uop_uopIdx, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_uopEnd, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [4:0]  io_in_bits_uop_lsrcUop_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [4:0]  io_in_bits_uop_lsrcUop_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [4:0]  io_in_bits_uop_ldestUop, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_lsrcValUop_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_lsrcValUop_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_lsrcValUop_2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_lmaskValUop, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_in_bits_uop_ldestValUop, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [63:0] io_in_bits_vs1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [63:0] io_in_bits_vs2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [63:0] io_in_bits_vs3, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input  [63:0] io_in_bits_rs1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_sewIn_oneHot_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_sewIn_oneHot_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_sewIn_oneHot_2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  input         io_sewIn_oneHot_3, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_valid, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_uop_ctrl_lsrc_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_uop_ctrl_lsrc_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_uop_ctrl_ldest, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_vm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [5:0]  io_out_bits_uop_ctrl_funct6, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [2:0]  io_out_bits_uop_ctrl_funct3, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_illegal, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_lsrcVal_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_lsrcVal_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_lsrcVal_2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_ldestVal, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_rdVal, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_load, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_store, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_arith, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_crossLane, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_alu, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_mul, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_fp, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_div, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_fixP, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_redu, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_mask, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_perm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_vfadd, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_vfma, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_vfcvt, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_widen, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_widen2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_narrow, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ctrl_narrow_to_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [8:0]  io_out_bits_uop_csr_vstart, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [9:0]  io_out_bits_uop_csr_vl, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [1:0]  io_out_bits_uop_csr_vxrm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [2:0]  io_out_bits_uop_csr_frm, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [2:0]  io_out_bits_uop_csr_vlmul, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [2:0]  io_out_bits_uop_csr_vsew, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_csr_vill, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_csr_ma, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_csr_ta, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_robIdx_flag, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [7:0]  io_out_bits_uop_robIdx_value, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [2:0]  io_out_bits_uop_veewVd, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [2:0]  io_out_bits_uop_uopIdx, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_uopEnd, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_uop_lsrcUop_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_uop_lsrcUop_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_uop_ldestUop, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_lsrcValUop_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_lsrcValUop_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_lsrcValUop_2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_lmaskValUop, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_out_bits_uop_ldestValUop, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [63:0] io_out_bits_vd, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_fflags_0, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_fflags_1, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_fflags_2, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [4:0]  io_out_bits_fflags_3, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output        io_rd_valid, // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
  output [63:0] io_rd_bits // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 21:14]
);
`ifdef RANDOMIZE_REG_INIT
  reg [31:0] _RAND_0;
  reg [31:0] _RAND_1;
  reg [31:0] _RAND_2;
  reg [31:0] _RAND_3;
  reg [31:0] _RAND_4;
  reg [31:0] _RAND_5;
  reg [31:0] _RAND_6;
  reg [31:0] _RAND_7;
  reg [31:0] _RAND_8;
  reg [31:0] _RAND_9;
  reg [31:0] _RAND_10;
  reg [31:0] _RAND_11;
  reg [31:0] _RAND_12;
  reg [31:0] _RAND_13;
  reg [31:0] _RAND_14;
  reg [31:0] _RAND_15;
  reg [31:0] _RAND_16;
  reg [31:0] _RAND_17;
  reg [31:0] _RAND_18;
  reg [31:0] _RAND_19;
  reg [31:0] _RAND_20;
  reg [31:0] _RAND_21;
  reg [31:0] _RAND_22;
  reg [31:0] _RAND_23;
  reg [31:0] _RAND_24;
  reg [31:0] _RAND_25;
  reg [31:0] _RAND_26;
  reg [31:0] _RAND_27;
  reg [31:0] _RAND_28;
  reg [31:0] _RAND_29;
  reg [31:0] _RAND_30;
  reg [31:0] _RAND_31;
  reg [31:0] _RAND_32;
  reg [31:0] _RAND_33;
  reg [31:0] _RAND_34;
  reg [31:0] _RAND_35;
  reg [31:0] _RAND_36;
  reg [31:0] _RAND_37;
  reg [31:0] _RAND_38;
  reg [31:0] _RAND_39;
  reg [31:0] _RAND_40;
  reg [31:0] _RAND_41;
  reg [31:0] _RAND_42;
  reg [31:0] _RAND_43;
  reg [31:0] _RAND_44;
  reg [31:0] _RAND_45;
  reg [31:0] _RAND_46;
  reg [31:0] _RAND_47;
  reg [31:0] _RAND_48;
  reg [31:0] _RAND_49;
  reg [31:0] _RAND_50;
  reg [31:0] _RAND_51;
  reg [31:0] _RAND_52;
  reg [31:0] _RAND_53;
  reg [31:0] _RAND_54;
  reg [31:0] _RAND_55;
  reg [31:0] _RAND_56;
  reg [31:0] _RAND_57;
  reg [31:0] _RAND_58;
  reg [31:0] _RAND_59;
  reg [31:0] _RAND_60;
  reg [31:0] _RAND_61;
  reg [31:0] _RAND_62;
  reg [31:0] _RAND_63;
  reg [31:0] _RAND_64;
  reg [31:0] _RAND_65;
  reg [31:0] _RAND_66;
  reg [31:0] _RAND_67;
  reg [31:0] _RAND_68;
  reg [31:0] _RAND_69;
  reg [31:0] _RAND_70;
  reg [31:0] _RAND_71;
  reg [31:0] _RAND_72;
  reg [31:0] _RAND_73;
  reg [31:0] _RAND_74;
  reg [31:0] _RAND_75;
  reg [31:0] _RAND_76;
  reg [31:0] _RAND_77;
  reg [31:0] _RAND_78;
  reg [31:0] _RAND_79;
  reg [31:0] _RAND_80;
  reg [31:0] _RAND_81;
  reg [31:0] _RAND_82;
  reg [31:0] _RAND_83;
  reg [31:0] _RAND_84;
  reg [31:0] _RAND_85;
  reg [31:0] _RAND_86;
  reg [31:0] _RAND_87;
  reg [31:0] _RAND_88;
  reg [31:0] _RAND_89;
  reg [31:0] _RAND_90;
  reg [31:0] _RAND_91;
  reg [31:0] _RAND_92;
  reg [31:0] _RAND_93;
  reg [31:0] _RAND_94;
  reg [31:0] _RAND_95;
  reg [31:0] _RAND_96;
  reg [31:0] _RAND_97;
  reg [31:0] _RAND_98;
  reg [31:0] _RAND_99;
  reg [31:0] _RAND_100;
  reg [31:0] _RAND_101;
  reg [31:0] _RAND_102;
  reg [31:0] _RAND_103;
  reg [31:0] _RAND_104;
  reg [31:0] _RAND_105;
  reg [63:0] _RAND_106;
  reg [63:0] _RAND_107;
  reg [63:0] _RAND_108;
  reg [63:0] _RAND_109;
  reg [63:0] _RAND_110;
  reg [63:0] _RAND_111;
  reg [31:0] _RAND_112;
  reg [31:0] _RAND_113;
  reg [31:0] _RAND_114;
  reg [31:0] _RAND_115;
  reg [31:0] _RAND_116;
  reg [31:0] _RAND_117;
  reg [31:0] _RAND_118;
  reg [31:0] _RAND_119;
  reg [31:0] _RAND_120;
  reg [31:0] _RAND_121;
  reg [31:0] _RAND_122;
  reg [31:0] _RAND_123;
  reg [31:0] _RAND_124;
  reg [31:0] _RAND_125;
  reg [31:0] _RAND_126;
  reg [31:0] _RAND_127;
  reg [31:0] _RAND_128;
  reg [31:0] _RAND_129;
  reg [31:0] _RAND_130;
  reg [31:0] _RAND_131;
  reg [31:0] _RAND_132;
  reg [31:0] _RAND_133;
  reg [31:0] _RAND_134;
  reg [31:0] _RAND_135;
  reg [31:0] _RAND_136;
  reg [31:0] _RAND_137;
  reg [31:0] _RAND_138;
  reg [31:0] _RAND_139;
  reg [31:0] _RAND_140;
  reg [31:0] _RAND_141;
  reg [31:0] _RAND_142;
  reg [31:0] _RAND_143;
  reg [31:0] _RAND_144;
  reg [31:0] _RAND_145;
  reg [31:0] _RAND_146;
  reg [31:0] _RAND_147;
  reg [31:0] _RAND_148;
  reg [31:0] _RAND_149;
  reg [31:0] _RAND_150;
  reg [31:0] _RAND_151;
  reg [31:0] _RAND_152;
  reg [31:0] _RAND_153;
  reg [31:0] _RAND_154;
  reg [31:0] _RAND_155;
  reg [31:0] _RAND_156;
  reg [31:0] _RAND_157;
  reg [31:0] _RAND_158;
  reg [31:0] _RAND_159;
  reg [31:0] _RAND_160;
  reg [31:0] _RAND_161;
  reg [31:0] _RAND_162;
  reg [31:0] _RAND_163;
  reg [31:0] _RAND_164;
  reg [31:0] _RAND_165;
  reg [31:0] _RAND_166;
  reg [31:0] _RAND_167;
  reg [31:0] _RAND_168;
  reg [31:0] _RAND_169;
  reg [31:0] _RAND_170;
  reg [31:0] _RAND_171;
  reg [31:0] _RAND_172;
  reg [31:0] _RAND_173;
  reg [31:0] _RAND_174;
  reg [31:0] _RAND_175;
  reg [31:0] _RAND_176;
  reg [31:0] _RAND_177;
  reg [31:0] _RAND_178;
  reg [31:0] _RAND_179;
  reg [31:0] _RAND_180;
  reg [31:0] _RAND_181;
  reg [31:0] _RAND_182;
  reg [31:0] _RAND_183;
  reg [31:0] _RAND_184;
  reg [31:0] _RAND_185;
  reg [31:0] _RAND_186;
  reg [31:0] _RAND_187;
  reg [31:0] _RAND_188;
  reg [31:0] _RAND_189;
  reg [63:0] _RAND_190;
`endif // RANDOMIZE_REG_INIT
  wire  vfadd0_clock; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_reset; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_valid_in; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_is_bf16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_is_fp32; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_is_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_a_already_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire [31:0] vfadd0_io_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire [31:0] vfadd0_io_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire [31:0] vfadd0_io_res; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_valid_out; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd0_io_valid_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
  wire  vfadd1_clock; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_reset; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_valid_in; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_is_bf16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_is_fp16; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_is_fp32; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_is_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_a_already_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire [31:0] vfadd1_io_a; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire [31:0] vfadd1_io_b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire [31:0] vfadd1_io_res; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_valid_out; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  vfadd1_io_valid_S1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
  wire  _rs1_T = io_sewIn_oneHot_1 | io_sewIn_oneHot_0; // @[src/main/scala/vpu/Bundles.scala 210:21]
  wire [63:0] _rs1_T_3 = {io_in_bits_rs1[15:0],io_in_bits_rs1[15:0],io_in_bits_rs1[15:0],io_in_bits_rs1[15:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 33:36]
  wire [63:0] _rs1_T_5 = {io_in_bits_rs1[31:0],io_in_bits_rs1[31:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 33:68]
  wire [63:0] rs1 = _rs1_T ? _rs1_T_3 : _rs1_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 33:16]
  wire  res_is_16b = _rs1_T & ~io_in_bits_uop_ctrl_widen2 & ~io_in_bits_uop_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 34:54]
  wire [15:0] vs2_32b_0_fadd1_low = io_in_bits_vs2[47:32]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 47:86]
  wire [15:0] vs2_32b_0_fadd0_low = io_in_bits_vs2[15:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 48:86]
  wire [31:0] vs2_32b_0_vs_32b = io_in_bits_uop_uopIdx[0] ? io_in_bits_vs2[63:32] : io_in_bits_vs2[31:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 49:21]
  wire [15:0] vs2_32b_0_fadd0_high = io_in_bits_uop_ctrl_widen ? vs2_32b_0_vs_32b[15:0] : io_in_bits_vs2[31:16]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 50:27 51:18 48:70]
  wire [15:0] vs2_32b_0_fadd1_high = io_in_bits_uop_ctrl_widen ? vs2_32b_0_vs_32b[31:16] : io_in_bits_vs2[63:48]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 50:27 52:18 47:70]
  wire [63:0] _vs2_32b_0_T_3 = {vs2_32b_0_fadd1_high,vs2_32b_0_fadd1_low,vs2_32b_0_fadd0_high,vs2_32b_0_fadd0_low}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 54:8]
  wire [31:0] vs2_32b_0 = io_in_bits_uop_ctrl_widen2 ? io_in_bits_vs2[31:0] : _vs2_32b_0_T_3[31:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 68:22]
  wire [15:0] vs1_32b_0_fadd1_low = io_in_bits_vs1[47:32]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 47:86]
  wire [15:0] vs1_32b_0_fadd0_low = io_in_bits_vs1[15:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 48:86]
  wire [31:0] vs1_32b_0_vs_32b = io_in_bits_uop_uopIdx[0] ? io_in_bits_vs1[63:32] : io_in_bits_vs1[31:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 49:21]
  wire [15:0] vs1_32b_0_fadd0_high = io_in_bits_uop_ctrl_widen ? vs1_32b_0_vs_32b[15:0] : io_in_bits_vs1[31:16]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 50:27 51:18 48:70]
  wire [15:0] vs1_32b_0_fadd1_high = io_in_bits_uop_ctrl_widen ? vs1_32b_0_vs_32b[31:16] : io_in_bits_vs1[63:48]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 50:27 52:18 47:70]
  wire [63:0] _vs1_32b_0_T_3 = {vs1_32b_0_fadd1_high,vs1_32b_0_fadd1_low,vs1_32b_0_fadd0_high,vs1_32b_0_fadd0_low}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 54:8]
  wire [63:0] _vs1_32b_0_T_5 = io_in_bits_uop_ctrl_funct3[2] ? rs1 : {{32'd0}, _vs1_32b_0_T_3[31:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 69:22]
  wire [31:0] vs2_32b_1 = io_in_bits_uop_ctrl_widen2 ? io_in_bits_vs2[63:32] : _vs2_32b_0_T_3[63:32]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 68:22]
  wire [63:0] _vs1_32b_1_T_5 = io_in_bits_uop_ctrl_funct3[2] ? rs1 : {{32'd0}, _vs1_32b_0_T_3[63:32]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 69:22]
  wire  _isAdd_T_2 = io_in_bits_uop_ctrl_funct6[5:4] == 2'h3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 74:46]
  wire  isMinMax = io_in_bits_uop_ctrl_funct6[5:2] == 4'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 75:31]
  wire  isCmp = io_in_bits_uop_ctrl_funct6[5:3] == 3'h3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 76:28]
  wire  _isSub_T_4 = io_in_bits_uop_ctrl_funct6[5:4] == 2'h0 & io_in_bits_uop_ctrl_funct6[1]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 78:36]
  wire  _isSub_T_5 = isMinMax | isCmp | _isSub_T_4; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 77:33]
  wire  isSub = _isSub_T_5 | _isAdd_T_2 & io_in_bits_uop_ctrl_funct6[1]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 78:49]
  wire  isRSub = io_in_bits_uop_ctrl_funct6 == 6'h27; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 79:23]
  wire  isSgn = io_in_bits_uop_ctrl_funct6[5:3] == 3'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 80:28]
  wire  isMove = io_in_bits_uop_ctrl_funct6[5:2] == 4'h5 & io_in_bits_uop_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 81:43]
  wire  _isVfmv_f_s_T = io_in_bits_uop_ctrl_funct6 == 6'h10; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 82:27]
  wire  isVfmv_s_f = _isVfmv_f_s_T & io_in_bits_uop_ctrl_funct3[2]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 83:43]
  wire [31:0] vs1_32b_0 = _vs1_32b_0_T_5[31:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 66:30 69:16]
  wire  vs1_isNaN_32b_0 = vs1_32b_0[30:23] == 8'hff & vs1_32b_0[22:0] != 23'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 90:33]
  wire [31:0] vs1_32b_1 = _vs1_32b_1_T_5[31:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 66:30 69:16]
  wire  vs1_isNaN_32b_1 = vs1_32b_1[30:23] == 8'hff & vs1_32b_1[22:0] != 23'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 90:33]
  wire  vs2_isNaN_32b_0 = vs2_32b_0[30:23] == 8'hff & vs2_32b_0[22:0] != 23'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 90:33]
  wire  vs2_isNaN_32b_1 = vs2_32b_1[30:23] == 8'hff & vs2_32b_1[22:0] != 23'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 90:33]
  wire  _vs1_isNaN_16b_T_13 = vs1_32b_0[15:10] == 6'h1f & vs1_32b_0[9:0] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs1_isNaN_16b_0 = io_sewIn_oneHot_0 ? vs1_32b_0[15:7] == 9'hff & vs1_32b_0[6:0] != 7'h0 : _vs1_isNaN_16b_T_13; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  _vs1_isNaN_16b_T_23 = vs1_32b_0[31:26] == 6'h1f & vs1_32b_0[25:16] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs1_isNaN_16b_1 = io_sewIn_oneHot_0 ? vs1_32b_0[31:23] == 9'hff & vs1_32b_0[22:16] != 7'h0 : _vs1_isNaN_16b_T_23
    ; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  _vs1_isNaN_16b_T_33 = vs1_32b_1[15:10] == 6'h1f & vs1_32b_1[9:0] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs1_isNaN_16b_2 = io_sewIn_oneHot_0 ? vs1_32b_1[15:7] == 9'hff & vs1_32b_1[6:0] != 7'h0 : _vs1_isNaN_16b_T_33; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  _vs1_isNaN_16b_T_43 = vs1_32b_1[31:26] == 6'h1f & vs1_32b_1[25:16] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs1_isNaN_16b_3 = io_sewIn_oneHot_0 ? vs1_32b_1[31:23] == 9'hff & vs1_32b_1[22:16] != 7'h0 : _vs1_isNaN_16b_T_43
    ; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  _vs2_isNaN_16b_T_13 = vs2_32b_0[15:10] == 6'h1f & vs2_32b_0[9:0] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs2_isNaN_16b_0 = io_sewIn_oneHot_0 ? vs2_32b_0[15:7] == 9'hff & vs2_32b_0[6:0] != 7'h0 : _vs2_isNaN_16b_T_13; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  _vs2_isNaN_16b_T_23 = vs2_32b_0[31:26] == 6'h1f & vs2_32b_0[25:16] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs2_isNaN_16b_1 = io_sewIn_oneHot_0 ? vs2_32b_0[31:23] == 9'hff & vs2_32b_0[22:16] != 7'h0 : _vs2_isNaN_16b_T_23
    ; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  _vs2_isNaN_16b_T_33 = vs2_32b_1[15:10] == 6'h1f & vs2_32b_1[9:0] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs2_isNaN_16b_2 = io_sewIn_oneHot_0 ? vs2_32b_1[15:7] == 9'hff & vs2_32b_1[6:0] != 7'h0 : _vs2_isNaN_16b_T_33; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  _vs2_isNaN_16b_T_43 = vs2_32b_1[31:26] == 6'h1f & vs2_32b_1[25:16] != 10'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 87:46]
  wire  vs2_isNaN_16b_3 = io_sewIn_oneHot_0 ? vs2_32b_1[31:23] == 9'hff & vs2_32b_1[22:16] != 7'h0 : _vs2_isNaN_16b_T_43
    ; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 86:8]
  wire  input_has_NaN_32b_0 = vs1_isNaN_32b_0 | vs2_isNaN_32b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 96:89]
  wire  input_has_NaN_32b_1 = vs1_isNaN_32b_1 | vs2_isNaN_32b_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 96:89]
  wire  input_has_NaN_16b_0 = vs1_isNaN_16b_0 | vs2_isNaN_16b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 97:89]
  wire  input_has_NaN_16b_1 = vs1_isNaN_16b_1 | vs2_isNaN_16b_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 97:89]
  wire  input_has_NaN_16b_2 = vs1_isNaN_16b_2 | vs2_isNaN_16b_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 97:89]
  wire  input_has_NaN_16b_3 = vs1_isNaN_16b_3 | vs2_isNaN_16b_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 97:89]
  wire  _vfadd0_io_b_T_3 = isSub ^ vs1_32b_0[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire  _vfadd0_io_b_T_8 = isSub ^ vs1_32b_0[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd0_io_b_T_11 = {_vfadd0_io_b_T_3,vs1_32b_0[30:16],_vfadd0_io_b_T_8,vs1_32b_0[14:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 209:12]
  wire  _vfadd0_io_b_T_13 = isSub ^ vs1_32b_0[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd0_io_b_T_15 = {_vfadd0_io_b_T_13,vs1_32b_0[30:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:8]
  wire  _vfadd0_io_a_T_3 = isRSub ^ vs2_32b_0[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire  _vfadd0_io_a_T_8 = isRSub ^ vs2_32b_0[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd0_io_a_T_11 = {_vfadd0_io_a_T_3,vs2_32b_0[30:16],_vfadd0_io_a_T_8,vs2_32b_0[14:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 209:12]
  wire  _vfadd0_io_a_T_13 = isRSub ^ vs2_32b_0[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd0_io_a_T_15 = {_vfadd0_io_a_T_13,vs2_32b_0[30:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:8]
  wire  _vfadd1_io_b_T_3 = isSub ^ vs1_32b_1[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire  _vfadd1_io_b_T_8 = isSub ^ vs1_32b_1[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd1_io_b_T_11 = {_vfadd1_io_b_T_3,vs1_32b_1[30:16],_vfadd1_io_b_T_8,vs1_32b_1[14:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 209:12]
  wire  _vfadd1_io_b_T_13 = isSub ^ vs1_32b_1[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd1_io_b_T_15 = {_vfadd1_io_b_T_13,vs1_32b_1[30:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:8]
  wire  _vfadd1_io_a_T_3 = isRSub ^ vs2_32b_1[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire  _vfadd1_io_a_T_8 = isRSub ^ vs2_32b_1[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd1_io_a_T_11 = {_vfadd1_io_a_T_3,vs2_32b_1[30:16],_vfadd1_io_a_T_8,vs2_32b_1[14:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 209:12]
  wire  _vfadd1_io_a_T_13 = isRSub ^ vs2_32b_1[31]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:17]
  wire [31:0] _vfadd1_io_a_T_15 = {_vfadd1_io_a_T_13,vs2_32b_1[30:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 205:8]
  wire [15:0] faddOut_16b_0 = vfadd0_io_res[15:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 105:39]
  wire [15:0] faddOut_16b_1 = vfadd0_io_res[31:16]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 105:62]
  wire [15:0] faddOut_16b_2 = vfadd1_io_res[15:0]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 105:86]
  wire [15:0] faddOut_16b_3 = vfadd1_io_res[31:16]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 105:109]
  wire  cmp_gte_0 = ~faddOut_16b_0[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 107:21]
  wire  cmp_gte_1 = ~faddOut_16b_1[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 107:42]
  wire  cmp_gte_2 = ~faddOut_16b_2[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 107:63]
  wire  cmp_gte_3 = ~faddOut_16b_3[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 107:84]
  reg [4:0] out_bits_uop_r_ctrl_lsrc_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [4:0] out_bits_uop_r_ctrl_lsrc_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [4:0] out_bits_uop_r_ctrl_ldest; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [5:0] out_bits_uop_r_ctrl_funct6; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [2:0] out_bits_uop_r_ctrl_funct3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_illegal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_lsrcVal_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_lsrcVal_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_lsrcVal_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_ldestVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_rdVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_load; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_store; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_arith; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_crossLane; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_alu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_mul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_fp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_div; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_fixP; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_redu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_mask; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_perm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_vfadd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_vfma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_vfcvt; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_narrow; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ctrl_narrow_to_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [8:0] out_bits_uop_r_csr_vstart; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [9:0] out_bits_uop_r_csr_vl; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [1:0] out_bits_uop_r_csr_vxrm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [2:0] out_bits_uop_r_csr_frm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [2:0] out_bits_uop_r_csr_vlmul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [2:0] out_bits_uop_r_csr_vsew; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_csr_vill; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_csr_ma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_csr_ta; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_robIdx_flag; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [7:0] out_bits_uop_r_robIdx_value; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [2:0] out_bits_uop_r_veewVd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [2:0] out_bits_uop_r_uopIdx; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_uopEnd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [4:0] out_bits_uop_r_lsrcUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [4:0] out_bits_uop_r_lsrcUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [4:0] out_bits_uop_r_ldestUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_lsrcValUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_lsrcValUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_lsrcValUop_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_lmaskValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg  out_bits_uop_r_ldestValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
  reg [4:0] out_bits_uop_r_1_ctrl_lsrc_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [4:0] out_bits_uop_r_1_ctrl_lsrc_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [4:0] out_bits_uop_r_1_ctrl_ldest; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [5:0] out_bits_uop_r_1_ctrl_funct6; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [2:0] out_bits_uop_r_1_ctrl_funct3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_illegal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_lsrcVal_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_lsrcVal_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_lsrcVal_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_ldestVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_rdVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_load; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_store; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_arith; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_crossLane; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_alu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_mul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_fp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_div; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_fixP; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_redu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_mask; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_perm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_vfadd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_vfma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_vfcvt; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_narrow; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ctrl_narrow_to_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [8:0] out_bits_uop_r_1_csr_vstart; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [9:0] out_bits_uop_r_1_csr_vl; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [1:0] out_bits_uop_r_1_csr_vxrm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [2:0] out_bits_uop_r_1_csr_frm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [2:0] out_bits_uop_r_1_csr_vlmul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [2:0] out_bits_uop_r_1_csr_vsew; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_csr_vill; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_csr_ma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_csr_ta; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_robIdx_flag; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [7:0] out_bits_uop_r_1_robIdx_value; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [2:0] out_bits_uop_r_1_veewVd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [2:0] out_bits_uop_r_1_uopIdx; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_uopEnd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [4:0] out_bits_uop_r_1_lsrcUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [4:0] out_bits_uop_r_1_lsrcUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [4:0] out_bits_uop_r_1_ldestUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_lsrcValUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_lsrcValUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_lsrcValUop_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_lmaskValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg  out_bits_uop_r_1_ldestValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
  reg [63:0] vs1_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 115:35]
  reg [63:0] vs1_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 115:25]
  reg [63:0] vs2_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 116:35]
  reg [63:0] vs2_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 116:25]
  reg [63:0] rs1_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 117:35]
  reg [63:0] rs1_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 117:25]
  wire [15:0] vs1_S2_16b_0 = vs1_S2[15:0]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  wire [15:0] vs1_S2_16b_1 = vs1_S2[31:16]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  wire [15:0] vs1_S2_16b_2 = vs1_S2[47:32]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  wire [15:0] vs1_S2_16b_3 = vs1_S2[63:48]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  wire [15:0] vs2_S2_16b_0 = vs2_S2[15:0]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  wire [15:0] vs2_S2_16b_1 = vs2_S2[31:16]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  wire [15:0] vs2_S2_16b_2 = vs2_S2[47:32]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  wire [15:0] vs2_S2_16b_3 = vs2_S2[63:48]; // @[src/main/scala/vpu/utils/VUtils.scala 36:50]
  reg  res_is_16b_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 120:42]
  reg  res_is_16b_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 120:32]
  reg  isMinMax_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 121:40]
  reg  isMinMax_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 121:30]
  reg  isSgn_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 122:37]
  reg  isSgn_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 122:27]
  reg  isCmp_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 123:37]
  reg  isCmp_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 123:27]
  reg  isMove_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 124:38]
  reg  isMove_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 124:28]
  reg  isVfmv_s_f_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 125:42]
  reg  isVfmv_s_f_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 125:32]
  wire  isMax_S2 = isMinMax_S2 & out_bits_uop_r_1_ctrl_funct6[1]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 128:30]
  wire  isMin_S2 = isMinMax_S2 & ~out_bits_uop_r_1_ctrl_funct6[1]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 129:30]
  wire [15:0] _vd_minmax_0_T_4 = cmp_gte_0 & isMax_S2 | ~cmp_gte_0 & isMin_S2 ? vs2_S2_16b_0 : vs1_S2_16b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 139:29]
  wire  _vd_sgn_0_T_1 = out_bits_uop_r_1_ctrl_funct6[1:0] == 2'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 141:42]
  wire  _vd_sgn_0_T_4 = out_bits_uop_r_1_ctrl_funct6[1:0] == 2'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 142:42]
  wire  _vd_sgn_0_T_9 = vs1_S2_16b_0[15] ^ vs2_S2_16b_0[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 143:44]
  wire  _vd_sgn_0_T_10 = out_bits_uop_r_1_ctrl_funct6[1:0] == 2'h1 ? ~vs2_S2_16b_0[15] : _vd_sgn_0_T_9; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 142:25]
  wire  _vd_sgn_0_T_11 = out_bits_uop_r_1_ctrl_funct6[1:0] == 2'h0 ? vs2_S2_16b_0[15] : _vd_sgn_0_T_10; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 141:25]
  wire [15:0] _vd_sgn_0_T_13 = {_vd_sgn_0_T_11,vs1_S2_16b_0[14:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 143:66]
  wire  _vd_minmax_0_T_8 = cmp_gte_1 & isMax_S2 | ~cmp_gte_1 & isMin_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 145:54]
  wire [15:0] _vd_minmax_0_T_9 = cmp_gte_1 & isMax_S2 | ~cmp_gte_1 & isMin_S2 ? vs2_S2_16b_0 : vs1_S2_16b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 145:28]
  wire [15:0] vd_minmax_0 = res_is_16b_S2 ? _vd_minmax_0_T_4 : _vd_minmax_0_T_9; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 138:28 139:22 145:22]
  wire [15:0] vd_sgn_0 = res_is_16b_S2 ? _vd_sgn_0_T_13 : vs1_S2_16b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 138:28 141:19 147:19]
  wire [15:0] vd_minmax_1 = _vd_minmax_0_T_8 ? vs2_S2_16b_1 : vs1_S2_16b_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 132:27]
  wire  _vd_sgn_1_T_9 = vs1_S2_16b_1[15] ^ vs2_S2_16b_1[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 136:42]
  wire  _vd_sgn_1_T_10 = _vd_sgn_0_T_4 ? ~vs2_S2_16b_1[15] : _vd_sgn_1_T_9; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 135:23]
  wire  _vd_sgn_1_T_11 = _vd_sgn_0_T_1 ? vs2_S2_16b_1[15] : _vd_sgn_1_T_10; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 134:23]
  wire [15:0] _vd_minmax_2_T_4 = cmp_gte_2 & isMax_S2 | ~cmp_gte_2 & isMin_S2 ? vs2_S2_16b_2 : vs1_S2_16b_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 139:29]
  wire  _vd_sgn_2_T_9 = vs1_S2_16b_2[15] ^ vs2_S2_16b_2[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 143:44]
  wire  _vd_sgn_2_T_10 = out_bits_uop_r_1_ctrl_funct6[1:0] == 2'h1 ? ~vs2_S2_16b_2[15] : _vd_sgn_2_T_9; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 142:25]
  wire  _vd_sgn_2_T_11 = out_bits_uop_r_1_ctrl_funct6[1:0] == 2'h0 ? vs2_S2_16b_2[15] : _vd_sgn_2_T_10; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 141:25]
  wire [15:0] _vd_sgn_2_T_13 = {_vd_sgn_2_T_11,vs1_S2_16b_2[14:0]}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 143:66]
  wire  _vd_minmax_2_T_8 = cmp_gte_3 & isMax_S2 | ~cmp_gte_3 & isMin_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 145:54]
  wire [15:0] _vd_minmax_2_T_9 = cmp_gte_3 & isMax_S2 | ~cmp_gte_3 & isMin_S2 ? vs2_S2_16b_2 : vs1_S2_16b_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 145:28]
  wire [15:0] vd_minmax_2 = res_is_16b_S2 ? _vd_minmax_2_T_4 : _vd_minmax_2_T_9; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 138:28 139:22 145:22]
  wire [15:0] vd_sgn_2 = res_is_16b_S2 ? _vd_sgn_2_T_13 : vs1_S2_16b_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 138:28 141:19 147:19]
  wire [15:0] vd_minmax_3 = _vd_minmax_2_T_8 ? vs2_S2_16b_3 : vs1_S2_16b_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 132:27]
  wire  _vd_sgn_3_T_9 = vs1_S2_16b_3[15] ^ vs2_S2_16b_3[15]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 136:42]
  wire  _vd_sgn_3_T_10 = _vd_sgn_0_T_4 ? ~vs2_S2_16b_3[15] : _vd_sgn_3_T_9; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 135:23]
  wire  _vd_sgn_3_T_11 = _vd_sgn_0_T_1 ? vs2_S2_16b_3[15] : _vd_sgn_3_T_10; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 134:23]
  reg  input_has_NaN_32b_S2_r_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:49]
  reg  input_has_NaN_32b_S2_r_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:49]
  reg  input_has_NaN_32b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:39]
  reg  input_has_NaN_32b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:39]
  reg  input_has_NaN_16b_S2_r_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
  reg  input_has_NaN_16b_S2_r_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
  reg  input_has_NaN_16b_S2_r_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
  reg  input_has_NaN_16b_S2_r_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
  reg  input_has_NaN_16b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
  reg  input_has_NaN_16b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
  reg  input_has_NaN_16b_S2_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
  reg  input_has_NaN_16b_S2_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
  wire  _cmp_eq_32b_T_2 = ~input_has_NaN_32b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 156:103]
  wire  cmp_eq_32b_0 = vfadd0_io_res[30:0] == 31'h0 & ~input_has_NaN_32b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 156:100]
  wire  _cmp_eq_32b_T_5 = ~input_has_NaN_32b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 156:103]
  wire  cmp_eq_32b_1 = vfadd1_io_res[30:0] == 31'h0 & ~input_has_NaN_32b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 156:100]
  wire  _cmp_eq_16b_T_2 = ~input_has_NaN_16b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:103]
  wire  cmp_eq_16b_0 = faddOut_16b_0[14:0] == 15'h0 & ~input_has_NaN_16b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:100]
  wire  _cmp_eq_16b_T_5 = ~input_has_NaN_16b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:103]
  wire  cmp_eq_16b_1 = faddOut_16b_1[14:0] == 15'h0 & ~input_has_NaN_16b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:100]
  wire  _cmp_eq_16b_T_8 = ~input_has_NaN_16b_S2_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:103]
  wire  cmp_eq_16b_2 = faddOut_16b_2[14:0] == 15'h0 & ~input_has_NaN_16b_S2_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:100]
  wire  _cmp_eq_16b_T_11 = ~input_has_NaN_16b_S2_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:103]
  wire  cmp_eq_16b_3 = faddOut_16b_3[14:0] == 15'h0 & ~input_has_NaN_16b_S2_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 157:100]
  wire  cmp_ge_32b_0 = (cmp_gte_1 | cmp_eq_32b_0) & _cmp_eq_32b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 158:129]
  wire  cmp_ge_32b_1 = (cmp_gte_3 | cmp_eq_32b_1) & _cmp_eq_32b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 158:129]
  wire  cmp_ge_16b_0 = (cmp_gte_0 | cmp_eq_16b_0) & _cmp_eq_16b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 159:109]
  wire  cmp_ge_16b_1 = (cmp_gte_1 | cmp_eq_16b_1) & _cmp_eq_16b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 159:109]
  wire  cmp_ge_16b_2 = (cmp_gte_2 | cmp_eq_16b_2) & _cmp_eq_16b_T_8; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 159:109]
  wire  cmp_ge_16b_3 = (cmp_gte_3 | cmp_eq_16b_3) & _cmp_eq_16b_T_11; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 159:109]
  wire  cmp_ne_32b_0 = ~cmp_eq_32b_0 | input_has_NaN_32b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 160:84]
  wire  cmp_ne_32b_1 = ~cmp_eq_32b_1 | input_has_NaN_32b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 160:84]
  wire  cmp_ne_16b_0 = ~cmp_eq_16b_0 | input_has_NaN_16b_S2_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 161:84]
  wire  cmp_ne_16b_1 = ~cmp_eq_16b_1 | input_has_NaN_16b_S2_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 161:84]
  wire  cmp_ne_16b_2 = ~cmp_eq_16b_2 | input_has_NaN_16b_S2_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 161:84]
  wire  cmp_ne_16b_3 = ~cmp_eq_16b_3 | input_has_NaN_16b_S2_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 161:84]
  wire  _cmp_lt_32b_T = ~cmp_ge_32b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 162:104]
  wire  cmp_lt_32b_0 = ~cmp_ge_32b_0 & cmp_ne_32b_0 & _cmp_eq_32b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 162:115]
  wire  _cmp_lt_32b_T_3 = ~cmp_ge_32b_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 162:104]
  wire  cmp_lt_32b_1 = ~cmp_ge_32b_1 & cmp_ne_32b_1 & _cmp_eq_32b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 162:115]
  wire  _cmp_lt_16b_T = ~cmp_ge_16b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:104]
  wire  cmp_lt_16b_0 = ~cmp_ge_16b_0 & cmp_ne_16b_0 & _cmp_eq_16b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:115]
  wire  _cmp_lt_16b_T_3 = ~cmp_ge_16b_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:104]
  wire  cmp_lt_16b_1 = ~cmp_ge_16b_1 & cmp_ne_16b_1 & _cmp_eq_16b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:115]
  wire  _cmp_lt_16b_T_6 = ~cmp_ge_16b_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:104]
  wire  cmp_lt_16b_2 = ~cmp_ge_16b_2 & cmp_ne_16b_2 & _cmp_eq_16b_T_8; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:115]
  wire  _cmp_lt_16b_T_9 = ~cmp_ge_16b_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:104]
  wire  cmp_lt_16b_3 = ~cmp_ge_16b_3 & cmp_ne_16b_3 & _cmp_eq_16b_T_11; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 163:115]
  wire  cmp_le_32b_0 = _cmp_lt_32b_T & _cmp_eq_32b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 164:86]
  wire  cmp_le_32b_1 = _cmp_lt_32b_T_3 & _cmp_eq_32b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 164:86]
  wire  cmp_le_16b_0 = _cmp_lt_16b_T & _cmp_eq_16b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 165:86]
  wire  cmp_le_16b_1 = _cmp_lt_16b_T_3 & _cmp_eq_16b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 165:86]
  wire  cmp_le_16b_2 = _cmp_lt_16b_T_6 & _cmp_eq_16b_T_8; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 165:86]
  wire  cmp_le_16b_3 = _cmp_lt_16b_T_9 & _cmp_eq_16b_T_11; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 165:86]
  wire  cmp_gt_32b_0 = cmp_ge_32b_0 & cmp_ne_32b_0 & _cmp_eq_32b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 166:114]
  wire  cmp_gt_32b_1 = cmp_ge_32b_1 & cmp_ne_32b_1 & _cmp_eq_32b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 166:114]
  wire  cmp_gt_16b_0 = cmp_ge_16b_0 & cmp_ne_16b_0 & _cmp_eq_16b_T_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 167:114]
  wire  cmp_gt_16b_1 = cmp_ge_16b_1 & cmp_ne_16b_1 & _cmp_eq_16b_T_5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 167:114]
  wire  cmp_gt_16b_2 = cmp_ge_16b_2 & cmp_ne_16b_2 & _cmp_eq_16b_T_8; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 167:114]
  wire  cmp_gt_16b_3 = cmp_ge_16b_3 & cmp_ne_16b_3 & _cmp_eq_16b_T_11; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 167:114]
  wire  eq = io_in_bits_uop_ctrl_funct6[2:0] == 3'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 169:48]
  wire  le = io_in_bits_uop_ctrl_funct6[2:0] == 3'h1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 169:70]
  wire  lt = io_in_bits_uop_ctrl_funct6[2:0] == 3'h3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 169:92]
  wire  ne = io_in_bits_uop_ctrl_funct6[2:0] == 3'h4; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 170:48]
  wire  gt = io_in_bits_uop_ctrl_funct6[2:0] == 3'h5; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 170:70]
  wire  ge = io_in_bits_uop_ctrl_funct6[2:0] == 3'h7; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 170:92]
  wire [1:0] _vd_cmp_32b_T = {cmp_eq_32b_1,cmp_eq_32b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 172:31]
  wire [1:0] _vd_cmp_32b_T_1 = {cmp_le_32b_1,cmp_le_32b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 173:31]
  wire [1:0] _vd_cmp_32b_T_2 = {cmp_lt_32b_1,cmp_lt_32b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 174:31]
  wire [1:0] _vd_cmp_32b_T_3 = {cmp_ne_32b_1,cmp_ne_32b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 175:31]
  wire [1:0] _vd_cmp_32b_T_4 = {cmp_gt_32b_1,cmp_gt_32b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 176:31]
  wire [1:0] _vd_cmp_32b_T_5 = {cmp_ge_32b_1,cmp_ge_32b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 177:31]
  wire [1:0] _vd_cmp_32b_T_6 = eq ? _vd_cmp_32b_T : 2'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_7 = le ? _vd_cmp_32b_T_1 : 2'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_8 = lt ? _vd_cmp_32b_T_2 : 2'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_9 = ne ? _vd_cmp_32b_T_3 : 2'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_10 = gt ? _vd_cmp_32b_T_4 : 2'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_11 = ge ? _vd_cmp_32b_T_5 : 2'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_12 = _vd_cmp_32b_T_6 | _vd_cmp_32b_T_7; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_13 = _vd_cmp_32b_T_12 | _vd_cmp_32b_T_8; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_14 = _vd_cmp_32b_T_13 | _vd_cmp_32b_T_9; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] _vd_cmp_32b_T_15 = _vd_cmp_32b_T_14 | _vd_cmp_32b_T_10; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [1:0] vd_cmp_32b = _vd_cmp_32b_T_15 | _vd_cmp_32b_T_11; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T = {cmp_eq_16b_3,cmp_eq_16b_2,cmp_eq_16b_1,cmp_eq_16b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 180:31]
  wire [3:0] _vd_cmp_16b_T_1 = {cmp_le_16b_3,cmp_le_16b_2,cmp_le_16b_1,cmp_le_16b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 181:31]
  wire [3:0] _vd_cmp_16b_T_2 = {cmp_lt_16b_3,cmp_lt_16b_2,cmp_lt_16b_1,cmp_lt_16b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 182:31]
  wire [3:0] _vd_cmp_16b_T_3 = {cmp_ne_16b_3,cmp_ne_16b_2,cmp_ne_16b_1,cmp_ne_16b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 183:31]
  wire [3:0] _vd_cmp_16b_T_4 = {cmp_gt_16b_3,cmp_gt_16b_2,cmp_gt_16b_1,cmp_gt_16b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 184:31]
  wire [3:0] _vd_cmp_16b_T_5 = {cmp_ge_16b_3,cmp_ge_16b_2,cmp_ge_16b_1,cmp_ge_16b_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 185:31]
  wire [3:0] _vd_cmp_16b_T_6 = eq ? _vd_cmp_16b_T : 4'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_7 = le ? _vd_cmp_16b_T_1 : 4'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_8 = lt ? _vd_cmp_16b_T_2 : 4'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_9 = ne ? _vd_cmp_16b_T_3 : 4'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_10 = gt ? _vd_cmp_16b_T_4 : 4'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_11 = ge ? _vd_cmp_16b_T_5 : 4'h0; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_12 = _vd_cmp_16b_T_6 | _vd_cmp_16b_T_7; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_13 = _vd_cmp_16b_T_12 | _vd_cmp_16b_T_8; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_14 = _vd_cmp_16b_T_13 | _vd_cmp_16b_T_9; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] _vd_cmp_16b_T_15 = _vd_cmp_16b_T_14 | _vd_cmp_16b_T_10; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [3:0] vd_cmp_16b = _vd_cmp_16b_T_15 | _vd_cmp_16b_T_11; // @[src/main/scala/chisel3/util/Mux.scala 30:73]
  wire [63:0] _vd_cmp_T = {{60'd0}, vd_cmp_16b}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 187:49]
  wire [63:0] _vd_cmp_T_1 = {{62'd0}, vd_cmp_32b}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 187:76]
  wire [63:0] vd_cmp = res_is_16b_S2 ? _vd_cmp_T : _vd_cmp_T_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 187:19]
  wire [63:0] _out_bits_vd_T = {vfadd1_io_res,vfadd0_io_res}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 189:29]
  wire [63:0] _out_bits_vd_T_1 = {vd_minmax_3,vd_minmax_2,vd_minmax_1,vd_minmax_0}; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 190:30]
  wire [63:0] _out_bits_vd_T_2 = {_vd_sgn_3_T_11,vs1_S2_16b_3[14:0],vd_sgn_2,_vd_sgn_1_T_11,vs1_S2_16b_1[14:0],vd_sgn_0}
    ; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 191:24]
  wire  _out_bits_vd_T_3 = isMove_S2 | isVfmv_s_f_S2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 192:16]
  wire [63:0] _out_bits_vd_T_4 = isCmp_S2 ? vd_cmp : _out_bits_vd_T; // @[src/main/scala/chisel3/util/Mux.scala 141:16]
  reg  io_out_valid_REG; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 201:26]
  reg [4:0] io_out_bits_r_uop_ctrl_lsrc_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [4:0] io_out_bits_r_uop_ctrl_lsrc_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [4:0] io_out_bits_r_uop_ctrl_ldest; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [5:0] io_out_bits_r_uop_ctrl_funct6; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [2:0] io_out_bits_r_uop_ctrl_funct3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_illegal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_lsrcVal_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_lsrcVal_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_lsrcVal_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_ldestVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_rdVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_load; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_store; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_arith; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_crossLane; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_alu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_mul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_fp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_div; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_fixP; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_redu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_mask; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_perm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_vfadd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_vfma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_vfcvt; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_narrow; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ctrl_narrow_to_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [8:0] io_out_bits_r_uop_csr_vstart; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [9:0] io_out_bits_r_uop_csr_vl; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [1:0] io_out_bits_r_uop_csr_vxrm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [2:0] io_out_bits_r_uop_csr_frm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [2:0] io_out_bits_r_uop_csr_vlmul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [2:0] io_out_bits_r_uop_csr_vsew; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_csr_vill; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_csr_ma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_csr_ta; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_robIdx_flag; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [7:0] io_out_bits_r_uop_robIdx_value; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [2:0] io_out_bits_r_uop_veewVd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [2:0] io_out_bits_r_uop_uopIdx; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_uopEnd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [4:0] io_out_bits_r_uop_lsrcUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [4:0] io_out_bits_r_uop_lsrcUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [4:0] io_out_bits_r_uop_ldestUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_lsrcValUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_lsrcValUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_lsrcValUop_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_lmaskValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg  io_out_bits_r_uop_ldestValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  reg [63:0] io_out_bits_r_vd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
  FAdd_16_32 vfadd0 ( // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 28:22]
    .clock(vfadd0_clock),
    .reset(vfadd0_reset),
    .io_valid_in(vfadd0_io_valid_in),
    .io_is_bf16(vfadd0_io_is_bf16),
    .io_is_fp16(vfadd0_io_is_fp16),
    .io_is_fp32(vfadd0_io_is_fp32),
    .io_is_widen(vfadd0_io_is_widen),
    .io_a_already_widen(vfadd0_io_a_already_widen),
    .io_a(vfadd0_io_a),
    .io_b(vfadd0_io_b),
    .io_res(vfadd0_io_res),
    .io_valid_out(vfadd0_io_valid_out),
    .io_valid_S1(vfadd0_io_valid_S1)
  );
  FAdd_16_32 vfadd1 ( // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 29:22]
    .clock(vfadd1_clock),
    .reset(vfadd1_reset),
    .io_valid_in(vfadd1_io_valid_in),
    .io_is_bf16(vfadd1_io_is_bf16),
    .io_is_fp16(vfadd1_io_is_fp16),
    .io_is_fp32(vfadd1_io_is_fp32),
    .io_is_widen(vfadd1_io_is_widen),
    .io_a_already_widen(vfadd1_io_a_already_widen),
    .io_a(vfadd1_io_a),
    .io_b(vfadd1_io_b),
    .io_res(vfadd1_io_res),
    .io_valid_out(vfadd1_io_valid_out),
    .io_valid_S1(vfadd1_io_valid_S1)
  );
  assign io_out_valid = io_out_valid_REG; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 201:16]
  assign io_out_bits_uop_ctrl_lsrc_0 = io_out_bits_r_uop_ctrl_lsrc_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_lsrc_1 = io_out_bits_r_uop_ctrl_lsrc_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_ldest = io_out_bits_r_uop_ctrl_ldest; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_vm = io_out_bits_r_uop_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_funct6 = io_out_bits_r_uop_ctrl_funct6; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_funct3 = io_out_bits_r_uop_ctrl_funct3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_illegal = io_out_bits_r_uop_ctrl_illegal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_lsrcVal_0 = io_out_bits_r_uop_ctrl_lsrcVal_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_lsrcVal_1 = io_out_bits_r_uop_ctrl_lsrcVal_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_lsrcVal_2 = io_out_bits_r_uop_ctrl_lsrcVal_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_ldestVal = io_out_bits_r_uop_ctrl_ldestVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_rdVal = io_out_bits_r_uop_ctrl_rdVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_load = io_out_bits_r_uop_ctrl_load; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_store = io_out_bits_r_uop_ctrl_store; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_arith = io_out_bits_r_uop_ctrl_arith; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_crossLane = io_out_bits_r_uop_ctrl_crossLane; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_alu = io_out_bits_r_uop_ctrl_alu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_mul = io_out_bits_r_uop_ctrl_mul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_fp = io_out_bits_r_uop_ctrl_fp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_div = io_out_bits_r_uop_ctrl_div; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_fixP = io_out_bits_r_uop_ctrl_fixP; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_redu = io_out_bits_r_uop_ctrl_redu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_mask = io_out_bits_r_uop_ctrl_mask; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_perm = io_out_bits_r_uop_ctrl_perm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_vfadd = io_out_bits_r_uop_ctrl_vfadd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_vfma = io_out_bits_r_uop_ctrl_vfma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_vfcvt = io_out_bits_r_uop_ctrl_vfcvt; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_widen = io_out_bits_r_uop_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_widen2 = io_out_bits_r_uop_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_narrow = io_out_bits_r_uop_ctrl_narrow; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ctrl_narrow_to_1 = io_out_bits_r_uop_ctrl_narrow_to_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_vstart = io_out_bits_r_uop_csr_vstart; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_vl = io_out_bits_r_uop_csr_vl; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_vxrm = io_out_bits_r_uop_csr_vxrm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_frm = io_out_bits_r_uop_csr_frm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_vlmul = io_out_bits_r_uop_csr_vlmul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_vsew = io_out_bits_r_uop_csr_vsew; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_vill = io_out_bits_r_uop_csr_vill; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_ma = io_out_bits_r_uop_csr_ma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_csr_ta = io_out_bits_r_uop_csr_ta; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_robIdx_flag = io_out_bits_r_uop_robIdx_flag; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_robIdx_value = io_out_bits_r_uop_robIdx_value; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_veewVd = io_out_bits_r_uop_veewVd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_uopIdx = io_out_bits_r_uop_uopIdx; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_uopEnd = io_out_bits_r_uop_uopEnd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_lsrcUop_0 = io_out_bits_r_uop_lsrcUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_lsrcUop_1 = io_out_bits_r_uop_lsrcUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ldestUop = io_out_bits_r_uop_ldestUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_lsrcValUop_0 = io_out_bits_r_uop_lsrcValUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_lsrcValUop_1 = io_out_bits_r_uop_lsrcValUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_lsrcValUop_2 = io_out_bits_r_uop_lsrcValUop_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_lmaskValUop = io_out_bits_r_uop_lmaskValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_uop_ldestValUop = io_out_bits_r_uop_ldestValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_vd = io_out_bits_r_vd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_fflags_0 = 5'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_fflags_1 = 5'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_fflags_2 = 5'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_out_bits_fflags_3 = 5'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:15]
  assign io_rd_valid = io_in_bits_uop_ctrl_funct6 == 6'h10 & ~io_in_bits_uop_ctrl_funct3[2]; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 82:43]
  assign io_rd_bits = io_in_bits_vs2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 195:20]
  assign vfadd0_clock = clock;
  assign vfadd0_reset = reset;
  assign vfadd0_io_valid_in = io_in_valid; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 58:23]
  assign vfadd0_io_is_bf16 = io_sewIn_oneHot_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 59:22]
  assign vfadd0_io_is_fp16 = io_sewIn_oneHot_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 60:22]
  assign vfadd0_io_is_fp32 = io_sewIn_oneHot_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 61:22]
  assign vfadd0_io_is_widen = io_in_bits_uop_ctrl_widen | io_in_bits_uop_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 62:41]
  assign vfadd0_io_a_already_widen = io_in_bits_uop_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 63:30]
  assign vfadd0_io_a = _rs1_T ? _vfadd0_io_a_T_11 : _vfadd0_io_a_T_15; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 208:8]
  assign vfadd0_io_b = _rs1_T ? _vfadd0_io_b_T_11 : _vfadd0_io_b_T_15; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 208:8]
  assign vfadd1_clock = clock;
  assign vfadd1_reset = reset;
  assign vfadd1_io_valid_in = io_in_valid; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 58:23]
  assign vfadd1_io_is_bf16 = io_sewIn_oneHot_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 59:22]
  assign vfadd1_io_is_fp16 = io_sewIn_oneHot_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 60:22]
  assign vfadd1_io_is_fp32 = io_sewIn_oneHot_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 61:22]
  assign vfadd1_io_is_widen = io_in_bits_uop_ctrl_widen | io_in_bits_uop_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 62:41]
  assign vfadd1_io_a_already_widen = io_in_bits_uop_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 63:30]
  assign vfadd1_io_a = _rs1_T ? _vfadd1_io_a_T_11 : _vfadd1_io_a_T_15; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 208:8]
  assign vfadd1_io_b = _rs1_T ? _vfadd1_io_b_T_11 : _vfadd1_io_b_T_15; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 208:8]
  always @(posedge clock) begin
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_lsrc_0 <= io_in_bits_uop_ctrl_lsrc_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_lsrc_1 <= io_in_bits_uop_ctrl_lsrc_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_ldest <= io_in_bits_uop_ctrl_ldest; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_vm <= io_in_bits_uop_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_funct6 <= io_in_bits_uop_ctrl_funct6; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_funct3 <= io_in_bits_uop_ctrl_funct3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_illegal <= io_in_bits_uop_ctrl_illegal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_lsrcVal_0 <= io_in_bits_uop_ctrl_lsrcVal_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_lsrcVal_1 <= io_in_bits_uop_ctrl_lsrcVal_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_lsrcVal_2 <= io_in_bits_uop_ctrl_lsrcVal_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_ldestVal <= io_in_bits_uop_ctrl_ldestVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_rdVal <= io_in_bits_uop_ctrl_rdVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_load <= io_in_bits_uop_ctrl_load; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_store <= io_in_bits_uop_ctrl_store; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_arith <= io_in_bits_uop_ctrl_arith; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_crossLane <= io_in_bits_uop_ctrl_crossLane; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_alu <= io_in_bits_uop_ctrl_alu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_mul <= io_in_bits_uop_ctrl_mul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_fp <= io_in_bits_uop_ctrl_fp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_div <= io_in_bits_uop_ctrl_div; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_fixP <= io_in_bits_uop_ctrl_fixP; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_redu <= io_in_bits_uop_ctrl_redu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_mask <= io_in_bits_uop_ctrl_mask; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_perm <= io_in_bits_uop_ctrl_perm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_vfadd <= io_in_bits_uop_ctrl_vfadd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_vfma <= io_in_bits_uop_ctrl_vfma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_vfcvt <= io_in_bits_uop_ctrl_vfcvt; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_widen <= io_in_bits_uop_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_widen2 <= io_in_bits_uop_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_narrow <= io_in_bits_uop_ctrl_narrow; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ctrl_narrow_to_1 <= io_in_bits_uop_ctrl_narrow_to_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_vstart <= io_in_bits_uop_csr_vstart; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_vl <= io_in_bits_uop_csr_vl; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_vxrm <= io_in_bits_uop_csr_vxrm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_frm <= io_in_bits_uop_csr_frm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_vlmul <= io_in_bits_uop_csr_vlmul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_vsew <= io_in_bits_uop_csr_vsew; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_vill <= io_in_bits_uop_csr_vill; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_ma <= io_in_bits_uop_csr_ma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_csr_ta <= io_in_bits_uop_csr_ta; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_robIdx_flag <= io_in_bits_uop_robIdx_flag; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_robIdx_value <= io_in_bits_uop_robIdx_value; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_veewVd <= io_in_bits_uop_veewVd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_uopIdx <= io_in_bits_uop_uopIdx; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_uopEnd <= io_in_bits_uop_uopEnd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_lsrcUop_0 <= io_in_bits_uop_lsrcUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_lsrcUop_1 <= io_in_bits_uop_lsrcUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ldestUop <= io_in_bits_uop_ldestUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_lsrcValUop_0 <= io_in_bits_uop_lsrcValUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_lsrcValUop_1 <= io_in_bits_uop_lsrcValUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_lsrcValUop_2 <= io_in_bits_uop_lsrcValUop_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_lmaskValUop <= io_in_bits_uop_lmaskValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
      out_bits_uop_r_ldestValUop <= io_in_bits_uop_ldestValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:38]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_lsrc_0 <= out_bits_uop_r_ctrl_lsrc_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_lsrc_1 <= out_bits_uop_r_ctrl_lsrc_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_ldest <= out_bits_uop_r_ctrl_ldest; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_vm <= out_bits_uop_r_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_funct6 <= out_bits_uop_r_ctrl_funct6; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_funct3 <= out_bits_uop_r_ctrl_funct3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_illegal <= out_bits_uop_r_ctrl_illegal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_lsrcVal_0 <= out_bits_uop_r_ctrl_lsrcVal_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_lsrcVal_1 <= out_bits_uop_r_ctrl_lsrcVal_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_lsrcVal_2 <= out_bits_uop_r_ctrl_lsrcVal_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_ldestVal <= out_bits_uop_r_ctrl_ldestVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_rdVal <= out_bits_uop_r_ctrl_rdVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_load <= out_bits_uop_r_ctrl_load; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_store <= out_bits_uop_r_ctrl_store; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_arith <= out_bits_uop_r_ctrl_arith; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_crossLane <= out_bits_uop_r_ctrl_crossLane; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_alu <= out_bits_uop_r_ctrl_alu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_mul <= out_bits_uop_r_ctrl_mul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_fp <= out_bits_uop_r_ctrl_fp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_div <= out_bits_uop_r_ctrl_div; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_fixP <= out_bits_uop_r_ctrl_fixP; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_redu <= out_bits_uop_r_ctrl_redu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_mask <= out_bits_uop_r_ctrl_mask; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_perm <= out_bits_uop_r_ctrl_perm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_vfadd <= out_bits_uop_r_ctrl_vfadd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_vfma <= out_bits_uop_r_ctrl_vfma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_vfcvt <= out_bits_uop_r_ctrl_vfcvt; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_widen <= out_bits_uop_r_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_widen2 <= out_bits_uop_r_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_narrow <= out_bits_uop_r_ctrl_narrow; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ctrl_narrow_to_1 <= out_bits_uop_r_ctrl_narrow_to_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_vstart <= out_bits_uop_r_csr_vstart; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_vl <= out_bits_uop_r_csr_vl; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_vxrm <= out_bits_uop_r_csr_vxrm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_frm <= out_bits_uop_r_csr_frm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_vlmul <= out_bits_uop_r_csr_vlmul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_vsew <= out_bits_uop_r_csr_vsew; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_vill <= out_bits_uop_r_csr_vill; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_ma <= out_bits_uop_r_csr_ma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_csr_ta <= out_bits_uop_r_csr_ta; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_robIdx_flag <= out_bits_uop_r_robIdx_flag; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_robIdx_value <= out_bits_uop_r_robIdx_value; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_veewVd <= out_bits_uop_r_veewVd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_uopIdx <= out_bits_uop_r_uopIdx; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_uopEnd <= out_bits_uop_r_uopEnd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_lsrcUop_0 <= out_bits_uop_r_lsrcUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_lsrcUop_1 <= out_bits_uop_r_lsrcUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ldestUop <= out_bits_uop_r_ldestUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_lsrcValUop_0 <= out_bits_uop_r_lsrcValUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_lsrcValUop_1 <= out_bits_uop_r_lsrcValUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_lsrcValUop_2 <= out_bits_uop_r_lsrcValUop_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_lmaskValUop <= out_bits_uop_r_lmaskValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
      out_bits_uop_r_1_ldestValUop <= out_bits_uop_r_ldestValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 113:28]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 115:35]
      vs1_S2_r <= io_in_bits_vs1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 115:35]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 115:25]
      vs1_S2 <= vs1_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 115:25]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 116:35]
      vs2_S2_r <= io_in_bits_vs2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 116:35]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 116:25]
      vs2_S2 <= vs2_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 116:25]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 117:35]
      if (_rs1_T) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 33:16]
        rs1_S2_r <= _rs1_T_3;
      end else begin
        rs1_S2_r <= _rs1_T_5;
      end
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 117:25]
      rs1_S2 <= rs1_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 117:25]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 120:42]
      res_is_16b_S2_r <= res_is_16b; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 120:42]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 120:32]
      res_is_16b_S2 <= res_is_16b_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 120:32]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 121:40]
      isMinMax_S2_r <= isMinMax; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 121:40]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 121:30]
      isMinMax_S2 <= isMinMax_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 121:30]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 122:37]
      isSgn_S2_r <= isSgn; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 122:37]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 122:27]
      isSgn_S2 <= isSgn_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 122:27]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 123:37]
      isCmp_S2_r <= isCmp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 123:37]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 123:27]
      isCmp_S2 <= isCmp_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 123:27]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 124:38]
      isMove_S2_r <= isMove; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 124:38]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 124:28]
      isMove_S2 <= isMove_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 124:28]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 125:42]
      isVfmv_s_f_S2_r <= isVfmv_s_f; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 125:42]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 125:32]
      isVfmv_s_f_S2 <= isVfmv_s_f_S2_r; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 125:32]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:49]
      input_has_NaN_32b_S2_r_0 <= input_has_NaN_32b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:49]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:49]
      input_has_NaN_32b_S2_r_1 <= input_has_NaN_32b_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:49]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:39]
      input_has_NaN_32b_S2_0 <= input_has_NaN_32b_S2_r_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:39]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:39]
      input_has_NaN_32b_S2_1 <= input_has_NaN_32b_S2_r_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 152:39]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
      input_has_NaN_16b_S2_r_0 <= input_has_NaN_16b_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
      input_has_NaN_16b_S2_r_1 <= input_has_NaN_16b_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
      input_has_NaN_16b_S2_r_2 <= input_has_NaN_16b_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
    end
    if (io_in_valid) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
      input_has_NaN_16b_S2_r_3 <= input_has_NaN_16b_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:49]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
      input_has_NaN_16b_S2_0 <= input_has_NaN_16b_S2_r_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
      input_has_NaN_16b_S2_1 <= input_has_NaN_16b_S2_r_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
      input_has_NaN_16b_S2_2 <= input_has_NaN_16b_S2_r_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
    end
    if (vfadd0_io_valid_S1) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
      input_has_NaN_16b_S2_3 <= input_has_NaN_16b_S2_r_3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 153:39]
    end
    if (reset) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 201:26]
      io_out_valid_REG <= 1'h0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 201:26]
    end else begin
      io_out_valid_REG <= vfadd0_io_valid_out; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 201:26]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_lsrc_0 <= out_bits_uop_r_1_ctrl_lsrc_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_lsrc_1 <= out_bits_uop_r_1_ctrl_lsrc_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_ldest <= out_bits_uop_r_1_ctrl_ldest; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_vm <= out_bits_uop_r_1_ctrl_vm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_funct6 <= out_bits_uop_r_1_ctrl_funct6; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_funct3 <= out_bits_uop_r_1_ctrl_funct3; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_illegal <= out_bits_uop_r_1_ctrl_illegal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_lsrcVal_0 <= out_bits_uop_r_1_ctrl_lsrcVal_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_lsrcVal_1 <= out_bits_uop_r_1_ctrl_lsrcVal_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_lsrcVal_2 <= out_bits_uop_r_1_ctrl_lsrcVal_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_ldestVal <= out_bits_uop_r_1_ctrl_ldestVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_rdVal <= out_bits_uop_r_1_ctrl_rdVal; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_load <= out_bits_uop_r_1_ctrl_load; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_store <= out_bits_uop_r_1_ctrl_store; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_arith <= out_bits_uop_r_1_ctrl_arith; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_crossLane <= out_bits_uop_r_1_ctrl_crossLane; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_alu <= out_bits_uop_r_1_ctrl_alu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_mul <= out_bits_uop_r_1_ctrl_mul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_fp <= out_bits_uop_r_1_ctrl_fp; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_div <= out_bits_uop_r_1_ctrl_div; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_fixP <= out_bits_uop_r_1_ctrl_fixP; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_redu <= out_bits_uop_r_1_ctrl_redu; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_mask <= out_bits_uop_r_1_ctrl_mask; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_perm <= out_bits_uop_r_1_ctrl_perm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_vfadd <= out_bits_uop_r_1_ctrl_vfadd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_vfma <= out_bits_uop_r_1_ctrl_vfma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_vfcvt <= out_bits_uop_r_1_ctrl_vfcvt; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_widen <= out_bits_uop_r_1_ctrl_widen; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_widen2 <= out_bits_uop_r_1_ctrl_widen2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_narrow <= out_bits_uop_r_1_ctrl_narrow; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ctrl_narrow_to_1 <= out_bits_uop_r_1_ctrl_narrow_to_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_vstart <= out_bits_uop_r_1_csr_vstart; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_vl <= out_bits_uop_r_1_csr_vl; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_vxrm <= out_bits_uop_r_1_csr_vxrm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_frm <= out_bits_uop_r_1_csr_frm; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_vlmul <= out_bits_uop_r_1_csr_vlmul; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_vsew <= out_bits_uop_r_1_csr_vsew; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_vill <= out_bits_uop_r_1_csr_vill; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_ma <= out_bits_uop_r_1_csr_ma; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_csr_ta <= out_bits_uop_r_1_csr_ta; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_robIdx_flag <= out_bits_uop_r_1_robIdx_flag; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_robIdx_value <= out_bits_uop_r_1_robIdx_value; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_veewVd <= out_bits_uop_r_1_veewVd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_uopIdx <= out_bits_uop_r_1_uopIdx; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_uopEnd <= out_bits_uop_r_1_uopEnd; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_lsrcUop_0 <= out_bits_uop_r_1_lsrcUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_lsrcUop_1 <= out_bits_uop_r_1_lsrcUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ldestUop <= out_bits_uop_r_1_ldestUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_lsrcValUop_0 <= out_bits_uop_r_1_lsrcValUop_0; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_lsrcValUop_1 <= out_bits_uop_r_1_lsrcValUop_1; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_lsrcValUop_2 <= out_bits_uop_r_1_lsrcValUop_2; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_lmaskValUop <= out_bits_uop_r_1_lmaskValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      io_out_bits_r_uop_ldestValUop <= out_bits_uop_r_1_ldestValUop; // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
    end
    if (vfadd0_io_valid_out) begin // @[src/main/scala/vpu/exu/laneexu/fp/fadd_16_32/LaneFAdd.scala 202:27]
      if (isMinMax_S2) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        io_out_bits_r_vd <= _out_bits_vd_T_1;
      end else if (isSgn_S2) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        io_out_bits_r_vd <= _out_bits_vd_T_2;
      end else if (_out_bits_vd_T_3) begin // @[src/main/scala/chisel3/util/Mux.scala 141:16]
        io_out_bits_r_vd <= rs1_S2;
      end else begin
        io_out_bits_r_vd <= _out_bits_vd_T_4;
      end
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_lsrc_0 = _RAND_0[4:0];
  _RAND_1 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_lsrc_1 = _RAND_1[4:0];
  _RAND_2 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_ldest = _RAND_2[4:0];
  _RAND_3 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_vm = _RAND_3[0:0];
  _RAND_4 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_funct6 = _RAND_4[5:0];
  _RAND_5 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_funct3 = _RAND_5[2:0];
  _RAND_6 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_illegal = _RAND_6[0:0];
  _RAND_7 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_lsrcVal_0 = _RAND_7[0:0];
  _RAND_8 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_lsrcVal_1 = _RAND_8[0:0];
  _RAND_9 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_lsrcVal_2 = _RAND_9[0:0];
  _RAND_10 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_ldestVal = _RAND_10[0:0];
  _RAND_11 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_rdVal = _RAND_11[0:0];
  _RAND_12 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_load = _RAND_12[0:0];
  _RAND_13 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_store = _RAND_13[0:0];
  _RAND_14 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_arith = _RAND_14[0:0];
  _RAND_15 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_crossLane = _RAND_15[0:0];
  _RAND_16 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_alu = _RAND_16[0:0];
  _RAND_17 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_mul = _RAND_17[0:0];
  _RAND_18 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_fp = _RAND_18[0:0];
  _RAND_19 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_div = _RAND_19[0:0];
  _RAND_20 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_fixP = _RAND_20[0:0];
  _RAND_21 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_redu = _RAND_21[0:0];
  _RAND_22 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_mask = _RAND_22[0:0];
  _RAND_23 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_perm = _RAND_23[0:0];
  _RAND_24 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_vfadd = _RAND_24[0:0];
  _RAND_25 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_vfma = _RAND_25[0:0];
  _RAND_26 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_vfcvt = _RAND_26[0:0];
  _RAND_27 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_widen = _RAND_27[0:0];
  _RAND_28 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_widen2 = _RAND_28[0:0];
  _RAND_29 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_narrow = _RAND_29[0:0];
  _RAND_30 = {1{`RANDOM}};
  out_bits_uop_r_ctrl_narrow_to_1 = _RAND_30[0:0];
  _RAND_31 = {1{`RANDOM}};
  out_bits_uop_r_csr_vstart = _RAND_31[8:0];
  _RAND_32 = {1{`RANDOM}};
  out_bits_uop_r_csr_vl = _RAND_32[9:0];
  _RAND_33 = {1{`RANDOM}};
  out_bits_uop_r_csr_vxrm = _RAND_33[1:0];
  _RAND_34 = {1{`RANDOM}};
  out_bits_uop_r_csr_frm = _RAND_34[2:0];
  _RAND_35 = {1{`RANDOM}};
  out_bits_uop_r_csr_vlmul = _RAND_35[2:0];
  _RAND_36 = {1{`RANDOM}};
  out_bits_uop_r_csr_vsew = _RAND_36[2:0];
  _RAND_37 = {1{`RANDOM}};
  out_bits_uop_r_csr_vill = _RAND_37[0:0];
  _RAND_38 = {1{`RANDOM}};
  out_bits_uop_r_csr_ma = _RAND_38[0:0];
  _RAND_39 = {1{`RANDOM}};
  out_bits_uop_r_csr_ta = _RAND_39[0:0];
  _RAND_40 = {1{`RANDOM}};
  out_bits_uop_r_robIdx_flag = _RAND_40[0:0];
  _RAND_41 = {1{`RANDOM}};
  out_bits_uop_r_robIdx_value = _RAND_41[7:0];
  _RAND_42 = {1{`RANDOM}};
  out_bits_uop_r_veewVd = _RAND_42[2:0];
  _RAND_43 = {1{`RANDOM}};
  out_bits_uop_r_uopIdx = _RAND_43[2:0];
  _RAND_44 = {1{`RANDOM}};
  out_bits_uop_r_uopEnd = _RAND_44[0:0];
  _RAND_45 = {1{`RANDOM}};
  out_bits_uop_r_lsrcUop_0 = _RAND_45[4:0];
  _RAND_46 = {1{`RANDOM}};
  out_bits_uop_r_lsrcUop_1 = _RAND_46[4:0];
  _RAND_47 = {1{`RANDOM}};
  out_bits_uop_r_ldestUop = _RAND_47[4:0];
  _RAND_48 = {1{`RANDOM}};
  out_bits_uop_r_lsrcValUop_0 = _RAND_48[0:0];
  _RAND_49 = {1{`RANDOM}};
  out_bits_uop_r_lsrcValUop_1 = _RAND_49[0:0];
  _RAND_50 = {1{`RANDOM}};
  out_bits_uop_r_lsrcValUop_2 = _RAND_50[0:0];
  _RAND_51 = {1{`RANDOM}};
  out_bits_uop_r_lmaskValUop = _RAND_51[0:0];
  _RAND_52 = {1{`RANDOM}};
  out_bits_uop_r_ldestValUop = _RAND_52[0:0];
  _RAND_53 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_lsrc_0 = _RAND_53[4:0];
  _RAND_54 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_lsrc_1 = _RAND_54[4:0];
  _RAND_55 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_ldest = _RAND_55[4:0];
  _RAND_56 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_vm = _RAND_56[0:0];
  _RAND_57 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_funct6 = _RAND_57[5:0];
  _RAND_58 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_funct3 = _RAND_58[2:0];
  _RAND_59 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_illegal = _RAND_59[0:0];
  _RAND_60 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_lsrcVal_0 = _RAND_60[0:0];
  _RAND_61 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_lsrcVal_1 = _RAND_61[0:0];
  _RAND_62 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_lsrcVal_2 = _RAND_62[0:0];
  _RAND_63 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_ldestVal = _RAND_63[0:0];
  _RAND_64 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_rdVal = _RAND_64[0:0];
  _RAND_65 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_load = _RAND_65[0:0];
  _RAND_66 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_store = _RAND_66[0:0];
  _RAND_67 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_arith = _RAND_67[0:0];
  _RAND_68 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_crossLane = _RAND_68[0:0];
  _RAND_69 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_alu = _RAND_69[0:0];
  _RAND_70 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_mul = _RAND_70[0:0];
  _RAND_71 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_fp = _RAND_71[0:0];
  _RAND_72 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_div = _RAND_72[0:0];
  _RAND_73 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_fixP = _RAND_73[0:0];
  _RAND_74 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_redu = _RAND_74[0:0];
  _RAND_75 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_mask = _RAND_75[0:0];
  _RAND_76 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_perm = _RAND_76[0:0];
  _RAND_77 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_vfadd = _RAND_77[0:0];
  _RAND_78 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_vfma = _RAND_78[0:0];
  _RAND_79 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_vfcvt = _RAND_79[0:0];
  _RAND_80 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_widen = _RAND_80[0:0];
  _RAND_81 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_widen2 = _RAND_81[0:0];
  _RAND_82 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_narrow = _RAND_82[0:0];
  _RAND_83 = {1{`RANDOM}};
  out_bits_uop_r_1_ctrl_narrow_to_1 = _RAND_83[0:0];
  _RAND_84 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_vstart = _RAND_84[8:0];
  _RAND_85 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_vl = _RAND_85[9:0];
  _RAND_86 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_vxrm = _RAND_86[1:0];
  _RAND_87 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_frm = _RAND_87[2:0];
  _RAND_88 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_vlmul = _RAND_88[2:0];
  _RAND_89 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_vsew = _RAND_89[2:0];
  _RAND_90 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_vill = _RAND_90[0:0];
  _RAND_91 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_ma = _RAND_91[0:0];
  _RAND_92 = {1{`RANDOM}};
  out_bits_uop_r_1_csr_ta = _RAND_92[0:0];
  _RAND_93 = {1{`RANDOM}};
  out_bits_uop_r_1_robIdx_flag = _RAND_93[0:0];
  _RAND_94 = {1{`RANDOM}};
  out_bits_uop_r_1_robIdx_value = _RAND_94[7:0];
  _RAND_95 = {1{`RANDOM}};
  out_bits_uop_r_1_veewVd = _RAND_95[2:0];
  _RAND_96 = {1{`RANDOM}};
  out_bits_uop_r_1_uopIdx = _RAND_96[2:0];
  _RAND_97 = {1{`RANDOM}};
  out_bits_uop_r_1_uopEnd = _RAND_97[0:0];
  _RAND_98 = {1{`RANDOM}};
  out_bits_uop_r_1_lsrcUop_0 = _RAND_98[4:0];
  _RAND_99 = {1{`RANDOM}};
  out_bits_uop_r_1_lsrcUop_1 = _RAND_99[4:0];
  _RAND_100 = {1{`RANDOM}};
  out_bits_uop_r_1_ldestUop = _RAND_100[4:0];
  _RAND_101 = {1{`RANDOM}};
  out_bits_uop_r_1_lsrcValUop_0 = _RAND_101[0:0];
  _RAND_102 = {1{`RANDOM}};
  out_bits_uop_r_1_lsrcValUop_1 = _RAND_102[0:0];
  _RAND_103 = {1{`RANDOM}};
  out_bits_uop_r_1_lsrcValUop_2 = _RAND_103[0:0];
  _RAND_104 = {1{`RANDOM}};
  out_bits_uop_r_1_lmaskValUop = _RAND_104[0:0];
  _RAND_105 = {1{`RANDOM}};
  out_bits_uop_r_1_ldestValUop = _RAND_105[0:0];
  _RAND_106 = {2{`RANDOM}};
  vs1_S2_r = _RAND_106[63:0];
  _RAND_107 = {2{`RANDOM}};
  vs1_S2 = _RAND_107[63:0];
  _RAND_108 = {2{`RANDOM}};
  vs2_S2_r = _RAND_108[63:0];
  _RAND_109 = {2{`RANDOM}};
  vs2_S2 = _RAND_109[63:0];
  _RAND_110 = {2{`RANDOM}};
  rs1_S2_r = _RAND_110[63:0];
  _RAND_111 = {2{`RANDOM}};
  rs1_S2 = _RAND_111[63:0];
  _RAND_112 = {1{`RANDOM}};
  res_is_16b_S2_r = _RAND_112[0:0];
  _RAND_113 = {1{`RANDOM}};
  res_is_16b_S2 = _RAND_113[0:0];
  _RAND_114 = {1{`RANDOM}};
  isMinMax_S2_r = _RAND_114[0:0];
  _RAND_115 = {1{`RANDOM}};
  isMinMax_S2 = _RAND_115[0:0];
  _RAND_116 = {1{`RANDOM}};
  isSgn_S2_r = _RAND_116[0:0];
  _RAND_117 = {1{`RANDOM}};
  isSgn_S2 = _RAND_117[0:0];
  _RAND_118 = {1{`RANDOM}};
  isCmp_S2_r = _RAND_118[0:0];
  _RAND_119 = {1{`RANDOM}};
  isCmp_S2 = _RAND_119[0:0];
  _RAND_120 = {1{`RANDOM}};
  isMove_S2_r = _RAND_120[0:0];
  _RAND_121 = {1{`RANDOM}};
  isMove_S2 = _RAND_121[0:0];
  _RAND_122 = {1{`RANDOM}};
  isVfmv_s_f_S2_r = _RAND_122[0:0];
  _RAND_123 = {1{`RANDOM}};
  isVfmv_s_f_S2 = _RAND_123[0:0];
  _RAND_124 = {1{`RANDOM}};
  input_has_NaN_32b_S2_r_0 = _RAND_124[0:0];
  _RAND_125 = {1{`RANDOM}};
  input_has_NaN_32b_S2_r_1 = _RAND_125[0:0];
  _RAND_126 = {1{`RANDOM}};
  input_has_NaN_32b_S2_0 = _RAND_126[0:0];
  _RAND_127 = {1{`RANDOM}};
  input_has_NaN_32b_S2_1 = _RAND_127[0:0];
  _RAND_128 = {1{`RANDOM}};
  input_has_NaN_16b_S2_r_0 = _RAND_128[0:0];
  _RAND_129 = {1{`RANDOM}};
  input_has_NaN_16b_S2_r_1 = _RAND_129[0:0];
  _RAND_130 = {1{`RANDOM}};
  input_has_NaN_16b_S2_r_2 = _RAND_130[0:0];
  _RAND_131 = {1{`RANDOM}};
  input_has_NaN_16b_S2_r_3 = _RAND_131[0:0];
  _RAND_132 = {1{`RANDOM}};
  input_has_NaN_16b_S2_0 = _RAND_132[0:0];
  _RAND_133 = {1{`RANDOM}};
  input_has_NaN_16b_S2_1 = _RAND_133[0:0];
  _RAND_134 = {1{`RANDOM}};
  input_has_NaN_16b_S2_2 = _RAND_134[0:0];
  _RAND_135 = {1{`RANDOM}};
  input_has_NaN_16b_S2_3 = _RAND_135[0:0];
  _RAND_136 = {1{`RANDOM}};
  io_out_valid_REG = _RAND_136[0:0];
  _RAND_137 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_lsrc_0 = _RAND_137[4:0];
  _RAND_138 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_lsrc_1 = _RAND_138[4:0];
  _RAND_139 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_ldest = _RAND_139[4:0];
  _RAND_140 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_vm = _RAND_140[0:0];
  _RAND_141 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_funct6 = _RAND_141[5:0];
  _RAND_142 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_funct3 = _RAND_142[2:0];
  _RAND_143 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_illegal = _RAND_143[0:0];
  _RAND_144 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_lsrcVal_0 = _RAND_144[0:0];
  _RAND_145 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_lsrcVal_1 = _RAND_145[0:0];
  _RAND_146 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_lsrcVal_2 = _RAND_146[0:0];
  _RAND_147 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_ldestVal = _RAND_147[0:0];
  _RAND_148 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_rdVal = _RAND_148[0:0];
  _RAND_149 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_load = _RAND_149[0:0];
  _RAND_150 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_store = _RAND_150[0:0];
  _RAND_151 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_arith = _RAND_151[0:0];
  _RAND_152 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_crossLane = _RAND_152[0:0];
  _RAND_153 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_alu = _RAND_153[0:0];
  _RAND_154 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_mul = _RAND_154[0:0];
  _RAND_155 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_fp = _RAND_155[0:0];
  _RAND_156 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_div = _RAND_156[0:0];
  _RAND_157 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_fixP = _RAND_157[0:0];
  _RAND_158 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_redu = _RAND_158[0:0];
  _RAND_159 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_mask = _RAND_159[0:0];
  _RAND_160 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_perm = _RAND_160[0:0];
  _RAND_161 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_vfadd = _RAND_161[0:0];
  _RAND_162 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_vfma = _RAND_162[0:0];
  _RAND_163 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_vfcvt = _RAND_163[0:0];
  _RAND_164 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_widen = _RAND_164[0:0];
  _RAND_165 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_widen2 = _RAND_165[0:0];
  _RAND_166 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_narrow = _RAND_166[0:0];
  _RAND_167 = {1{`RANDOM}};
  io_out_bits_r_uop_ctrl_narrow_to_1 = _RAND_167[0:0];
  _RAND_168 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_vstart = _RAND_168[8:0];
  _RAND_169 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_vl = _RAND_169[9:0];
  _RAND_170 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_vxrm = _RAND_170[1:0];
  _RAND_171 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_frm = _RAND_171[2:0];
  _RAND_172 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_vlmul = _RAND_172[2:0];
  _RAND_173 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_vsew = _RAND_173[2:0];
  _RAND_174 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_vill = _RAND_174[0:0];
  _RAND_175 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_ma = _RAND_175[0:0];
  _RAND_176 = {1{`RANDOM}};
  io_out_bits_r_uop_csr_ta = _RAND_176[0:0];
  _RAND_177 = {1{`RANDOM}};
  io_out_bits_r_uop_robIdx_flag = _RAND_177[0:0];
  _RAND_178 = {1{`RANDOM}};
  io_out_bits_r_uop_robIdx_value = _RAND_178[7:0];
  _RAND_179 = {1{`RANDOM}};
  io_out_bits_r_uop_veewVd = _RAND_179[2:0];
  _RAND_180 = {1{`RANDOM}};
  io_out_bits_r_uop_uopIdx = _RAND_180[2:0];
  _RAND_181 = {1{`RANDOM}};
  io_out_bits_r_uop_uopEnd = _RAND_181[0:0];
  _RAND_182 = {1{`RANDOM}};
  io_out_bits_r_uop_lsrcUop_0 = _RAND_182[4:0];
  _RAND_183 = {1{`RANDOM}};
  io_out_bits_r_uop_lsrcUop_1 = _RAND_183[4:0];
  _RAND_184 = {1{`RANDOM}};
  io_out_bits_r_uop_ldestUop = _RAND_184[4:0];
  _RAND_185 = {1{`RANDOM}};
  io_out_bits_r_uop_lsrcValUop_0 = _RAND_185[0:0];
  _RAND_186 = {1{`RANDOM}};
  io_out_bits_r_uop_lsrcValUop_1 = _RAND_186[0:0];
  _RAND_187 = {1{`RANDOM}};
  io_out_bits_r_uop_lsrcValUop_2 = _RAND_187[0:0];
  _RAND_188 = {1{`RANDOM}};
  io_out_bits_r_uop_lmaskValUop = _RAND_188[0:0];
  _RAND_189 = {1{`RANDOM}};
  io_out_bits_r_uop_ldestValUop = _RAND_189[0:0];
  _RAND_190 = {2{`RANDOM}};
  io_out_bits_r_vd = _RAND_190[63:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule

