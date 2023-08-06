# Automata Problem Solver

It solves some of the automata and formal languages problems:

* L1:
  * convert NFA to DFA
  * convert NFA to REG
  * convert DFA to minimal DFA
  * Pumping Lemma _need to be fixed_

L2:
  * Chomsky normal form
    * Epsilon free: remove rules like (S, ε) _need to be fixed_
    * Chaining free: remove rules like (S, T) _need to be fixed_
    * Normal cases: working :)
  * CYK
    * solve word problem
    * CYK matrix

## Install
  * Option 1
    1. install `gem`
    2. call `gem install falafel` in the terminal
  * Option 2
  1. clone this repo
  2. `cd falafel`
  3. `gem build falafel.gemspec`
  4. `gem install ./falafel-x.x.x.gem`
  5. use one of the examples in example folder or in this page

## Examples

- ### Exapmle: NFA to DFA
- ### Exapmle: NFA to REG
- ### Exapmle: DFA to minimal DFA
- ### Exapmle: Pumping Lemma
- ### Exapmle: Chomsky normal form _Epsilon_
- ### Exapmle: Chomsky normal form _Chaining_
- ### Exapmle: Chomsky normal form _Normal_
- ### Exapmle: CYK

## Coming soon
  * Run using container
  * Build frontend to use the gem
