function [ y ] = f2(A, b, c, x)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here


lgsum = 0;
for i = 1:500
    
    lgsum = lgsum + log(b(i) - A(i,:)*x);
end

y = c'*x - lgsum;

end

