function [ output ] = calculate_policy_no_greedy(state ,Weights,CSt)
%   This is the policy calculation function of LSPI algorithm for Single pendulum control
%   Ver 0.1 by Y.D. CUI, ISC lab, NAIST, Japan 2014/11/15
GridSz= size(state,2);
USz =  length(CSt.UTable);
Pol =zeros( USz,GridSz );  

X =[repmat(state, 1, USz);reshape(repmat(CSt.UTable(:,1:USz), GridSz, 1), size(CSt.UTable, 1), length(CSt.UTable(:,1:USz))*GridSz);];
PolTemp = Weights*RBF_Kernel(CSt.BMeanMat, X);
Pol=reshape(PolTemp,GridSz,USz)';

%PolEta = exp(Pol*Min_num0*CSt.Eta);
PolEta = exp(Pol*0.01);
%PolEta = exp(Pol*Min_num*CSt.Eta);
PSum=sum(PolEta,1);
Pi=PolEta./(ones(USz,1)*PSum);
PiSum = cumsum(Pi,1);
r1=rand(1,GridSz);
Ind=sum(PiSum<(ones(USz,1)*r1))+1;
output = CSt.UTable(:,Ind(end,:));

end
