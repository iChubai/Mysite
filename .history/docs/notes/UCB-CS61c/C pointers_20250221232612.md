---
title: C pointers
math: false
tags:
  - CS61C
---
# 📚 CS61C Lecture Notes: Introduction to C & Pointers  
**Instructor**: Stephan Kaminsky | **Date**: Jun 2019  

---

## 📌 Key Concepts in C Programming  

### 1. **Compilation in C**  
- **Compiled Language**: Converts C code directly to machine-specific instructions (0s and 1s).  
  - 🚀 **Advantages**: Faster execution than Java/Python (no bytecode/JVM).  
  - ⚠️ **Disadvantages**: Platform-dependent executables; slower edit-compile-run cycle.  

---

### 2. **Variable Types & Declarations**  
- **Typed Variables**: Must declare type before use.  
  - Example:  
    ```c
    int x = 5;          // Integer
    float y = 1.618;    // Floating point
    char z = 'A';       // Character
    ```  
- **Type Sizes**: Machine-dependent (e.g., `int` = 4/8 bytes).  
- **Special Keywords**: `short`, `long`, `unsigned`.  

---

### 3. **Characters & ASCII**  
- **ASCII Encoding**: Characters stored as numbers (e.g., `'a'` = 97).  
  ```c
  char c = 'a';     // Same as char c = 97;
  ```  
- **Size**: 1 byte (8 bits).  

---

### 4. **Type Casting**  
- **Weak Typing**: Explicitly cast between types.  
  - Example:  
    ```c
    int i = -1;
    if ((unsigned int)i < 0) { ... }  // False
    ```  
- ⚠️ **Caution**: Risky casts (e.g., casting structs to integers).  

---

### 5. **Functions**  
- **Prototypes & Definitions**:  
  ```c
  int add(int a, int b);   // Prototype
  int add(int a, int b) { return a + b; }  // Definition
  ```  
- **Return Types**: Must declare return type (`void` for no return).  

---

### 6. **Structs & Unions**  
- **Structs**: Group related variables.  
  ```c
  typedef struct {
    int length;
    int year;
  } Song;
  Song s = {213, 1994}; 
  ```  
- **Unions**: Overlapping memory for different types.  
  ```c
  union Data {
    int i;
    float f;
  };
  ```  

---

## 🧮 Example: Struct Padding  
```c
struct foo {
  int a;     // 4 bytes
  char b;    // 1 byte (+3 padding)
  struct foo* c;  // 4 bytes
};  
// Total size = 12 bytes (32-bit architecture)
```  

---

## 📊 C vs Java Comparison  
| Feature              | C                          | Java                       |
|----------------------|----------------------------|----------------------------|
| **Language Type**    | Function-Oriented          | Object-Oriented            |
| **Memory Management**| Manual (`malloc`, `free`)  | Automatic (Garbage Collection) |
| **Hello World**      | `printf("Hello\n");`       | `System.out.println(...);` |  

---

## 🎯 Pointers: Address vs Value  
- **Pointer Syntax**:  
  ```c
  int y = 5;
  int *p = &y;   // p stores address of y
  int z = *p;    // z = value at address p (5)
  ```  
- **Pointer Types**:  
  - `int*`, `char*`, `void*` (generic pointer).  
  - ⚠️ **Dangling Pointers**: Uninitialized pointers → undefined behavior!  

---

### 🔍 Example: Pointer Parameter Passing  
```c
void addOne(int *p) { (*p)++; }  
int main() {
  int y = 3;
  addOne(&y);    // y becomes 4
  return 0;
}
```  

---

## ❓ **Quiz: 4-Bit Number Representations**  
Given `x = 0b1010` (4 bits), which value does **NOT** represent `x`?  

**Options**:  
(A) -4  (B) -6 (C) 10 (D) -2  

**Analysis**:  
- **Unsigned**: \(2^3 + 2^1 = 10\) ✔️ (C)  
- **Sign & Magnitude**: \(-2^1 = -2\) ✔️ (D)  
- **Biased (Bias=7)**: \(10 - 7 = 3\) → Not an option.  
- **Two’s Complement**: \(-6\) ✔️ (B)  
- **One’s Complement**: \(-5\) → Not an option.  

**Answer**: (A) -4 ❌  

---

## 🛑 Common Pointer Bugs  
- **Uninitialized Pointers**:  
  ```c
  int *p;     // p points to garbage!
  *p = 5;     // Crash/undefined behavior
  ```  
- **Memory Leaks**: Forgetting to `free()` after `malloc()`.  

---

## 📖 Key Takeaways  
- C offers low-level control but requires careful memory management.  
- Pointers = powerful but error-prone. Always initialize!  
- Structs/unions organize data; padding affects memory layout.  

🔗 **Resources**:  
- K&R Book ("The C Programming Language")  
- [C99 Standard](http://en.wikipedia.org/wiki/C99)  


