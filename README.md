# Mini Solveur SMT #

Mini Solveur SMT pour le cours de
[Sémantique et Vérification](http://www.di.ens.fr/~rival/semverif-2018/)
avec [Sylvain Conchon](https://www.lri.fr/~conchon/) (ENS Paris)

## Getting started ##

### Prerequisites ###

This project has been conducted using the
[Crystal Programming Language](https://crystal-lang.org/).

Its syntax is very similar to Ruby, but it is statically type-checked
and compiled through [LLVM](https://llvm.org/), offering performances similar to C.

Instructions regarding the installation of the Crystal Programming Language
can be found on the [official documentation](https://crystal-lang.org/docs/installation/).

It is, as of this writing, not available for Windows though.

### Installation ###

You can now build and run the unit tests with

```
make
```

Or, alternatively, only build or run the automated unit tests with

```
make build
make test
```

## Description ##

### Overall process ###

This small SMT solver combines a SAT solver with an equality theory decision procedure.

The SAT solver implements DPLL with two-watched literals, and picks literals at random
when a decision is needed. When the SAT solver returns an assignement that satifies all
constraints, the equality theory decision procedure verifies that it indeed yields a
valid assignement, using a Union-Find structure. If it doesn't, then the assignement
is negated and reinjected into the CNF and SAT-solved again.

The CNF is first analyzed and pure literals trigger deduction before being removed.
Unsatisfiable clauses/relation are also stripped during this process.
All clauses can then be assumed to have at least two different literals, which makes
it easier to implement two-watched literals procedure.

The executable can return with five different exit codes:
- 0 : the formula was analyzed and is satisfiable
- 1 : the formula is unsatisfiable
- 2 : invalid arguments
- 3 : an error occured when parsing the input file
- 4 : an internal error occurred

### Further improvements ###

This process of going back and forth between the solver and the decision procedure is
highly inefficient. It would have been much better, as the equality theory is the only
one supported here, to interlace the two procedures and reject assignements as soon as
they are identified invalid by the decision procedure.

Implementing a Conflict-Driven Clause Learning procedure would also help improve performance.

### Unit testing ###

Throughout the development process, specification files were written alongside source files
(*spec/* folder). They ensure proper behavior of all functions by testing them right after
compiling all sources, and help reduce the amount of bugs. In fact, this whole solver was
written without ever needing to debug it : all unwanted behaviors were reported at compile
time by the specs, and fixed before even running manual tests.


## Author ##

* **David ROBIN**

## License ##

This project is licensed under the MIT License - see [License.md](License.md) file for details
