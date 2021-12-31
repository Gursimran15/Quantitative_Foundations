function [ g ] = g1( x )

g = zeros(100,1);

for i = 1:100
   
    g(i) = i*2*x(i);
end

end

