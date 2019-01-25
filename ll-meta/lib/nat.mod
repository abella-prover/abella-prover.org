module nat.

is_nat z.
is_nat (s X) :- is_nat X.

plus z X X :- is_nat X.
plus (s X) Y (s Z) :- plus X Y Z.
