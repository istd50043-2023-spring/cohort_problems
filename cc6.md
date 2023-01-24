# 50.043 - Cohort Class 6

## Learning Outcomes

By the end of this unit, you should be able to 

- apply nested loop join, block nested loop join and sort merge join to join data in relations
- apply external sort to sort data in a relation
- estimate the I/O cost

## Recap External Sort

We consider the pseudo-code of the exernal sort algorithm. 
The algorithm is defined by a pseudo function ext_sort(in_pages, bpool), which has the following input and output.

- input 
    * bpool - the buffer pool (in RAM)
    * in_pages - the pages to be sorted (on disk)
- output
    * sorted results (on disk)
    
We find the pseudo code as follows
1. def ext_sort(in_pages, bpool)
    1. let runs = divide_n_sort(in_pages, bpool)
    2. while size_of(runs) > 1
        1. let runs = merge(runs, bpool)
    3. return runs

At step 1.1, we call a helper function divide_n_sort(in_pages, bpool) to generate the initial runs, (phase 0). 
Steps 1.2 to 1.3 define the merging phases (phase 1, phase 2, .., etc). We repeatly call the helper function `merge(runs, run_size, bpool)` to merge the current runs set until all runs are merged into a single run.

The ext_sort function has two main parts. The phase 0, the divide_n_sort function call and the while loop, i.e.  phase i where i>0.
* In divide_n_sort, we read each page to be sorted once and write back to disk once. Hence the cost is $2 \cdot n$.
*  In each iteration of the while loop in ext_sort function, we merge every $m-1$ runs into a single run, until all runs are merged. There should be $\lceil log_{(m-1)}(\lceil n/m \rceil) \rceil$ iterations. For each iteration, we read and write each page once. Hence the cost is $2 \cdot  n \cdot  \lceil log_{(m-1)}(\lceil n/m \rceil)\rceil$.


## Recap Join

### Nested Loop Join

1. for each tuple $t$ in $R$
    1. for each tuple $u$ in $S$
        1. if $t$ and $u$ satisfy $c$, output $t$ and $u$.

The cost of this approach is $B(R) + |R| \cdot B(S)$. The $B(R)$ is total cost of loading all tuples from $R$ once. For each tuple of $R$, it will be compared with every tuple in $S$, hence $|R| \cdot B(S)$.

### Block Nested Loop Join

Assuming the buffer pool is of size $m$, we divde the buffer pool into $m-2$ frames for loading $R$ and 1 frame for loading $S$ and 1 frame for output
1. for each $m-2$ pages in $R$, we extract each tuple $t$
    1. for each tuple $u$ in $S$
        1. if $t$ and $u$ satisfy $c$, output $t$ and $u$.

The cost of this approach is $B(R) + \lceil B(R) / (m - 2) \rceil \cdot B(S)$.
The cost will be $B(S) + \lceil B(S) / (m - 2) \rceil \cdot B(R)$ if the outer/inner relations are swapped.


### Sort Merge Join

1. Sort $R$ by the attribute used in $c$
2. Sort $S$ by the attribute used in $c$
3. Merge the sorted $R$ and sorted $S$ like external sort

The cost of step 1 is 
$$2\cdot B(R) \cdot (1 + \lceil log_{m-1}(\lceil B(R) / m \rceil)\rceil)$$

The cost of step 2 is 
$$2\cdot B(S) \cdot (1 + \lceil log_{m-1}(\lceil B(S) / m \rceil)\rceil)$$

The cost of step 3 is 
$$B(R) +  B(S)$$






## Exercise 1 


Given 2 relations $R$ and $S$.​ $R$ has 100 pages, 100 records per page.​ $S$ has 50 pages, 50 records per pages. Suppose we have 20 buffer frames.​


1. What is the I/O cost of joining $R$ and $S$ with nested loop join, using $S$ as outer relation?
2. Same as `1`, but with block nested loop join​

## Exercise 2 

Suppose you need to sort 108-page file using 4 buffer frames, using external sort.​​

1. How many passes are needed?​
2. What is the total IO cost?​
3. What is the cost if the file is already sorted?​
4. What is the smallest number of buffer frames needed to sort the file in 2 passes?​

## Exercise 3

Suppose you have 10,000 buffer frames to sort a relation $R$, and $R$ has 186 pages. ​
​
How many I/O does it cost?​

## Exercise 4

Suppose you have 2 relations:​

$R$: 20,000 tuples; 25 tuples fit in a block​

$S$: 45,000 tuples; 30 tuples fit in a block​

Buffer size M=30​

$R$ is sorted​

1. What is the cost of sort-merge join the two relations?​
2. Suppose that $S$ has an unclustered B+-tree index on the join attribute, and the entire index is in memory. Consider a merge join variation which scans the index of $S$ during merge, what is the cost of sort-merge? ​
    * Each tuple in $R$ can join with `k` tuples in $S$​