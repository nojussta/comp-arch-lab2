# a	DW  4  ;   10000; perpildymo situacijai
# b	DB 3
# c	DB 8
# x	DW -1,-2,-4,12,9,45,6

# ;
# ; suskaiciuoti     /   (a+2b)/(a-x)    , kai a-x > 0
# ;              y = |   a*a-3b            , kai a-x = 0
# ;                  \   |c+x|          , kai a-x < 0

from operator import mod
from math import modf


a = 4
b = 3
c = 8
x = {-1, -2, -4, 12, 9, 45, 6}

for n, number in enumerate(x):
    if ((a-n) > 0):
        print(a+2*b)/(a-n)
    elif (a-n) == 0:
        print((a*a)-3*b)
    elif (a-n) < 0:
        print(modf(a-n))
