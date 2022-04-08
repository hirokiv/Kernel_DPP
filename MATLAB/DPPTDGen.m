function  [W]  = LSPIGen( X, XNext, A , R, sample_iteration)
global CSt;
W = CSt.Weights;
GridSz=size(X,2);
index = size(CSt.UTable,2);
% TOO MUCH MEMORY IS NEEDED!! in 10 DOF
%   current state with soft-max
XSExt =[repmat(X, [1, index]);reshape(repmat(CSt.UTable(:,1:index), GridSz, 1), size(CSt.UTable, 1), length(CSt.UTable(:,1:index))*GridSz)];
Pol = reshape((W*RBF_Kernel(CSt.BMeanMat, XSExt))',GridSz,index)';
%   next state with soft-max
XNExt =[repmat(XNext, [1, index]);reshape(repmat(CSt.UTable(:,1:index), GridSz, 1), size(CSt.UTable, 1), length(CSt.UTable(:,1:index))*GridSz)];
NPol = reshape((W*RBF_Kernel(CSt.BMeanMat, XNExt))',GridSz,index)';
%   current state with current action

% for i = 1:index
%   XSExt = [X;CSt.UTable(:,i)*ones(1,GridSz)];
%   XNExt = [XNext;CSt.UTable(:,i)*ones(1,GridSz)];
%   Pol(i,:) = (W*RBF_Kernel(CSt.BMeanMat, XSExt))'; 
%   NPol(i,:) = (W*RBF_Kernel(CSt.BMeanMat, XNExt))';
% end

XExt=[ X ; A];
Phi = RBF_Kernel(CSt.BMeanMat, XExt);
PolReal = W*Phi;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NPolEta =  exp(NPol*CSt.eta);
NSum=sum(NPolEta,1);
lastPolEta =  exp(Pol*CSt.eta);
lastSum =     sum(lastPolEta,1);

BRes    =     sum(lastPolEta.*Pol,1)./lastSum-R-CSt.gamma*sum(NPolEta.*NPol,1)./NSum-PolReal;
DPPVect =     -1*Phi*BRes';
FMat    =     Phi*Phi';

[W] = DPPTDIterBatch( FMat , DPPVect, CSt );
return;

