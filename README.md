# Logic-evaluation
This program can read and store rules written in logic notation through user input and then test if those rules hold true 
for a given set of facts.  
A rule is asserted by typing ``A:<RULE>``, and a query is made by typing ``?:<FACT1>,<FACT2>,...``  
For example, you can assert the rule "If A exists, then so must B" by typing ``A:A->B``. You can then test that rule by making
queries. By entering ``?:A,B``, the program will respond that it holds true for all set rules. However, typing ``?:A``
will cause the program to respond that it cannot be true since if A is true, then so must B. Since B isn't included in the query, 
and therefore not true, that rule is broken.  
``?:B`` will also hold true since a false premise does not enforce any particular conclusion. 

The program can also execute both assertions and queries from text files by entering ``LOAD <file>``.  
Set rules can be displayed and cleared using the commands ``SHOW ASSERTIONS`` and ``CLEAR ASSERTIONS``
