module Test where

 g = \x -> (\y -> [x,y])

 ff g = \x -> (\y -> x + y )

 a = ff g 5 1
