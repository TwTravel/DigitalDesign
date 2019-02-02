// Fast Fourier Transform (64 pt)
// fft64pt.v
//
// ECE 576, Fall 2007 - Cornell University
//
// Revision History:
//
// v1.0		Adrian Wong		2007.11.18		Initial revision (combinatorially)

module fft64pt(sample_clk, sample_data,
freq_1, freq_2, freq_3, freq_4, freq_5, freq_6, freq_7, freq_8,
freq_9, freq_10, freq_11, freq_12, freq_13, freq_14, freq_15, freq_16,
freq_17, freq_18, freq_19, freq_20, freq_21, freq_22, freq_23, freq_24,
freq_25, freq_26, freq_27, freq_28, freq_29, freq_30, freq_31, freq_32);

input	sample_clk;
input	[15:0] sample_data;
output	[7:0] freq_1, freq_2, freq_3, freq_4, freq_5, freq_6, freq_7, freq_8,
freq_9, freq_10, freq_11, freq_12, freq_13, freq_14, freq_15, freq_16,
freq_17, freq_18, freq_19, freq_20, freq_21, freq_22, freq_23, freq_24,
freq_25, freq_26, freq_27, freq_28, freq_29, freq_30, freq_31, freq_32;

reg signed [17:0] stage1_1_r, stage1_2_r, stage1_3_r, stage1_4_r, stage1_5_r, stage1_6_r, stage1_7_r,stage1_8_r,
stage1_9_r, stage1_10_r, stage1_11_r, stage1_12_r, stage1_13_r, stage1_14_r, stage1_15_r, stage1_16_r,
stage1_17_r, stage1_18_r, stage1_19_r, stage1_20_r, stage1_21_r, stage1_22_r, stage1_23_r, stage1_24_r,
stage1_25_r, stage1_26_r, stage1_27_r, stage1_28_r, stage1_29_r, stage1_30_r, stage1_31_r, stage1_32_r,
stage1_33_r, stage1_34_r, stage1_35_r, stage1_36_r, stage1_37_r, stage1_38_r, stage1_39_r, stage1_40_r,
stage1_41_r, stage1_42_r, stage1_43_r, stage1_44_r, stage1_45_r, stage1_46_r, stage1_47_r, stage1_48_r,
stage1_49_r, stage1_50_r, stage1_51_r, stage1_52_r, stage1_53_r, stage1_54_r, stage1_55_r, stage1_56_r,
stage1_57_r, stage1_58_r, stage1_59_r, stage1_60_r, stage1_61_r, stage1_62_r, stage1_63_r, stage1_64_r;

reg signed [17:0] stage1_1_c, stage1_2_c, stage1_3_c, stage1_4_c, stage1_5_c, stage1_6_c, stage1_7_c,stage1_8_c,
stage1_9_c, stage1_10_c, stage1_11_c, stage1_12_c, stage1_13_c, stage1_14_c, stage1_15_c, stage1_16_c,
stage1_17_c, stage1_18_c, stage1_19_c, stage1_20_c, stage1_21_c, stage1_22_c, stage1_23_c, stage1_24_c,
stage1_25_c, stage1_26_c, stage1_27_c, stage1_28_c, stage1_29_c, stage1_30_c, stage1_31_c, stage1_32_c,
stage1_33_c, stage1_34_c, stage1_35_c, stage1_36_c, stage1_37_c, stage1_38_c, stage1_39_c, stage1_40_c,
stage1_41_c, stage1_42_c, stage1_43_c, stage1_44_c, stage1_45_c, stage1_46_c, stage1_47_c, stage1_48_c,
stage1_49_c, stage1_50_c, stage1_51_c, stage1_52_c, stage1_53_c, stage1_54_c, stage1_55_c, stage1_56_c,
stage1_57_c, stage1_58_c, stage1_59_c, stage1_60_c, stage1_61_c, stage1_62_c, stage1_63_c, stage1_64_c;

wire	[17:0] stage2_1_r, stage2_2_r, stage2_3_r, stage2_4_r, stage2_5_r, stage2_6_r, stage2_7_r,stage2_8_r,
stage2_9_r, stage2_10_r, stage2_11_r, stage2_12_r, stage2_13_r, stage2_14_r, stage2_15_r, stage2_16_r,
stage2_17_r, stage2_18_r, stage2_19_r, stage2_20_r, stage2_21_r, stage2_22_r, stage2_23_r, stage2_24_r,
stage2_25_r, stage2_26_r, stage2_27_r, stage2_28_r, stage2_29_r, stage2_30_r, stage2_31_r, stage2_32_r,
stage2_33_r, stage2_34_r, stage2_35_r, stage2_36_r, stage2_37_r, stage2_38_r, stage2_39_r, stage2_40_r,
stage2_41_r, stage2_42_r, stage2_43_r, stage2_44_r, stage2_45_r, stage2_46_r, stage2_47_r, stage2_48_r,
stage2_49_r, stage2_50_r, stage2_51_r, stage2_52_r, stage2_53_r, stage2_54_r, stage2_55_r, stage2_56_r,
stage2_57_r, stage2_58_r, stage2_59_r, stage2_60_r, stage2_61_r, stage2_62_r, stage2_63_r, stage2_64_r;

