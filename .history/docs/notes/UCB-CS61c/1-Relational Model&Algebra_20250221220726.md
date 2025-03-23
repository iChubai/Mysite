
# elational Model&Algebra

## ++ Requirement
All the projects are in C++.  
- If you are new to C++, you must pick it up quickly.  
- If you can take and get all the questions on the following quizzes right, you are all set:  
  - Scoping: [https://www.learncpp.com/cpp-tutorial/chapter-7-summary-and-quiz/](https://www.learncpp.com/cpp-tutorial/chapter-7-summary-and-quiz/)  
  - Type Conversion: [https://www.learncpp.com/cpp-tutorial/chapter-10-summary-and-quiz/](https://www.learncpp.com/cpp-tutorial/chapter-10-summary-and-quiz/)  
  - lvalues/rvalues: [https://www.learncpp.com/cpp-tutorial/chapter-12-summary-and-quiz/](https://www.learncpp.com/cpp-tutorial/chapter-12-summary-and-quiz/)  
  - Stack and heap: [https://www.learncpp.com/cpp-tutorial/chapter-20-summary-and-quiz/](https://www.learncpp.com/cpp-tutorial/chapter-20-summary-and-quiz/)  
  - Move Semantics: [https://www.learncpp.com/cpp-tutorial/chapter-22-summary-and-quiz/](https://www.learncpp.com/cpp-tutorial/chapter-22-summary-and-quiz/)  
  - Templates: [https://www.learncpp.com/cpp-tutorial/chapter-26-summary-and-quiz/](https://www.learncpp.com/cpp-tutorial/chapter-26-summary-and-quiz/)  

Additional resource:  
[https://db.in.tum.de/teaching/ss23/c++praktikum/slides/lecture-10.2.pdf?lang=en](https://db.in.tum.de/teaching/ss23/c++praktikum/slides/lecture-10.2.pdf?lang=en)

**C++ Bootcamp**: This Friday Jan. 17th from 3pm-4pm in GHC 4303.

---

### Project 0 (P0): Goals
→ Get you started on C++, so you are not surprised later.  
→ Get you thinking about algorithms and concurrency.  
→ P0 is about building a **Skip List** data structure.  
→ We will discuss Skip List in more detail later in the class.  
→ **P0 is published; due on Jan 26 @ 11:59pm.**  
**No late days allowed for P0.**  

**If you can't score 100% on P0, you can't stay in this class, even if you are currently enrolled.**

---

### OFFICE HOURS
- Instructors and TAs will hold office hours on weekdays (Mon-Fri) at different times.  
- We will also hold a **TA power session** on the Saturday before each project is due.  
- **There will not be any office hours on Sundays.**

---

### PROJECT LATE POLICY
- You will lose **10%** of the points for a project or homework for every **24 hours** it is late.  
- You have a total of **four late days** to be used for projects only.  
- We will grant no-penalty extensions due to extreme circumstances (e.g., medical emergencies).  
  → If something comes up, please contact the instructors as soon as possible.  

![](https://wy-static.wenxiaobai.com/chat-doc/1d46c29cc15122c12dad00ab0e4caa48-image.png)

---

### PLAGIARISM WARNING
![](https://wy-static.wenxiaobai.com/chat-doc/c51a375f315d922918367431fbb98912-image.png)  
- The homework and projects must be your own original work. They are **not group assignments**.  
- You may not copy source code from other people or the web.  
- **Plagiarism is not tolerated.** You will get lit up. → Please ask instructors (not TAs!) if you are unsure.  
- See CMU's [Policy on Academic Integrity](https://www.cmu.edu/policies/) for additional information.

---

### TODAY'S AGENDA
1. Database Systems Background  
2. Relational Model  
3. Relational Algebra  
4. Alternative Data Models  
5. Q&A Session  

---

### DATABASE
- **Organized collection** of inter-related data that models some aspect of the real-world.  
- Databases are the core component of most computer applications.

---

### DATABASE EXAMPLE
Create a database that models a digital music store to keep track of artists and albums.  
**Information we need to keep track of**:  
→ Information about Artists  
→ The Albums those Artists released  

---

### FLAT FILE STRAWMAN
Store our database as comma-separated value (CSV) files managed in application code.  
→ Use a separate file per entity.  
→ The application must parse the files each time they want to read/update records.  

**Artist (name, year, country)**  
```
"Wu-Tang Clan",1992,"USA"
"Notorious BIG",1992,"USA"
"GZA",1990,"USA"
```

**Album (name, artist, year)**  
```
"Enter the Wu-Tang","Wu-Tang Clan",1993
"St.Ides Mix Tape","Wu-Tang Clan",1994
"Liquid Swords","GZA",1990
```

---

### FLAT FILE STRAWMAN: Example
**Goal**: Get the year that GZA went solo.  
**Artist (name, year, country)**  
```
"Wu-Tang Clan",1992,"USA"
"Notorious BIG",1992,"USA"
"GZA",1990,"USA"
```

**Code**:
```python
for line in file.readlines():
    record = parse(line)
    if record == "GZA":
        print(int(record))
```

---

### FLAT FILES: DATA INTEGRITY
- How do we ensure that the artist is the same for each album entry?  
- What if somebody overwrites the album year with an invalid string?  
- What if there are multiple artists on an album?  
- What happens if we delete an artist that has albums?  

---

### FLAT FILES: IMPLEMENTATION
- How do you find a particular record?  
- What if we want to create a new application that uses the same database?  
- What if two threads try to write to the same file at the same time?  

---

### FLAT FILES: DURABILITY
- What if the machine crashes while our program is updating a record?  
- What if we want to replicate the database on multiple machines for high availability?  

---

### DATABASE MANAGEMENT SYSTEM (DBMS)
- A DBMS is software that allows applications to store and analyze information in a database.  
- A general-purpose DBMS supports the definition, creation, querying, update, and administration of databases in accordance with some data model.  

---

### DATA MODELS
- **Data model**: A collection of concepts for describing the data in a database.  
- **Schema**: A description of a particular collection of data, using a given data model.  
  → This defines the structure of data for a data model.  
  → Otherwise, you have random bits with no meaning.  

---

### EARLY DBMSs
- Early database applications (1960s) were difficult to build and maintain.  
  → Examples: IDS, IMS, CODASYL  
  → Tight coupling between logical and physical layers.  
  → Programmers had to know queries in advance.  

**Ted Codd** (IBM Research) devised the relational model in 1969 to address these issues.  

---

### RELATIONAL MODEL
- **Key tenets**:  
  → Store database in simple data structures (relations).  
  → Physical storage left up to the DBMS implementation.  
  → Access data through high-level language; DBMS figures out execution strategy.  

**Components**:  
1. **Structure**: Definition of relations and their contents.  
2. **Integrity**: Ensure database contents satisfy constraints.  
3. **Manipulation**: Programming interface for accessing/modifying data.  

---

### DATA INDEPENDENCE
- **Goal**: Isolate user/application from low-level data representation.  
  → User focuses on high-level logic.  
  → DBMS optimizes layout based on environment, data, and workload.  
  → DBMS can re-optimize as factors change.  

![](https://wy-static.wenxiaobai.com/chat-doc/9f08c61cc42c4f4e12eb1a9179237a37-image.png)

---

### RELATIONAL MODEL: PRIMARY KEYS
- A **primary key** uniquely identifies a single tuple.  
- DBMS can auto-generate keys via:  
  - `IDENTITY` (SQL Standard)  
  - `SEQUENCE` (PostgreSQL/Oracle)  
  - `AUTO_INCREMENT` (MySQL)  

**Example**:  
| id  | name           | year | country |
|-----|----------------|------|---------|
| 101 | Wu-Tang Clan   | 1992 | USA     |
| 102 | Notorious BIG  | 1992 | USA     |
| 103 | GZA            | 1990 | USA     |

---

### RELATIONAL ALGEBRA
- Fundamental operations to retrieve and manipulate tuples.  
- **Operators**:  
  - **σ (Select)**  
  - **π (Projection)**  
  - **∪ (Union)**  
  - **∩ (Intersection)**  
  - **− (Difference)**  
  - **× (Product)**  
  - **⨝ (Join)**  

**Example**:  
```sql
σ_{a_id='a2' ∧ b_id>102}(R)  -- Select tuples where a_id='a2' and b_id>102
```

---

### DOCUMENT DATA MODEL
- A collection of documents containing hierarchical field/value pairs.  
- Modern implementations use JSON.  

**Example**:  
```json
{
  "name": "GZA",
  "year": 1990,
  "albums": [
    {"name": "Liquid Swords", "year": 1995},
    {"name": "Beneath the Surface", "year": 1999}
  ]
}
```

---

### VECTOR DATA MODEL
- One-dimensional arrays for nearest-neighbor search (e.g., semantic search with ML embeddings).  
- Uses specialized indexes (e.g., HNSW, Faiss, Annoy).  

**Example**:  
| id  | name                 | year | embedding_vector          |
|-----|----------------------|------|---------------------------|
| 33  | Liquid Swords        | 1995 | [0.01, 0.18, 0.85, ...]  |

**Query**:  
```sql
Find albums similar to "Liquid Swords"
```

---

**Course materials continue with detailed examples and diagrams.**  
*For full content, refer to original document.*
```