# 📚 Machine-Level Programming IV: Data  
**15-213/15-513: Introduction to Computer Systems**  
*6th Lecture, Sept 12, 2024*  

---

## 🧮 Arrays  

### One-Dimensional Arrays  
- **Declaration**: `T name[Length];`  
  - Contiguously allocated region of `Length * sizeof(T)` bytes.  
- **Access**:  
  - Identifier `name` acts as a pointer to element 0.  
  - Example: `val` translates to `*(val + 4)`.  

![](https://wy-static.wenxiaobai.com/chat-doc/ae7abc020300a34e7a9b9faea606e6ce-image.png)  

#### Example: Array Allocation  
```c
#define ZLEN 5
typedef int zip_dig[ZLEN];
zip_dig cmu = {1, 5, 2, 1, 3};
```
- Memory layout (20-byte block):  
  ![](https://wy-static.wenxiaobai.com/chat-doc/15eaeba3bee3ae03cc7cde0678d5f9b5-image.png)  

---

### Multi-Dimensional (Nested) Arrays  
- **Declaration**: `T A[R][C];`  
  - **Row-Major Order**: Elements stored row-wise.  
  - **Row Access**: `A[i]` starts at `A + i * (C * sizeof(T))`.  
  - **Element Access**: `A[i][j]` address = `A + (i * C + j) * sizeof(T)`.  

#### Example: 2D Array  
```c
int pgh = {
  {1,5,2,0,6}, {1,5,2,1,3}, 
  {1,5,2,1,7}, {1,5,2,2,1}
};
```
- Memory layout:  
  ![](https://wy-static.wenxiaobai.com/chat-doc/1cb077f0cca3deee205bdaeb5f94b617-image.png)  

#### Assembly for Element Access  
```assembly
# Access pgh[index][dig]
leaq (%rdi, %rdi, 4), %rax   # 5 * index
addl %rax, %rsi              # 5*index + dig
movl pgh(, %rsi, 4), %eax    # Mem[pgh + 4*(5*index + dig)]
```

---

### Multi-Level Arrays  
- **Declaration**: Array of pointers to arrays.  
```c
int* univ = {mit, cmu, ucb};
```
- Memory layout:  
  ![](https://wy-static.wenxiaobai.com/chat-doc/fdb1fce19040b04a82867a68652e0b0c-image.png)  

#### Element Access  
- Requires **two memory reads**:  
  ```assembly
  salq $2, %rsi              # 4 * digit
  addq univ(,%rdi,8), %rsi   # p = univ[index] + 4*digit
  movl (%rsi), %eax          # return *p
  ```

---

## 🏗️ Structures  

### Memory Allocation & Alignment  
- **Alignment Rules**:  
  - Primitive type of size *B* must have address multiple of *B*.  
  - Example:  
    ```c
    struct S1 { char c; int i; double v; };
    ```
    ![](https://wy-static.wenxiaobai.com/chat-doc/dc5971202e8aebf57d809837b85000dc-image.png)  

#### Structure Padding Example  
```c
struct S2 { double v; int i; char c; } a;
```
- Memory layout (each element padded to 24 bytes):  
  ![](https://wy-static.wenxiaobai.com/chat-doc/bf4e82ad3d8db4a014b163f18625ddf1-image.png)  

---

### Linked List Example  
```c
long length(struct rec *r) {
  long len = 0L;
  while (r) { len++; r = r->next; }
  return len;
}
```
- **Assembly**:  
  ```assembly
  .L11:
    addq $1, %rax        # len++
    movq 24(%rdi), %rdi  # r = Mem[r + 24]
    testq %rdi, %rdi
    jne .L11
  ```

---

## 🎯 Floating Point  

### Basics  
- **Registers**: XMM registers (`%xmm0`, `%xmm1`, ...) for FP arguments/results.  
- **Operations**:  
  ```assembly
  addss %xmm1, %xmm0   # Single-precision add
  addsd %xmm1, %xmm0   # Double-precision add
  ```

#### Example: FP Function  
```c
double dincr(double *p, double v) {
  double x = *p;
  *p = x + v;
  return x;
}
```
- **Assembly**:  
  ```assembly
  movapd %xmm0, %xmm1   # Copy v
  movsd (%rdi), %xmm0   # x = *p
  addsd %xmm0, %xmm1    # t = x + v
  movsd %xmm1, (%rdi)   # *p = t
  ```

---

## 📝 Quiz & Examples  

### Understanding Pointers & Arrays #1  
| Decl          | Comp | Bad | Size | *A1/*A2 Comp | Bad | Size |  
|---------------|------|-----|------|--------------|-----|------|  
| `int A1`   | Y    | N   | 12   | Y            | N   | 4    |  
| `int *A2`     | Y    | N   | 8    | Y            | Y   | 4    |  

![](https://wy-static.wenxiaobai.com/chat-doc/2d0a4c073a1321dc22ebbebf89710da7-image.png)  

### Array Access Example  
```c
int result = pgh + linear_zip + *(linear_zip + 8) + zip2;
// Result: 9
```

---

## 🔍 Summary  
- **Arrays**: Contiguous memory, index arithmetic for access.  
- **Structures**: Compiler-managed padding for alignment.  
- **Floating Point**: XMM registers and SIMD operations.  

⚠️ **Key Reminder**: Always consider alignment and pointer arithmetic nuances in low-level code!  
