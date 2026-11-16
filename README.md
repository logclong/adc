# ECE-5730 Lab 8 — ADC

**AI-2 (AI as a Tutor).** Explanations and feedback are fine; the VHDL is yours and you
must be able to defend every line. The report needs an AI-2 compliance statement **at
the top**.

## Deadline and points

| Item | Due |
|---|---|
| Lab 8 — ADC (report, PDF, VHDL as an appendix) | **Mon Nov 16** |
| Lab 8 — Pass-off | **Mon Nov 16** |

Canvas lists both as all-day Nov 16 with no time. Every earlier lab used that pattern
and was due 11:59 PM. The Canvas session had expired when this was set up, so the exact
time and the point values were not re-checked. The rubric gives pass-off 10 and report 20.

## The brief, as a checklist

| # | Requirement | How you show it |
|---|---|---|
| 1 | DE10-Lite project takes an ADC measurement **at a 1 Hz rate** | demo; tick math in the report |
| 2 | Reading shown **in hex** on **the appropriate number** of seven-segment displays | board photo |
| 3 | A **potentiometer** wired to the board; the display changes as the pot turns | demo; wiring photo or schematic |
| 4 | A **reset button** | demo |
| 5 | Report with the AI-2 statement at the top | `report/` |
| 6 | **Your VHDL as an appendix** to the report | your top-level VHDL, `segment.vhd`, anything you add |

## What is already in this folder

| File | What it is | Whose |
|---|---|---|
| `ADC_8.qpf`, `ADC_8.qsf`, `ADC_8.sdc` | System Builder project from the repo: clocks, KEY, HEX0–5 (no SW or LEDR pins), top = `ADC_8` | tooling |
| `ADC_8.v`, `top.vhd` | System Builder Verilog top; `top.vhd` holds an empty Verilog module | replace with your VHDL top |
| `segment.vhd` | Your hex decoder from Lab 5, unchanged | yours |
| `adc_qsys.qsys`, `adc_qsys/` | Terasic's ADC system (PLL + Modular ADC core) from the DE10-Lite CD, generated as VHDL | Terasic / Altera; cite it |
| `adc_qsys/adc_qsys.cmp` | Component declaration to paste into your architecture | tool output |
| `adc_qsys/adc_qsys_inst.vhd` | Instantiation template | tool output |
| `build.cmd`, `program.cmd` | Compile, and load `ADC_8.sof` over JTAG | tooling |
| `cheatsheet.md` | ADC core signals, handshake, pot wiring, display notes | reference |
| `report/report_template.md` | Section headings from the rubric | fill in |

The project does not compile yet: `top.vhd` is listed as VHDL but holds Verilog. The ADC system
was also compiled with a throwaway test design outside this folder: it fits, with a
25 MHz system clock and a 10 MHz ADC clock.

## Traps in this brief

- **"Takes a measurement at 1 Hz"** reads most safely as one conversion started per
  second. The ADC core converts continuously if you hold `command_valid` high (that is
  what Terasic's demo does). Sampling continuously and only refreshing the display once
  a second is a different design; decide which you built and say so.
- **The system clock out of `adc_qsys` is 25 MHz, not 50.** The response signals are
  synchronous to `clock_bridge_sys_out_clk_clk`. Count one second on the clock you
  actually use.
- **Channel 1 is header pin A0.** Channel 0 is the chip's dedicated analog pin, which
  the Arduino header does not reach. Channels 1–6 = A0–A5.
- **12 bits = 3 hex digits.** "The appropriate number of displays" means three; blank
  the other three. Segments are active low, so all ones turns a display off. Undriven
  outputs light every segment.
- **Full scale is 5 V at the header.** The board halves the input before the ADC
  (2.5 V reference). A pot fed from 5 V sweeps 000 to about FFF; fed from 3.3 V it tops
  out near A8F. Either works; state which in the report. Never put more than 5 V on A0.
- **KEY is active low**, and `reset_reset_n` on the ADC system is active low too.
- **The low digit will flicker by a few counts.** That is ADC noise, not a bug.
- **The generated IP contains Verilog submodules.** That is Altera's code. The appendix
  is your VHDL only.

## Decisions the brief leaves to you

- What does reset do: clear the display, restart the one-second count, reset the ADC
  system, or all three?
- What shows before the first conversion finishes?
- Does the reading update the moment the response arrives, or on your one-second tick?
- Do you want a 1 Hz heartbeat? This project has no LEDR pins; a decimal point works (or add LEDR pins to make the rate visible at
  pass-off)?

## Pass-off

Office hours were MTWRF 9:30–10:20 in ENLAB 260 (from the Lab 2 notes), so today's slot
has passed. The earlier fallback was Zoom or a recorded video; confirm with Dr. Phillips
which he accepts for this lab.

## Order of work

1. Wire the pot (cheatsheet section 3).
2. Paste the component and instance into your top-level VHDL, drive the command signals, run
   `build.cmd`.
3. Get any reading onto the displays, then add the 1 Hz timing and reset.
4. Photos of the board at a low, middle and high pot position for the report.
5. Report: AI-2 statement, rubric sections, VHDL appendix. Export to PDF.
