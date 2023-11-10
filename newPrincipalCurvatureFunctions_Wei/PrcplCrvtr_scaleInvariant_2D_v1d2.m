function [curvature_merged,curvature_all]=PrcplCrvtr_scaleInvariant_2D_v1d2(dat,smFactorLst,noiseSigma)
%scale invariant principal curvature detection v1.2
% normalize based on noise
% estimate noise based on MC simulation

dat_null=generateNullHypothsis_2D()*noiseSigma;

curvature_all=zeros([size(dat) length(smFactorLst)]);
curvature_merged=zeros(size(dat));

% curvature_max=-inf(size(dat));
% curvature_min=inf(size(dat));

N_smNum=length(smFactorLst);
for smCnt=1:N_smNum
    smFactor=smFactorLst(smCnt);
    curvature_temp=getCurvature_2D(dat,smFactor);
    curvature_null=getCurvature_2D(dat_null,smFactor);
    curvature_null=curvature_null(:);
    curvature_temp=(curvature_temp-mean(curvature_null))./std(curvature_null);
    curvature_all(:,:,smCnt)=curvature_temp;

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged(validRegion)=curvature_temp(validRegion);
end



end