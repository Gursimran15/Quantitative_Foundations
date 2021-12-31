function [mn,y_pred_model_final,Rtr,test] = poly_select(K)
[x,y] = import_data();
xcopy = x
ycopy = y
for p=0:10
    [Rtest(p+1) Rtrain(p+1)] = cross_validation(x,y,K,p)
end
plot(Rtrain,"Linewidth",4)
hold on
plot(Rtest,'r','Linewidth',4)
xlabel('Degree of Polynomial(p)')
ylabel('Average Error (R)')
title("Average Error vs Degree of Polynomial")
%ylim([0,500]);
xlim([1,11]);
hold off
legend('Rtrain','Rtest')
%test = mean(Rtest)
%plot(Rtrain)
%plot(Rtrain)
mn = 1;
for i=2:11
    if (Rtest(i) < Rtest(mn))
        mn = i
    end
end
test = Rtest(mn)
%mn=min(Rtest)
%mn=find(Rtest==mn)-1
mn=mn-1;
x_model_train_final = sin_inv_expand(xcopy,mn)

[w_t Rtr]=least_square_MS(x_model_train_final,ycopy')
[xt] = import_data_test()
x_model_test_final = sin_inv_expand(xt,mn)
y_pred_model_final= w_t'*x_model_test_final
writematrix(y_pred_model_final)
%print min
%print Rtr
%print y_pred_model_final
end

%######################Cross-validation######################

function [Rtest,Rtrain] = cross_validation(x,y,K,order)
N=size(x,2)
d = floor(N/K)
Rtrain=0
Rtest=0
A=0
for k=1:K
test_s = 1 + (k-1)*d
test_e = k*d
x_test = x(:,test_s:test_e) 
x_train = x(:,[1:(test_s-1) (test_e + 1):K*d])
y_train = y([1:(test_s-1) (test_e + 1):K*d])
y_test = y(test_s:test_e)

x_model_train = sin_inv_expand(x_train,order)

[w_t Rtrain(k)]=least_square_MS(x_model_train,y_train')
x_model_test = sin_inv_expand(x_test,order)
y_pred_model= w_t'*x_model_test
Rtest(k) = mean((y_test-y_pred_model).^2)
%A = A + Rtest(k); 
end
Rtest = sum(Rtest)/K
Rtrain = sum(Rtrain)/K
%avg = A/K;
end

%########################LSE##################

function [w,R]= least_square_MS(X,y)
[p,N] = size(X)
M = zeros(p,p)
S= zeros(p,1)
M = X*X'
S = X*y
w = M\S
y_pred= w'*X
R = mean((y-y_pred').^2)
end

%###############################Models###############################
function [x_poly] = poly_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;x.^i];
end
x_poly = [x_poly;ones(1,size(x,2))];
end

function [x_poly] = cos_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;cos(x.^i)];
end
x_poly = [x_poly;ones(1,size(x,2))];
end

function [x_poly] = cos_inv_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;cos(x.^(1/i))];
end
x_poly = [x_poly;ones(1,size(x,2))];
end

function [x_poly] = log_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;log(x.^i)];
end
x_poly = [x_poly;ones(1,size(x,2))];
end

function [x_poly] = sin_inv_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;sin(x.^(1/i))];
end
x_poly = [x_poly;ones(1,size(x,2))];
end

function [x_poly] = nroot_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;sin(nthroot(x.^(1/i),3))];
end
x_poly = [x_poly;ones(1,size(x,2))];
end

function [x_poly] = sin_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;sin(x.^i)];
end
x_poly = [x_poly;ones(1,size(x,2))];
end
function [x_poly] = poly_inv_expand(x,p)
x_poly = [];
for i= p:-1:1
    x_poly = [x_poly;x.^(1/i)];
end
x_poly = [x_poly;ones(1,size(x,2))];
end



%######################Input Data##############

function [x,y] = import_data()
traindata = importdata('traindata.txt');
x = traindata(:,1:8)';
y = traindata(:,9)';
end
function [x] = import_data_test()
testdata = importdata('testinputs.txt');
x = testdata(:,1:8)';
%y = testdata(:,9)';
end
