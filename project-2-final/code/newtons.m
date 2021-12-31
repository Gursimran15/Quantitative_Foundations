function [opt, x] = newtons(f, g, H, x, a, eps)


iter_max = 1000;
iter = 1;
delta = Inf(size(x));

while norm(delta) > eps && iter <= iter_max
   
    delta =  H(x) \ g(x);
    a_ = backTrack(f, g, x, - delta, a);
    x = x - a_*delta;
     plot_arr(iter) = f(x);
    iter = iter + 1;
end
plot(plot_arr(1:iter-1),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('Newton Method');
grid on
opt = f(x);
end

