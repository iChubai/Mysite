# 🧠 C Memory Management & Usage - Comprehensive Notes

## 📚 Table of Contents
1. [C Memory Layout](#-c-memory-layout)
2. [Addressing & Endianness](#-addressing--endianness)
3. [Dynamic Memory Allocation](#-dynamic-memory-allocation)
4. [Common Memory Problems](#-common-memory-problems)
5. [Linked List Example](#-linked-list-example)
6. [Memory Fragmentation & K&R Algorithm](#-memory-fragmentation--kr-algorithm)
7. [Debugging Tools](#-debugging-tools)

---

## 🗺️ C Memory Layout

### Program Address Space
- **4 Regions**:
  1. **Stack** 📥  
     - Stores local variables (declared inside functions).  
     - Grows **downward**.  
     - Freed when function returns.  
     - Example: `int x = 5;` inside `main()`.
  
  2. **Heap** 🧱  
     - Dynamically allocated via `malloc()`, `calloc()`, `realloc()`.  
     - Grows **upward**.  
     - Must be explicitly freed with `free()`.  
     - Example: `int *arr = malloc(10 * sizeof(int));`.
  
  3. **Static Data** 🌐  
     - Stores global/static variables and string literals.  
     - Does **not** grow/shrink.  
     - Example: `char *str = "hello";` (string literal in static data).  
     - ⚠️ `char str[] = "hello";` stores the array on the **stack**!
  
  4. **Code** 📜  
     - Contains compiled machine code.  
     - Read-only and immutable.


---

## 🔢 Addressing & Endianness

### Key Concepts
- **Byte-Addressed Machines**: Each address points to a unique byte.  
- **Word-Addressed Machines**: Each address points to a word (group of bytes).  
- **Endianness**: Order of bytes in multi-byte data types.  

### Types of Endianness
1. **Big Endian** 🐘  
   - Most significant byte at **lowest** address.  
   - Example: `0x12345678` stored as `12 34 56 78`.  
2. **Little Endian** 🐭  
   - Least significant byte at **lowest** address.  
   - Example: `0x12345678` stored as `78 56 34 12`.  

![](https://wy-static.wenxiaobai.com/chat-doc/4483e0a6f60849172fb76f01a974815f-image.png)

### Example: Integer `28` (0x0000001C)
- **Big Endian**: `00 00 00 1C`  
- **Little Endian**: `1C 00 00 00`  

---

## 💥 Dynamic Memory Allocation

### Functions
1. **`malloc(n)`**  
   - Allocates `n` bytes of **uninitialized** memory.  
   - Example:  
     ```c
     int *arr = (int*)malloc(5 * sizeof(int)); // Allocate space for 5 integers
     ```
2. **`calloc(n, size)`**  
   - Allocates `n * size` bytes initialized to **zero**.  
   - Example:  
     ```c
     int *arr = (int*)calloc(5, sizeof(int)); // [0, 0, 0, 0, 0]
     ```
3. **`realloc(ptr, new_size)`**  
   - Resizes existing memory block.  
   - May move the block to a new address.  
   - Example:  
     ```c
     arr = realloc(arr, 10 * sizeof(int)); // Expand to 10 integers
     ```
4. **`free(ptr)`**  
   - Releases memory.  
   - ⚠️ Never free:  
     - Stack variables.  
     - Already freed memory.  
     - Middle of a block (e.g., `free(arr + 1)`).

---

## 🚨 Common Memory Problems

### 1. Using Uninitialized Values
```c
int *p;
printf("%d", *p); // Undefined behavior! p points to garbage.
```

### 2. Using Memory You Don’t Own
- **Example 1**: Returning a stack-allocated array.  
  ```c
  char* func() {
      char arr;
      return arr; // ❌ arr is on the stack; invalid after function returns.
  }
  ```
- **Example 2**: Buffer overflow.  
  ```c
  char buf;
  strcpy(buf, "This is too long!"); // Writes beyond buf
  ```

### 3. Freeing Invalid Memory
- **Double Free**:  
  ```c
  int *p = malloc(4);
  free(p);
  free(p); // ❌ p already freed.
  ```
- **Freeing Stack Variable**:  
  ```c
  int x = 5;
  free(&x); // ❌ x is on the stack.
  ```

### 4. Memory Leaks
- **Example**: Overwriting a pointer before freeing.  
  ```c
  int *p = malloc(4);
  p = malloc(8); // ❌ Original 4 bytes are now unreachable.
  ```

---

## 🔗 Linked List Example

### Node Structure
```c
struct Node {
    char *value;
    struct Node *next;
};
```

### Adding a Node
```c
struct Node* addNode(char *s, struct Node *list) {
    struct Node *newNode = (struct Node*)malloc(sizeof(struct Node));
    newNode->value = (char*)malloc(strlen(s) + 1); // +1 for '\0'
    strcpy(newNode->value, s);
    newNode->next = list;
    return newNode;
}
```

### Freeing a Node
```c
void freeList(struct Node *list) {
    while (list != NULL) {
        struct Node *temp = list;
        list = list->next;
        free(temp->value); // Free the string
        free(temp);        // Free the node
    }
}
```

### Visualization
![](https://wy-static.wenxiaobai.com/chat-doc/608d573b74e60552237aaffda5e0b667-image.png)

---

## 🧩 Memory Fragmentation & K&R Algorithm

### Fragmentation Example
![](https://wy-static.wenxiaobai.com/chat-doc/1eeffb50d11263f205ce287093987561-image.png)

### K&R Allocation Strategy
- **Free List**: Linked list of free memory blocks.  
- **Merging Adjacent Blocks**: `free()` combines adjacent free blocks.  
- **Allocation Policies**:  
  - **First Fit**: Use the first block that fits.  
  - **Best Fit**: Use the smallest block that fits.  
  - **Next Fit**: Resume search from last position.

---

## 🛠️ Debugging Tools
- **Valgrind** 🧪: Detects memory leaks, invalid accesses, and more.  
  ```bash
  valgrind --leak-check=full ./your_program
  ```
- **Example Output**:  
  ```
  ==12345== Invalid write of size 4
  ==12345==    at 0x400ABC: main (example.c:10)
  ```

---

## 📌 Summary
- **Stack**: Local variables, LIFO.  
- **Heap**: Dynamic, manually managed.  
- **Static Data**: Globals & literals.  
- **Code**: Immutable.  
- **Common Pitfalls**: Leaks, invalid accesses, uninitialized values.  
- **Golden Rule**: Always pair `malloc()` with `free()`! 🛑

![](https://wy-static.wenxiaobai.com/chat-doc/681b67124d525fb68d071ce92b077373-image.png)
