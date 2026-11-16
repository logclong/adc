
module unsaved (
	clk_clk,
	clk_0_clk_clk,
	clk_0_clk_reset_reset_n,
	modular_adc_0_adc_pll_clock_clk,
	modular_adc_0_adc_pll_locked_export,
	modular_adc_0_clock_clk,
	modular_adc_0_command_valid,
	modular_adc_0_command_channel,
	modular_adc_0_command_startofpacket,
	modular_adc_0_command_endofpacket,
	modular_adc_0_command_ready,
	modular_adc_0_reset_sink_reset_n,
	modular_adc_0_response_valid,
	modular_adc_0_response_channel,
	modular_adc_0_response_data,
	modular_adc_0_response_startofpacket,
	modular_adc_0_response_endofpacket,
	reset_reset_n);	

	input		clk_clk;
	output		clk_0_clk_clk;
	output		clk_0_clk_reset_reset_n;
	input		modular_adc_0_adc_pll_clock_clk;
	input		modular_adc_0_adc_pll_locked_export;
	input		modular_adc_0_clock_clk;
	input		modular_adc_0_command_valid;
	input	[4:0]	modular_adc_0_command_channel;
	input		modular_adc_0_command_startofpacket;
	input		modular_adc_0_command_endofpacket;
	output		modular_adc_0_command_ready;
	input		modular_adc_0_reset_sink_reset_n;
	output		modular_adc_0_response_valid;
	output	[4:0]	modular_adc_0_response_channel;
	output	[11:0]	modular_adc_0_response_data;
	output		modular_adc_0_response_startofpacket;
	output		modular_adc_0_response_endofpacket;
	input		reset_reset_n;
endmodule
