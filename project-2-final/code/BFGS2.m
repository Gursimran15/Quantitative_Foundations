function [ opt, new_x ] = BFGS2(f, g, A, b, c, x, a, eps)

iter_max = 1000;
Q = eye(length(x));

iter = 1;
s = Inf(size(x));

while norm(s) > eps && iter <= iter_max
    
   a_ = backTrack2(f, A, b, c, g, x, - Q*g(A, b, c, x), a);
   
   
   new_x =  x - a_*Q*g(A, b, c, x);
   
   k = 0;
   while any(b - A*new_x <= 0) && k <= 100
       a_ = a_ * 0.5;
       new_x =  x - a_*Q*g(A, b, c, x);
       k = k + 1;
   end
  
   s = new_x - x;
   y = g(A, b, c, new_x) - g(A, b, c, x);
   
   Q = Q - (s*y'*Q + Q*y*s') / (s'*y) + (1 + (y'*Q*y)/(s'*y)) * (s*s')/(s'*y);
   plot_arr(iter) = f(A,b,c,x);
   iter = iter + 1;
   x = new_x;
end
plot(plot_arr(1:iter-1),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('BFGS-Quasi Newton');
grid on
opt = f(A, b, c, new_x);
end
