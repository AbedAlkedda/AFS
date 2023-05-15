maximum' :: (Ord a) => [a] -> a
maximum' [] = error "maximum of empty list"
maximum' [x] = x
maximum' (x:xs) = max x (maximum' xs)
-- maximum' [2, 4, 1]
-- max 2 ( max 4 1)

adddme :: (Num a) => [a] -> a
adddme [] = error "maximum of empty list"
adddme [x] = x
adddme (x:xs) = x + (adddme xs)

foldl (\acc x -> acc + x) 0 [1, 2, 3, 4, 5]
-- 0 + 1 = 1
-- 1 + 2 = 3
-- 3 + 3 = 6
-- 6 + 4 = 10
-- 10 + 5 = 15
