
# 15-213/14-513/15-513: Introduction to Computer Systems  
**1st Lecture, Aug 27, 2024**  

---

## 📌 Instructors  
- **15-213/15-513**:  
  🧑🏫 Phil Gibbons  
  🧑💻 Brian Railing  
- **14-513**:  
  🧑🏫 Mohamed Farag  
  🧑💻 David Varodayan  

![](https://wy-static.wenxiaobai.com/chat-doc/6a7da06c4a6d01e99341ce2c8c906f9b-image.png)  

---

## 🎯 Course Theme: **Systems Knowledge is Power!**  
### Key Outcomes:  
1. **Become a better programmer**:  
   - Find and eliminate bugs efficiently.  
   - Understand and tune program performance.  
2. **Prepare for advanced systems courses**:  
   - Compilers, OS, Networks, Computer Architecture, Embedded Systems, etc.  

---

## 🌟 **The Five Great Realities**  

### **Great Reality #1: Ints ≠ Integers, Floats ≠ Reals**  
#### Example 1: Is \( x^2 \geq 0 \)?  
- **Floats**: Always true.  
- **Ints**:  
  - \( 40000 \times 40000 = 1600000000 \) ✅  
  - \( 50000 \times 50000 = \) **Overflow** ❌ (Result: \(-2147483648\) for 32-bit ints).  

#### Example 2: Is \( (x + y) + z = x + (y + z) \)?  
- **Ints**: ✅ (Associative).  
- **Floats**: ❌  
  - \( (1e20 + -1e20) + 3.14 = 3.14 \)  
  - \( 1e20 + (-1e20 + 3.14) = 0 \) (Catastrophic cancellation due to limited precision).  

![](https://wy-static.wenxiaobai.com/chat-doc/103042a3fd4869e2adc58940578e74c0-image.png)  

---

### **Great Reality #2: You Must Know Assembly**  
- **Why?**  
  - Debugging: High-level abstractions break down.  
  - Performance tuning: Understand compiler optimizations.  
  - System software: Compilers/OS rely on assembly.  
- **Focus**: x86 assembly.  

![](https://wy-static.wenxiaobai.com/chat-doc/00ec6c6caabf27ca1b869a3b21ba319e-image.png)  

---

### **Great Reality #3: Memory Matters**  
#### Memory Referencing Bug Example:  
```c  
typedef struct {  
    int a;  
    double d;  
} struct_t;  

double fun(int i) {  
    volatile struct_t s;  
    s.d = 3.14;  
    s.a[i] = 1073741824;  // Out-of-bounds access  
    return s.d;  
}  
```  
**Results**:  
- `fun(0)` → `3.14` ✅  
- `fun(3)` → `2.00000061035156` ❌ (Corrupted memory).  

![](https://wy-static.wenxiaobai.com/chat-doc/30b8b9c7d55b6484c0a5a605819826e3-image.png)  

---

### **Great Reality #4: Performance ≠ Asymptotic Complexity**  
- **Constant factors matter!**  
  - Example: Loop unrolling, cache locality.  
- **Memory Hierarchy**:  
  - L1/L2 cache vs. RAM vs. Disk (4.3ms vs. 81.8ms access time).  

![](https://wy-static.wenxiaobai.com/chat-doc/80ea529642a097bae7e3bd7243de09c4-image.png)  

---

### **Great Reality #5: Computers Do More Than Execute Programs**  
- **I/O and Networking**:  
  - Concurrency, unreliable media, cross-platform issues.  
- **Example**: Web proxy lab (L7) → Handle HTTP requests concurrently.  

---

## 📚 **Course Components**  
### **Labs (50% of Grade)**  
1. **Data Lab**: Bit manipulation.  
2. **Bomb Lab**: Reverse engineering.  
3. **Attack Lab**: Code injection.  
4. **Cache Lab**: Optimize memory locality.  
5. **Malloc Lab**: Implement `malloc`/`free`.  
6. **Shell Lab**: Build a Unix shell.  

### **Written Assignments (20%)**  
- Peer-reviewed problem sets (drop lowest 2).  

### **Final Exam (30%)**  
- Covers all course concepts.  

---

## ⚠️ **Academic Integrity**  
### **Cheating Examples**:  
- ❌ Copying code from peers/web.  
- ❌ Using AI tools (ChatGPT, Copilot) for solutions.  
- ❌ Reusing old code.  

### **Consequences**:  
- Failing grade, expulsion, or retroactive penalties.  

### **Allowed**:  
- ✅ Discuss high-level design.  
- ✅ Use textbook/CS:APP code (with attribution).  

---

## 💻 **Lab Policies**  
- **Grace Days**: 5 per semester (max 2 per lab).  
- **Late Penalty**: 15% per day after grace days.  

---

## 📖 **Textbooks**  
1. **Primary**: *Computer Systems: A Programmer’s Perspective* (Bryant & O’Hallaron).  
2. **Recommended**: *The C Programming Language* (K&R).  

---

## 🛠️ **Tools & Infrastructure**  
- **Shark Machines**: `ssh shark.ics.cs.cmu.edu`.  
- **Autolab**: Submit labs, view scoreboards.  

---

## 🚀 **Key Advice**  
- Start labs early!  
- Commit code frequently (Git history matters).  
- Attend bootcamps (GDB, Makefiles, C debugging).  

![](https://wy-static.wenxiaobai.com/chat-doc/4e002faa674f1ab16505393d58846195-image.png)  
