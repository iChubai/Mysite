# Design and Debugging  
**15-213/15-513: Introduction to Computer Systems**  
**8th Lecture, Sept. 19, 2024**  
*Instructors: Brian Railing, Mohamed Farag*  

---

## 📚 After This Lecture, You Will Be Able To:  
1. **Describe** the steps to debug complex code failures.  
2. **Identify** ways to manage complexity when programming.  
3. **State** guidelines for communicating the intention of the code.  

---

## 📝 Outline  
### Debugging  
- Defects and Failures  
- Scientific Debugging  
- Tools  

### Design  
- Managing Complexity  
- Communication (Naming, Comments)  

---

## 🛠 Debugging  

### Defects, Errors, & Failures  
1. **Defect**: Programmer creates a fault.  
2. **Error**: Defect causes wrong results in data/control signals.  
3. **Error Propagation**: Erroneous state spreads.  
4. **Failure**: System/component fails to produce intended result.  

🔍 **Why errors ≠ failures?**  
Errors can be *masked* (e.g., ECC memory) or *detected*.  

### 🧪 Scientific Debugging  
1. **Hypothesis**: Propose a defect explanation.  
2. **Prediction**: What happens if the hypothesis is true?  
3. **Experiment**: Test under controlled conditions.  
4. **Observation**: Collect data to confirm/refute the hypothesis.  
5. **Fix & Confirm**: Apply fix and validate.  

#### Example: Atlas-Centaur Rocket Failure  
- **First Failure**: Clogged turbopumps due to plastic remnants.  
  - *Fix*: Bake off plastic.  
- **Second Failure**: Leaking valve pushed to failure by efficiency demands.  
  - *Lesson*: Reproduce the failure to diagnose.  

---

### 🐛 Code Example: Buggy Fibonacci  
```c
int fib(int n) {
    int $f, f 0=1, f 1=1$;
    while $(n>1)$ {
        $$n=n-1;$$
        $f=f 0+f 1$;
        $f 0=f 1$;
        f1=f;
    }
    return $f;
}
```
**Failure**: `fib(1)` returns garbage (e.g., `134513905`).  

#### 🔍 Hypothesis Table  
| Code Snippet          | Hypothesis                          |  
|-----------------------|-------------------------------------|  
| `while(n>1)`          | Loop condition incorrect for `n=1` |  
| `int f;`              | `f` is uninitialized               |  

#### 🛠 Fix: Initialize `f`  
```c
int fib(int n) {
    int f = 1; // Initialize f
    ...
}
```

#### 🧪 Experiment Results  
- **Without Fix**: `fib(1) = 0` (uninitialized value).  
- **With Fix**: `fib(1) = 1` (correct).  

---

## 🛠 Tools for Debugging  
1. **Compiler Flags**:  
   ```bash
   gcc -Wall -Werror -O3 -o fib fib.c  # Catch uninitialized variables
   ```  
2. **Valgrind**: Detect memory leaks/uninitialized accesses.  
3. **GDB**: Step-through execution to trace state.  

---

## 🎨 Design  

### Managing Complexity  
- **Techniques**:  
  - Separation of Concerns  
  - Modularity  
  - Abstraction  
  - DRY (Don’t Repeat Yourself)  

#### Example: Cache Access Steps  
1. Convert address → tag, set index, block offset.  
2. Look up set.  
3. Check tag match.  
4. Handle hit/miss (evict LRU, load new line).  

---

### 📛 Naming Guidelines  
1. **Avoid meaningless names**:  
   - ❌ `tmp`, `data`, `foo`  
   - ✅ `employeeSalary`, `cacheLine`  
2. **Use domain terms**:  
   - In a cache lab: `line`, `tag`, `setIndex`.  
3. **Limit word count**:  
   - ❌ `arraysOfSetsOfLinesOfBlocks`  
   - ✅ `cache`  

---

### 💬 Comments  
- **Don’ts**:  
  - ❌ Explain what code does (`i++ // increment i`).  
  - ❌ Apologize for bad code.  
- **Dos**:  
  - ✅ Explain **why** (e.g., magic numbers):  
    ```c
    // MAX_ADDRESS_LENGTH = 17 for 64-bit addresses (16 hex chars + null)
    const int MAX_ADDRESS_LENGTH = 17;
    ```

---

## 📊 Summary  
1. **Debugging**: Systematic hypothesis-driven process. ✅  
2. **Design**: Manage complexity via modularity, naming, and clear communication. 📦  
3. **Tools**: Use `-Wall`, Valgrind, and debuggers to catch issues early. 🛠  

*"Testing shows the presence, not the absence, of defects." – Dijkstra*  

---

**🔗 Resources**:  
- [The Space Review: Atlas-Centaur Failure](https://www.thespacereview.com/article/1321/1)  
- *Computer Systems: A Programmer’s Perspective, 3rd Ed.*  