wire	[17:0] stage2_1_c, stage2_2_c, stage2_3_c, stage2_4_c, stage2_5_c, stage2_6_c, stage2_7_c, stage2_8_c,
stage2_9_c, stage2_10_c, stage2_11_c, stage2_12_c, stage2_13_c, stage2_14_c, stage2_15_c, stage2_16_c,
stage2_17_c, stage2_18_c, stage2_19_c, stage2_20_c, stage2_21_c, stage2_22_c, stage2_23_c, stage2_24_c,
stage2_25_c, stage2_26_c, stage2_27_c, stage2_28_c, stage2_29_c, stage2_30_c, stage2_31_c, stage2_32_c,
stage2_33_c, stage2_34_c, stage2_35_c, stage2_36_c, stage2_37_c, stage2_38_c, stage2_39_c, stage2_40_c,
stage2_41_c, stage2_42_c, stage2_43_c, stage2_44_c, stage2_45_c, stage2_46_c, stage2_47_c, stage2_48_c,
stage2_49_c, stage2_50_c, stage2_51_c, stage2_52_c, stage2_53_c, stage2_54_c, stage2_55_c, stage2_56_c,
stage2_57_c, stage2_58_c, stage2_59_c, stage2_60_c, stage2_61_c, stage2_62_c, stage2_63_c, stage2_64_c;

wire	[17:0] stage3_1_r, stage3_2_r, stage3_3_r, stage3_4_r, stage3_5_r, stage3_6_r, stage3_7_r, stage3_8_r,
stage3_9_r, stage3_10_r, stage3_11_r, stage3_12_r, stage3_13_r, stage3_14_r, stage3_15_r, stage3_16_r,
stage3_17_r, stage3_18_r, stage3_19_r, stage3_20_r, stage3_21_r, stage3_22_r, stage3_23_r, stage3_24_r,
stage3_25_r, stage3_26_r, stage3_27_r, stage3_28_r, stage3_29_r, stage3_30_r, stage3_31_r, stage3_32_r,
stage3_33_r, stage3_34_r, stage3_35_r, stage3_36_r, stage3_37_r, stage3_38_r, stage3_39_r, stage3_40_r,
stage3_41_r, stage3_42_r, stage3_43_r, stage3_44_r, stage3_45_r, stage3_46_r, stage3_47_r, stage3_48_r,
stage3_49_r, stage3_50_r, stage3_51_r, stage3_52_r, stage3_53_r, stage3_54_r, stage3_55_r, stage3_56_r,
stage3_57_r, stage3_58_r, stage3_59_r, stage3_60_r, stage3_61_r, stage3_62_r, stage3_63_r, stage3_64_r;

wire	[17:0] stage3_1_c, stage3_2_c, stage3_3_c, stage3_4_c, stage3_5_c, stage3_6_c, stage3_7_c, stage3_8_c,
stage3_9_c, stage3_10_c, stage3_11_c, stage3_12_c, stage3_13_c, stage3_14_c, stage3_15_c, stage3_16_c,
stage3_17_c, stage3_18_c, stage3_19_c, stage3_20_c, stage3_21_c, stage3_22_c, stage3_23_c, stage3_24_c,
stage3_25_c, stage3_26_c, stage3_27_c, stage3_28_c, stage3_29_c, stage3_30_c, stage3_31_c, stage3_32_c,
stage3_33_c, stage3_34_c, stage3_35_c, stage3_36_c, stage3_37_c, stage3_38_c, stage3_39_c, stage3_40_c,
stage3_41_c, stage3_42_c, stage3_43_c, stage3_44_c, stage3_45_c, stage3_46_c, stage3_47_c, stage3_48_c,
stage3_49_c, stage3_50_c, stage3_51_c, stage3_52_c, stage3_53_c, stage3_54_c, stage3_55_c, stage3_56_c,
stage3_57_c, stage3_58_c, stage3_59_c, stage3_60_c, stage3_61_c, stage3_62_c, stage3_63_c, stage3_64_c;

wire	[17:0] stage4_1_r, stage4_2_r, stage4_3_r, stage4_4_r, stage4_5_r, stage4_6_r, stage4_7_r, stage4_8_r,
stage4_9_r, stage4_10_r, stage4_11_r, stage4_12_r, stage4_13_r, stage4_14_r, stage4_15_r, stage4_16_r,
stage4_17_r, stage4_18_r, stage4_19_r, stage4_20_r, stage4_21_r, stage4_22_r, stage4_23_r, stage4_24_r,
stage4_25_r, stage4_26_r, stage4_27_r, stage4_28_r, stage4_29_r, stage4_30_r, stage4_31_r, stage4_32_r,
stage4_33_r, stage4_34_r, stage4_35_r, stage4_36_r, stage4_37_r, stage4_38_r, stage4_39_r, stage4_40_r,
stage4_41_r, stage4_42_r, stage4_43_r, stage4_44_r, stage4_45_r, stage4_46_r, stage4_47_r, stage4_48_r,
stage4_49_r, stage4_50_r, stage4_51_r, stage4_52_r, stage4_53_r, stage4_54_r, stage4_55_r, stage4_56_r,
stage4_57_r, stage4_58_r, stage4_59_r, stage4_60_r, stage4_61_r, stage4_62_r, stage4_63_r, stage4_64_r;

