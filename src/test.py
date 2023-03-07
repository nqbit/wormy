import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_wormy(dut):
    dut._log.info("start")
    clock = Clock(dut.clk, 10, units="us")
    cocotb.start_soon(clock.start())

    dut._log.info("reset")
    dut.rst.value = 1
    dut.buttons.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst.value = 0

    await ClockCycles(dut.clk, 1000)
    dut.buttons.value = 1
    await ClockCycles(dut.clk, 1000)
    dut.buttons.value = 2
    await ClockCycles(dut.clk, 1000)
    dut.buttons.value = 0b0011
    await ClockCycles(dut.clk, 1000)
