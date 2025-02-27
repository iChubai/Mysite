## 🕰️ **Historical Context of Parallel Computing**  
### ■ **1970s–2000s: Supercomputers & Databases**  
- **C.mmp at CMU (1971)**: 16 PDP-11 processors.  
  ![](https://wy-static.wenxiaobai.com/chat-doc/18abbf2373e9f20d453a6895f7b2dd40-image.png)  
- **Cray XMP (1984)**: 4 vector processors.  
  ![](https://wy-static.wenxiaobai.com/chat-doc/74d4e6469bdcaf62d33bdb6d9dba9dba-image.png)  
- **Sun Enterprise 10000 (1997)**: 16 UltraSPARC-II processors.  
  ![](https://wy-static.wenxiaobai.com/chat-doc/fbc32ad7a5a9cf5d188fd83823a4ad6d-image.png)  

### ■ **Inflection Point (2004)**  
- **Power Density Wall**: Intel abandons frequency scaling, shifts to multi-core CPUs.  
  ![](https://wy-static.wenxiaobai.com/chat-doc/1349a9accc08efefaff662c62f774410-image.png)  

---

## 💡 **Key Concepts**  
### ■ **Speedup Formula**  
$$\text{Speedup}(P) = \frac{\text{Execution Time (1 processor)}}{\text{Execution Time (P processors)}}$$  

**Demo Observations**:  
1. **Demo 1**: Communication limits speedup.  
2. **Demo 2**: Work imbalance reduces efficiency.  
3. **Demo 3**: Communication dominates computation.  

---

## 🖥️ **Modern Parallel Hardware**  
### ■ **Apple Products**  
- **Mac Pro**: 12-core Intel Xeon E5.  
  ![](https://wy-static.wenxiaobai.com/chat-doc/58e346b095db957e744263f71cd386c3-image.png)  
- **iPad Retina**: 2 Swift cores.  
  ![](https://wy-static.wenxiaobai.com/chat-doc/07e9655c62a5c4f498bf3919574734c2-image.png)  

### ■ **Supercomputers**  
- **Titan (#2 Supercomputer)**: 18,688 AMD CPUs + 18,688 NVIDIA GPUs.  
  ![](https://wy-static.wenxiaobai.com/chat-doc/348bb25872253a55633bac924d9c0e62-image.png)  

---

## 🧩 **Course Themes**  
1. **Scaling Parallel Programs**:  
   - Decomposition, work assignment, communication.  
2. **Hardware Efficiency**:  
   - Performance vs. cost vs. power.  
3. **Post-2004 Shift**:  
   - Maximize **performance per Watt** instead of raw speed.  

---

## 🚨 **Key Takeaways**  
- **Single-thread performance growth is stagnant** → Parallelism is essential.  
- **Writing parallel code is challenging** but unlocks immense computational power.  
- **Efficiency matters**: 2x speedup on 1010 processors is *not* impressive.  

📢 **Welcome to 15-418!**  