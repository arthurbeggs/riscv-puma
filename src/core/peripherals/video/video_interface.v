///////////////////////////////////////////////////////////////////////////////
//                  RISC-V SiMPLE - Interface de Vídeo VGA                   //
//                                                                           //
//        Código fonte em https://github.com/arthurbeggs/riscv-simple        //
//                            BSD 3-Clause License                           //
///////////////////////////////////////////////////////////////////////////////

`ifndef CONFIG_AND_CONSTANTS
    `include "config.v"
`endif

module video_interface (
    input  clock_core,
    input  clock_memory,
    input  clock_video,
    input  reset,
    input  frame_select_switch,

    output [31:0] bus_data_fetched,
    input  [31:0] bus_address,
    input  [31:0] bus_write_data,
    input  [2:0]  bus_format,
    input  bus_read_enable,
    input  bus_write_enable,

    output [7:0] vga_red,
    output [7:0] vga_green,
    output [7:0] vga_blue,
    output vga_clock,
    output vga_horizontal_sync,
    output vga_vertical_sync,
    output vga_blank,
    output vga_sync
);

wire [9:0]  pixel_x_pos;
wire [9:0]  pixel_y_pos;
wire [7:0]  pixel_frame0;
wire [7:0]  pixel_frame1;
wire [7:0]  pixel_red;
wire [7:0]  pixel_green;
wire [7:0]  pixel_blue;
wire frame_select_memory;

vga_driver vga_driver (
    .clock                  (clock_video),
    .reset                  (reset),
    .pixel_red              (pixel_red),
    .pixel_green            (pixel_green),
    .pixel_blue             (pixel_blue),
    .pixel_x_pos            (pixel_x_pos),
    .pixel_y_pos            (pixel_y_pos),
    .vga_red                (vga_red),
    .vga_green              (vga_green),
    .vga_blue               (vga_blue),
    .vga_clock              (vga_clock),
    .vga_horizontal_sync    (vga_horizontal_sync),
    .vga_vertical_sync      (vga_vertical_sync),
    .vga_blank              (vga_blank),
    .vga_sync               (vga_sync)
);

video_compositor video_compositor (
    .pixel_x_pos            (pixel_x_pos),
    .pixel_y_pos            (pixel_y_pos),
    .pixel_frame0           (pixel_frame0),
    .pixel_frame1           (pixel_frame1),
    .frame_select_memory    (frame_select_memory),
    .frame_select_switch    (frame_select_switch),
    .pixel_red              (pixel_red),
    .pixel_green            (pixel_green),
    .pixel_blue             (pixel_blue)
);

framebuffer_interface framebuffer_interface (
    .clock_core             (clock_core),
    .clock_memory           (clock_memory),
    .clock_video            (clock_video),
    .reset                  (reset),
    .bus_data_fetched       (bus_data_fetched),
    .bus_address            (bus_address),
    .bus_write_data         (bus_write_data),
    .bus_format             (bus_format),
    .bus_read_enable        (bus_read_enable),
    .bus_write_enable       (bus_write_enable),
    .pixel_x_pos            (pixel_x_pos),
    .pixel_y_pos            (pixel_y_pos),
    .pixel_frame0           (pixel_frame0),
    .pixel_frame1           (pixel_frame1),
    .frame_select           (frame_select_memory)
);

endmodule

