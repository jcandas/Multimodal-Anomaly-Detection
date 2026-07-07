d = fileparts(pwd);
a = genpath(d);
path(path,a);
rmpath(genpath('old/'))

