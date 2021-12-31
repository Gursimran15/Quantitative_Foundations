function [ y ] = f1( x )

y = 0;

for i = 1:100
    y = y + i*x(i)^2;
end

end