wire	[17:0] stage4_1_c, stage4_2_c, stage4_3_c, stage4_4_c, stage4_5_c, stage4_6_c, stage4_7_c,stage4_8_c,
stage4_9_c, stage4_10_c, stage4_11_c, stage4_12_c, stage4_13_c, stage4_14_c, stage4_15_c, stage4_16_c,
stage4_17_c, stage4_18_c, stage4_19_c, stage4_20_c, stage4_21_c, stage4_22_c, stage4_23_c, stage4_24_c,
stage4_25_c, stage4_26_c, stage4_27_c, stage4_28_c, stage4_29_c, stage4_30_c, stage4_31_c, stage4_32_c,
stage4_33_c, stage4_34_c, stage4_35_c, stage4_36_c, stage4_37_c, stage4_38_c, stage4_39_c, stage4_40_c,
stage4_41_c, stage4_42_c, stage4_43_c, stage4_44_c, stage4_45_c, stage4_46_c, stage4_47_c, stage4_48_c,
stage4_49_c, stage4_50_c, stage4_51_c, stage4_52_c, stage4_53_c, stage4_54_c, stage4_55_c, stage4_56_c,
stage4_57_c, stage4_58_c, stage4_59_c, stage4_60_c, stage4_61_c, stage4_62_c, stage4_63_c, stage4_64_c;


// Stage 1

radix4dft r4dft0(18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage1_1_r, stage1_17_r, stage1_33_r, stage1_49_r,
stage1_1_c, stage1_17_c, stage1_33_c, stage1_49_c,
stage2_1_r, stage2_17_r, stage2_33_r, stage2_49_r,
stage2_1_c, stage2_17_c, stage2_33_c, stage2_49_c);

radix4dft r4dft1(18'hFEC4, 18'h3E6E9, 18'hFB14, 18'h3CE0F, 18'hF4FA, 18'h3B5B0, 
stage1_2_r, stage1_18_r, stage1_34_r, stage1_50_r,
stage1_2_c, stage1_18_c, stage1_34_c, stage1_50_c,
stage2_2_r, stage2_18_r, stage2_34_r, stage2_50_r,
stage2_2_c, stage2_18_c, stage2_34_c, stage2_50_c);

radix4dft r4dft2(18'hFB14, 18'h3CE0F, 18'hEC83, 18'h39E09, 18'hD4DB, 18'h371C7, 
stage1_3_r, stage1_19_r, stage1_35_r, stage1_51_r,
stage1_3_c, stage1_19_c, stage1_35_c, stage1_51_c,
stage2_3_r, stage2_19_r, stage2_35_r, stage2_51_r,
stage2_3_c, stage2_19_c, stage2_35_c, stage2_51_c);

radix4dft r4dft3(18'hF4FA, 18'h3B5B0, 18'hD4DB, 18'h371C7, 18'hA267, 18'h33A1C, 
stage1_4_r, stage1_20_r, stage1_36_r, stage1_52_r,
stage1_4_c, stage1_20_c, stage1_36_c, stage1_52_c,
stage2_4_r, stage2_20_r, stage2_36_r, stage2_52_r,
stage2_4_c, stage2_20_c, stage2_36_c, stage2_52_c);

radix4dft r4dft4(18'hEC83, 18'h39E09, 18'hB504, 18'h34AFC, 18'h61F7, 18'h3137D, 
stage1_5_r, stage1_21_r, stage1_37_r, stage1_53_r,
stage1_5_c, stage1_21_c, stage1_37_c, stage1_53_c,
stage2_5_r, stage2_21_r, stage2_37_r, stage2_53_r,
stage2_5_c, stage2_21_c, stage2_37_c, stage2_53_c);

radix4dft r4dft5(18'hE1C5, 18'h38753, 18'h8E39, 18'h32B25, 18'h1917, 18'h3013C, 
stage1_6_r, stage1_22_r, stage1_38_r, stage1_54_r,
stage1_6_c, stage1_22_c, stage1_38_c, stage1_54_c,
stage2_6_r, stage2_22_r, stage2_38_r, stage2_54_r,
stage2_6_c, stage2_22_c, stage2_38_c, stage2_54_c);

radix4dft r4dft6(18'hD4DB, 18'h371C7, 18'h61F7, 18'h3137D, 18'h3CE0F, 18'h304EC, 
stage1_7_r, stage1_23_r, stage1_39_r, stage1_55_r,
stage1_7_c, stage1_23_c, stage1_39_c, stage1_55_c,
stage2_7_r, stage2_23_r, stage2_39_r, stage2_55_r,
stage2_7_c, stage2_23_c, stage2_39_c, stage2_55_c);

radix4dft r4dft7(18'hC5E4, 18'h35D99, 18'h31F1, 18'h304EC, 18'h38753, 18'h31E3B, 
stage1_8_r, stage1_24_r, stage1_40_r, stage1_56_r,
stage1_8_c, stage1_24_c, stage1_40_c, stage1_56_c,
stage2_8_r, stage2_24_r, stage2_40_r, stage2_56_r,
stage2_8_c, stage2_24_c, stage2_40_c, stage2_56_c);

