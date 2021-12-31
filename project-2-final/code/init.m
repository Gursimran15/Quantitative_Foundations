function [ S ] = init( x )

h = 0.1;
e = zeros(size(x));
S = zeros(length(x), length(x)+1);

for i = 1:length(x)
    
   ei = e;
   ei(i) = 1;
   S(:, i) = x + ei*h;
end

S(:, end) = x;

end

