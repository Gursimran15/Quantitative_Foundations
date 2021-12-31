function [ opt, new_x ] = BFGS(f, g, x, a, eps)

iter_max = 10000;
Q = eye(length(x));

iter = 1;
s = Inf(size(x));

plot_arr = zeros(iter_max, 1);

while norm(s) > eps && iter <= iter_max
    
   a_ = backTrack(f, g, x, - Q*g(x), a);
   new_x =  x - a_*Q*g(x);
  
   s = new_x - x;
   y = g(new_x) - g(x);
   
   Q = Q - (s*y'*Q + Q*y*s') / (s'*y) + (1 + (y'*Q*y)/(s'*y)) * (s*s')/(s'*y);
   
   x = new_x;
   
   plot_arr(iter) = f(x);
   
   iter = iter + 1;
end

plot(plot_arr(1:iter),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('BFGS-Quasi Newton');
grid on
opt = f(new_x);
end

