# Lecture 5: Performance Optimization Part 1 - Work Distribution and Scheduling  
**CMU 15-418/618, Fall 2018**  

---

## Key Goals of Parallel Program Optimization 🎯  
1. **Balance workload** across execution resources.  
2. **Reduce communication** to avoid stalls.  
3. **Minimize overhead** from parallelism management.  

**TIP #1**: Always start with the simplest solution, then measure performance.  
> *"My solution scales" = Your code scales as needed for your target hardware.*  

---

## Balancing the Workload ⚖️  
**Ideal Scenario**: All processors compute simultaneously and finish at the same time.  

### Amdahl’s Law Impact  
- **Example**: If P4 does 20% more work → P4 takes 20% longer → 20% of runtime becomes serial execution.  
  - Serialized section (S) = 5% of total work → Limits maximum speedup.  

![](https://wy-static.wenxiaobai.com/chat-doc/e70f358a0a1014f049331520a37ab5cb-image.png)  

---

## Static Assignment 🔧  
**Definition**: Pre-determine work-to-thread mapping (may depend on runtime parameters).  

### Example: Grid Solver  
- Assign equal grid cells to each thread.  
- **Strategies**:  
  - **Blocked**: Contiguous chunks.  
  - **Interleaved**: Cyclic distribution.  

![](https://wy-static.wenxiaobai.com/chat-doc/26461c186285396fb237d4eec0e6f6c8-image.png)  

### When to Use Static Assignment?  
1. **Predictable work cost** (e.g., uniform task durations).  
2. **Known statistics** (e.g., average execution time).  

**Example**: 12 tasks with equal cost → Assign 3 tasks to each of 4 processors.  

![](https://wy-static.wenxiaobai.com/chat-doc/7839bd6877b039762e69a22a2ad59c04-image.png)  

---

## Semi-Static Assignment 🔄  
- **Periodic profiling** to adjust assignments.  
- **Example**: Particle simulation redistributes particles as they move slowly.  

![](https://wy-static.wenxiaobai.com/chat-doc/41ff8bbab4cc654edbce5d0c63b10453-image.png)  

---

## Dynamic Assignment 🚀  
**Use Case**: Unpredictable task execution time/number.  

### Shared Counter Example (Prime Testing)  
```cpp
int N = 1024;
int* x = new int[N];
bool* is_prime = new bool[N];
LOCK counter_lock;
int counter = 0;

while (1) {
    int i;
    lock(counter_lock);
    i = counter++;
    unlock(counter_lock);
    if (i >= N) break;
    is_prime[i] = test_primality(x[i]);
}
```
**Problem**: High synchronization overhead due to frequent lock contention.  

---

### Task Granularity Adjustment 🧩  
**Coarse Granularity**: Reduce synchronization by grouping tasks.  
```cpp
const int GRANULARITY = 10;
...
counter += GRANULARITY;
for (int j = i; j < end; j++) {
    is_prime[j] = test_primality(x[j]);
}
```
![](https://wy-static.wenxiaobai.com/chat-doc/31d8ffcab31d7243406eb1967e7db038-image.png)  

**Trade-off**:  
- Small tasks → Better load balance.  
- Large tasks → Lower overhead.  

---

## Smarter Task Scheduling 🧠  
### Problem: Load Imbalance  
![](https://wy-static.wenxiaobai.com/chat-doc/f83aa244f636d6bc65c54c867dfb6996-image.png)  

**Solutions**:  
1. **Split long tasks** into smaller subtasks.  
2. **Schedule long tasks first** to minimize "slop".  

![](https://wy-static.wenxiaobai.com/chat-doc/9f679bd90a0a65e2e7f5281d6d72e7e8-image.png)  

---

## Distributed Work Queues 🗃️  
**Design**:  
- Each thread has its own work queue.  
- **Work stealing** when local queue is empty.  

![](https://wy-static.wenxiaobai.com/chat-doc/0bfd9da26fb7d6ed368ecd363b4e9b8c-image.png)  

**Advantages**:  
- Reduced synchronization.  
- Improved locality (producer-consumer pattern).  

---

## Fork-Join Parallelism with Cilk Plus 🛠️  
### Key Constructs:  
- `cilk_spawn`: Fork a task.  
- `cilk_sync`: Join all spawned tasks.  

**Example**: Parallel QuickSort  
```cpp
void quick_sort(int* begin, int* end) {
    if (begin >= end - PARALLEL_CUTOFF) std::sort(begin, end);
    else {
        int* middle = partition(begin, end);
        cilk_spawn quick_sort(begin, middle);
        quick_sort(middle + 1, end);
    }
}
```
![](https://wy-static.wenxiaobai.com/chat-doc/8885883f8993f74824ac85047dc5521d-image.png)  

---

### Work Stealing Scheduler 🕵️  
- **Continuation Stealing**: Run child task first, leave continuation for stealing.  
- **Greedy Policy**: Idle threads steal work immediately.  

**Example**: Loop with `cilk_spawn`  
```cpp
for (int i = 0; i < N; i++) {
    cilk_spawn foo(i);
}
cilk_sync;
```
![](https://wy-static.wenxiaobai.com/chat-doc/67a8c1c00d8e46650428de9444e9310b-image.png)  

---

## Summary 📝  
1. **Load Balance**: Critical for maximizing resource utilization.  
2. **Assignment Strategies**:  
   - Static: Predictable workloads.  
   - Dynamic: Unpredictable workloads (use work queues).  
3. **Fork-Join**: Natural for divide-and-conquer (Cilk Plus uses work stealing).  
4. **Granularity**: Balance task size to minimize overhead and ensure parallelism.  

**Key Insight**: Use workload knowledge to choose the right strategy! 🚀  