radix4dft r4dft8(18'hB504, 18'h34AFC, 18'h0, 18'h30000, 18'h34AFC, 18'h34AFC, 
stage1_9_r, stage1_25_r, stage1_41_r, stage1_57_r,
stage1_9_c, stage1_25_c, stage1_41_c, stage1_57_c,
stage2_9_r, stage2_25_r, stage2_41_r, stage2_57_r,
stage2_9_c, stage2_25_c, stage2_41_c, stage2_57_c);

radix4dft r4dft9(18'hA267, 18'h33A1C, 18'h3CE0F, 18'h304EC, 18'h31E3B, 18'h38753, 
stage1_10_r, stage1_26_r, stage1_42_r, stage1_58_r,
stage1_10_c, stage1_26_c, stage1_42_c, stage1_58_c,
stage2_10_r, stage2_26_r, stage2_42_r, stage2_58_r,
stage2_10_c, stage2_26_c, stage2_42_c, stage2_58_c);

radix4dft r4dft10(18'h8E39, 18'h32B25, 18'h39E09, 18'h3137D, 18'h304EC, 18'h3CE0F, 
stage1_11_r, stage1_27_r, stage1_43_r, stage1_59_r,
stage1_11_c, stage1_27_c, stage1_43_c, stage1_59_c,
stage2_11_r, stage2_27_r, stage2_43_r, stage2_59_r,
stage2_11_c, stage2_27_c, stage2_43_c, stage2_59_c);

radix4dft r4dft11(18'h78AD, 18'h31E3B, 18'h371C7, 18'h32B25, 18'h3013C, 18'h1917, 
stage1_12_r, stage1_28_r, stage1_44_r, stage1_60_r,
stage1_12_c, stage1_28_c, stage1_44_c, stage1_60_c,
stage2_12_r, stage2_28_r, stage2_44_r, stage2_60_r,
stage2_12_c, stage2_28_c, stage2_44_c, stage2_60_c);

radix4dft r4dft12(18'h61F7, 18'h3137D, 18'h34AFC, 18'h34AFC, 18'h3137D, 18'h61F7, 
stage1_13_r, stage1_29_r, stage1_45_r, stage1_61_r,
stage1_13_c, stage1_29_c, stage1_45_c, stage1_61_c,
stage2_13_r, stage2_29_r, stage2_45_r, stage2_61_r,
stage2_13_c, stage2_29_c, stage2_45_c, stage2_61_c);

radix4dft r4dft13(18'h4A50, 18'h30B06, 18'h32B25, 18'h371C7, 18'h33A1C, 18'hA267, 
stage1_14_r, stage1_30_r, stage1_46_r, stage1_62_r,
stage1_14_c, stage1_30_c, stage1_46_c, stage1_62_c,
stage2_14_r, stage2_30_r, stage2_46_r, stage2_62_r,
stage2_14_c, stage2_30_c, stage2_46_c, stage2_62_c);

radix4dft r4dft14(18'h31F1, 18'h304EC, 18'h3137D, 18'h39E09, 18'h371C7, 18'hD4DB, 
stage1_15_r, stage1_31_r, stage1_47_r, stage1_63_r,
stage1_15_c, stage1_31_c, stage1_47_c, stage1_63_c,
stage2_15_r, stage2_31_r, stage2_47_r, stage2_63_r,
stage2_15_c, stage2_31_c, stage2_47_c, stage2_63_c);

radix4dft r4dft15(18'h1917, 18'h3013C, 18'h304EC, 18'h3CE0F, 18'h3B5B0, 18'hF4FA, 
stage1_16_r, stage1_32_r, stage1_48_r, stage1_64_r,
stage1_16_c, stage1_32_c, stage1_48_c, stage1_64_c,
stage2_16_r, stage2_32_r, stage2_48_r, stage2_64_r,
stage2_16_c, stage2_32_c, stage2_48_c, stage2_64_c);

// Stage 2

radix4dft r4dft16(18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage2_1_r, stage2_5_r, stage2_9_r, stage2_13_r,
stage2_1_c, stage2_5_c, stage2_9_c, stage2_13_c,
stage3_1_r, stage3_5_r, stage3_9_r, stage3_13_r,
stage3_1_c, stage3_5_c, stage3_9_c, stage3_13_c);

radix4dft r4dft17(18'hEC83, 18'h39E09, 18'hB504, 18'h34AFC, 18'h61F7, 18'h3137D, 
stage2_2_r, stage2_6_r, stage2_10_r, stage2_14_r,
stage2_2_c, stage2_6_c, stage2_10_c, stage2_14_c,
stage3_2_r, stage3_6_r, stage3_10_r, stage3_14_r,
stage3_2_c, stage3_6_c, stage3_10_c, stage3_14_c);

