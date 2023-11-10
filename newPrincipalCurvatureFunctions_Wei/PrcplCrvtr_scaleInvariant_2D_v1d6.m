function [curvature_merged,curvature_all]=PrcplCrvtr_scaleInvariant_2D_v1d6(dat,smFactorLst,foreground)
%scale invariant principal curvature detection v1.6
% only detect V shape



curvature_all=zeros([size(dat) length(smFactorLst)]);
curvature_merged=zeros(size(dat));

N_smNum=length(smFactorLst);
for smCnt=1:N_smNum
    smFactor=smFactorLst(smCnt);
    curvature_temp=getCurvature_2D_2(dat,smFactor);
    curvature_null=curvature_temp(~foreground);
    disp(mean(curvature_null))
%     curvature_temp=curvature_temp-mean(curvature_null);
    curvature_all(:,:,smCnt)=curvature_temp;

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged(validRegion)=curvature_temp(validRegion);
end



end