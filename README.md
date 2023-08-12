# Automata Problem Solver (Mini)

It solves some of the automata and formal languages problems:

* L1:
  * convert NFA to DFA
  * convert NFA to REG
  * convert DFA to minimal DFA
  * Pumping Lemma
* L2:
  * Epsilon free: remove rules like (S, ε)
  * Chaining free: remove rules like (S, T)
  * find Chomsky normal forms
  * CYK
    * solve word problem
    * print CYK matrix

## Installation
  * Option 1
    1. install `gem`
    2. call `gem install falafel` in the terminal
  * Option 2
    1. clone this repo
    2. `cd falafel`
    3. `gem build falafel.gemspec`
    4. `gem install ./falafel-x.x.x.gem`, replace `x.x.x` with the version number
    5. use one of the examples in example folder or in this page

## Usage examples

- ### Example: NFA to DFA
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

- ### Example: NFA to REG
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

- ### Example: DFA to minimal DFA
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

- ### Example: Pumping Lemma
  #### Language a^* b^*
  ```ruby
    require  'falafel'

    pump = Falafel.new {}
    lang   = ->(w) { w.match?(/\Aa*b*\z/) }
    length = 3
    pump_lemma = pump.pump_lemma lang, length

    words = %w[aaaaa aaaab aaab aabb abb]

    words.each do |word|
      pump_lemma.word = word
      pump_lemma.run show_pros: false
      r, s, t = pump_lemma.decomposition
      puts "is_regular? #{pump_lemma.is_regular}"
      puts "\"#{pump_lemma.word}\", decomposition { r = \"#{r}\" , s = \"#{s}\", t = \"#{t}\"}"
    end

  ```
  #### Output
  ```Bash
    is_regular? true
    "aaaaa", decomposition { r = "aaaa" , s = "a", t = ""}
    is_regular? false
    "aaaab", decomposition { r = "aa" , s = "aab", t = ""}
    is_regular? false
    "aaab", decomposition { r = "a" , s = "aab", t = ""}
    is_regular? false
    "aabb", decomposition { r = "" , s = "aab", t = "b"}
    is_regular? false
    "abb", decomposition { r = "" , s = "abb", t = ""}
  ```
  ---

- ### Example: CYK _Epsilon_
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

    cfg.chomsky_nf cfg.rules_ef

    word = 'aaaabbbbcccccccc'
    cfg.cyk_run word
    puts cfg.cyk_matrix.map(&:inspect)
    puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
  ```
  #### Output
  ```Bash
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

- ### Example: CYK _Chaining_
  ```ruby
    require 'falafel'

    alphabet  = %w[a b]
    vars_set  = %w[S X Y]
    start_var = 'S'
    rules = { 'S' => [['X'], ['Y']], 'X' => [['aX'], ['a']], 'Y' => [['bY']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chaining_free
    cfg.chomsky_nf cfg.rules_cf

    word = 'aaaa'
    cfg.cyk_run word
    puts cfg.cyk_matrix.map(&:inspect)
    puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
  ```
  #### Output
  ```Bash
    ["A", "X", "X", "S"]
    [[], "A", "X", "X"]
    [[], [], "A", "X"]
    [[], [], [], "A"]
    word aaaa is in CFL
  ```
  ---

- ### Example: CYK _Normal_
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

- ### Example: CYK _Epsilon_ with _Chaining_
  ```ruby
    require 'falafel'

    alphabet  = %w[a b c]
    vars_set  = %w[S X]
    start_var = 'S'
    rules = { 'S' => [[], ['X'], ['aSbS']],
              'X' => [['c']] }

    falafel = Falafel.new {}
    cfg     = falafel.cfg alphabet, vars_set, start_var, rules

    cfg.chaining_free

    cfg.epsilon_free cfg.rules_cf

    cfg.chomsky_nf cfg.rules_ef

    puts cfg.chomsky_nf_rules.inspect
    word = 'aacbcbacbc'

    cfg.cyk_run word
    puts cfg.cyk_matrix.map(&:inspect)
    puts "word #{word} is #{cfg.is_in_l ? '' : 'not '}in CFL"
  ```
  #### Output
  ```Bash
    {"A"=>"a", "B"=>"b", "C"=>"c", "S"=>["AH", "AJ", "AI", "AB", "C", "C"], "X"=>["C"], "H"=>["SI", "CI"], "I"=>["BS", "BC"], "J"=>["SB", "CB"]}

    ["A", "0", "0", "0", "0", "S", "0", "0", "S", "S"]
    [[], "A", "0", "S", "S", "J", "0", "0", "H", "H"]
    [[], [], "C", "J", "H", "0", "0", "0", "0", "0"]
    [[], [], [], "B", "I", "0", "0", "0", "0", "0"]
    [[], [], [], [], "C", "J", "0", "0", "H", "H"]
    [[], [], [], [], [], "B", "0", "0", "I", "I"]
    [[], [], [], [], [], [], "A", "0", "S", "S"]
    [[], [], [], [], [], [], [], "C", "J", "H"]
    [[], [], [], [], [], [], [], [], "B", "I"]
    [[], [], [], [], [], [], [], [], [], "C"]

    word aacbcbacbc is in CFL
  ```
  ---
