/* system.h
 *
 * Machine generated for a CPU named "cpu_0" as defined in:
 * C:\DE2\NiosIIpimpedOut\software\hello_ucosii_0_syslib\..\..\bigNios.ptf
 *
 * Generated: 2006-07-17 14:00:14.718
 *
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/*

DO NOT MODIFY THIS FILE

   Changing this file will have subtle consequences
   which will almost certainly lead to a nonfunctioning
   system. If you do modify this file, be aware that your
   changes will be overwritten and lost when this file
   is generated again.

DO NOT MODIFY THIS FILE

*/

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

/*
 * system configuration
 *
 */

#define ALT_SYSTEM_NAME "bigNios"
#define ALT_CPU_NAME "cpu_0"
#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_DEVICE_FAMILY "CYCLONEII"
#define ALT_STDIN "/dev/jtag_uart_0"
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN_BASE 0x00000810
#define ALT_STDOUT "/dev/jtag_uart_0"
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT_BASE 0x00000810
#define ALT_STDERR "/dev/jtag_uart_0"
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDERR_BASE 0x00000810
#define ALT_CPU_FREQ 50000000
#define ALT_IRQ_BASE NULL

/*
 * processor configuration
 *
 */

#define NIOS2_CPU_IMPLEMENTATION "small"
#define NIOS2_BIG_ENDIAN 0

#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_FLUSHDA_SUPPORTED

#define NIOS2_EXCEPTION_ADDR 0x00800020
#define NIOS2_RESET_ADDR 0x00800000
#define NIOS2_BREAK_ADDR 0x00000020

#define NIOS2_HAS_DEBUG_STUB

#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0

/*
 * A define for each class of peripheral
 *
 */

#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_LCD_16207
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_PIO
#define __ALTERA_AVALON_TIMER

/*
 * sdram_0 configuration
 *
 */

#define SDRAM_0_NAME "/dev/sdram_0"
#define SDRAM_0_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_0_BASE 0x00800000
#define SDRAM_0_SPAN 8388608
#define SDRAM_0_REGISTER_DATA_IN 1
#define SDRAM_0_SIM_MODEL_BASE 0
#define SDRAM_0_SDRAM_DATA_WIDTH 16
#define SDRAM_0_SDRAM_ADDR_WIDTH 12
#define SDRAM_0_SDRAM_ROW_WIDTH 12
#define SDRAM_0_SDRAM_COL_WIDTH 8
#define SDRAM_0_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_0_SDRAM_NUM_BANKS 4
#define SDRAM_0_REFRESH_PERIOD 15.625
#define SDRAM_0_POWERUP_DELAY 100
#define SDRAM_0_CAS_LATENCY 3
#define SDRAM_0_T_RFC 70
#define SDRAM_0_T_RP 20
#define SDRAM_0_T_MRD 3
#define SDRAM_0_T_RCD 20
#define SDRAM_0_T_AC 5.5
#define SDRAM_0_T_WR 14
#define SDRAM_0_INIT_REFRESH_COMMANDS 2
#define SDRAM_0_INIT_NOP_DELAY 0
#define SDRAM_0_SHARED_DATA 0
#define SDRAM_0_STARVATION_INDICATOR 0
#define SDRAM_0_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_0_IS_INITIALIZED 1
#define SDRAM_0_SDRAM_BANK_WIDTH 2

/*
 * lcd configuration
 *
 */

#define LCD_NAME "/dev/lcd"
#define LCD_TYPE "altera_avalon_lcd_16207"
#define LCD_BASE 0x00000800
#define LCD_SPAN 16

/*
 * jtag_uart_0 configuration
 *
 */

