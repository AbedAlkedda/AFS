{-# language DeriveGeneric #-}


data Sigma = A | B deriving (Eq, Show, Generic)

data FiniteAutomaton q i f delta = FiniteAutomaton
  { states :: [q]
  , inputSymbols :: [i]
  , finalStates :: [q]
  , transitionFunction :: q -> i -> q
  }

fa = FiniteAutomaton
  { states = [0, 1]
  , inputSymbols = ['a', 'b']
  , finalStates = [1]
  , transitionFunction = (\q i ->
      case (q, i) of
        (0, 'a') -> 1
        (0, 'b') -> 0
        (1, 'a') -> 1
        (1, 'b') -> 0
        _ -> error "Invalid state or input symbol"
    )
  }
