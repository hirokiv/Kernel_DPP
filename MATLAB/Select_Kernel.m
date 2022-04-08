function Select_Kernel(C, A)
%SELECT_KERNEL
global CSt
sample = [C;A];
old_num = size(CSt.Weights,2);
for i = 1:size(sample,2)
   if (size(CSt.BMeanMat,2)==0)
      CSt.BMeanMat = [CSt.BMeanMat sample(:,i)]; 
      CSt.K_mm = RBF_Kernel(CSt.BMeanMat,CSt.BMeanMat);
      CSt.K_mmInv = CSt.K_mm^(-1);
   else
       K_tt = RBF_Kernel(sample(:,i),sample(:,i));
       K_tm = RBF_Kernel(sample(:,i),CSt.BMeanMat);
       %K_mm = RBF_Kernel(CSt.BMeanMat,CSt.BMeanMat);
       Error = K_tt - K_tm*CSt.K_mmInv*(K_tm');
       if Error > 0.025
           CSt.BMeanMat = [CSt.BMeanMat sample(:,i)];
           CSt.K_mm = RBF_Kernel(CSt.BMeanMat,CSt.BMeanMat);
           CSt.K_mmInv = CSt.K_mm^(-1);
       end
   end
end
% if (size(CSt.BMeanMat,2)==0)
%     CSt.BMeanMat = [CSt.BMeanMat sample]; 
%     CSt.K_mm = RBF_Kernel(CSt.BMeanMat,CSt.BMeanMat);
% else
%     K_tt = RBF_Kernel(sample,sample);
%     K_tm = RBF_Kernel(sample,CSt.BMeanMat);
%     Error = diag(K_tt)- diag(K_tm*CSt.K_mm^(-1)*(K_tm'));
%     CSt.BMeanMat = [CSt.BMeanMat sample(:,(Error>0.01))];
%     CSt.K_mm = RBF_Kernel(CSt.BMeanMat,CSt.BMeanMat);    
% end
%CSt.Weights = [CSt.Weights, (2*rand(1,size(CSt.BMeanMat(:,old_num+1:end),2))-1)];
CSt.Weights = [CSt.Weights, zeros(1,size(CSt.BMeanMat(:,old_num+1:end),2))];
end
