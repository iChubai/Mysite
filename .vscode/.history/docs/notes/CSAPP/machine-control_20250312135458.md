# Machine-Level Programming II: Control  
**15-213/14-513/15-513: Introduction to Computer Systems**  
**4th Lecture, Sept 5, 2024**  

---

## 📌 Overview  
- **Key Topics**:  
  - Condition Codes (EFLAGS)  
  - Conditional Branches & Loops  
  - Switch Statements  
- **References**: CSAPP 3.6.1–3.6.8  

---

## 🔍 Review: Machine Instructions & Addressing Modes  

### 1️⃣ **`movq` Instruction**  
- **C Code**: `*dest = t;`  
- **Assembly**: `movq %rax, (%rbx)`  
  - Moves 8-byte value from `%rax` to memory location `M[%rbx]`.  
  - Operands:  
    - `t`: Register `%rax`  
    - `dest`: Memory `M[%rbx]`  

![](https://wy-static.wenxiaobai.com/chat-doc/adddd874ff1a5c2a373c206cd640a4b0-image.png)

---

### 2️⃣ **General Addressing Mode**  
- **Syntax**: `D(Rb, Ri, S)`  
  - **Meaning**: `Mem[Reg[Rb] + S * Reg[Ri] + D]`  
  - Components:  
    - `D`: Displacement (1/2/4 bytes)  
    - `Rb`: Base register  
    - `Ri`: Index register (≠ `%rsp`)  
    - `S`: Scale (1/2/4/8)  

#### Special Cases:  
| Syntax          | Meaning                      |  
|-----------------|------------------------------|  
| `(Rb)`          | `Mem[Reg[Rb]]`               |  
| `(Rb, Ri)`      | `Mem[Reg[Rb] + Reg[Ri]]`     |  
| `D(Rb, Ri)`     | `Mem[Reg[Rb] + Reg[Ri] + D]` |  
| `(Rb, Ri, S)`   | `Mem[Reg[Rb] + S * Reg[Ri]]` |  

---

### 3️⃣ **`lea` vs. Memory Access**  
- **`lea` (Load Effective Address)**:  
  - **Does NOT access memory**! Computes address and stores it in a register.  
  - **Example**:  
    ```asm
    lea 6(%rbx, %rdi, 8), %rax  # rax = rbx + rdi*8 + 6
    ```  
  - **Use Cases**:  
    - Pointer arithmetic (e.g., array indexing).  
    - Multi-operand calculations (e.g., `rax = rbx * 3` via `lea (%rbx, %rbx, 2), %rax`).  

---

## 🚩 Condition Codes (EFLAGS)  
Implicitly set by arithmetic/logical operations:  
- **CF (Carry Flag)**: Unsigned overflow.  
- **ZF (Zero Flag)**: Result is zero.  
- **SF (Sign Flag)**: Result is negative (signed).  
- **OF (Overflow Flag)**: Signed overflow.  

### ⚙️ `cmp` and `test` Instructions  
- **`cmp a, b`**: Computes `b - a` and sets flags.  
- **`test a, b`**: Computes `b & a` and sets flags (SF/ZF).  
  - Common use: `test %rax, %rax` to check if `%rax` is zero.  

---

## 🔀 Conditional Branches  
### Jump Table (`jX` Instructions)  
| Instruction | Condition         | Description          |  
|-------------|-------------------|----------------------|  
| `jmp`       | Always            | Unconditional jump   |  
| `je`/`jz`   | `ZF=1`            | Jump if equal/zero   |  
| `jne`/`jnz` | `ZF=0`            | Jump if not equal    |  
| `jg`        | `~(SF^OF) & ~ZF`  | Jump if greater (signed) |  
| `ja`        | `~CF & ~ZF`       | Jump if above (unsigned) |  

![](https://wy-static.wenxiaobai.com/chat-doc/a92b3d06cc65d2ff1c965ee4b0c58486-image.png)

---

## 🔄 Loops in Assembly  

### 1️⃣ **Do-While Loop**  
- **C Code**:  
  ```c
  long pcount_do(unsigned long x) {
      long result = 0;
      do {
          result += x & 0x1;
          x >>= 1;
      } while (x);
      return result;
  }
  ```  
- **Assembly**:  
  ```asm
  movl $0, %eax       # result = 0
  .L2:
  movq %rdi, %rdx     # t = x
  andl $1, %edx       # t &= 0x1
  addq %rdx, %rax     # result += t
  shrq %rdi           # x >>= 1
  jne .L2             # if (x != 0) goto loop
  ret
  ```  

---

### 2️⃣ **While Loop (Jump-to-Middle)**  
- **C Code**:  
  ```c
  long pcount_while(unsigned long x) {
      long result = 0;
      while (x) {
          result += x & 0x1;
          x >>= 1;
      }
      return result;
  }
  ```  
- **Assembly**:  
  ```asm
  movl $0, %eax       # result = 0
  jmp .L2
  .L3:
  movq %rdi, %rdx     # t = x
  andl $1, %edx       # t &= 0x1
  addq %rdx, %rax     # result += t
  shrq %rdi           # x >>= 1
  .L2:
  testq %rdi, %rdi    # Test x
  jne .L3             # if (x != 0) goto loop
  ret
  ```  

---

## 🔀 Switch Statements  
- **Jump Table**: Maps case values to code addresses.  
- **Example**:  
  ```c
  long my_switch(long x, long y, long z) {
      long w = 1;
      switch (x) {
          case 1: w = y*z; break;
          case 2: w = y/z; /* Fall through */
          case 3: w += z; break;
          case 5: case 6: w -= z; break;
          default: w = 2;
      }
      return w;
  }
  ```  

- **Assembly**:  
  ```asm
  my_switch:
    cmpq $6, %rdi        # Compare x to 6
    ja .L8               # If x > 6, jump to default
    jmp *.L4(,%rdi,8)    # Jump via table at .L4 + x*8
  .L3:
    movq %rsi, %rax      # w = y
    imulq %rdx, %rax     # w *= z
    ret
  .L5:
    movq %rsi, %rax
    cqto
    idivq %rcx           # w = y/z
    jmp .L9
  .L9:
    addq %rdx, %rax      # w += z
    ret
  .L7:
    movq $1, %rax
    subq %rdx, %rax      # w -= z
    ret
  .L8:
    movq $2, %rax        # default: w = 2
    ret
  ```  

---

## 📊 Register Usage Table  
| Register | Use(s)               |  
|----------|----------------------|  
| `%rdi`   | Argument `x`         |  
| `%rsi`   | Argument `y`         |  
| `%rdx`   | Argument `z`         |  
| `%rax`   | Return value `w`     |  

---

## 🎯 Key Takeaways  
1. **Condition Codes**: Set implicitly by arithmetic operations.  
2. **Branches**: Use `jX` instructions to control flow.  
3. **Loops**: Translated into conditional jumps and labels.  
4. **Switch Statements**: Implemented via jump tables for efficiency.  

---

## 📝 Activity Time!  
1. **Parts 1-4 (Q1-Q6)**: Practice with condition codes and loops.  
2. **Parts 5-6 (Q7-Q11)**: Explore conditional moves and switch statements.  
3. **Canvas Quiz**: Complete the Day 4 quiz.  
