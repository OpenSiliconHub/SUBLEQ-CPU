<pre align="center">
 ██████╗ ███████╗██╗  ██╗
██╔═══██╗██╔════╝██║  ██║
██║   ██║███████╗███████║
██║   ██║╚════██║██╔══██║
╚██████╔╝███████║██║  ██║
 ╚═════╝ ╚══════╝╚═╝  ╚═╝
 
OSH-SUBLEQ-CPU
</pre>

## Overview
<img width="761" height="249" alt="image" src="https://github.com/user-attachments/assets/dc198858-6165-43ca-a9d2-583065bc007f" />


OSH‑SUBLEQ‑CPU is a community‑driven implementation of a SUBLEQ (Subtract and Branch if Less than or Equal to Zero) CPU in Verilog.  
SUBLEQ is a one‑instruction set computer (OISC) architecture, where all computation is expressed through a single subtract‑and‑branch operation.

This project delivers a **minimal SUBLEQ CPU core** maintained as an **industrial‑style reference implementation**.  
It is structured to be extended, integrated, or benchmarked in professional workflows, ensuring reproducibility, modularity, and alignment with established digital design practices.



## 2. Architecture Summary

| Parameter           | Value                               |
| ------------------- | ----------------------------------- |
| Architecture Type   | OISC (One Instruction Set Computer) |
| Instruction Set     | SUBLEQ                              |
| Data Width          | 16 bits                             |
| Address Width       | 16 bits                             |
| Memory Space        | 64K × 16-bit words                  |
| Memory Organization | Unified Memory                      |
| Reset Vector        | 0x0000                              |
| Execution Style     | Multi-cycle                         |

---

## 3. Instruction Format

The processor implements a single SUBLEQ instruction.

Each instruction consists of three 16-bit addresses:

* Operand A Address
* Operand B Address
* Operand C Address

Total instruction length:

[
3 \times 16 = 48 \text{ bits}
]

The instruction operands are fetched sequentially during execution.

---

## 4. Register Set

The processor contains the following registers:

| Register | Description             |
| -------- | ----------------------- |
| PC       | Program Counter         |
| IRA      | Instruction Register A  |
| IRB      | Instruction Register B  |
| IRC      | Instruction Register C  |
| MAR      | Memory Address Register |
| MDR      | Memory Data Register    |
| TEMP     | Temporary Register      |

---

## 5. Memory System

The CPU uses a unified memory architecture in which both instructions and data share the same memory space.

### Memory Characteristics

| Property      | Value                           |
| ------------- | ------------------------------- |
| Address Width | 16 bits                         |
| Data Width    | 16 bits                         |
| Capacity      | 64K words                       |
| Organization  | Unified Instruction/Data Memory |

The Program Counter provides addresses for instruction fetch operations. Operand accesses are performed through the MAR and MDR registers.

---

## 6. Functional Blocks

### Program Counter (PC)

Maintains the address of the current instruction and supplies addresses during instruction fetch operations.

### Unified Memory

Stores both instructions and data within the same address space.

### Instruction Registers

* **IRA** stores operand A address.
* **IRB** stores operand B address.
* **IRC** stores operand C address.

### Arithmetic Logic Unit (ALU)

Performs the subtraction operation required by the SUBLEQ instruction.

### Control Unit

Generates control signals and sequences the processor through the execution states.

### Result Register/Path

Stores or forwards the ALU output for memory write-back and branch evaluation.

---

## 7. Execution Cycle

Instruction execution is divided into multiple states.

### State 1 – Fetch A

Fetch operand A address from memory and load into IRA.

### State 2 – Fetch B

Fetch operand B address from memory and load into IRB.

### State 3 – Fetch C

Fetch operand C address from memory and load into IRC.

### State 4 – Read Operand A

Read the value located at the address specified by IRA.

### State 5 – Read Operand B

Read the value located at the address specified by IRB.

### State 6 – Execute Subtract

Perform the subtraction operation using the ALU.

### State 7 – Write Result

Store the subtraction result back to memory.

### State 8 – Branch Decision

Evaluate the branch condition and determine the next value of the Program Counter.

---

## 8. Reset Behavior

Upon reset:

* Program Counter is initialized to **0x0000**.
* Execution begins from the reset vector address.
* Instruction fetch starts from unified memory location **0x0000**.

---




<p align="left">
  <img src="https://img.shields.io/github/license/OpenSiliconHub/SUBLEQ-CPU">
</p>

## Code of Conduct
This project follows the [No Code of Conduct](CODE_OF_CONDUCT.md).