radix4dft r4dft18(18'hB504, 18'h34AFC, 18'h0, 18'h30000, 18'h34AFC, 18'h34AFC, 
stage2_3_r, stage2_7_r, stage2_11_r, stage2_15_r,
stage2_3_c, stage2_7_c, stage2_11_c, stage2_15_c,
stage3_3_r, stage3_7_r, stage3_11_r, stage3_15_r,
stage3_3_c, stage3_7_c, stage3_11_c, stage3_15_c);

radix4dft r4dft19(18'h61F7, 18'h3137D, 18'h34AFC, 18'h34AFC, 18'h3137D, 18'h61F7, 
stage2_4_r, stage2_8_r, stage2_12_r, stage2_16_r,
stage2_4_c, stage2_8_c, stage2_12_c, stage2_16_c,
stage3_4_r, stage3_8_r, stage3_12_r, stage3_16_r,
stage3_4_c, stage3_8_c, stage3_12_c, stage3_16_c);

radix4dft r4dft20(18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage2_17_r, stage2_21_r, stage2_25_r, stage2_29_r,
stage2_17_c, stage2_21_c, stage2_25_c, stage2_29_c,
stage3_17_r, stage3_21_r, stage3_25_r, stage3_29_r,
stage3_17_c, stage3_21_c, stage3_25_c, stage3_29_c);

radix4dft r4dft21(18'hEC83, 18'h39E09, 18'hB504, 18'h34AFC, 18'h61F7, 18'h3137D, 
stage2_18_r, stage2_22_r, stage2_26_r, stage2_30_r,
stage2_18_c, stage2_22_c, stage2_26_c, stage2_30_c,
stage3_18_r, stage3_22_r, stage3_26_r, stage3_30_r,
stage3_18_c, stage3_22_c, stage3_26_c, stage3_30_c);

radix4dft r4dft22(18'hB504, 18'h34AFC, 18'h0, 18'h30000, 18'h34AFC, 18'h34AFC, 
stage2_19_r, stage2_23_r, stage2_27_r, stage2_31_r,
stage2_19_c, stage2_23_c, stage2_27_c, stage2_31_c,
stage3_19_r, stage3_23_r, stage3_27_r, stage3_31_r,
stage3_19_c, stage3_23_c, stage3_27_c, stage3_31_c);

radix4dft r4dft23(18'h61F7, 18'h3137D, 18'h34AFC, 18'h34AFC, 18'h3137D, 18'h61F7, 
stage2_20_r, stage2_24_r, stage2_28_r, stage2_32_r,
stage2_20_c, stage2_24_c, stage2_28_c, stage2_32_c,
stage3_20_r, stage3_24_r, stage3_28_r, stage3_32_r,
stage3_20_c, stage3_24_c, stage3_28_c, stage3_32_c);

radix4dft r4dft24(18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage2_33_r, stage2_37_r, stage2_41_r, stage2_45_r,
stage2_33_c, stage2_37_c, stage2_41_c, stage2_45_c,
stage3_33_r, stage3_37_r, stage3_41_r, stage3_45_r,
stage3_33_c, stage3_37_c, stage3_41_c, stage3_45_c);

radix4dft r4dft25(18'hEC83, 18'h39E09, 18'hB504, 18'h34AFC, 18'h61F7, 18'h3137D, 
stage2_34_r, stage2_38_r, stage2_42_r, stage2_46_r,
stage2_34_c, stage2_38_c, stage2_42_c, stage2_46_c,
stage3_34_r, stage3_38_r, stage3_42_r, stage3_46_r,
stage3_34_c, stage3_38_c, stage3_42_c, stage3_46_c);

radix4dft r4dft26(18'hB504, 18'h34AFC, 18'h0, 18'h30000, 18'h34AFC, 18'h34AFC, 
stage2_35_r, stage2_39_r, stage2_43_r, stage2_47_r,
stage2_35_c, stage2_39_c, stage2_43_c, stage2_47_c,
stage3_35_r, stage3_39_r, stage3_43_r, stage3_47_r,
stage3_35_c, stage3_39_c, stage3_43_c, stage3_47_c);

radix4dft r4dft27(18'h61F7, 18'h3137D, 18'h34AFC, 18'h34AFC, 18'h3137D, 18'h61F7, 
stage2_36_r, stage2_40_r, stage2_44_r, stage2_48_r,
stage2_36_c, stage2_40_c, stage2_44_c, stage2_48_c,
stage3_36_r, stage3_40_r, stage3_44_r, stage3_48_r,
stage3_36_c, stage3_40_c, stage3_44_c, stage3_48_c);

radix4dft r4dft28(18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage2_49_r, stage2_53_r, stage2_57_r, stage2_61_r,
stage2_49_c, stage2_53_c, stage2_57_c, stage2_61_c,
stage3_49_r, stage3_53_r, stage3_57_r, stage3_61_r,
stage3_49_c, stage3_53_c, stage3_57_c, stage3_61_c);

radix4dft r4dft29(18'hEC83, 18'h39E09, 18'hB504, 18'h34AFC, 18'h61F7, 18'h3137D, 
stage2_50_r, stage2_54_r, stage2_58_r, stage2_62_r,
stage2_50_c, stage2_54_c, stage2_58_c, stage2_62_c,
stage3_50_r, stage3_54_r, stage3_58_r, stage3_62_r,
stage3_50_c, stage3_54_c, stage3_58_c, stage3_62_c);

