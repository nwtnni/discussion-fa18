# Functors and Include

Today we'll be reviewing modules and signatures, and adding the implementation 
of functors to our modules. We will also explore `include`, and the difference 
between `include` and `open`.

## Functors

Just like signatures can be used on multiple modules, so can functors! Functors 
are a lot like the functions we've been using in the sense that they take in 
a structure, and return another structure. You can use them to apply a set of
functions on your modules, for example, a series of tests. 


## Include

Using the keyword `include M`, with M being your module, within your code 
essentially copies all of the contents of your module, M, to the location of 
the `include` statement. The keyword `open` is similar, but only allows the
module contents to be accessed within that scope of your code.

## Today's Activity

Please go through Triples.ml with your A2-A5 group. We encourage a lot of 
discussion! Make sure that you understand what is going on every step of the way.
You'll go through a quick review of modules and corresponding signatures, then
get right into using `include` statements and functors. 

### Exercise Summary

1. Create a signature for the TupleTriple module
2. Implement TupleTripleExt, using `include` to extend the functionality of TupleTriple.
3. Explore the difference between `include` and `open`
4. Now we add the ListTriple module. Create a functor that we can use on both
of our modules (TupleTriple and ListTriple).


As always, if you have any questions, please feel free to email one of the TAs!

This exercise will not be graded, but it is good preparation for the prelim, so if you 
don't finish during discussion section it's recommended you go back and look it through.
Solutions will be posted after discussion section on 9/19.