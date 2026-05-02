function V = blkdngNd(Vleft,Vright)

% Join both input scaling functions
d = size(Vleft,3);
mleft = size(Vleft,1);
nleft = size(Vleft,2);
mright = size(Vright,1);
nright = size(Vright,2);
V = [[Vleft zeros(mleft, nright, d)];
    [zeros(mright, nleft, d), Vright]
   ];