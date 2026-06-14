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
  <img src="https://img.shields.io/github/license/OpenSiliconHub/SUBLEQ-CPU">
</p>

## About this repository

This repository provides a standardized, hardware-verified reference implementation of a minimal **SUBLEQ CPU** core written in synthesizable Verilog. It serves as an educational resource and baseline architecture for a functional One Instruction Set Computer (OISC).

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

>  *A detailed engineering report and design breakdown are available in the [Documentation](./docs.md) directory.*

---

## Project Status & Community Maintenance

Following the stable **v1.0 release**, primary development by the core maintainers will conclude. Moving forward, this repository will transition into a fully **community-driven project**. 

We warmly welcome open-source contributions to expand the features of this educational core. Key focus areas include:
* **Verification:** Enhancing testbenches, edge-case coverage, and formal verification.
* **Harvard Architecture:** Creating a varient with distinct Instruction and Data memory buses.
* **Peripherals:** Integrating memory-mapped GPIO controllers for hardware interaction.
* **Tooling:** Developing simple assemblers/compilers targeting this core architecture.

Please review our guidelines in [CONTRIBUTING.md](./CONTRIBUTING.md).
