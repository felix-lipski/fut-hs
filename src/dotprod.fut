entry dotprod (xs: []i32) (ys: []i32): i32 =
  reduce (+) 0 (map2 (*) xs ys)

entry times_two (x: i32): i32 = 
  x + 2