radix4dft r4dft30(18'hB504, 18'h34AFC, 18'h0, 18'h30000, 18'h34AFC, 18'h34AFC, 
stage2_51_r, stage2_55_r, stage2_59_r, stage2_63_r,
stage2_51_c, stage2_55_c, stage2_59_c, stage2_63_c,
stage3_51_r, stage3_55_r, stage3_59_r, stage3_63_r,
stage3_51_c, stage3_55_c, stage3_59_c, stage3_63_c);

radix4dft r4dft31(18'h61F7, 18'h3137D, 18'h34AFC, 18'h34AFC, 18'h3137D, 18'h61F7, 
stage2_52_r, stage2_56_r, stage2_60_r, stage2_64_r,
stage2_52_c, stage2_56_c, stage2_60_c, stage2_64_c,
stage3_52_r, stage3_56_r, stage3_60_r, stage3_64_r,
stage3_52_c, stage3_56_c, stage3_60_c, stage3_64_c);

// Stage 3

radix4dft r4dft32(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_1_r, stage3_2_r, stage3_3_r, stage3_4_r,
stage3_1_c, stage3_2_c, stage3_3_c, stage3_4_c,
stage4_1_r, stage4_2_r, stage4_3_r, stage4_4_r,
stage4_1_c, stage4_2_c, stage4_3_c, stage4_4_c);

radix4dft r4dft33(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_5_r, stage3_6_r, stage3_7_r, stage3_8_r,
stage3_5_c, stage3_6_c, stage3_7_c, stage3_8_c,
stage4_5_r, stage4_6_r, stage4_7_r, stage4_8_r,
stage4_5_c, stage4_6_c, stage4_7_c, stage4_8_c);

radix4dft r4dft34(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_9_r, stage3_10_r, stage3_11_r, stage3_12_r,
stage3_9_c, stage3_10_c, stage3_11_c, stage3_12_c,
stage4_9_r, stage4_10_r, stage4_11_r, stage4_12_r,
stage4_9_c, stage4_10_c, stage4_11_c, stage4_12_c);

radix4dft r4dft35(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_13_r, stage3_14_r, stage3_15_r, stage3_16_r,
stage3_13_c, stage3_14_c, stage3_15_c, stage3_16_c,
stage4_13_r, stage4_14_r, stage4_15_r, stage4_16_r,
stage4_13_c, stage4_14_c, stage4_15_c, stage4_16_c);

radix4dft r4dft36(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_17_r, stage3_18_r, stage3_19_r, stage3_20_r,
stage3_17_c, stage3_18_c, stage3_19_c, stage3_20_c,
stage4_17_r, stage4_18_r, stage4_19_r, stage4_20_r,
stage4_17_c, stage4_18_c, stage4_19_c, stage4_20_c);

radix4dft r4dft37(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_21_r, stage3_22_r, stage3_23_r, stage3_24_r,
stage3_21_c, stage3_22_c, stage3_23_c, stage3_24_c,
stage4_21_r, stage4_22_r, stage4_23_r, stage4_24_r,
stage4_21_c, stage4_22_c, stage4_23_c, stage4_24_c);

radix4dft r4dft38(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_25_r, stage3_26_r, stage3_27_r, stage3_28_r,
stage3_25_c, stage3_26_c, stage3_27_c, stage3_28_c,
stage4_25_r, stage4_26_r, stage4_27_r, stage4_28_r,
stage4_25_c, stage4_26_c, stage4_27_c, stage4_28_c);

radix4dft r4dft39(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_29_r, stage3_30_r, stage3_31_r, stage3_32_r,
stage3_29_c, stage3_30_c, stage3_31_c, stage3_32_c,
stage4_29_r, stage4_30_r, stage4_31_r, stage4_32_r,
stage4_29_c, stage4_30_c, stage4_31_c, stage4_32_c);

radix4dft r4dft40(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_33_r, stage3_34_r, stage3_35_r, stage3_36_r,
stage3_33_c, stage3_34_c, stage3_35_c, stage3_36_c,
stage4_33_r, stage4_34_r, stage4_35_r, stage4_36_r,
stage4_33_c, stage4_34_c, stage4_35_c, stage4_36_c);

radix4dft r4dft41(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_37_r, stage3_38_r, stage3_39_r, stage3_40_r,
stage3_37_c, stage3_38_c, stage3_39_c, stage3_40_c,
stage4_37_r, stage4_38_r, stage4_39_r, stage4_40_r,
stage4_37_c, stage4_38_c, stage4_39_c, stage4_40_c);

radix4dft r4dft42(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_41_r, stage3_42_r, stage3_43_r, stage3_44_r,
stage3_41_c, stage3_42_c, stage3_43_c, stage3_44_c,
stage4_41_r, stage4_42_r, stage4_43_r, stage4_44_r,
stage4_41_c, stage4_42_c, stage4_43_c, stage4_44_c);

