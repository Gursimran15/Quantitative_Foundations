function [H] = H2(A, b, x)

H = A'*diag(1 ./ ((b-A*x).^2))*A;

end