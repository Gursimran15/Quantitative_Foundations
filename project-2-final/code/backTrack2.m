function [a] = backTrack2(f, A, b, c, grad, x, d, a)
p = 0.5;

beta = 1e-4;

y = f(A, b, c, x);
g = grad(A, b, c, x);

while( f(A, b, c, x + a * d) > y + beta * a * (g'*d) )
    
    a = a * p;
end

end