#define JTAG_UART_0_NAME "/dev/jtag_uart_0"
#define JTAG_UART_0_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_0_BASE 0x00000810
#define JTAG_UART_0_SPAN 8
#define JTAG_UART_0_IRQ 0
#define JTAG_UART_0_WRITE_DEPTH 64
#define JTAG_UART_0_READ_DEPTH 64
#define JTAG_UART_0_WRITE_THRESHOLD 8
#define JTAG_UART_0_READ_THRESHOLD 8
#define JTAG_UART_0_READ_CHAR_STREAM ""
#define JTAG_UART_0_SHOWASCII 1
#define JTAG_UART_0_READ_LE 0
#define JTAG_UART_0_WRITE_LE 0
#define JTAG_UART_0_ALTERA_SHOW_UNRELEASED_JTAG_UART_FEATURES 0

/*
 * Out0 configuration
 *
 */

#define OUT0_NAME "/dev/Out0"
#define OUT0_TYPE "altera_avalon_pio"
#define OUT0_BASE 0x00000820
#define OUT0_SPAN 16
#define OUT0_DO_TEST_BENCH_WIRING 0
#define OUT0_DRIVEN_SIM_VALUE 0x0000
#define OUT0_HAS_TRI 0
#define OUT0_HAS_OUT 1
#define OUT0_HAS_IN 0
#define OUT0_CAPTURE 0
#define OUT0_EDGE_TYPE "NONE"
#define OUT0_IRQ_TYPE "NONE"
#define OUT0_FREQ 50000000

/*
 * Out1 configuration
 *
 */

#define OUT1_NAME "/dev/Out1"
#define OUT1_TYPE "altera_avalon_pio"
#define OUT1_BASE 0x00000830
#define OUT1_SPAN 16
#define OUT1_DO_TEST_BENCH_WIRING 0
#define OUT1_DRIVEN_SIM_VALUE 0x0000
#define OUT1_HAS_TRI 0
#define OUT1_HAS_OUT 1
#define OUT1_HAS_IN 0
#define OUT1_CAPTURE 0
#define OUT1_EDGE_TYPE "NONE"
#define OUT1_IRQ_TYPE "NONE"
#define OUT1_FREQ 50000000

/*
 * In0 configuration
 *
 */

#define IN0_NAME "/dev/In0"
#define IN0_TYPE "altera_avalon_pio"
#define IN0_BASE 0x00000840
#define IN0_SPAN 16
#define IN0_DO_TEST_BENCH_WIRING 0
#define IN0_DRIVEN_SIM_VALUE 0x0000
#define IN0_HAS_TRI 0
#define IN0_HAS_OUT 0
#define IN0_HAS_IN 1
#define IN0_CAPTURE 0
#define IN0_EDGE_TYPE "NONE"
#define IN0_IRQ_TYPE "NONE"
#define IN0_FREQ 50000000

/*
 * In1_8bit configuration
 *
 */

#define IN1_8BIT_NAME "/dev/In1_8bit"
#define IN1_8BIT_TYPE "altera_avalon_pio"
#define IN1_8BIT_BASE 0x00000850
#define IN1_8BIT_SPAN 16
#define IN1_8BIT_DO_TEST_BENCH_WIRING 0
#define IN1_8BIT_DRIVEN_SIM_VALUE 0x0000
#define IN1_8BIT_HAS_TRI 0
#define IN1_8BIT_HAS_OUT 0
#define IN1_8BIT_HAS_IN 1
#define IN1_8BIT_CAPTURE 0
#define IN1_8BIT_EDGE_TYPE "NONE"
#define IN1_8BIT_IRQ_TYPE "NONE"
#define IN1_8BIT_FREQ 50000000

/*
 * timer_0 configuration
 *
 */

#define TIMER_0_NAME "/dev/timer_0"
#define TIMER_0_TYPE "altera_avalon_timer"
#define TIMER_0_BASE 0x00000860
#define TIMER_0_SPAN 32
#define TIMER_0_IRQ 1
#define TIMER_0_ALWAYS_RUN 0
#define TIMER_0_FIXED_PERIOD 0
#define TIMER_0_SNAPSHOT 1
#define TIMER_0_PERIOD 1
#define TIMER_0_PERIOD_UNITS "ms"
#define TIMER_0_RESET_OUTPUT 0
#define TIMER_0_TIMEOUT_PULSE_OUTPUT 0
#define TIMER_0_MULT 0.001
#define TIMER_0_FREQ 50000000

