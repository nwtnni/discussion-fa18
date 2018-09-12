# Higher-Order Programming

For this discussion, we'll be writing a handful of higher-order functions. 

We will cover:
- fold
- map
- reverse
- filter
- trees

Please avoid looking through the textbook while working on these exercises! You will find many of the answers there, but this will not help you learn. Give all problems an honest try on your own first. Solutions will be posted here after discussion.

# Notes about fold_left

Since we had many questions about fold during discussion today, here is a brief overview.

The fold_left and fold_right functions use the Abstraction Principle to let us simplify our
writing of a wide variety of functions. That is, instead of writing many similar functions
which have the same underlying style, we can just use fold_left or fold_right as a template
and fill in the parameters we want (namely the accumulator/initial value and the operator itself).

This way, instead of writing many functions which use pattern matching to achieve different
goals, we can simply use fold_left or fold_right to act as our underlying structure and do that
in fewer lines of code. Neat!

Please check out textbook sections [4.5](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/hop/fold_right.html), [4.6](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/hop/fold_left.html), [4.7](http://www.cs.cornell.edu/courses/cs3110/2018fa/textbook/hop/fold_left_vs_right.html) and beyond
for more details on fold, the difference between fold_left and fold_right, and when to use each.

As always, feel free to reach out to me at ne236@cornell.edu with any questions about this
exercise, or post general questions to Piazza so your peers can benefit as well!