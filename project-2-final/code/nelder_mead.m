function [ opt, new_x ] = nelder_mead(f, x, eps)

S = init(x);

alpha = 1;
beta = 2;
gamma = 0.5;
max_iter= 1000;

D = Inf;
y_arr = zeros(length(S), 1);


iter = 0;

while D > eps && iter <= max_iter

    for i = 1:length(S)
        y_arr(i) = f(S(:, i));
    end
    
    [y_arr, p] = sort(y_arr);
    S = S(:, p);
    
    xl = S(:,1); yl = y_arr(1);
    xh = S(:, end); yh = y_arr(end);
    xs = S(:, end-1); ys = y_arr(end-1);
    xm = mean(S(:, 1:end-1), 2, "default");
    xr = xm + alpha*(xm-xh);
    yr = f(xr);
    
    if yr < yl
        xe = xm + beta*(xr-xm);
        ye = f(xe);
        if ye < yr
            S(:, end) = xe;
            y_arr(end) = ye;
        else
            S(:, end) = xr;
            y_arr(end) = yr;
        end
    elseif yr > ys
        if yr <= yh
            xh = xr;
            yh = yr;
            S(:, end) = xr;
            y_arr(end) = yr;
        end
        xc = xm + gamma*(xh-xm);
        yc = f(xc);
        if yc > yh
            for i = 2:length(y_arr)
                S(:, i) = (S(:, i) + xl)./2;
                y_arr(i) = f(S(:, i));
            end
        else
            S(:, end) = xc; y_arr(end) = yc;
        end
    else
        S(:, end) = xr; y_arr(end) = yr;
    end
    
    D = std(y_arr);
    plot_arr(iter+1) = f(xl);
    iter = iter + 1;
end
plot(plot_arr(1:iter),'-o')
xlabel('Number of Iterations'); 
ylabel('Function value'); 
title('Nelder Mead');
grid on
[~, p] = sort(y_arr);
new_x = S(:, p(1));
opt = f(new_x);

end

