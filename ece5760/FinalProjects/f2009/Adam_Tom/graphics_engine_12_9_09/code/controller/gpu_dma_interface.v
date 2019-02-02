module gpu_dma_interface (
    input              clk,
    //Read interface (DMA out->GPU in).
    input              dma__int__write,
    output wire        int__dma__ready,
    input [15:0]       dma__int__data_out,
                          
    output wire        int__gpu__clk,
    output wire        int__gpu__write,
    input              gpu__int__ready,
    output wire [15:0] int__gpu__data_out);

   assign int__dma__ready = gpu__int__ready;
   assign int__gpu__clk = clk;
   assign int__gpu__write = dma__int__write;
   assign int__gpu__data_out = dma__int__data_out;

endmodule
