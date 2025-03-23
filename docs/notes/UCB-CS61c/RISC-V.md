# Lecture Notes: RISC-V Machine Language

## 🖥️ **Registers in RISC-V**
- **32 Registers** (`x0`-`x31`), each 32-bit wide.
- **Special Registers**:
  - `x0` (**zero**): Always `0`. 
  - `x1` (**ra**): Return address.
  - `x2` (**sp**): Stack pointer.
  - `x8` (**s0/fp**): Saved register/Frame pointer.
  - `x10`-`x17` (**a0**-**a7**): Function arguments/return values.

| Register | Name   | Use                          |
|----------|--------|------------------------------|
| x0       | zero   | Constant 0                   |
| x1       | ra     | Return address               |
| x2       | sp     | Stack pointer                |
| x8       | s0/fp  | Saved register/Frame pointer |
| x10-x11  | a0-a1  | Function args/Return values  |

---

## 🔧 **Basic RISC-V Instructions**
### 1️⃣ **Arithmetic Instructions**
- **Syntax**: `op dst, src1, src2`
- **Examples**:
  ```asm
  add s1, s2, s3   # s1 = s2 + s3
  sub s0, t2, t1   # s0 = t2 - t1
  addi s1, s2, 5   # s1 = s2 + 5 (immediate)
  ```

### 2️⃣ **Data Transfer Instructions**
- **Load/Store Syntax**: `memop reg, offset(base)`
- **Examples**:
  ```asm
  lw t0, 12(s3)    # t0 = Memory[s3 + 12]
  sw t0, 40(s3)    # Memory[s3 + 40] = t0
  lb s1, 1(s0)     # Load byte (sign-extended)
  ```

### 3️⃣ **Control Flow Instructions**
- **Branch/Jump Syntax**: `beq/bne/blt/bge/j label`
- **Example** (If-Else):
  ```asm
  # C: if (i == j) a = b; else a = -b;
  beq s0, s1, then   # Branch if i == j
  j else
  then:
    add s2, s3, x0   # a = b
    j end
  else:
    sub s2, x0, s3   # a = -b
  end:
  ```

---

## 🧮 **Example: Translating C to RISC-V**
### **C Code**:
```c
a = (b + c) - (d + e);
```
### **RISC-V Assembly**:
```asm
add t1, s3, s4   # t1 = d + e
add t2, s1, s2   # t2 = b + c
sub s0, t2, t1   # a = (b+c) - (d+e)
```
- **Registers Used**:
  - `a → s0`, `b → s1`, `c → s2`, `d → s3`, `e → s4`.

---

## 🔄 **Shifting Instructions**
- **Examples**:
  ```asm
  slli s0, s1, 3   # s0 = s1 << 3 (logical left shift)
  srai s2, t0, 8   # s2 = t0 >> 8 (arithmetic right shift)
  ```

---

## 📊 **RISC-V Green Card (Key Instructions)**
| Mnemonic | Description               | Example           |
|----------|---------------------------|-------------------|
| `add`    | Add registers             | `add s1, s2, s3`  |
| `addi`   | Add immediate             | `addi s1, s2, 5`  |
| `lw`     | Load word from memory     | `lw t0, 12(s3)`   |
| `sw`     | Store word to memory      | `sw t0, 40(s3)`   |
| `beq`    | Branch if equal           | `beq s0, s1, L1`  |
| `jal`    | Jump and link             | `jal ra, proc`    |

---

## 🧩 **Key Concepts**
1. **RISC vs. CISC**:  
   - RISC focuses on **simple instructions** executed quickly (e.g., ARM, RISC-V).  
   - CISC uses complex instructions (e.g., x86).  

2. **Memory Hierarchy**:  
   - Registers (fastest) → Cache → RAM → Disk (slowest).  

3. **Endianness**:  
   - RISC-V uses **little-endian** (LSB at lowest address).  

---

## 📝 **Summary**
- **Registers**: Fast, limited storage for variables.  
- **Immediates**: Constants embedded in instructions (e.g., `addi`).  
- **Control Flow**: Branches (`beq`, `bne`) and jumps (`j`, `jal`).  
- **Data Transfer**: Load/store instructions for memory access.  

🚀 **RISC-V is dominant in embedded systems, academia, and modern computing!**


---

📸 **PPT Screenshots** (Hypothetical Links):  
![C Memory Layout](https://wy-static.wenxiaobai.com/chat-doc/b1a9a95d80c21ea9eaf339df032df6c7-image.png)  
![RISC-V Registers](https://wy-static.wenxiaobai.com/chat-doc/1ae3a971585f03feaeed06b564741c4b-image.png)  
![Control Flow](https://wy-static.wenxiaobai.com/chat-doc/fd4725497f7f80bff5b81179322dc56b-image.png)  

*Note: Replace image links with actual screenshots of full PPT slides.*