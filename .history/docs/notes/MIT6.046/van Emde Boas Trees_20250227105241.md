
## Lower Bound [Patrascu & Thorup 2007]
Even for static queries (no Insert/Delete)
- `$ \Omega(\log \log u) $` time per query for `$ u = n^{(\log n)^{O(1)}} $`
- `$ O(n \cdot $poly$(\log n)) $` space

## Space Improvements
We can improve from `$ \Theta(u) $` to `$ O(n \log \log u) $`.
- Only create nonempty clusters
- If V.min becomes None, deallocate V
- Store V.cluster as a hashtable of nonempty clusters
- Each insert may create a new structure `$ \Theta(\log \log u) $` times (each empty insert) - Can actually happen [Vladimir Čunát]
- Charge pointer to structure (and associated hash table entry) to the structure This gives us `$ O(n \log \log u) $` space (but randomized).

## Indirection
We can further reduce to `$ O(n) $` space.
- Store vEB structure with `$ n = O(\log \log u) $` using BST or even an array `$ \implies O(\log \log n) $` time once in base case
- We use `$ O\left(\frac{n}{\log \log u}\right) $` such structures (disjoint)

\[
\implies O\left(\frac{n}{\log \log u} \cdot \log \log u\right) = O(n) $space for small$
$

- Larger structures "store" pointers to them

$
O\left(\frac{n}{\log \log u} \cdot \log \log u\right) = O(n) $space for large$
$

- Details: Split/Merge small structures

---

6.046J/18.410J Design and Analysis of Algorithms Spring 2015

For information about citing these materials or our Terms of Use, visit: http://ocw.mit.edu/terms.