radix4dft r4dft43(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_45_r, stage3_46_r, stage3_47_r, stage3_48_r,
stage3_45_c, stage3_46_c, stage3_47_c, stage3_48_c,
stage4_45_r, stage4_46_r, stage4_47_r, stage4_48_r,
stage4_45_c, stage4_46_c, stage4_47_c, stage4_48_c);

radix4dft r4dft44(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_49_r, stage3_50_r, stage3_51_r, stage3_52_r,
stage3_49_c, stage3_50_c, stage3_51_c, stage3_52_c,
stage4_49_r, stage4_50_r, stage4_51_r, stage4_52_r,
stage4_49_c, stage4_50_c, stage4_51_c, stage4_52_c);

radix4dft r4dft45(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_53_r, stage3_54_r, stage3_55_r, stage3_56_r,
stage3_53_c, stage3_54_c, stage3_55_c, stage3_56_c,
stage4_53_r, stage4_54_r, stage4_55_r, stage4_56_r,
stage4_53_c, stage4_54_c, stage4_55_c, stage4_56_c);

radix4dft r4dft46(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_57_r, stage3_58_r, stage3_59_r, stage3_60_r,
stage3_57_c, stage3_58_c, stage3_59_c, stage3_60_c,
stage4_57_r, stage4_58_r, stage4_59_r, stage4_60_r,
stage4_57_c, stage4_58_c, stage4_59_c, stage4_60_c);

radix4dft r4dft47(
18'h10000, 18'h0, 18'h10000, 18'h0, 18'h10000, 18'h0, 
stage3_61_r, stage3_62_r, stage3_63_r, stage3_64_r,
stage3_61_c, stage3_62_c, stage3_63_c, stage3_64_c,
stage4_61_r, stage4_62_r, stage4_63_r, stage4_64_r,
stage4_61_c, stage4_62_c, stage4_63_c, stage4_64_c);


// Reorder
freqnormal fnom1 (stage4_1_r, stage4_1_c, freq_1);
freqnormal fnom2 (stage4_2_r, stage4_2_c, freq_17);
// freqnormal fnom3 (stage4_3_r, stage4_3_c, freq_33);
// freqnormal fnom4 (stage4_4_r, stage4_4_c, freq_49);
freqnormal fnom5 (stage4_5_r, stage4_5_c, freq_5);
freqnormal fnom6 (stage4_6_r, stage4_6_c, freq_21);
// freqnormal fnom7 (stage4_7_r, stage4_7_c, freq_37);
// freqnormal fnom8 (stage4_8_r, stage4_8_c, freq_53);
freqnormal fnom9 (stage4_9_r, stage4_9_c, freq_9);
freqnormal fnom10 (stage4_10_r, stage4_10_c, freq_25);
// freqnormal fnom11 (stage4_11_r, stage4_11_c, freq_41);
// freqnormal fnom12 (stage4_12_r, stage4_12_c, freq_57);
freqnormal fnom13 (stage4_13_r, stage4_13_c, freq_13);
freqnormal fnom14 (stage4_14_r, stage4_14_c, freq_29);
// freqnormal fnom15 (stage4_15_r, stage4_15_c, freq_45);
// freqnormal fnom16 (stage4_16_r, stage4_16_c, freq_61);
freqnormal fnom17 (stage4_17_r, stage4_17_c, freq_2);
freqnormal fnom18 (stage4_18_r, stage4_18_c, freq_18);
// freqnormal fnom19 (stage4_19_r, stage4_19_c, freq_34);
// freqnormal fnom20 (stage4_20_r, stage4_20_c, freq_50);
freqnormal fnom21 (stage4_21_r, stage4_21_c, freq_6);
freqnormal fnom22 (stage4_22_r, stage4_22_c, freq_22);
// freqnormal fnom23 (stage4_23_r, stage4_23_c, freq_38);
// freqnormal fnom24 (stage4_24_r, stage4_24_c, freq_54);
freqnormal fnom25 (stage4_25_r, stage4_25_c, freq_10);
freqnormal fnom26 (stage4_26_r, stage4_26_c, freq_26);
// freqnormal fnom27 (stage4_27_r, stage4_27_c, freq_42);
// freqnormal fnom28 (stage4_28_r, stage4_28_c, freq_58);
freqnormal fnom29 (stage4_29_r, stage4_29_c, freq_14);
freqnormal fnom30 (stage4_30_r, stage4_30_c, freq_30);
// freqnormal fnom31 (stage4_31_r, stage4_31_c, freq_46);
// freqnormal fnom32 (stage4_32_r, stage4_32_c, freq_62);
freqnormal fnom33 (stage4_33_r, stage4_33_c, freq_3);
freqnormal fnom34 (stage4_34_r, stage4_34_c, freq_19);
// freqnormal fnom35 (stage4_35_r, stage4_35_c, freq_35);
// freqnormal fnom36 (stage4_36_r, stage4_36_c, freq_51);
freqnormal fnom37 (stage4_37_r, stage4_37_c, freq_7);
freqnormal fnom38 (stage4_38_r, stage4_38_c, freq_23);
// freqnormal fnom39 (stage4_39_r, stage4_39_c, freq_39);
// freqnormal fnom40 (stage4_40_r, stage4_40_c, freq_55);
freqnormal fnom41 (stage4_41_r, stage4_41_c, freq_11);
freqnormal fnom42 (stage4_42_r, stage4_42_c, freq_27);
// freqnormal fnom43 (stage4_43_r, stage4_43_c, freq_43);
// freqnormal fnom44 (stage4_44_r, stage4_44_c, freq_59);
freqnormal fnom45 (stage4_45_r, stage4_45_c, freq_15);
freqnormal fnom46 (stage4_46_r, stage4_46_c, freq_31);
// freqnormal fnom47 (stage4_47_r, stage4_47_c, freq_47);
// freqnormal fnom48 (stage4_48_r, stage4_48_c, freq_63);
freqnormal fnom49 (stage4_49_r, stage4_49_c, freq_4);
freqnormal fnom50 (stage4_50_r, stage4_50_c, freq_20);
// freqnormal fnom51 (stage4_51_r, stage4_51_c, freq_36);
// freqnormal fnom52 (stage4_52_r, stage4_52_c, freq_52);
freqnormal fnom53 (stage4_53_r, stage4_53_c, freq_8);
freqnormal fnom54 (stage4_54_r, stage4_54_c, freq_24);
// freqnormal fnom55 (stage4_55_r, stage4_55_c, freq_40);
// freqnormal fnom56 (stage4_56_r, stage4_56_c, freq_56);
freqnormal fnom57 (stage4_57_r, stage4_57_c, freq_12);
freqnormal fnom58 (stage4_58_r, stage4_58_c, freq_28);
// freqnormal fnom59 (stage4_59_r, stage4_59_c, freq_44);
// freqnormal fnom60 (stage4_60_r, stage4_60_c, freq_60);
freqnormal fnom61 (stage4_61_r, stage4_61_c, freq_16);
freqnormal fnom62 (stage4_62_r, stage4_62_c, freq_32);
// freqnormal fnom63 (stage4_63_r, stage4_63_c, freq_48);
// freqnormal fnom64 (stage4_64_r, stage4_64_c, freq_64);

