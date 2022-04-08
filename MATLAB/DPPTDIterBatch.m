function [W] = DPPTDIterBatch(  FMat,  FB, p, a)
DW=0;
%W=( FMat+p.alpha*p.nsamples*p.length*eye( size(FMat) ))\FB;
W=( FMat+p.alpha*p.K_mm)\FB;
%W=( FMat+p.alpha*eye(size(FMat)))\FB;
W=min(max(W,-p.WMax),p.WMax);
return;




