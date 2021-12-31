function [ y ] = f3(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
x1 = x(1);
x2 = x(2);

y = 100*(x2-x1^2)^2 + (1-x1)^2;

end

