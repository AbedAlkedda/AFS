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
  4. `gem install ./falafel-x.x.x.gem`, replace `x.x.x` with the version number
  5. use one of the examples in example folder or in this page

## Examples

- ### Exapmle: NFA to DFA
  ```ruby
    require  'falafel'

    d_a    = [[1, 1], [2, 2], [2, 1]]
    d_b    = [[1, 2]]
    states = [1, 2]
    starts = [1]
    finals = [1]

    Falafel.new do |a|
      a.build d_a, d_b, states: states, starts: starts, finals: finals
      a.nfa_to_dfa
    end
  ```
  #### Output
  ```Bash
    dfa:
    finals: [1, 12]
    states: [1, 2, 12, 0]
    (1 ,'a', 1)
    (2 ,'a', 12)
    (0 ,'a', 0)
    (12 ,'a', 12)
    (1 ,'b', 2)
    (2 ,'b', 0)
    (0 ,'b', 0)
    (12 ,'b', 2)
  ```
  ---

- ### Exapmle: NFA to REG
  ```ruby
    require  'falafel'

    d_a    = [[1, 1], [2, 2], [2, 1]]
    d_b    = [[1, 2]]
    states = [1, 2]
    starts = [1]
    finals = [1]

    Falafel.new do |a|
      a.build d_a, d_b, states: states, starts: starts, finals: finals
      reg = a.nfa_to_reg
      reg.print_matrix
      puts "\nnfa to reg: #{reg.final_reg}"
    end
  ```
  #### Output
  ```Bash
    l0
            |ε+a    |a  |
            |b      |ε+a|
    l1
            |(a)*           |(a)*.b        |
            |b.(a)*         |ε+a+(b.(a)*.a)|
    l2
            |(a)*+((a)*.b.(a+(b.(a)*.a))*.b.(a)*)   |(a)*.b.(a+(b.(a)*.a))*              |
            |(a+(b.(a)*.a))*.(a)*.b                 |(ε+a+(b.(a)*.a))*                   |

    nfa to reg: (a)*+((a)*.b.(a+(b.(a)*.a))*.b.(a)*)
  ```
  ---

- ### Exapmle: DFA to minimal DFA
  ```ruby
    require  'falafel'

    d_a    = [[1, 1], [2, 2], [2, 1]]
    d_b    = [[1, 2]]
    states = [1, 2]
    starts = [1]
    finals = [1]

    Falafel.new do |a|
      a.build d_a, d_b, states: states, starts: starts, finals: finals
      dfa = a.nfa_to_dfa
      a.dfa_to_min dfa
    end
  ```
  #### Output
  ```Bash
    dfa:
    finals: [1, 12]
    states: [1, 2, 12, 0]
    (1 ,'a', 1)
    (2 ,'a', 12)
    (0 ,'a', 0)
    (12 ,'a', 12)
    (1 ,'b', 2)
    (2 ,'b', 0)
    (0 ,'b', 0)
    (12 ,'b', 2)

    Q={1=>"p", 2=>"q", 12=>"r", 0=>"s"}
    F={1=>"p", 12=>"r"}
    {F, Q\F }={["p", "r"]}, {["q", "s"]}
    R0=[["p", "p"], ["p", "r"], ["q", "q"], ["q", "s"], ["r", "p"], ["r", "r"], ["s", "q"], ["s", "s"]]
    R1=[["p", "p"], ["p", "r"], ["q", "q"], ["r", "p"], ["r", "r"], ["s", "s"]]
    R2=[["p", "p"], ["p", "r"], ["q", "q"], ["r", "p"], ["r", "r"], ["s", "s"]]
  ```
  ---

- ### Exapmle: Pumping Lemma (ToDo)
  ```ruby

  ```
  #### Output
  ```Bash

  ```
  ---

- ### Exapmle: CYK _Epsilon_ (needs some fixes)
  ```ruby
    require 'falafel'

    alphabet  = %w[a b c]
    vars_set  = ['S']
    start_var = 'S'

    rules = { 'S' => [[]] }
    rules['S'] << ['aSc']
    rules['S'] << ['bSc']

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.epsilon_free

    puts "Chomksy normal form: #{cfg.rules_ef_res}"

    cfg.chomsky_nf cfg.rules_ef

    word = 'aaaabbbbcccccccc'
    cfg.cyk_run word
    puts cfg.cyk_matrix.map(&:inspect)
    puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
  ```
  #### Output
  ```Bash
    Chomksy normal form: {"S"=>["aSc", "ac", "bSc", "bc"]}
    ["A", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "S"]
    [[], "A", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "S", "H"]
    [[], [], "A", "0", "0", "0", "0", "0", "0", "0", "0", "0", "0", "S", "H", "0"]
    [[], [], [], "A", "0", "0", "0", "0", "0", "0", "0", "0", "S", "H", "0", "0"]
    [[], [], [], [], "B", "0", "0", "0", "0", "0", "0", "S", "H", "0", "0", "0"]
    [[], [], [], [], [], "B", "0", "0", "0", "0", "S", "H", "0", "0", "0", "0"]
    [[], [], [], [], [], [], "B", "0", "0", "S", "H", "0", "0", "0", "0", "0"]
    [[], [], [], [], [], [], [], "B", "S", "H", "0", "0", "0", "0", "0", "0"]
    [[], [], [], [], [], [], [], [], "C", "0", "0", "0", "0", "0", "0", "0"]
    [[], [], [], [], [], [], [], [], [], "C", "0", "0", "0", "0", "0", "0"]
    [[], [], [], [], [], [], [], [], [], [], "C", "0", "0", "0", "0", "0"]
    [[], [], [], [], [], [], [], [], [], [], [], "C", "0", "0", "0", "0"]
    [[], [], [], [], [], [], [], [], [], [], [], [], "C", "0", "0", "0"]
    [[], [], [], [], [], [], [], [], [], [], [], [], [], "C", "0", "0"]
    [[], [], [], [], [], [], [], [], [], [], [], [], [], [], "C", "0"]
    [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], "C"]
    word aaaabbbbcccccccc is in CFL
  ```
  ---

- ### Exapmle: CYK _Chaining_ (needs some fixes to solve word problem)
  ```ruby
    require 'falafel'

    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'

    rules = { 'S' => [['X'], ['Y']] }
    rules['X'] = [['aX']]
    rules['Y'] = [['bY']]

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chaining_free
    puts cfg.rules_cf.inspect
  ```
  #### Output
  ```Bash
    {"S"=>[["a", "X"], ["b", "Y"]], "X"=>[["a", "X"]], "Y"=>[["b", "Y"]]}
  ```
  ---

- ### Exapmle: CYK _Normal_
  ```ruby
    require 'falafel'

    alphabet  = %w[a b]
    vars_set  = %w[S]
    start_var = 'S'

    rules = { 'S' => [['b'], ['a'], ['aSS']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chomsky_nf nil

    word = 'aabaabb'

    cfg.cyk_run word
    puts cfg.cyk_matrix.map(&:inspect)
    puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
  ```
  #### Output
  ```Bash
    ["A", "I", "S", "I", "S", "I", "S"]
    [[], "A", "I", "S", "I", "S", "I"]
    [[], [], "B", "I", "0", "I", "0"]
    [[], [], [], "A", "I", "S", "I"]
    [[], [], [], [], "A", "I", "S"]
    [[], [], [], [], [], "B", "I"]
    [[], [], [], [], [], [], "B"]
    word aabaabb is in CFL
  ```
  ---

## Coming soon
  * Run using container
  * Build frontend to use the gem
