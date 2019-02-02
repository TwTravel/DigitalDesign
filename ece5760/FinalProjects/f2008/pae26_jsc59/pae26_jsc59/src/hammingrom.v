// Infer ROM storage for a hamming window
module hammingrom (
    input      [9:0]  iAddress,
    output reg [15:0] oHamming
);

always @ (iAddress)
begin
    case (iAddress)
        10'h00: oHamming = 16'h28f;
        10'h01: oHamming = 16'h28f;
        10'h02: oHamming = 16'h28f;
        10'h03: oHamming = 16'h28f;
        10'h04: oHamming = 16'h290;
        10'h05: oHamming = 16'h291;
        10'h06: oHamming = 16'h291;
        10'h07: oHamming = 16'h292;
        10'h08: oHamming = 16'h293;
        10'h09: oHamming = 16'h295;
        10'h0a: oHamming = 16'h296;
        10'h0b: oHamming = 16'h297;
        10'h0c: oHamming = 16'h299;
        10'h0d: oHamming = 16'h29b;
        10'h0e: oHamming = 16'h29d;
        10'h0f: oHamming = 16'h29f;
        10'h10: oHamming = 16'h2a1;
        10'h11: oHamming = 16'h2a3;
        10'h12: oHamming = 16'h2a6;
        10'h13: oHamming = 16'h2a8;
        10'h14: oHamming = 16'h2ab;
        10'h15: oHamming = 16'h2ae;
        10'h16: oHamming = 16'h2b1;
        10'h17: oHamming = 16'h2b4;
        10'h18: oHamming = 16'h2b8;
        10'h19: oHamming = 16'h2bb;
        10'h1a: oHamming = 16'h2bf;
        10'h1b: oHamming = 16'h2c3;
        10'h1c: oHamming = 16'h2c6;
        10'h1d: oHamming = 16'h2ca;
        10'h1e: oHamming = 16'h2cf;
        10'h1f: oHamming = 16'h2d3;
        10'h20: oHamming = 16'h2d7;
        10'h21: oHamming = 16'h2dc;
        10'h22: oHamming = 16'h2e1;
        10'h23: oHamming = 16'h2e6;
        10'h24: oHamming = 16'h2eb;
        10'h25: oHamming = 16'h2f0;
        10'h26: oHamming = 16'h2f5;
        10'h27: oHamming = 16'h2fa;
        10'h28: oHamming = 16'h300;
        10'h29: oHamming = 16'h306;
        10'h2a: oHamming = 16'h30c;
        10'h2b: oHamming = 16'h312;
        10'h2c: oHamming = 16'h318;
        10'h2d: oHamming = 16'h31e;
        10'h2e: oHamming = 16'h324;
        10'h2f: oHamming = 16'h32b;
        10'h30: oHamming = 16'h331;
        10'h31: oHamming = 16'h338;
        10'h32: oHamming = 16'h33f;
        10'h33: oHamming = 16'h346;
        10'h34: oHamming = 16'h34d;
        10'h35: oHamming = 16'h355;
        10'h36: oHamming = 16'h35c;
        10'h37: oHamming = 16'h364;
        10'h38: oHamming = 16'h36c;
        10'h39: oHamming = 16'h373;
        10'h3a: oHamming = 16'h37b;
        10'h3b: oHamming = 16'h384;
        10'h3c: oHamming = 16'h38c;
        10'h3d: oHamming = 16'h394;
        10'h3e: oHamming = 16'h39d;
        10'h3f: oHamming = 16'h3a5;
        10'h40: oHamming = 16'h3ae;
        10'h41: oHamming = 16'h3b7;
        10'h42: oHamming = 16'h3c0;
        10'h43: oHamming = 16'h3c9;
        10'h44: oHamming = 16'h3d3;
        10'h45: oHamming = 16'h3dc;
        10'h46: oHamming = 16'h3e6;
        10'h47: oHamming = 16'h3f0;
        10'h48: oHamming = 16'h3f9;
        10'h49: oHamming = 16'h403;
        10'h4a: oHamming = 16'h40d;
        10'h4b: oHamming = 16'h418;
        10'h4c: oHamming = 16'h422;
        10'h4d: oHamming = 16'h42c;
        10'h4e: oHamming = 16'h437;
        10'h4f: oHamming = 16'h442;
        10'h50: oHamming = 16'h44d;
        10'h51: oHamming = 16'h458;
        10'h52: oHamming = 16'h463;
        10'h53: oHamming = 16'h46e;
        10'h54: oHamming = 16'h479;
        10'h55: oHamming = 16'h485;
        10'h56: oHamming = 16'h490;
        10'h57: oHamming = 16'h49c;
        10'h58: oHamming = 16'h4a8;
        10'h59: oHamming = 16'h4b4;
        10'h5a: oHamming = 16'h4c0;
        10'h5b: oHamming = 16'h4cc;
        10'h5c: oHamming = 16'h4d9;
        10'h5d: oHamming = 16'h4e5;
        10'h5e: oHamming = 16'h4f2;
        10'h5f: oHamming = 16'h4fe;
        10'h60: oHamming = 16'h50b;
        10'h61: oHamming = 16'h518;
        10'h62: oHamming = 16'h525;
        10'h63: oHamming = 16'h532;
        10'h64: oHamming = 16'h540;
        10'h65: oHamming = 16'h54d;
        10'h66: oHamming = 16'h55a;
        10'h67: oHamming = 16'h568;
        10'h68: oHamming = 16'h576;
        10'h69: oHamming = 16'h584;
        10'h6a: oHamming = 16'h592;
        10'h6b: oHamming = 16'h5a0;
        10'h6c: oHamming = 16'h5ae;
        10'h6d: oHamming = 16'h5bc;
        10'h6e: oHamming = 16'h5cb;
        10'h6f: oHamming = 16'h5d9;
        10'h70: oHamming = 16'h5e8;
        10'h71: oHamming = 16'h5f7;
        10'h72: oHamming = 16'h605;
        10'h73: oHamming = 16'h614;
        10'h74: oHamming = 16'h623;
        10'h75: oHamming = 16'h633;
        10'h76: oHamming = 16'h642;
        10'h77: oHamming = 16'h651;
        10'h78: oHamming = 16'h661;
        10'h79: oHamming = 16'h670;
        10'h7a: oHamming = 16'h680;
        10'h7b: oHamming = 16'h690;
        10'h7c: oHamming = 16'h6a0;
        10'h7d: oHamming = 16'h6b0;
        10'h7e: oHamming = 16'h6c0;
        10'h7f: oHamming = 16'h6d0;
        10'h80: oHamming = 16'h6e1;
        10'h81: oHamming = 16'h6f1;
        10'h82: oHamming = 16'h702;
        10'h83: oHamming = 16'h712;
        10'h84: oHamming = 16'h723;
        10'h85: oHamming = 16'h734;
        10'h86: oHamming = 16'h745;
        10'h87: oHamming = 16'h756;
        10'h88: oHamming = 16'h767;
        10'h89: oHamming = 16'h778;
        10'h8a: oHamming = 16'h789;
        10'h8b: oHamming = 16'h79b;
        10'h8c: oHamming = 16'h7ac;
        10'h8d: oHamming = 16'h7be;
        10'h8e: oHamming = 16'h7cf;
        10'h8f: oHamming = 16'h7e1;
        10'h90: oHamming = 16'h7f3;
        10'h91: oHamming = 16'h805;
        10'h92: oHamming = 16'h817;
        10'h93: oHamming = 16'h829;
        10'h94: oHamming = 16'h83b;
        10'h95: oHamming = 16'h84e;
        10'h96: oHamming = 16'h860;
        10'h97: oHamming = 16'h873;
        10'h98: oHamming = 16'h885;
        10'h99: oHamming = 16'h898;
        10'h9a: oHamming = 16'h8ab;
        10'h9b: oHamming = 16'h8bd;
        10'h9c: oHamming = 16'h8d0;
        10'h9d: oHamming = 16'h8e3;
        10'h9e: oHamming = 16'h8f6;
        10'h9f: oHamming = 16'h909;
        10'ha0: oHamming = 16'h91d;
        10'ha1: oHamming = 16'h930;
        10'ha2: oHamming = 16'h943;
        10'ha3: oHamming = 16'h957;
        10'ha4: oHamming = 16'h96a;
        10'ha5: oHamming = 16'h97e;
        10'ha6: oHamming = 16'h992;
        10'ha7: oHamming = 16'h9a5;
        10'ha8: oHamming = 16'h9b9;
        10'ha9: oHamming = 16'h9cd;
        10'haa: oHamming = 16'h9e1;
        10'hab: oHamming = 16'h9f5;
        10'hac: oHamming = 16'ha09;
        10'had: oHamming = 16'ha1d;
        10'hae: oHamming = 16'ha32;
        10'haf: oHamming = 16'ha46;
        10'hb0: oHamming = 16'ha5a;
        10'hb1: oHamming = 16'ha6f;
        10'hb2: oHamming = 16'ha83;
        10'hb3: oHamming = 16'ha98;
        10'hb4: oHamming = 16'haad;
        10'hb5: oHamming = 16'hac1;
        10'hb6: oHamming = 16'had6;
        10'hb7: oHamming = 16'haeb;
        10'hb8: oHamming = 16'hb00;
        10'hb9: oHamming = 16'hb15;
        10'hba: oHamming = 16'hb2a;
        10'hbb: oHamming = 16'hb3f;
        10'hbc: oHamming = 16'hb54;
        10'hbd: oHamming = 16'hb69;
        10'hbe: oHamming = 16'hb7e;
        10'hbf: oHamming = 16'hb94;
        10'hc0: oHamming = 16'hba9;
        10'hc1: oHamming = 16'hbbf;
        10'hc2: oHamming = 16'hbd4;
        10'hc3: oHamming = 16'hbea;
        10'hc4: oHamming = 16'hbff;
        10'hc5: oHamming = 16'hc15;
        10'hc6: oHamming = 16'hc2a;
        10'hc7: oHamming = 16'hc40;
        10'hc8: oHamming = 16'hc56;
        10'hc9: oHamming = 16'hc6c;
        10'hca: oHamming = 16'hc82;
        10'hcb: oHamming = 16'hc98;
        10'hcc: oHamming = 16'hcae;
        10'hcd: oHamming = 16'hcc4;
        10'hce: oHamming = 16'hcda;
        10'hcf: oHamming = 16'hcf0;
        10'hd0: oHamming = 16'hd06;
        10'hd1: oHamming = 16'hd1c;
        10'hd2: oHamming = 16'hd32;
        10'hd3: oHamming = 16'hd48;
        10'hd4: oHamming = 16'hd5f;
        10'hd5: oHamming = 16'hd75;
        10'hd6: oHamming = 16'hd8b;
        10'hd7: oHamming = 16'hda2;
        10'hd8: oHamming = 16'hdb8;
        10'hd9: oHamming = 16'hdcf;
        10'hda: oHamming = 16'hde5;
        10'hdb: oHamming = 16'hdfc;
        10'hdc: oHamming = 16'he12;
        10'hdd: oHamming = 16'he29;
        10'hde: oHamming = 16'he40;
        10'hdf: oHamming = 16'he56;
        10'he0: oHamming = 16'he6d;
        10'he1: oHamming = 16'he84;
        10'he2: oHamming = 16'he9a;
        10'he3: oHamming = 16'heb1;
        10'he4: oHamming = 16'hec8;
        10'he5: oHamming = 16'hedf;
        10'he6: oHamming = 16'hef6;
        10'he7: oHamming = 16'hf0d;
        10'he8: oHamming = 16'hf23;
        10'he9: oHamming = 16'hf3a;
        10'hea: oHamming = 16'hf51;
        10'heb: oHamming = 16'hf68;
        10'hec: oHamming = 16'hf7f;
        10'hed: oHamming = 16'hf96;
        10'hee: oHamming = 16'hfad;
        10'hef: oHamming = 16'hfc4;
        10'hf0: oHamming = 16'hfdb;
        10'hf1: oHamming = 16'hff2;
        10'hf2: oHamming = 16'h1009;
        10'hf3: oHamming = 16'h1020;
        10'hf4: oHamming = 16'h1037;
        10'hf5: oHamming = 16'h104f;
        10'hf6: oHamming = 16'h1066;
        10'hf7: oHamming = 16'h107d;
        10'hf8: oHamming = 16'h1094;
        10'hf9: oHamming = 16'h10ab;
        10'hfa: oHamming = 16'h10c2;
        10'hfb: oHamming = 16'h10d9;
        10'hfc: oHamming = 16'h10f0;
        10'hfd: oHamming = 16'h1108;
        10'hfe: oHamming = 16'h111f;
        10'hff: oHamming = 16'h1136;
        10'h100: oHamming = 16'h114d;
        10'h101: oHamming = 16'h1164;
        10'h102: oHamming = 16'h117b;
        10'h103: oHamming = 16'h1192;
        10'h104: oHamming = 16'h11aa;
        10'h105: oHamming = 16'h11c1;
        10'h106: oHamming = 16'h11d8;
        10'h107: oHamming = 16'h11ef;
        10'h108: oHamming = 16'h1206;
        10'h109: oHamming = 16'h121d;
        10'h10a: oHamming = 16'h1234;
        10'h10b: oHamming = 16'h124b;
        10'h10c: oHamming = 16'h1262;
        10'h10d: oHamming = 16'h127a;
        10'h10e: oHamming = 16'h1291;
        10'h10f: oHamming = 16'h12a8;
        10'h110: oHamming = 16'h12bf;
        10'h111: oHamming = 16'h12d6;
        10'h112: oHamming = 16'h12ed;
        10'h113: oHamming = 16'h1304;
        10'h114: oHamming = 16'h131b;
        10'h115: oHamming = 16'h1332;
        10'h116: oHamming = 16'h1349;
        10'h117: oHamming = 16'h135f;
        10'h118: oHamming = 16'h1376;
        10'h119: oHamming = 16'h138d;
        10'h11a: oHamming = 16'h13a4;
        10'h11b: oHamming = 16'h13bb;
        10'h11c: oHamming = 16'h13d2;
        10'h11d: oHamming = 16'h13e9;
        10'h11e: oHamming = 16'h13ff;
        10'h11f: oHamming = 16'h1416;
        10'h120: oHamming = 16'h142d;
        10'h121: oHamming = 16'h1443;
        10'h122: oHamming = 16'h145a;
        10'h123: oHamming = 16'h1471;
        10'h124: oHamming = 16'h1487;
        10'h125: oHamming = 16'h149e;
        10'h126: oHamming = 16'h14b4;
        10'h127: oHamming = 16'h14cb;
        10'h128: oHamming = 16'h14e1;
        10'h129: oHamming = 16'h14f8;
        10'h12a: oHamming = 16'h150e;
        10'h12b: oHamming = 16'h1524;
        10'h12c: oHamming = 16'h153b;
        10'h12d: oHamming = 16'h1551;
        10'h12e: oHamming = 16'h1567;
        10'h12f: oHamming = 16'h157d;
        10'h130: oHamming = 16'h1594;
        10'h131: oHamming = 16'h15aa;
        10'h132: oHamming = 16'h15c0;
        10'h133: oHamming = 16'h15d6;
        10'h134: oHamming = 16'h15ec;
        10'h135: oHamming = 16'h1602;
        10'h136: oHamming = 16'h1618;
        10'h137: oHamming = 16'h162e;
        10'h138: oHamming = 16'h1643;
        10'h139: oHamming = 16'h1659;
        10'h13a: oHamming = 16'h166f;
        10'h13b: oHamming = 16'h1684;
        10'h13c: oHamming = 16'h169a;
        10'h13d: oHamming = 16'h16b0;
        10'h13e: oHamming = 16'h16c5;
        10'h13f: oHamming = 16'h16db;
        10'h140: oHamming = 16'h16f0;
        10'h141: oHamming = 16'h1705;
        10'h142: oHamming = 16'h171b;
        10'h143: oHamming = 16'h1730;
        10'h144: oHamming = 16'h1745;
        10'h145: oHamming = 16'h175a;
        10'h146: oHamming = 16'h176f;
        10'h147: oHamming = 16'h1784;
        10'h148: oHamming = 16'h1799;
        10'h149: oHamming = 16'h17ae;
        10'h14a: oHamming = 16'h17c3;
        10'h14b: oHamming = 16'h17d7;
        10'h14c: oHamming = 16'h17ec;
        10'h14d: oHamming = 16'h1801;
        10'h14e: oHamming = 16'h1815;
        10'h14f: oHamming = 16'h182a;
        10'h150: oHamming = 16'h183e;
        10'h151: oHamming = 16'h1853;
        10'h152: oHamming = 16'h1867;
        10'h153: oHamming = 16'h187b;
        10'h154: oHamming = 16'h188f;
        10'h155: oHamming = 16'h18a3;
        10'h156: oHamming = 16'h18b7;
        10'h157: oHamming = 16'h18cb;
        10'h158: oHamming = 16'h18df;
        10'h159: oHamming = 16'h18f3;
        10'h15a: oHamming = 16'h1907;
        10'h15b: oHamming = 16'h191a;
        10'h15c: oHamming = 16'h192e;
        10'h15d: oHamming = 16'h1941;
        10'h15e: oHamming = 16'h1955;
        10'h15f: oHamming = 16'h1968;
        10'h160: oHamming = 16'h197b;
        10'h161: oHamming = 16'h198f;
        10'h162: oHamming = 16'h19a2;
        10'h163: oHamming = 16'h19b5;
        10'h164: oHamming = 16'h19c8;
        10'h165: oHamming = 16'h19da;
        10'h166: oHamming = 16'h19ed;
        10'h167: oHamming = 16'h1a00;
        10'h168: oHamming = 16'h1a12;
        10'h169: oHamming = 16'h1a25;
        10'h16a: oHamming = 16'h1a37;
        10'h16b: oHamming = 16'h1a4a;
        10'h16c: oHamming = 16'h1a5c;
        10'h16d: oHamming = 16'h1a6e;
        10'h16e: oHamming = 16'h1a80;
        10'h16f: oHamming = 16'h1a92;
        10'h170: oHamming = 16'h1aa4;
        10'h171: oHamming = 16'h1ab6;
        10'h172: oHamming = 16'h1ac8;
        10'h173: oHamming = 16'h1ad9;
        10'h174: oHamming = 16'h1aeb;
        10'h175: oHamming = 16'h1afc;
        10'h176: oHamming = 16'h1b0e;
        10'h177: oHamming = 16'h1b1f;
        10'h178: oHamming = 16'h1b30;
        10'h179: oHamming = 16'h1b41;
        10'h17a: oHamming = 16'h1b52;
        10'h17b: oHamming = 16'h1b63;
        10'h17c: oHamming = 16'h1b74;
        10'h17d: oHamming = 16'h1b84;
        10'h17e: oHamming = 16'h1b95;
        10'h17f: oHamming = 16'h1ba6;
        10'h180: oHamming = 16'h1bb6;
        10'h181: oHamming = 16'h1bc6;
        10'h182: oHamming = 16'h1bd6;
        10'h183: oHamming = 16'h1be6;
        10'h184: oHamming = 16'h1bf6;
        10'h185: oHamming = 16'h1c06;
        10'h186: oHamming = 16'h1c16;
        10'h187: oHamming = 16'h1c26;
        10'h188: oHamming = 16'h1c35;
        10'h189: oHamming = 16'h1c45;
        10'h18a: oHamming = 16'h1c54;
        10'h18b: oHamming = 16'h1c63;
        10'h18c: oHamming = 16'h1c72;
        10'h18d: oHamming = 16'h1c81;
        10'h18e: oHamming = 16'h1c90;
        10'h18f: oHamming = 16'h1c9f;
        10'h190: oHamming = 16'h1cae;
        10'h191: oHamming = 16'h1cbc;
        10'h192: oHamming = 16'h1ccb;
        10'h193: oHamming = 16'h1cd9;
        10'h194: oHamming = 16'h1ce8;
        10'h195: oHamming = 16'h1cf6;
        10'h196: oHamming = 16'h1d04;
        10'h197: oHamming = 16'h1d12;
        10'h198: oHamming = 16'h1d1f;
        10'h199: oHamming = 16'h1d2d;
        10'h19a: oHamming = 16'h1d3b;
        10'h19b: oHamming = 16'h1d48;
        10'h19c: oHamming = 16'h1d55;
        10'h19d: oHamming = 16'h1d63;
        10'h19e: oHamming = 16'h1d70;
        10'h19f: oHamming = 16'h1d7d;
        10'h1a0: oHamming = 16'h1d8a;
        10'h1a1: oHamming = 16'h1d96;
        10'h1a2: oHamming = 16'h1da3;
        10'h1a3: oHamming = 16'h1db0;
        10'h1a4: oHamming = 16'h1dbc;
        10'h1a5: oHamming = 16'h1dc8;
        10'h1a6: oHamming = 16'h1dd4;
        10'h1a7: oHamming = 16'h1de0;
        10'h1a8: oHamming = 16'h1dec;
        10'h1a9: oHamming = 16'h1df8;
        10'h1aa: oHamming = 16'h1e04;
        10'h1ab: oHamming = 16'h1e0f;
        10'h1ac: oHamming = 16'h1e1b;
        10'h1ad: oHamming = 16'h1e26;
        10'h1ae: oHamming = 16'h1e31;
        10'h1af: oHamming = 16'h1e3c;
        10'h1b0: oHamming = 16'h1e47;
        10'h1b1: oHamming = 16'h1e52;
        10'h1b2: oHamming = 16'h1e5d;
        10'h1b3: oHamming = 16'h1e67;
        10'h1b4: oHamming = 16'h1e72;
        10'h1b5: oHamming = 16'h1e7c;
        10'h1b6: oHamming = 16'h1e86;
        10'h1b7: oHamming = 16'h1e90;
        10'h1b8: oHamming = 16'h1e9a;
        10'h1b9: oHamming = 16'h1ea4;
        10'h1ba: oHamming = 16'h1ead;
        10'h1bb: oHamming = 16'h1eb7;
        10'h1bc: oHamming = 16'h1ec0;
        10'h1bd: oHamming = 16'h1eca;
        10'h1be: oHamming = 16'h1ed3;
        10'h1bf: oHamming = 16'h1edc;
        10'h1c0: oHamming = 16'h1ee5;
        10'h1c1: oHamming = 16'h1eed;
        10'h1c2: oHamming = 16'h1ef6;
        10'h1c3: oHamming = 16'h1efe;
        10'h1c4: oHamming = 16'h1f07;
        10'h1c5: oHamming = 16'h1f0f;
        10'h1c6: oHamming = 16'h1f17;
        10'h1c7: oHamming = 16'h1f1f;
        10'h1c8: oHamming = 16'h1f27;
        10'h1c9: oHamming = 16'h1f2e;
        10'h1ca: oHamming = 16'h1f36;
        10'h1cb: oHamming = 16'h1f3d;
        10'h1cc: oHamming = 16'h1f45;
        10'h1cd: oHamming = 16'h1f4c;
        10'h1ce: oHamming = 16'h1f53;
        10'h1cf: oHamming = 16'h1f5a;
        10'h1d0: oHamming = 16'h1f60;
        10'h1d1: oHamming = 16'h1f67;
        10'h1d2: oHamming = 16'h1f6d;
        10'h1d3: oHamming = 16'h1f74;
        10'h1d4: oHamming = 16'h1f7a;
        10'h1d5: oHamming = 16'h1f80;
        10'h1d6: oHamming = 16'h1f86;
        10'h1d7: oHamming = 16'h1f8c;
        10'h1d8: oHamming = 16'h1f91;
        10'h1d9: oHamming = 16'h1f97;
        10'h1da: oHamming = 16'h1f9c;
        10'h1db: oHamming = 16'h1fa1;
        10'h1dc: oHamming = 16'h1fa6;
        10'h1dd: oHamming = 16'h1fab;
        10'h1de: oHamming = 16'h1fb0;
        10'h1df: oHamming = 16'h1fb5;
        10'h1e0: oHamming = 16'h1fb9;
        10'h1e1: oHamming = 16'h1fbe;
        10'h1e2: oHamming = 16'h1fc2;
        10'h1e3: oHamming = 16'h1fc6;
        10'h1e4: oHamming = 16'h1fca;
        10'h1e5: oHamming = 16'h1fce;
        10'h1e6: oHamming = 16'h1fd1;
        10'h1e7: oHamming = 16'h1fd5;
        10'h1e8: oHamming = 16'h1fd8;
        10'h1e9: oHamming = 16'h1fdc;
        10'h1ea: oHamming = 16'h1fdf;
        10'h1eb: oHamming = 16'h1fe2;
        10'h1ec: oHamming = 16'h1fe5;
        10'h1ed: oHamming = 16'h1fe7;
        10'h1ee: oHamming = 16'h1fea;
        10'h1ef: oHamming = 16'h1fec;
        10'h1f0: oHamming = 16'h1fee;
        10'h1f1: oHamming = 16'h1ff1;
        10'h1f2: oHamming = 16'h1ff3;
        10'h1f3: oHamming = 16'h1ff4;
        10'h1f4: oHamming = 16'h1ff6;
        10'h1f5: oHamming = 16'h1ff8;
        10'h1f6: oHamming = 16'h1ff9;
        10'h1f7: oHamming = 16'h1ffa;
        10'h1f8: oHamming = 16'h1ffc;
        10'h1f9: oHamming = 16'h1ffc;
        10'h1fa: oHamming = 16'h1ffd;
        10'h1fb: oHamming = 16'h1ffe;
        10'h1fc: oHamming = 16'h1fff;
        10'h1fd: oHamming = 16'h1fff;
        10'h1fe: oHamming = 16'h1fff;
        10'h1ff: oHamming = 16'h1fff;
        10'h200: oHamming = 16'h1fff;
        10'h201: oHamming = 16'h1fff;
        10'h202: oHamming = 16'h1fff;
        10'h203: oHamming = 16'h1fff;
        10'h204: oHamming = 16'h1ffe;
        10'h205: oHamming = 16'h1ffd;
        10'h206: oHamming = 16'h1ffc;
        10'h207: oHamming = 16'h1ffc;
        10'h208: oHamming = 16'h1ffa;
        10'h209: oHamming = 16'h1ff9;
        10'h20a: oHamming = 16'h1ff8;
        10'h20b: oHamming = 16'h1ff6;
        10'h20c: oHamming = 16'h1ff4;
        10'h20d: oHamming = 16'h1ff3;
        10'h20e: oHamming = 16'h1ff1;
        10'h20f: oHamming = 16'h1fee;
        10'h210: oHamming = 16'h1fec;
        10'h211: oHamming = 16'h1fea;
        10'h212: oHamming = 16'h1fe7;
        10'h213: oHamming = 16'h1fe5;
        10'h214: oHamming = 16'h1fe2;
        10'h215: oHamming = 16'h1fdf;
        10'h216: oHamming = 16'h1fdc;
        10'h217: oHamming = 16'h1fd8;
        10'h218: oHamming = 16'h1fd5;
        10'h219: oHamming = 16'h1fd1;
        10'h21a: oHamming = 16'h1fce;
        10'h21b: oHamming = 16'h1fca;
        10'h21c: oHamming = 16'h1fc6;
        10'h21d: oHamming = 16'h1fc2;
        10'h21e: oHamming = 16'h1fbe;
        10'h21f: oHamming = 16'h1fb9;
        10'h220: oHamming = 16'h1fb5;
        10'h221: oHamming = 16'h1fb0;
        10'h222: oHamming = 16'h1fab;
        10'h223: oHamming = 16'h1fa6;
        10'h224: oHamming = 16'h1fa1;
        10'h225: oHamming = 16'h1f9c;
        10'h226: oHamming = 16'h1f97;
        10'h227: oHamming = 16'h1f91;
        10'h228: oHamming = 16'h1f8c;
        10'h229: oHamming = 16'h1f86;
        10'h22a: oHamming = 16'h1f80;
        10'h22b: oHamming = 16'h1f7a;
        10'h22c: oHamming = 16'h1f74;
        10'h22d: oHamming = 16'h1f6d;
        10'h22e: oHamming = 16'h1f67;
        10'h22f: oHamming = 16'h1f60;
        10'h230: oHamming = 16'h1f5a;
        10'h231: oHamming = 16'h1f53;
        10'h232: oHamming = 16'h1f4c;
        10'h233: oHamming = 16'h1f45;
        10'h234: oHamming = 16'h1f3d;
        10'h235: oHamming = 16'h1f36;
        10'h236: oHamming = 16'h1f2e;
        10'h237: oHamming = 16'h1f27;
        10'h238: oHamming = 16'h1f1f;
        10'h239: oHamming = 16'h1f17;
        10'h23a: oHamming = 16'h1f0f;
        10'h23b: oHamming = 16'h1f07;
        10'h23c: oHamming = 16'h1efe;
        10'h23d: oHamming = 16'h1ef6;
        10'h23e: oHamming = 16'h1eed;
        10'h23f: oHamming = 16'h1ee5;
        10'h240: oHamming = 16'h1edc;
        10'h241: oHamming = 16'h1ed3;
        10'h242: oHamming = 16'h1eca;
        10'h243: oHamming = 16'h1ec0;
        10'h244: oHamming = 16'h1eb7;
        10'h245: oHamming = 16'h1ead;
        10'h246: oHamming = 16'h1ea4;
        10'h247: oHamming = 16'h1e9a;
        10'h248: oHamming = 16'h1e90;
        10'h249: oHamming = 16'h1e86;
        10'h24a: oHamming = 16'h1e7c;
        10'h24b: oHamming = 16'h1e72;
        10'h24c: oHamming = 16'h1e67;
        10'h24d: oHamming = 16'h1e5d;
        10'h24e: oHamming = 16'h1e52;
        10'h24f: oHamming = 16'h1e47;
        10'h250: oHamming = 16'h1e3c;
        10'h251: oHamming = 16'h1e31;
        10'h252: oHamming = 16'h1e26;
        10'h253: oHamming = 16'h1e1b;
        10'h254: oHamming = 16'h1e0f;
        10'h255: oHamming = 16'h1e04;
        10'h256: oHamming = 16'h1df8;
        10'h257: oHamming = 16'h1dec;
        10'h258: oHamming = 16'h1de0;
        10'h259: oHamming = 16'h1dd4;
        10'h25a: oHamming = 16'h1dc8;
        10'h25b: oHamming = 16'h1dbc;
        10'h25c: oHamming = 16'h1db0;
        10'h25d: oHamming = 16'h1da3;
        10'h25e: oHamming = 16'h1d96;
        10'h25f: oHamming = 16'h1d8a;
        10'h260: oHamming = 16'h1d7d;
        10'h261: oHamming = 16'h1d70;
        10'h262: oHamming = 16'h1d63;
        10'h263: oHamming = 16'h1d55;
        10'h264: oHamming = 16'h1d48;
        10'h265: oHamming = 16'h1d3b;
        10'h266: oHamming = 16'h1d2d;
        10'h267: oHamming = 16'h1d1f;
        10'h268: oHamming = 16'h1d12;
        10'h269: oHamming = 16'h1d04;
        10'h26a: oHamming = 16'h1cf6;
        10'h26b: oHamming = 16'h1ce8;
        10'h26c: oHamming = 16'h1cd9;
        10'h26d: oHamming = 16'h1ccb;
        10'h26e: oHamming = 16'h1cbc;
        10'h26f: oHamming = 16'h1cae;
        10'h270: oHamming = 16'h1c9f;
        10'h271: oHamming = 16'h1c90;
        10'h272: oHamming = 16'h1c81;
        10'h273: oHamming = 16'h1c72;
        10'h274: oHamming = 16'h1c63;
        10'h275: oHamming = 16'h1c54;
        10'h276: oHamming = 16'h1c45;
        10'h277: oHamming = 16'h1c35;
        10'h278: oHamming = 16'h1c26;
        10'h279: oHamming = 16'h1c16;
        10'h27a: oHamming = 16'h1c06;
        10'h27b: oHamming = 16'h1bf6;
        10'h27c: oHamming = 16'h1be6;
        10'h27d: oHamming = 16'h1bd6;
        10'h27e: oHamming = 16'h1bc6;
        10'h27f: oHamming = 16'h1bb6;
        10'h280: oHamming = 16'h1ba6;
        10'h281: oHamming = 16'h1b95;
        10'h282: oHamming = 16'h1b84;
        10'h283: oHamming = 16'h1b74;
        10'h284: oHamming = 16'h1b63;
        10'h285: oHamming = 16'h1b52;
        10'h286: oHamming = 16'h1b41;
        10'h287: oHamming = 16'h1b30;
        10'h288: oHamming = 16'h1b1f;
        10'h289: oHamming = 16'h1b0e;
        10'h28a: oHamming = 16'h1afc;
        10'h28b: oHamming = 16'h1aeb;
        10'h28c: oHamming = 16'h1ad9;
        10'h28d: oHamming = 16'h1ac8;
        10'h28e: oHamming = 16'h1ab6;
        10'h28f: oHamming = 16'h1aa4;
        10'h290: oHamming = 16'h1a92;
        10'h291: oHamming = 16'h1a80;
        10'h292: oHamming = 16'h1a6e;
        10'h293: oHamming = 16'h1a5c;
        10'h294: oHamming = 16'h1a4a;
        10'h295: oHamming = 16'h1a37;
        10'h296: oHamming = 16'h1a25;
        10'h297: oHamming = 16'h1a12;
        10'h298: oHamming = 16'h1a00;
        10'h299: oHamming = 16'h19ed;
        10'h29a: oHamming = 16'h19da;
        10'h29b: oHamming = 16'h19c8;
        10'h29c: oHamming = 16'h19b5;
        10'h29d: oHamming = 16'h19a2;
        10'h29e: oHamming = 16'h198f;
        10'h29f: oHamming = 16'h197b;
        10'h2a0: oHamming = 16'h1968;
        10'h2a1: oHamming = 16'h1955;
        10'h2a2: oHamming = 16'h1941;
        10'h2a3: oHamming = 16'h192e;
        10'h2a4: oHamming = 16'h191a;
        10'h2a5: oHamming = 16'h1907;
        10'h2a6: oHamming = 16'h18f3;
        10'h2a7: oHamming = 16'h18df;
        10'h2a8: oHamming = 16'h18cb;
        10'h2a9: oHamming = 16'h18b7;
        10'h2aa: oHamming = 16'h18a3;
        10'h2ab: oHamming = 16'h188f;
        10'h2ac: oHamming = 16'h187b;
        10'h2ad: oHamming = 16'h1867;
        10'h2ae: oHamming = 16'h1853;
        10'h2af: oHamming = 16'h183e;
        10'h2b0: oHamming = 16'h182a;
        10'h2b1: oHamming = 16'h1815;
        10'h2b2: oHamming = 16'h1801;
        10'h2b3: oHamming = 16'h17ec;
        10'h2b4: oHamming = 16'h17d7;
        10'h2b5: oHamming = 16'h17c3;
        10'h2b6: oHamming = 16'h17ae;
        10'h2b7: oHamming = 16'h1799;
        10'h2b8: oHamming = 16'h1784;
        10'h2b9: oHamming = 16'h176f;
        10'h2ba: oHamming = 16'h175a;
        10'h2bb: oHamming = 16'h1745;
        10'h2bc: oHamming = 16'h1730;
        10'h2bd: oHamming = 16'h171b;
        10'h2be: oHamming = 16'h1705;
        10'h2bf: oHamming = 16'h16f0;
        10'h2c0: oHamming = 16'h16db;
        10'h2c1: oHamming = 16'h16c5;
        10'h2c2: oHamming = 16'h16b0;
        10'h2c3: oHamming = 16'h169a;
        10'h2c4: oHamming = 16'h1684;
        10'h2c5: oHamming = 16'h166f;
        10'h2c6: oHamming = 16'h1659;
        10'h2c7: oHamming = 16'h1643;
        10'h2c8: oHamming = 16'h162e;
        10'h2c9: oHamming = 16'h1618;
        10'h2ca: oHamming = 16'h1602;
        10'h2cb: oHamming = 16'h15ec;
        10'h2cc: oHamming = 16'h15d6;
        10'h2cd: oHamming = 16'h15c0;
        10'h2ce: oHamming = 16'h15aa;
        10'h2cf: oHamming = 16'h1594;
        10'h2d0: oHamming = 16'h157d;
        10'h2d1: oHamming = 16'h1567;
        10'h2d2: oHamming = 16'h1551;
        10'h2d3: oHamming = 16'h153b;
        10'h2d4: oHamming = 16'h1524;
        10'h2d5: oHamming = 16'h150e;
        10'h2d6: oHamming = 16'h14f8;
        10'h2d7: oHamming = 16'h14e1;
        10'h2d8: oHamming = 16'h14cb;
        10'h2d9: oHamming = 16'h14b4;
        10'h2da: oHamming = 16'h149e;
        10'h2db: oHamming = 16'h1487;
        10'h2dc: oHamming = 16'h1471;
        10'h2dd: oHamming = 16'h145a;
        10'h2de: oHamming = 16'h1443;
        10'h2df: oHamming = 16'h142d;
        10'h2e0: oHamming = 16'h1416;
        10'h2e1: oHamming = 16'h13ff;
        10'h2e2: oHamming = 16'h13e9;
        10'h2e3: oHamming = 16'h13d2;
        10'h2e4: oHamming = 16'h13bb;
        10'h2e5: oHamming = 16'h13a4;
        10'h2e6: oHamming = 16'h138d;
        10'h2e7: oHamming = 16'h1376;
        10'h2e8: oHamming = 16'h135f;
        10'h2e9: oHamming = 16'h1349;
        10'h2ea: oHamming = 16'h1332;
        10'h2eb: oHamming = 16'h131b;
        10'h2ec: oHamming = 16'h1304;
        10'h2ed: oHamming = 16'h12ed;
        10'h2ee: oHamming = 16'h12d6;
        10'h2ef: oHamming = 16'h12bf;
        10'h2f0: oHamming = 16'h12a8;
        10'h2f1: oHamming = 16'h1291;
        10'h2f2: oHamming = 16'h127a;
        10'h2f3: oHamming = 16'h1262;
        10'h2f4: oHamming = 16'h124b;
        10'h2f5: oHamming = 16'h1234;
        10'h2f6: oHamming = 16'h121d;
        10'h2f7: oHamming = 16'h1206;
        10'h2f8: oHamming = 16'h11ef;
        10'h2f9: oHamming = 16'h11d8;
        10'h2fa: oHamming = 16'h11c1;
        10'h2fb: oHamming = 16'h11aa;
        10'h2fc: oHamming = 16'h1192;
        10'h2fd: oHamming = 16'h117b;
        10'h2fe: oHamming = 16'h1164;
        10'h2ff: oHamming = 16'h114d;
        10'h300: oHamming = 16'h1136;
        10'h301: oHamming = 16'h111f;
        10'h302: oHamming = 16'h1108;
        10'h303: oHamming = 16'h10f0;
        10'h304: oHamming = 16'h10d9;
        10'h305: oHamming = 16'h10c2;
        10'h306: oHamming = 16'h10ab;
        10'h307: oHamming = 16'h1094;
        10'h308: oHamming = 16'h107d;
        10'h309: oHamming = 16'h1066;
        10'h30a: oHamming = 16'h104f;
        10'h30b: oHamming = 16'h1037;
        10'h30c: oHamming = 16'h1020;
        10'h30d: oHamming = 16'h1009;
        10'h30e: oHamming = 16'hff2;
        10'h30f: oHamming = 16'hfdb;
        10'h310: oHamming = 16'hfc4;
        10'h311: oHamming = 16'hfad;
        10'h312: oHamming = 16'hf96;
        10'h313: oHamming = 16'hf7f;
        10'h314: oHamming = 16'hf68;
        10'h315: oHamming = 16'hf51;
        10'h316: oHamming = 16'hf3a;
        10'h317: oHamming = 16'hf23;
        10'h318: oHamming = 16'hf0d;
        10'h319: oHamming = 16'hef6;
        10'h31a: oHamming = 16'hedf;
        10'h31b: oHamming = 16'hec8;
        10'h31c: oHamming = 16'heb1;
        10'h31d: oHamming = 16'he9a;
        10'h31e: oHamming = 16'he84;
        10'h31f: oHamming = 16'he6d;
        10'h320: oHamming = 16'he56;
        10'h321: oHamming = 16'he40;
        10'h322: oHamming = 16'he29;
        10'h323: oHamming = 16'he12;
        10'h324: oHamming = 16'hdfc;
        10'h325: oHamming = 16'hde5;
        10'h326: oHamming = 16'hdcf;
        10'h327: oHamming = 16'hdb8;
        10'h328: oHamming = 16'hda2;
        10'h329: oHamming = 16'hd8b;
        10'h32a: oHamming = 16'hd75;
        10'h32b: oHamming = 16'hd5f;
        10'h32c: oHamming = 16'hd48;
        10'h32d: oHamming = 16'hd32;
        10'h32e: oHamming = 16'hd1c;
        10'h32f: oHamming = 16'hd06;
        10'h330: oHamming = 16'hcf0;
        10'h331: oHamming = 16'hcda;
        10'h332: oHamming = 16'hcc4;
        10'h333: oHamming = 16'hcae;
        10'h334: oHamming = 16'hc98;
        10'h335: oHamming = 16'hc82;
        10'h336: oHamming = 16'hc6c;
        10'h337: oHamming = 16'hc56;
        10'h338: oHamming = 16'hc40;
        10'h339: oHamming = 16'hc2a;
        10'h33a: oHamming = 16'hc15;
        10'h33b: oHamming = 16'hbff;
        10'h33c: oHamming = 16'hbea;
        10'h33d: oHamming = 16'hbd4;
        10'h33e: oHamming = 16'hbbf;
        10'h33f: oHamming = 16'hba9;
        10'h340: oHamming = 16'hb94;
        10'h341: oHamming = 16'hb7e;
        10'h342: oHamming = 16'hb69;
        10'h343: oHamming = 16'hb54;
        10'h344: oHamming = 16'hb3f;
        10'h345: oHamming = 16'hb2a;
        10'h346: oHamming = 16'hb15;
        10'h347: oHamming = 16'hb00;
        10'h348: oHamming = 16'haeb;
        10'h349: oHamming = 16'had6;
        10'h34a: oHamming = 16'hac1;
        10'h34b: oHamming = 16'haad;
        10'h34c: oHamming = 16'ha98;
        10'h34d: oHamming = 16'ha83;
        10'h34e: oHamming = 16'ha6f;
        10'h34f: oHamming = 16'ha5a;
        10'h350: oHamming = 16'ha46;
        10'h351: oHamming = 16'ha32;
        10'h352: oHamming = 16'ha1d;
        10'h353: oHamming = 16'ha09;
        10'h354: oHamming = 16'h9f5;
        10'h355: oHamming = 16'h9e1;
        10'h356: oHamming = 16'h9cd;
        10'h357: oHamming = 16'h9b9;
        10'h358: oHamming = 16'h9a5;
        10'h359: oHamming = 16'h992;
        10'h35a: oHamming = 16'h97e;
        10'h35b: oHamming = 16'h96a;
        10'h35c: oHamming = 16'h957;
        10'h35d: oHamming = 16'h943;
        10'h35e: oHamming = 16'h930;
        10'h35f: oHamming = 16'h91d;
        10'h360: oHamming = 16'h909;
        10'h361: oHamming = 16'h8f6;
        10'h362: oHamming = 16'h8e3;
        10'h363: oHamming = 16'h8d0;
        10'h364: oHamming = 16'h8bd;
        10'h365: oHamming = 16'h8ab;
        10'h366: oHamming = 16'h898;
        10'h367: oHamming = 16'h885;
        10'h368: oHamming = 16'h873;
        10'h369: oHamming = 16'h860;
        10'h36a: oHamming = 16'h84e;
        10'h36b: oHamming = 16'h83b;
        10'h36c: oHamming = 16'h829;
        10'h36d: oHamming = 16'h817;
        10'h36e: oHamming = 16'h805;
        10'h36f: oHamming = 16'h7f3;
        10'h370: oHamming = 16'h7e1;
        10'h371: oHamming = 16'h7cf;
        10'h372: oHamming = 16'h7be;
        10'h373: oHamming = 16'h7ac;
        10'h374: oHamming = 16'h79b;
        10'h375: oHamming = 16'h789;
        10'h376: oHamming = 16'h778;
        10'h377: oHamming = 16'h767;
        10'h378: oHamming = 16'h756;
        10'h379: oHamming = 16'h745;
        10'h37a: oHamming = 16'h734;
        10'h37b: oHamming = 16'h723;
        10'h37c: oHamming = 16'h712;
        10'h37d: oHamming = 16'h702;
        10'h37e: oHamming = 16'h6f1;
        10'h37f: oHamming = 16'h6e1;
        10'h380: oHamming = 16'h6d0;
        10'h381: oHamming = 16'h6c0;
        10'h382: oHamming = 16'h6b0;
        10'h383: oHamming = 16'h6a0;
        10'h384: oHamming = 16'h690;
        10'h385: oHamming = 16'h680;
        10'h386: oHamming = 16'h670;
        10'h387: oHamming = 16'h661;
        10'h388: oHamming = 16'h651;
        10'h389: oHamming = 16'h642;
        10'h38a: oHamming = 16'h633;
        10'h38b: oHamming = 16'h623;
        10'h38c: oHamming = 16'h614;
        10'h38d: oHamming = 16'h605;
        10'h38e: oHamming = 16'h5f7;
        10'h38f: oHamming = 16'h5e8;
        10'h390: oHamming = 16'h5d9;
        10'h391: oHamming = 16'h5cb;
        10'h392: oHamming = 16'h5bc;
        10'h393: oHamming = 16'h5ae;
        10'h394: oHamming = 16'h5a0;
        10'h395: oHamming = 16'h592;
        10'h396: oHamming = 16'h584;
        10'h397: oHamming = 16'h576;
        10'h398: oHamming = 16'h568;
        10'h399: oHamming = 16'h55a;
        10'h39a: oHamming = 16'h54d;
        10'h39b: oHamming = 16'h540;
        10'h39c: oHamming = 16'h532;
        10'h39d: oHamming = 16'h525;
        10'h39e: oHamming = 16'h518;
        10'h39f: oHamming = 16'h50b;
        10'h3a0: oHamming = 16'h4fe;
        10'h3a1: oHamming = 16'h4f2;
        10'h3a2: oHamming = 16'h4e5;
        10'h3a3: oHamming = 16'h4d9;
        10'h3a4: oHamming = 16'h4cc;
        10'h3a5: oHamming = 16'h4c0;
        10'h3a6: oHamming = 16'h4b4;
        10'h3a7: oHamming = 16'h4a8;
        10'h3a8: oHamming = 16'h49c;
        10'h3a9: oHamming = 16'h490;
        10'h3aa: oHamming = 16'h485;
        10'h3ab: oHamming = 16'h479;
        10'h3ac: oHamming = 16'h46e;
        10'h3ad: oHamming = 16'h463;
        10'h3ae: oHamming = 16'h458;
        10'h3af: oHamming = 16'h44d;
        10'h3b0: oHamming = 16'h442;
        10'h3b1: oHamming = 16'h437;
        10'h3b2: oHamming = 16'h42c;
        10'h3b3: oHamming = 16'h422;
        10'h3b4: oHamming = 16'h418;
        10'h3b5: oHamming = 16'h40d;
        10'h3b6: oHamming = 16'h403;
        10'h3b7: oHamming = 16'h3f9;
        10'h3b8: oHamming = 16'h3f0;
        10'h3b9: oHamming = 16'h3e6;
        10'h3ba: oHamming = 16'h3dc;
        10'h3bb: oHamming = 16'h3d3;
        10'h3bc: oHamming = 16'h3c9;
        10'h3bd: oHamming = 16'h3c0;
        10'h3be: oHamming = 16'h3b7;
        10'h3bf: oHamming = 16'h3ae;
        10'h3c0: oHamming = 16'h3a5;
        10'h3c1: oHamming = 16'h39d;
        10'h3c2: oHamming = 16'h394;
        10'h3c3: oHamming = 16'h38c;
        10'h3c4: oHamming = 16'h384;
        10'h3c5: oHamming = 16'h37b;
        10'h3c6: oHamming = 16'h373;
        10'h3c7: oHamming = 16'h36c;
        10'h3c8: oHamming = 16'h364;
        10'h3c9: oHamming = 16'h35c;
        10'h3ca: oHamming = 16'h355;
        10'h3cb: oHamming = 16'h34d;
        10'h3cc: oHamming = 16'h346;
        10'h3cd: oHamming = 16'h33f;
        10'h3ce: oHamming = 16'h338;
        10'h3cf: oHamming = 16'h331;
        10'h3d0: oHamming = 16'h32b;
        10'h3d1: oHamming = 16'h324;
        10'h3d2: oHamming = 16'h31e;
        10'h3d3: oHamming = 16'h318;
        10'h3d4: oHamming = 16'h312;
        10'h3d5: oHamming = 16'h30c;
        10'h3d6: oHamming = 16'h306;
        10'h3d7: oHamming = 16'h300;
        10'h3d8: oHamming = 16'h2fa;
        10'h3d9: oHamming = 16'h2f5;
        10'h3da: oHamming = 16'h2f0;
        10'h3db: oHamming = 16'h2eb;
        10'h3dc: oHamming = 16'h2e6;
        10'h3dd: oHamming = 16'h2e1;
        10'h3de: oHamming = 16'h2dc;
        10'h3df: oHamming = 16'h2d7;
        10'h3e0: oHamming = 16'h2d3;
        10'h3e1: oHamming = 16'h2cf;
        10'h3e2: oHamming = 16'h2ca;
        10'h3e3: oHamming = 16'h2c6;
        10'h3e4: oHamming = 16'h2c3;
        10'h3e5: oHamming = 16'h2bf;
        10'h3e6: oHamming = 16'h2bb;
        10'h3e7: oHamming = 16'h2b8;
        10'h3e8: oHamming = 16'h2b4;
        10'h3e9: oHamming = 16'h2b1;
        10'h3ea: oHamming = 16'h2ae;
        10'h3eb: oHamming = 16'h2ab;
        10'h3ec: oHamming = 16'h2a8;
        10'h3ed: oHamming = 16'h2a6;
        10'h3ee: oHamming = 16'h2a3;
        10'h3ef: oHamming = 16'h2a1;
        10'h3f0: oHamming = 16'h29f;
        10'h3f1: oHamming = 16'h29d;
        10'h3f2: oHamming = 16'h29b;
        10'h3f3: oHamming = 16'h299;
        10'h3f4: oHamming = 16'h297;
        10'h3f5: oHamming = 16'h296;
        10'h3f6: oHamming = 16'h295;
        10'h3f7: oHamming = 16'h293;
        10'h3f8: oHamming = 16'h292;
        10'h3f9: oHamming = 16'h291;
        10'h3fa: oHamming = 16'h291;
        10'h3fb: oHamming = 16'h290;
        10'h3fc: oHamming = 16'h28f;
        10'h3fd: oHamming = 16'h28f;
        10'h3fe: oHamming = 16'h28f;
        10'h3ff: oHamming = 16'h28f;
    endcase
end

endmodule
