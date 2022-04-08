function [ output ] = RBF_Kernel( X_1, X_2 )
%RBF_KERNEL Summary of this function goes here

dim     = size(X_1,1);
Var     = 0.5.*ones(dim,1);
Size_1  = size(X_1,2);
Size_2  = size(X_2,2);
X_1     = X_1./(Var.^(0.5)*ones(1,Size_1));
X_2     = X_2./(Var.^(0.5)*ones(1,Size_2));

ArgX    = -0.5*(ones( Size_1 ,  1 )*sum(X_2.^2,1)+sum(X_1.^2,1)'*ones( 1 ,  Size_2 )-2*X_1'*X_2);
output  = exp(ArgX); 
end

