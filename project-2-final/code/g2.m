function [g] = g2(A, b, c, x)


g = c + A'*(1 ./ (b - A*x));
end