// Shift register for values
always @ (negedge sample_clk)
begin
	stage1_64_r <= {sample_data[15], sample_data[15], sample_data[15:0]};
	stage1_63_r <= stage1_64_r;
	stage1_62_r <= stage1_63_r;
	stage1_61_r <= stage1_62_r;
	stage1_60_r <= stage1_61_r;
	stage1_59_r <= stage1_60_r;
	stage1_58_r <= stage1_59_r;
	stage1_57_r <= stage1_58_r;
	stage1_56_r <= stage1_57_r;
	stage1_55_r <= stage1_56_r;
	stage1_54_r <= stage1_55_r;
	stage1_53_r <= stage1_54_r;
	stage1_52_r <= stage1_53_r;
	stage1_51_r <= stage1_52_r;
	stage1_50_r <= stage1_51_r;
	stage1_49_r <= stage1_50_r;
	stage1_48_r <= stage1_49_r;
	stage1_47_r <= stage1_48_r;
	stage1_46_r <= stage1_47_r;
	stage1_45_r <= stage1_46_r;
	stage1_44_r <= stage1_45_r;
	stage1_43_r <= stage1_44_r;
	stage1_42_r <= stage1_43_r;
	stage1_41_r <= stage1_42_r;
	stage1_40_r <= stage1_41_r;
	stage1_39_r <= stage1_40_r;
	stage1_38_r <= stage1_39_r;
	stage1_37_r <= stage1_38_r;
	stage1_36_r <= stage1_37_r;
	stage1_35_r <= stage1_36_r;
	stage1_34_r <= stage1_35_r;
	stage1_33_r <= stage1_34_r;
	stage1_32_r <= stage1_33_r;
	stage1_31_r <= stage1_32_r;
	stage1_30_r <= stage1_31_r;
	stage1_29_r <= stage1_30_r;
	stage1_28_r <= stage1_29_r;
	stage1_27_r <= stage1_28_r;
	stage1_26_r <= stage1_27_r;
	stage1_25_r <= stage1_26_r;
	stage1_24_r <= stage1_25_r;
	stage1_23_r <= stage1_24_r;
	stage1_22_r <= stage1_23_r;
	stage1_21_r <= stage1_22_r;
	stage1_20_r <= stage1_21_r;
	stage1_19_r <= stage1_20_r;
	stage1_18_r <= stage1_19_r;
	stage1_17_r <= stage1_18_r;
	stage1_16_r <= stage1_17_r;
	stage1_15_r <= stage1_16_r;
	stage1_14_r <= stage1_15_r;
	stage1_13_r <= stage1_14_r;
	stage1_12_r <= stage1_13_r;
	stage1_11_r <= stage1_12_r;
	stage1_10_r <= stage1_11_r;
	stage1_9_r <= stage1_10_r;
	stage1_8_r <= stage1_9_r;
	stage1_7_r <= stage1_8_r;
	stage1_6_r <= stage1_7_r;
	stage1_5_r <= stage1_6_r;
	stage1_4_r <= stage1_5_r;
	stage1_3_r <= stage1_4_r;
	stage1_2_r <= stage1_3_r;
	stage1_1_r <= stage1_2_r;
end

endmodule