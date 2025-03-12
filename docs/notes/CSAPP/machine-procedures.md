# Machine-Level Programming III: Procedures  
📅 *15-213/15-513: Introduction to Computer Systems | 5th Lecture, Sept 10, 2024*  
📖 *Bryant and O’Hallaron, Computer Systems: A Programmer’s Perspective, Third Edition*  

---

## **Today’s Agenda**  
1. **Mechanisms in Procedures**  
   - Stack Structure  
   - Calling Conventions  
   - Passing Control  
   - Passing Data  
   - Managing Local Data  
2. **x86-64 Implementation**  
3. **Examples & Activities**  

---

## **Mechanisms in Procedures**  
### **What’s Needed?**  
- **Passing Control**  
  - Jump to the beginning of procedure code.  
  - Return to the original point after execution.  
- **Passing Data**  
  - Procedure arguments.  
  - Return value.  
- **Memory Management**  
  - Allocate during execution.  
  - Deallocate upon return.  

📌 **Key Insight**: *All mechanisms are implemented via machine instructions, with choices defined by the Application Binary Interface (ABI).*  

---

## **x86-64 Stack**  
### **Structure & Operations**  
- **Region of Memory Managed with Stack Discipline**:  
  - Grows toward **lower addresses**.  
  - `%rsp` (Stack Pointer) holds the address of the top element.  

![](https://wy-static.wenxiaobai.com/chat-doc/f4615ea2cf2b18af6a64538498597502-image.png)  

#### **Push Operation**  
```asm
pushq Src  
# 1. Decrement %rsp by 8  
# 2. Write operand at address %rsp  
```

#### **Pop Operation**  
```asm
popq Dest  
# 1. Read value at %rsp  
# 2. Increment %rsp by 8  
# 3. Store value in Dest  
```

---

## **Procedure Control Flow**  
### **Call and Return Instructions**  
- **`call Label`**:  
  - Push return address (next instruction) onto the stack.  
  - Jump to `Label`.  
- **`ret`**:  
  - Pop return address from the stack.  
  - Jump to that address.  

💡 **Example**:  
```asm
# Call example  
400544: call 400550   # Push return address (400549) and jump to 400550  
400549: mov %rax, (%rbx)  

# Return example  
400557: ret           # Pop address 400549 and jump back  
```

---

## **Code Examples**  
### **Example 1: `multstore` and `mult2`**  
**C Code**:  
```c
void multstore(long x, long y, long *dest) {  
    long t = mult2(x, y);  
    *dest = t;  
}  

long mult2(long a, long b) {  
    long s = a * b;  
    return s;  
}  
```

**Assembly**:  
| `multstore` (Caller) | `mult2` (Callee) |  
|-----------------------|-------------------|  
| ```asm                | ```asm            |  
| 400540: push %rbx     | 400550: mov %rdi, %rax |  
| 400541: mov %rdx, %rbx| 400553: imul %rsi, %rax |  
| 400544: call 400550   | 400557: ret       |  
| 400549: mov %rax, (%rbx)|                 |  
| 40054c: pop %rbx      |                   |  
| 40054d: ret           |                   |  
```                | ```                |  

📝 **Analysis**:  
- `multstore` saves `%rbx` (callee-saved register) before calling `mult2`.  
- Return value (`s`) is stored in `%rax` and written to `*dest`.  

---

## **Stack Frames & Recursion**  
### **Stack Frame Structure**  
- **Contents**:  
  - Return address.  
  - Local variables.  
  - Saved registers.  
  - Temporary storage.  

![](https://wy-static.wenxiaobai.com/chat-doc/53678a8e0fc73839618914a7ae0e805b-image.png)  

### **Recursive Example**  
```c  
long pcount_r(unsigned long x) {  
    if (x == 0) return 0;  
    else return (x & 1) + pcount_r(x >> 1);  
}  
```

**Assembly**:  
```asm  
pcount_r:  
    movl $0, %eax  
    testq %rdi, %rdi  
    je .L6  
    pushq %rbx  
    movq %rdi, %rbx  
    andl $1, %ebx  
    shrq %rdi  
    call pcount_r  
    addq %rbx, %rax  
    popq %rbx  
.L6:  
    rep; ret  
```

📌 **Key Observations**:  
- Recursion uses stack frames for isolation.  
- `%rbx` (callee-saved) preserves intermediate values across calls.  

---

## **Register Usage Conventions**  
### **x86-64 Linux Register Roles**  
| **Register** | **Role**                | **Saved By** |  
|--------------|-------------------------|--------------|  
| `%rax`       | Return value            | Caller       |  
| `%rdi-%r9`   | Arguments               | Caller       |  
| `%rbx, %r12-15` | Callee-saved       | Callee       |  
| `%rsp`       | Stack pointer           | Callee       |  

⚠️ **Note**: *Callee-saved registers must be preserved across function calls!*  

---

## **Activity Time!**  
### **Activity 2: Problems 6-9**  
1. **Setup**:  
```bash  
wget http://www.cs.cmu.edu/~213/activities/machine-procedures.pdf  
wget http://www.cs.cmu.edu/~213/activities/machine-procedures.tar  
tar xf machine-procedures.tar  
cd machine-procedures  
```  
2. **Tasks**:  
   - Analyze stack behavior during nested calls.  
   - Trace register usage in recursive functions.  

---

## **Quiz Time!**  
### **Sample Question**  
**Q**: What happens if you call `mult2(y, x)` instead of `mult2(x, y)` in `multstore`?  

**A**: The arguments `x` and `y` are passed in `%rdi` and `%rsi`, respectively. Swapping them would reverse the multiplication order (e.g., `y * x` instead of `x * y`), but the result remains the same due to commutativity.  

---

## **Key Takeaways**  
- **Stack Discipline** ensures proper nested execution and memory management.  
- **Calling Conventions** (caller/callee-saved registers) prevent data corruption.  
- **Recursion** leverages stack isolation for multiple instantiations.  

🚀 *Next: Dive into buffer overflows and advanced stack manipulation!*  