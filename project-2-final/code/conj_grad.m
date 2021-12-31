function [opt, x] = conj_grad(f, g, x, a, eps)


iter_max = 10000;
iter = 1;
delta = Inf(size(x));
plot_arr = zeros(iter_max, 1);

while norm(delta) > eps && iter <= iter_max
   
    delta = g(x);
    a_ = backTrack(f, g, x, - g(x), a);
    x0=x;
    x = x - a_*g(x);
    B=max(0,(g(x)'*g(x))/(g(x0)'*g(x0)));
    delta= g(x) + B*delta;
    plot_arr(iter) = f(x);
    iter = iter + 1;
end

plot(plot_arr(1:iter-1),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('Conjugate Gradient Descent');

opt = f(x);
end