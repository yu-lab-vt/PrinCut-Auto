function [curvature_max,curvature_min,y_merged]=PrcplCrvtr_scaleInvariant_1D_v1d2(y,smFactorLst)
%scale invariant principal curvature detection v1.2
% 
% 



y=y(:)';
curvature_max=-inf(size(y));
curvature_min=inf(size(y));

% smFactorLst=1:10;
N_smNum=length(smFactorLst);
curFltr=[0.25 0 -0.5 0 0.25];
for smCnt=1:N_smNum
    smFactor=smFactorLst(smCnt);
    gauFltr_0=normpdf(-smFactor*10:smFactor*10,0,smFactor);
    gauFltr=gauFltr_0/sum(gauFltr_0);
    finalFltr=conv(curFltr,gauFltr);
%     finalFltr=finalFltr/sum(abs(finalFltr));
    SZpad=length(finalFltr);
    y_pad=[ones(1,SZpad)*y(1) y ones(1,SZpad)*y(end)];
    y1=conv(y_pad,finalFltr);
    Ratio=sqrt(sum(finalFltr(:).^2));
    newSZpad=(SZpad-1)/2+SZpad;
    y_2=y1(1+newSZpad:end-newSZpad)/Ratio;

    curvature_max=max(curvature_max,y_2);
    curvature_min=min(curvature_min,y_2);
end

if 0
    K=5;
    curvature_max=movmin(curvature_max,K);
    curvature_min=movmax(curvature_min,K);
end

y_temp=[curvature_max;curvature_min];
[~,locLst]=max(abs(y_temp.*[2;1]));
y_merged=y_temp(locLst+(0:length(locLst)-1)*2);

end