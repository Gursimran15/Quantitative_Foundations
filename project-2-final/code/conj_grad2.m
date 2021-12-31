function [opt, x] = conj_grad2(f, g, A, b, c, x, a, eps)


iter_max = 1000;
iter = 1;
delta = Inf(size(x));

while norm(delta) > eps && iter <= iter_max
   
    delta = g(A, b, c, x);
    a_ = backTrack2(f, A, b, c, g, x, - g(A, b, c, x), a);
    x0=x;
    new_x =  x - a_*g(A, b, c, x);
    
    k = 0;
    while any(b - A*new_x <= 0) && k <= 100
       a_ = a_ * 0.5;
       new_x =  x - a_*g(A, b, c, x);
       k = k + 1;
    end
    
    x = new_x;
    B=max(0,(g(A,b,c,x)'*g(A,b,c,x))/(g(A,b,c,x0)'*g(A,b,c,x0)));
    delta= g(A,b,c,x) + B*delta;
    plot_arr(iter) = f(A,b,c,x);
    iter = iter + 1;
end
plot(plot_arr(1:iter-1),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('Conjugate Gradient Descent');
grid on
opt = f(A, b, c, new_x);
end
