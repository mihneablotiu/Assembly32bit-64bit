Blotiu Mihnea-Andrei - 323CA
Tema 3 - Infernul lui Biju - 18.01.2022

task1.asm:

- In order to sort the albums I used edx register as a "searching number" register;
- We know that the numbers must be from the interval [1, n] so we search for 1 as
we have to return it's address and also we memorise it's next field;
- If we find the first number we put it's address in the eax register and we
continue with the next number, in this case 2.
- When we find the next number we write the previous number next field and we 
memorise the current's one.
- We continue doing this until the number we search for in edx is bigger than n.

task2_p1.asm:

- In order to get CMMMC of two number we use the formula that says that
a * b = cmmdc(a, b) * cmmmc(a, b) so this means that our cmmmc(a, b) is
cmmmc(a, b) = a * b / cmmdc(a, b).
- The product of the numbers is easy to get so we just apply the Euclid's algorithm
in order to get the cmmdc(a, b).
- Afterwards, we just get the product of the numbers and we divide it by the
cmmdc(a, b) and that is the answer;
- No mov, enter or leave used in the previous implementation.

task2_p2.asm:

- In order to verify if an expression is balanced we will use a control number;
- Each time we find an open bracket we add one to the control number and we
continue to search;
- Each time we find an closed bracket we substract one from the control number
and if we arrive on a negative number, then the expression is not balanced;
- When we finish all the string, if the control number is 0, then the expression
is balanced, otherwise it is not;
- No mov, enter or leave used in the implementation above.

task3.asm:

- In order to split the string into words, we just delcare the delimitators as
a global variable and we call strtok until the last word is null;
- We write those words in the arrays using strncpy function;
- In order to sort those words we just call qsort with the necessary parameters;
- qsort need a comparing function as a parameter that we defined below in the asm;
- In order to realise the comparing function, we firstly determined the length
of each string using strlen;
- If one of the strings was longer than the other, we put a coresponding value
int the eax return register.
- If they had the same length, we compare them lexicographically using strncmp function.

bonus_x64.asm:

- In order to work on 64 bits we take the parameters from the coresponding
registers and not from the stack;
- We firstly search which of the arrays has more elements as we have to put them
at the end of the shuffle;
- If the first array is longer or has the same length as the second one we start
writing the elements in the v final array, one by one. Firstly from v1 then from v2;
- We repeat this step until the second array is over as it is the one that might
be shorter;
- If they have the same length we just stop when the second array is over,
otherwise we continue until the first array is over as well.
- In the other case when the second array is longer we do the same steps but until
the first array finishes first and the we continue until the second one finishes
as well.

bonus_cpuid.asm:

- In order to get the manufacturer id we call cpuid with eax = 0;
- In this case we will have the answer in the ebx, edx, ecx registers in this order
so we just write the answer to the coresponding address.

- In order to get the vmx, rdrand or avx we call cpuid with eax = 1;
- In this case, we get in ecx a series of bits where each bit coresponds to a feature;
- 5-th bit is for vmx, the 30-th bit is for rdrand and the 28-th is for avx;
- To extract the coresponding bit, we bring it to the bit 0 and we make an and
opperation between the ecx register and '1' as a number;
- In this way we will just have left the bit we need and we write it to the
corresponding address.

- In order to get the line size and the cache size we call cpuid with eax = 80000006h;
- The line size is in ecx in the 0-7 bits and the cache size is in ecx in the
16-31 bits;
- We issolate those bits and write them at the given address in the parameters.




