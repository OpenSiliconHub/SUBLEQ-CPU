<pre align="center">
 ██████╗ ███████╗██╗  ██╗
██╔═══██╗██╔════╝██║  ██║
██║   ██║███████╗███████║
██║   ██║╚════██║██╔══██║
╚██████╔╝███████║██║  ██║
 ╚═════╝ ╚══════╝╚═╝  ╚═╝
 
OSH-SUBLEQ-CPU
</pre>

<p align="left">
  <img src="https://img.shields.io/github/license/OpenSiliconHub/SUBLEQ-CPU" alt="License">
  <img src="https://img.shields.io/badge/status-archived-lightgrey" alt="Archived">
</p>

> **Archived Educational Artifact**
>
> This repository is archived and preserved as an educational reference. It contains a minimal **SUBLEQ OISC CPU** implemented in both synthesizable **Verilog** and **VHDL**. The original maintainers are no longer actively developing it. The community is welcome to fork, extend, and reuse it as a baseline. If you build on this work, please credit the **OpenSiliconHub SUBLEQ-CPU** project and its contributors.

## About this repository

This repository provides a standardized, hardware-verified reference implementation of a minimal **SUBLEQ CPU** core written in synthesizable **Verilog** and **VHDL**. It serves as an educational resource and baseline architecture for a functional One Instruction Set Computer (OISC).

The project was created as an educational artifact: a compact, readable SUBLEQ core intended to demonstrate how a complete CPU can be built around a single instruction. Both language variants implement the same architecture and were checked for behavioral equivalence using Yosys and the GHDL plugin.

---

## Instruction Semantics

SUBLEQ performs a subtract and branch-if-less-than-or-equal-to-zero operation:

```text
mem[B] = mem[B] - mem[A]
if (mem[B] <= 0) PC = C
else PC = PC + 3
```

---

## Architectural Specification Summary

| Parameter | Value |
| :--- | :--- |
| **Architecture Type** | OISC (One Instruction Set Computer) |
| **Instruction Set** | SUBLEQ (Subtract and Branch if Less than or Equal to Zero) |
| **PC Width** | 16-bit |
| **Memory Space** | 65,536 words |
| **Memory Organization** | Unified Memory (Von Neumann architecture) |
| **Reset Vector** | `0x0000` |
| **Sequential Update** | `PC = PC + 3` |
| **Branch Update** | `PC = C` |
| **Branch Condition** | `(B - A) <= 0` |

> A detailed engineering report and design breakdown are available in the repository documentation, if included.

---

## Repository Contents

| Path | Description |
| :--- | :--- |
| `Verilog/subleq.v` | SUBLEQ CPU core in synthesizable Verilog |
| `Verilog/single_port_ram.v` | Unified single-port memory model in Verilog |
| `VHDL/subleq.vhd` | SUBLEQ CPU core in synthesizable VHDL |
| `VHDL/single_port_ram.vhd` | Unified single-port memory model in VHDL |
| `report.tcl` | Yosys formal equivalence reporting helper and gatekeeper |
| `run_proof.ys`, `subleq_run_proof.ys` | Formal equivalence miter and verification flow |
| `CONTRIBUTING.md` | Historical contribution guidelines |
| `CODE_OF_CONDUCT.md` | Project code of conduct |
| `LICENSE` | Apache License 2.0 |

---

## Formal Equivalence Verification

A significant part of this project was verifying that the **Verilog** and **VHDL** implementations describe the same behavior. The repository includes a Yosys-based formal equivalence flow using the GHDL plugin.

The flow:

1. Reads and elaborates the Verilog implementation.
2. Reads and elaborates the VHDL implementation with GHDL.
3. Flattens both designs and maps memory cells.
4. Builds an equivalence miter with `equiv_make`.
5. Runs `equiv_simple`, `equiv_struct`, and `equiv_induct -seq 12` for the top-level `subleq`.
6. Uses `report.tcl` to print a dynamic verification report and fail if unproven bits remain.

This provides strong confidence that both language variants implement the same SUBLEQ semantics. It is not a replacement for a full functional testbench, but it is a useful educational example of formal equivalence checking between HDLs.

---

## Testing Note

During development, external contributors tested the core with a few small SUBLEQ programs. Those tests helped validate the design.

However, the test programs, testbenches, and generated hex files were **not added to this repository**. Future forks and maintainers are encouraged to add:

- Testbenches for both Verilog and VHDL
- Example SUBLEQ programs and `program.hex` files
- An assembler or compiler targeting this core
- CI-based simulation
- FPGA constraints and synthesis scripts
- Additional formal properties

---

## Memory Initialization

The RAM models support preloading from a hex file.

- **Verilog:** uncomment `$readmemh("program.hex", ram_block);` in `single_port_ram.v`.
- **VHDL:** uncomment the `G_INIT_MEM` generic and `init_ram_f` function in `single_port_ram.vhd`.

No example `program.hex` is included in this repository.

---

## Project Status

This repository is **archived** and no longer actively maintained by the original maintainers. It is preserved as an educational artifact and as a community baseline.

You are welcome to:

- Fork the repository
- Extend the core
- Add tests, tooling, peripherals, or architecture variants
- Use it in teaching or research

If you reuse this work, please credit the **OpenSiliconHub SUBLEQ-CPU** project and its contributors. That is all we ask.

For historical contribution guidelines, see [`CONTRIBUTING.md`](./CONTRIBUTING.md). Because the repository is archived, direct pull requests may not be accepted.

---

## Acknowledgements

We sincerely thank the three external contributors who supported this project through testing, feedback, and program-level validation. Their work helped confirm the behavior of the core, even though their test programs were not included in this repository.

- **[beemer2001ny](https://github.com/beemer2001ny)**
- **[Jaimay234](https://github.com/jaimay234)**
- **[ojaskudari](https://github.com/ojaskudari)**

---

## License

This project is licensed under the **Apache License 2.0**. See [`LICENSE`](./LICENSE) for details.

---

## Code of Conduct

Please see [`CODE_OF_CONDUCT.md`](./CODE_OF_CONDUCT.md).
