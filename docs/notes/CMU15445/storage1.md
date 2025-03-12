# Lecture #03: Database Storage (Part I)  
**15-445/645 Database Systems (Spring 2025)**  
**Carnegie Mellon University**  
**Prof. Jignesh Patel**  

---

## 1. Storage Hierarchy  
### Key Concepts:  
- **Disk-Oriented DBMS**: Primary storage is non-volatile disk.  
- **Volatile vs. Non-Volatile Devices**:  
  - **Volatile (Memory)**:  
    - 🚨 Data lost on power loss (e.g., DRAM).  
    - Byte-addressable, fast random access.  
  - **Non-Volatile (Disk)**:  
    - 💾 Data retained on power loss (e.g., HDD, SSD).  
    - Block/page addressable (e.g., read 4KB pages).  
    - Optimized for sequential access.  

### Latency Comparison (Humanized Scale):  
- **If L1 Cache = 1 second**:  
  - SSD read ≈ **4.4 hours**  
  - HDD read ≈ **3.3 weeks**  

![](https://wy-static.wenxiaobai.com/chat-doc/1ca20cba218a00936bd093c870ebce68-image.png)  

---

## 2. Disk-Oriented DBMS Architecture  
### Components:  
1. **Buffer Pool**: Manages data movement between disk and memory.  
2. **Execution Engine**: Executes queries by requesting pages from the buffer pool.  

![](https://wy-static.wenxiaobai.com/chat-doc/3961fca2ec6495d3774c39bf1ad5e0c6-image.png)  

### Key Design Goals:  
- Handle databases larger than memory.  
- Minimize disk stalls (optimize sequential access).  

---

## 3. DBMS vs. OS  
### Why DBMS Avoids OS Virtual Memory (mmap):  
- 🚫 **Page Faults Block Execution**: DBMS loses control over I/O scheduling.  
- **Better Alternatives**:  
  - `madvise()`: Hint OS about future page accesses.  
  - `mlock()`: Prevent OS from swapping pages.  
  - `msync()`: Force flush pages to disk.  

**Lesson**: *"The OS is not your friend."*  

---

## 4. File Storage  
### Basics:  
- DBMS stores databases as files (single or multiple).  
- **Storage Manager**:  
  - Manages files as a collection of **pages**.  
  - Tracks free space, read/write status, and page types.  

### Example: SQLite  
- Uses a **single file** for simplicity.  

![](https://wy-static.wenxiaobai.com/chat-doc/79ed283369712d0930cf38b5da7adb33-image.png)  

---

## 5. Database Pages  
### Types of Pages:  
1. **Hardware Page**: 4KB (atomic write guarantee).  
2. **OS Page**: 4KB (or 2MB/1GB for x64).  
3. **Database Page**: 1KB–32KB (configurable).  

### Page ID Management:  
- Unique **page ID** per page.  
- Indirection layer maps IDs to file paths/offsets.  

**Default Page Sizes**:  
- PostgreSQL: 8KB  
- MySQL: 16KB  
- SQLite: 4KB  

![](https://wy-static.wenxiaobai.com/chat-doc/8e68aea10fc1e177f265ae028470fa3b-image.png)  

---

## 6. Heap File Organization  
### Definition:  
- Unordered collection of pages (tuples stored randomly).  

### Page Tracking Methods:  
1. **Linked List**:  
   - Header page tracks free/data pages.  
   - Sequential scan required for page lookup.  
2. **Page Directory**:  
   - Special directory pages track data page locations and metadata.  

![](https://wy-static.wenxiaobai.com/chat-doc/a935b39b15c6fc0f29b28e626b7da7d4-image.png)  

---

## 7. Page Layout  
### Slotted Pages (Most Common):  
- **Structure**:  
  - Header tracks slot count and free space offset.  
  - **Slot Array** maps slots to tuple offsets.  
  - Tuples grow from the end backward; slots grow forward.  

![](https://wy-static.wenxiaobai.com/chat-doc/e697470abff3888a92e51e540930a299-image.png)  

**Example**:  
- Adding a new tuple:  
  1. Allocate slot in the slot array.  
  2. Write tuple data from the end of the page.  
- Deleting a tuple:  
  - Mark slot as unused; free space can be reused.  

---

## 8. Tuple Layout  
### Components:  
1. **Header**:  
   - Visibility info (concurrency control).  
   - NULL bitmap.  
2. **Data**: Attributes stored in schema order.  

**Example**:  
```plaintext
| Header (Visibility, NULL bits) | a (INT) | b (DOUBLE) | c (VARCHAR) | ...
```

### Denormalized Tuples:  
- **Pre-join**: Store related tuples (e.g., joined tables) in the same page.  
- **Pros**: Fewer I/O operations for common queries.  
- **Cons**: Updates become more complex.  
---

## Key Takeaways  
- **Disk vs. Memory**: Optimize for sequential access to minimize latency.  
- **Page Management**: Slotted pages dominate for flexibility.  
- **DBMS Control**: Avoid OS interference for performance and correctness.  

**Next Lecture**: Log-Structured Storage, Index-Organized Storage, and Catalogs 📚  
