# DMA Interconnect Specification

## Top Module File

`dma.v`


## Overview

The `dma` module is a multi-channel DMA controller that bridges AHB and APB bus domains. It acts as both an **AHB slave** (for register configuration by a processor) and an **AHB master** (for autonomous data movement). It can also drive an **APB master** interface to transfer data to/from APB peripherals. Hardware flow control inputs from up to 3 external sources (e.g., UARTs) gate data transfers.

The number of channels is compile-time configurable via defines in `dma_defs.v`: `one_channel`, `two_channel`, `three_channel`, or the default (4 channels).


## Submodules

i_udma_config (dma_ahb_config) – AHB slave register interface
i_udma_int_control (dma_int_control) – Interrupt mask & status
i_udma_ahb_ctrl (dma_ahb_master) – AHB master bus-request FSM
i_udma_arbiter (dma_arbiter) – Per-channel AHB/APB arbiter
i_udma_apb_mux (dma_apb_mux) – APB output mux
i_udma_ahb_mux (dma_ahb_mux) – AHB master output mux
i_udma_flow (dma_flow_mux) – Flow-control routing
i_udma_ch0..chN (dma_channel) – Transfer engines
