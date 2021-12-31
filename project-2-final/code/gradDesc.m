function [opt, x] = gradDesc(f, g, x, a, eps)


iter_max = 10000;
iter = 1;
delta = Inf(size(x));
plot_arr = zeros(iter_max, 1);

while norm(delta) > eps && iter <= iter_max  
    
    a_ = backTrack(f, g, x, - g(x), a);
    x = x - a_*g(x);
         
    plot_arr(iter) = f(x);
    
    iter = iter + 1;
    delta = g(x);
end

plot(plot_arr(1:iter-1),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('Gradient Descent');
grid on
opt = f(x);
end
