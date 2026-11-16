# Lab 8 cheatsheet — MAX 10 ADC on the DE10-Lite

## 1. The ADC system (`adc_qsys`)

This is Terasic's system from `DE10-Lite_v.2.0.2_SystemCD/Demonstrations/ADC_RTL`,
regenerated as VHDL. Inside it:

| Block | Setting |
|---|---|
| ALTPLL | 50 MHz in; c0 = 25 MHz (system clock), c1 = 10 MHz (ADC clock) |
| Altera Modular ADC core | "ADC control core only", ADC1, 2.5 V reference, channels 1–6 enabled (header A0–A5) |
| Clock bridge | exports the 25 MHz system clock to your logic |

The ADC hard block must be clocked from a PLL output, which is why the PLL sits inside
the system. You do not need a second PLL.

To look at or change it yourself: Quartus → Tools → Platform Designer → open
`adc_qsys.qsys` → Generate HDL → Synthesis: **VHDL**. The lecture path (slide 12) is
IP Catalog → Library → Processors and Peripherals → Peripherals → Altera Modular ADC
core, which builds the same core from scratch.

## 2. Ports

| Port | Dir | Width | Meaning |
|---|---|---|---|
| `clk_clk` | in | 1 | 50 MHz board clock (`MAX10_CLK1_50`) |
| `reset_reset_n` | in | 1 | active-low reset for the system |
| `clock_bridge_sys_out_clk_clk` | out | 1 | **25 MHz**; command and response are synchronous to this |
| `modular_adc_0_command_valid` | in | 1 | you are requesting a conversion |
| `modular_adc_0_command_channel` | in | 5 | which channel (1 = A0 ... 6 = A5) |
| `modular_adc_0_command_startofpacket` | in | 1 | ignored by the core; Terasic ties it to 1 |
| `modular_adc_0_command_endofpacket` | in | 1 | ignored by the core; Terasic ties it to 1 |
| `modular_adc_0_command_ready` | out | 1 | one-clock pulse: the command has been carried out |
| `modular_adc_0_response_valid` | out | 1 | one-clock pulse: `response_data` is good **this clock** |
| `modular_adc_0_response_channel` | out | 5 | channel the data belongs to |
| `modular_adc_0_response_data` | out | 12 | the reading, unsigned |
| `modular_adc_0_response_startofpacket` / `endofpacket` | out | 1 | not needed |

Handshake rules (Avalon streaming):

- Hold `command_valid` and `command_channel` steady until `command_ready` pulses. Dropping
  valid early can lose the request.
- If valid is still high after ready, the core starts another conversion straight away.
- `response_data` is only guaranteed while `response_valid` is high, so capture it into
  your own register on that clock.
- One conversion takes on the order of a microsecond to tens of microseconds, far less
  than a second.

Component declaration: `adc_qsys/adc_qsys.cmp`. Instance template:
`adc_qsys/adc_qsys_inst.vhd`. Your Lab 5 `Top.vhd` instances are the syntax model.
Unused outputs map to `open`.

## 3. Wiring the pot

Arduino header on the DE10-Lite, analog row labelled A0–A5, power row next to it.

    pot outer leg 1 ---- 5V  (or 3.3V)
    pot wiper (middle) -- A0
    pot outer leg 2 ---- GND

- The board divides the header voltage by 2 before the ADC, and the ADC reference is
  2.5 V. So code = 4095 x Vin / 5.0 (Terasic's manual, section 5.6).
- 5 V supply: 0 V → 000, 2.5 V → 7FF, 5 V → FFF.
- 3.3 V supply: top of travel ≈ 2703 = A8F.
- Any pot from about 1 k to 100 k works. Higher values charge the sampling capacitor
  more slowly (the RC sampling-time material from lecture, slide 11).
- Check with a multimeter on the wiper before plugging it into A0.

## 4. One second

    ticks per second = clock frequency in Hz

On the 25 MHz system clock that is 25,000,000, which needs 25 bits. Your Lab 1/Lab 2
enable-tick pattern applies: one clock, a counter, a one-clock enable. No divided or
gated clocks.

## 5. Displays

- 12 bits = 3 hex digits: bits 11–8, 7–4, 3–0.
- Your `segment.vhd`: `iDigit` 4 bits in, `oSegment` 7 bits out, active low.
- `HEXn(7)` is the decimal point; `'1'` = off.
- A blank display is `"11111111"`.
- HEX0 is the rightmost display.

## 6. Build, program, debug

    build.cmd        full compile; errors print, full log in build.log
    program.cmd      lists the cable, then loads ADC_8.sof (volatile)

- Quartus 25.1 writes `ADC_8.sof` and the reports to this folder, not `output_files/`.
- If `program.cmd` says "No JTAG hardware available", the board is unplugged or the
  USB-Blaster driver is not loaded.
- Fitter report → "PLL Usage" should list 25.0 MHz and 10.0 MHz.
- Reading stuck at 000: check the channel number, the wiper connection, and that
  `command_valid` actually goes high.
- Reading stuck at FFF with the pot mid-travel: wiper not connected, or A0 floating.
- Nothing changes at all: `reset_reset_n` held low (KEY polarity).
- To watch the handshake live: Tools → Signal Tap, clock = the 25 MHz system clock,
  trigger on `response_valid`.

## 7. Midterm 2 tie-in

The SAR ADC is a confirmed Midterm 2 topic (Nov 18–20). This lab's numbers are the
exam's numbers: 12 bits, VREF 2.5 V, step = 2.5 / 4096 ≈ 0.61 mV at the chip
(≈ 1.22 mV at the header).