/*
 * MicroC/OS-II configuration
 *
 */

#define ALT_MAX_FD 32
#define OS_MAX_TASKS 10
#define OS_LOWEST_PRIO 20
#define OS_FLAG_EN 1
#define OS_THREAD_SAFE_NEWLIB 1
#define OS_MUTEX_EN 1
#define OS_SEM_EN 1
#define OS_MBOX_EN 1
#define OS_Q_EN 1
#define OS_MEM_EN 1
#define OS_FLAG_WAIT_CLR_EN 1
#define OS_FLAG_ACCEPT_EN 1
#define OS_FLAG_DEL_EN 1
#define OS_FLAG_QUERY_EN 1
#define OS_FLAG_NAME_SIZE 32
#define OS_MAX_FLAGS 20
#define OS_MUTEX_ACCEPT_EN 1
#define OS_MUTEX_DEL_EN 1
#define OS_MUTEX_QUERY_EN 1
#define OS_SEM_ACCEPT_EN 1
#define OS_SEM_SET_EN 1
#define OS_SEM_DEL_EN 1
#define OS_SEM_QUERY_EN 1
#define OS_MBOX_ACCEPT_EN 1
#define OS_MBOX_DEL_EN 1
#define OS_MBOX_POST_EN 1
#define OS_MBOX_POST_OPT_EN 1
#define OS_MBOX_QUERY_EN 1
#define OS_Q_ACCEPT_EN 1
#define OS_Q_DEL_EN 1
#define OS_Q_FLUSH_EN 1
#define OS_Q_POST_EN 1
#define OS_Q_POST_FRONT_EN 1
#define OS_Q_POST_OPT_EN 1
#define OS_Q_QUERY_EN 1
#define OS_MAX_QS 20
#define OS_MEM_QUERY_EN 1
#define OS_MEM_NAME_SIZE 32
#define OS_MAX_MEM_PART 60
#define OS_ARG_CHK_EN 1
#define OS_CPU_HOOKS_EN 1
#define OS_DEBUG_EN 1
#define OS_SCHED_LOCK_EN 1
#define OS_TASK_STAT_EN 1
#define OS_TASK_STAT_STK_CHK_EN 1
#define OS_TICK_STEP_EN 1
#define OS_EVENT_NAME_SIZE 32
#define OS_MAX_EVENTS 60
#define OS_TASK_IDLE_STK_SIZE 512
#define OS_TASK_STAT_STK_SIZE 512
#define OS_TASK_CHANGE_PRIO_EN 1
#define OS_TASK_CREATE_EN 1
#define OS_TASK_CREATE_EXT_EN 1
#define OS_TASK_DEL_EN 1
#define OS_TASK_NAME_SIZE 32
#define OS_TASK_PROFILE_EN 1
#define OS_TASK_QUERY_EN 1
#define OS_TASK_SUSPEND_EN 1
#define OS_TASK_SW_HOOK_EN 1
#define OS_TIME_TICK_HOOK_EN 1
#define OS_TIME_GET_SET_EN 1
#define OS_TIME_DLY_RESUME_EN 1
#define OS_TIME_DLY_HMSM_EN 1
#define ALT_SYS_CLK TIMER_0
#define ALT_TIMESTAMP_CLK none

/*
 * Devices associated with code sections.
 *
 */

#define ALT_TEXT_DEVICE       SDRAM_0
#define ALT_RODATA_DEVICE     SDRAM_0
#define ALT_RWDATA_DEVICE     SDRAM_0
#define ALT_EXCEPTIONS_DEVICE SDRAM_0
#define ALT_RESET_DEVICE      SDRAM_0

/*
 * The text section is initialised so no bootloader will be required.
 * Set a variable to tell crt0.S to provide code at the reset address and
 * to initialise rwdata if appropriate.
 */

#define ALT_NO_BOOTLOADER


#endif /* __SYSTEM_H_ */
