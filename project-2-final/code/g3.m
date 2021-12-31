function [ g ] = g3(x)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
x1 = x(1);
x2 = x(2);

g1 = 2*x1 - 2 - 200*x1*(2*x2 - 2*(x1^2));
g2 = 200*(x2-x1^2);

g = [g1; g2];
end

