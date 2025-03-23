# Machine-Level Programming V: Advanced Topics  
**15-213/15-513/14-513: Introduction to Computer Systems**  
7th Lecture, Sept 17, 2024  
**Instructors:** Brian Railing, Mohamed Farag  

---

## 📚 Memory Layout  
### x86-64 Linux Memory Layout  
- **Stack**: Runtime stack (8MB limit), e.g., local variables.  
- **Heap**: Dynamically allocated (via `malloc`, `calloc`, `new`).  
- **Data**: Statically allocated data (global vars, static vars, string constants).  
- **Text/Shared Libraries**: Executable machine instructions (read-only).  

**Example Address Ranges (x86-64):**  
| Variable/Function    | Address (Hex)               |  
|-----------------------|-----------------------------|  
| `local`               | `0x00007ffe4d3be87c`        |  
| `phuge1`              | `0x00007f7262a1e010`        |  
| `main()`              | `0x0000000000400590`        |  
*(Exact values may vary)*  

---

## 🚨 Buffer Overflow  
### Vulnerability Example  
```c
typedef struct { 
    int a; 
    double d; 
} struct_t;

double fun(int i) { 
    volatile struct_t s; 
    s.d = 3.14; 
    s.a[i] = 1073741824; // Out-of-bounds access
    return s.d; 
}
```
**Results:**  
| Call      | Output                  |  
|-----------|-------------------------|  
| `fun(0)`  | `3.1400000000`          |  
| `fun(3)`  | `2.0000006104`          |  
| `fun(6)`  | Stack smashing detected |  
| `fun(8)`  | Segmentation fault      |  

**Explanation:**  
- Overwriting memory beyond `a` corrupts adjacent data (e.g., `d` or return addresses).  

---

### 🛡️ Protection Mechanisms  
1. **Avoid Overflow Vulnerabilities**  
   - Use `fgets` instead of `gets`, `strncpy` instead of `strcpy`.  
   ```c
   void echo() { 
       char buf; 
       fgets(buf, 4, stdin); // Safer input
       puts(buf); 
   }
   ```

2. **System-Level Protections**  
   - **Stack Randomization**: Randomize stack offsets at program start.  
   - **Non-Executable Memory**: Mark stack/heap as non-executable (NX bit).  

3. **Stack Canaries**  
   - Insert a "canary" value between buffer and return address.  
   ```assembly
   echo:
       sub    $0x18, %rsp
       mov    %fs:0x28, %rax     ; Load canary
       mov    %rax, 0x8(%rsp)    ; Store canary
       ...
       callq  gets
       mov    0x8(%rsp), %rax    ; Check canary
       xor    %fs:0x28, %rax
       je     safe_exit
       callq  stack_chk_fail     ; Crash if tampered
   ```

---

## ⚔️ Bypassing Protections  
### Return-Oriented Programming (ROP)  
- **Attack Strategy**: Chain existing code snippets ("gadgets") ending in `ret`.  
  ```assembly
  Gadget 1: 
      add %rdx, %rdi 
      ret          ; 0xc3

  Gadget 2: 
      mov %rax, %rdi 
      ret          ; 0xc3
  ```
**Crafted Attack String:**  
```hex
303132333435363738393031323334353637383930313233c806400000000000
```
- Overwrites return address to jump to `smash()`:  
  ```c
  void smash() { 
      printf("I've been smashed!\n"); 
      exit(0); 
  }
  ```

---

## 🔄 Unions  
### Memory Allocation & Usage  
- Allocate space for the **largest member**.  
```c
typedef union { 
    char c;     // 8 bytes
    short s;    // 8 bytes
    int i;      // 8 bytes
    long l;     // 8 bytes
} UnionExample;
```

### Byte Ordering  
- **Little Endian** (x86-64): LSB at lowest address.  
- **Big Endian** (Sparc): MSB at lowest address.  

**Example (x86-64):**  
| Data      | Bytes (Hex)               |  
|-----------|---------------------------|  
| `long l`  | `0xf7f6f5f4f3f2f1f0`     |  
| `int i`| `0xf3f2f1f0`              |  
| `short s` | `0xf1f0`              |  

---

## 🧩 Summary  
- **Buffer Overflow**: Major security threat via unchecked memory access.  
- **Protections**: Stack canaries, randomization, non-executable memory.  
- **Unions**: Flexible memory usage but require careful handling.  
- **Byte Ordering**: Critical for data portability across architectures.  

*Bryant and O'Hallaron, Computer Systems: A Programmer's Perspective, Third Edition* 📖
