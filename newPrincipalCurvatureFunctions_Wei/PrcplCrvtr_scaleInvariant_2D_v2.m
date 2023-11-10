function [curvature_merged,curvature_all]=PrcplCrvtr_scaleInvariant_2D_v2(dat,smFactorLst,foreground,varFit)
%scale invariant principal curvature detection v2
% normalize based on noise expectiation
% estimate noise based on data in background
% the noise change with baseline

curvature_all=zeros([size(dat) length(smFactorLst)]);
curvature_merged=zeros(size(dat));
varFitPara.minVal=varFit(1,1);
varFitPara.unit=varFit(2,1)-varFit(1,1);
varFitPara.sigmaLst=sqrt(varFit(:,2));

N_smNum=length(smFactorLst);
for smCnt=1:N_smNum
    smFactor=smFactorLst(smCnt);
    [curvature_temp,sigmaIdMap]=getCurvature_2D_3(dat,smFactor,varFitPara);
    curvature_null=curvature_temp(~foreground);
    sigmaMap=varFitPara.sigmaLst(sigmaIdMap);
    null_mu=sigmaMap*mean(curvature_null)/varFitPara.sigmaLst(1);
    null_sigma=sigmaMap*std(curvature_null)/varFitPara.sigmaLst(1);
    curvature_all(:,:,smCnt)=(curvature_temp-null_mu)./null_sigma;

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged(validRegion)=curvature_temp(validRegion);
end



end