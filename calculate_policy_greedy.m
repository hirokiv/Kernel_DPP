function [ output ] = calculate_policy_greedy( state ,Weights,CSt)
%   This is the policy calculation function of LSPI algorithm for Single pendulum control
%   Ver 0.1 by Y.D. CUI, ISC lab, NAIST, Japan 2014/11/15

GridSz= size(state,2);
USz =  length(CSt.UTable);
Pol =zeros( USz,GridSz );  

X =[repmat(state, 1, USz);reshape(repmat(CSt.UTable(:,1:USz), GridSz, 1), size(CSt.UTable, 1), length(CSt.UTable(:,1:USz))*GridSz);];
%[ PolTemp ,  PhiTemp ] = FullPolNet( X,  Weights, CSt );
PolTemp = CSt.Weights*RBF_Kernel(CSt.BMeanMat, X);
Pol=reshape(PolTemp,GridSz,USz)';

[asort, ind] = sort(Pol);
output = CSt.UTable(:,ind(end,:));
end
