## Instructor: Jenny Song 👩🏫

## Table of Contents 📚
1. **Review of C Memory Layout**
2. **Floating Point Representation**
3. **IEEE 754 Standard**
4. **Special Cases & Limitations**
5. **Examples & Practice**

---

## Review: C Memory Layout 🧠

```c
+------------------+
|       Stack      | 👉 Local variables (LIFO)
+------------------+
|    Static Data   | 👉 Global variables & string literals
+------------------+
|       Code       | 👉 Machine code copy
+------------------+
|       Heap       | 👉 Dynamic storage (malloc/free)
+------------------+
```

- **Memory Bugs** often arise from stack/heap collisions (OS prevents via virtual memory).

---

## Floating Point Representation 🌌

### Key Ideas:
- **Scientific Notation**: Normalized form ensures one non-zero digit left of the decimal point.
  - Example: `1.0 × 10⁻⁹` (normalized) vs. `0.1 × 10⁻⁸` (not normalized).
- **Binary Scientific Notation**:
  ```math
  1.0101_{two} \times 2^4 = 10110_{two} = 22_{ten}
  ```

### 6-Bit Fixed Binary Point Example:
- Representation: `XX.XXXX` (e.g., `10.1010_{two} = 2.625_{ten}`).
- **Range**: `0` to `3.9375` (smallest difference = `2⁻⁴ = 1/16`).

---

## IEEE 754 Floating Point Standard 🏛️

### Single Precision (32 bits):
```math
(-1)^S \times (1.\text{Significand}) \times 2^{\text{(Exponent - 127)}}
```

| Bit 31 | Bits 30-23 (Exponent) | Bits 22-0 (Significand) |
|--------|------------------------|-------------------------|
| S (1)  | 8 bits (Biased)        | 23 bits (Fraction)      |

- **Exponent Bias**: `127` (actual exponent = `Exponent field - 127`).
- **Implicit Leading 1**: Significand assumes `1.xxx...`, e.g., `1.1010...`.

### Double Precision (64 bits):
- Larger significand (52 bits) and exponent bias `1023`.

---

## Special Cases & Limitations ⚠️

### Encodings Summary:
| Exponent | Significand | Meaning          | Example (Hex)                |
|----------|-------------|------------------|------------------------------|
| 0        | 0           | ±0               | `0x00000000` (＋0)           |
| 0        | ≠0          | Denormalized     | Gradual underflow            |
| 1-254    | Any         | Normalized Float | `0x40400000` = `3.0`         |
| 255      | 0           | ±∞               | `0x7F800000` (＋∞)           |
| 255      | ≠0          | NaN              | Result of `0/0` or `√(-1)`   |

### Key Notes:
- **Two Zeros**: `+0` and `-0` (same value, different sign bits).
- **Infinity**: Result of overflow (e.g., division by zero).
- **NaN**: "Not a Number" for undefined operations.

---

## Examples & Practice 💡

### Example 1: Convert to Single-Precision
**Value**: `-3.75`
1. **Sign**: `S = 1` (negative).
2. **Binary Fraction**: `3.75 = 11.11_{two} = 1.111_{two} × 2^1`.
3. **Exponent**: `1 + 127 = 128` → `10000000_{two}`.
4. **Significand**: `111000...0` (23 bits).

**Encoding**:
```
1 10000000 11100000000000000000000
```

### Example 2: Decode Single-Precision
**Hex**: `0xC0A00000`
1. **Binary**: `1 10000001 01000000000000000000000`.
2. **Sign**: Negative (`S=1`).
3. **Exponent**: `129 - 127 = 2`.
4. **Significand**: `1.010000... = 1.25_{ten}`.
5. **Value**: `-1.25 × 2^2 = -5.0`.

---

## Practice Problems 📝

1. **Convert `12.375` to IEEE 754 single-precision.**
   - **Answer**: `0x41460000`.

2. **Decode `0x3F800000`**.
   - **Answer**: `1.0` (S=0, Exponent=127, Significand=1.0).

---

## Key Takeaways 🚀
- Floating point trades **precision** for **range**.
- IEEE 754 ensures consistency across systems.
- Special values (`±0`, `±∞`, `NaN`) handle edge cases gracefully.

