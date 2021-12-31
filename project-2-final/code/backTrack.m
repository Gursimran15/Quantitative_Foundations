function [a] = backTrack(f, grad, x, d, a)
p = 0.5;

beta = 1e-4;

y = f(x);
g = grad(x);

while( f(x + a * d) > y + beta * a * (g'*d) )
    
    a = a * p;
end

end

