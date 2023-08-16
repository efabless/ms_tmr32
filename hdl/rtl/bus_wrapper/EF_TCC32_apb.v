/*
	Copyright 2023 Efabless Corp.

	Author: Mohamed Shalan (mshalan@aucegypt.edu)

	This file is auto-generated by wrapper_gen.py

	Permission is hereby granted, free of charge, to any person obtaining
	a copy of this software and associated documentation files (the
	"Software"), to deal in the Software without restriction, including
	without limitation the rights to use, copy, modify, merge, publish,
	distribute, sublicense, and/or sell copies of the Software, and to
	permit persons to whom the Software is furnished to do so, subject to
	the following conditions:

	The above copyright notice and this permission notice shall be
	included in all copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
	LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
	OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
	WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/


`timescale			1ns/1ns
`default_nettype	none

`define		APB_BLOCK(name, init)	always @(posedge PCLK or negedge PRESETn) if(~PRESETn) name <= init;
`define		APB_REG(name, init)		`APB_BLOCK(name, init) else if(apb_we & (PADDR==``name``_ADDR)) name <= PWDATA;
`define		APB_ICR(sz)				`APB_BLOCK(ICR_REG, sz'b0) else if(apb_we & (PADDR==ICR_REG_ADDR)) ICR_REG <= PWDATA; else ICR_REG <= sz'd0;

module EF_TCC32_apb (
	input	wire 		ext_clk,
	input	wire 		PCLK,
	input	wire 		PRESETn,
	input	wire [31:0]	PADDR,
	input	wire 		PWRITE,
	input	wire 		PSEL,
	input	wire 		PENABLE,
	input	wire [31:0]	PWDATA,
	output	wire [31:0]	PRDATA,
	output	wire 		PREADY,
	output	wire 		irq
);
	localparam[15:0] TIMER_REG_ADDR = 16'h0000;
	localparam[15:0] PERIOD_REG_ADDR = 16'h0004;
	localparam[15:0] COUNTER_REG_ADDR = 16'h0008;
	localparam[15:0] COUNTER_MATCH_REG_ADDR = 16'h000c;
	localparam[15:0] CONTROL_REG_ADDR = 16'h0010;
	localparam[15:0] ICR_REG_ADDR = 16'h0f00;
	localparam[15:0] RIS_REG_ADDR = 16'h0f04;
	localparam[15:0] IM_REG_ADDR = 16'h0f08;
	localparam[15:0] MIS_REG_ADDR = 16'h0f0c;

	reg	[31:0]	PERIOD_REG;
	reg	[31:0]	COUNTER_MATCH_REG;
	reg	[31:0]	CONTROL_REG;
	reg	[2:0]	RIS_REG;
	reg	[2:0]	ICR_REG;
	reg	[2:0]	IM_REG;

	wire[31:0]	tmr;
	wire[31:0]	TIMER_REG	= tmr;
	wire[31:0]	period	= PERIOD_REG[31:0];
	wire[31:0]	cp_count;
	wire[31:0]	COUNTER_REG	= cp_count;
	wire[31:0]	ctr_match	= COUNTER_MATCH_REG[31:0];
	wire		en	= CONTROL_REG[0:0];
	wire		tmr_en	= CONTROL_REG[1:1];
	wire		cp_en	= CONTROL_REG[3:3];
	wire[3:0]	clk_src	= CONTROL_REG[11:8];
	wire		up	= CONTROL_REG[16:16];
	wire		one_shot	= CONTROL_REG[17:17];
	wire[1:0]	cp_event	= CONTROL_REG[25:24];
	wire		to_flag;
	wire		_TO_FLAG_	= to_flag;
	wire		cp_flag;
	wire		_CP_FLAG_	= cp_flag;
	wire		match_flag;
	wire		_MATCH_FLAG_	= match_flag;
	wire[2:0]	MIS_REG	= RIS_REG & IM_REG;
	wire		ctr_in	= ext_clk;
	wire		apb_valid	= PSEL & PENABLE;
	wire		apb_we	= PWRITE & apb_valid;
	wire		apb_re	= ~PWRITE & apb_valid;
	wire		_clk_	= PCLK;
	wire		_rst_	= ~PRESETn;

	EF_TCC32 inst_to_wrap (
		.clk(_clk_),
		.rst_n(~_rst_),
		.ctr_in(ctr_in),
		.period(period),
		.ctr_match(ctr_match),
		.tmr(tmr),
		.cp_count(cp_count),
		.clk_src(clk_src),
		.to_flag(to_flag),
		.match_flag(match_flag),
		.tmr_en(tmr_en),
		.one_shot(one_shot),
		.up(up),
		.cp_en(cp_en),
		.cp_event(cp_event),
		.cp_flag(cp_flag),
		.en(en)
	);

	`APB_REG(PERIOD_REG, 0)
	`APB_REG(COUNTER_MATCH_REG, 0)
	`APB_REG(CONTROL_REG, 0)
	`APB_REG(IM_REG, 0)

	`APB_ICR(3)

	always @(posedge PCLK or negedge PRESETn)
		if(~PRESETn) RIS_REG <= 32'd0;
		else begin
			if(_TO_FLAG_) RIS_REG[0] <= 1'b1; else if(ICR_REG[0]) RIS_REG[0] <= 1'b0;
			if(_CP_FLAG_) RIS_REG[1] <= 1'b1; else if(ICR_REG[1]) RIS_REG[1] <= 1'b0;
			if(_MATCH_FLAG_) RIS_REG[2] <= 1'b1; else if(ICR_REG[2]) RIS_REG[2] <= 1'b0;

		end

	assign irq = |MIS_REG;

	assign	PRDATA = 
			(PADDR == PERIOD_REG_ADDR) ? PERIOD_REG :
			(PADDR == COUNTER_MATCH_REG_ADDR) ? COUNTER_MATCH_REG :
			(PADDR == CONTROL_REG_ADDR) ? CONTROL_REG :
			(PADDR == RIS_REG_ADDR) ? RIS_REG :
			(PADDR == ICR_REG_ADDR) ? ICR_REG :
			(PADDR == IM_REG_ADDR) ? IM_REG :
			(PADDR == TIMER_REG_ADDR) ? TIMER_REG :
			(PADDR == COUNTER_REG_ADDR) ? COUNTER_REG :
			(PADDR == MIS_REG_ADDR) ? MIS_REG :
			32'hDEADBEEF;


	assign PREADY = 1'b1;

endmodule
