function test_n()
%for g = [0.5 0.3 0.4 0.6 0.7]
for(i=1:10)
c=0;
disp('CI Normal')
i
k=1;
%T = zeros(1,27);
%n = zeros(1,27);
T = [0.1 0.1 0.1 0.1 0.2 0.2 0.2 0.2 0.3 0.3 0.3 0.3 0.4 0.4 0.4 0.4 0.5 0.5 0.5 0.5 0.6 0.6 0.6 0.6 0.7 0.7 0.7 0.7 0.8 0.8 0.8 0.8 0.9 0.9 0.9 0.9];
n = [10 100 1000 10000 10 100 1000 10000 10 100 1000 10000 10 100 1000 10000 10 100 1000 10000 10 100 1000 10000 10 100 1000 10000 10 100 1000 10000 10 100 1000 10000];
%for s = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]
%g
for t = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]
for N =  [10 100 1000 10000]
for(j=1:10000)    
% Six sig and mu combos lie between 0 and 1 - s:0.1 , m:0.3 ;s:0.1 , m:0.4 ;s:0.1 , m:0.5 ;s:0.2 , m:0.5 ;s:0.1 , m:0.6 ;s:0.1 , m: 0.7;
X = sample_normal(N,0.2,0.5);
m = mean(X);
[a,b] = ci(X,i);
if(a <= t && t <=b)
    c = c+1;
end
end

out = c/100;

tb(k) = out; 
c=0;
k=k+1;
end

end
%s
colnames = {'N','theta/mean','percentage (approx > 1-alpha)'};
Outtable = table(n',T',tb','VariableNames', colnames) 
%end
%end
end
end