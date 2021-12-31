function [ opt, new_x ] = newtons2(f, g, H, A, b, c, x, a, eps)

iter_max = 1000;


iter = 1;
s = Inf(size(x));

while norm(s) > eps && iter <= iter_max
   
   s = H(A, b, x) \ g(A, b, c, x);
   a_ = backTrack2(f, A, b, c, g, x, - s, a);
   
   
   new_x =  x - a_*s;
   
   k = 0;
   while any(b - A*new_x <= 0) && k <= 100
       a_ = a_ * 0.5;
       new_x =  x - a_*s;
       k = k + 1;
   end
    plot_arr(iter) = f(A,b,c,x);
   iter = iter + 1;
   x = new_x;
end
plot(plot_arr(1:iter-1),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('Newton Method');
grid on
opt = f(A, b, c, new_x);

end