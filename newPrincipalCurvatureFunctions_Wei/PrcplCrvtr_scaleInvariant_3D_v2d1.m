function [curvature_merged,curvature_all]=PrcplCrvtr_scaleInvariant_3D_v2d1(dat,smFactorLst,BG,varFit)
%2D scale invariant principal curvature for 3D data, v2.1
% normalize based on noise expectiation, the noise change with baseline
%
% input:    dat:            3D input data
%           smFactorLst:    vector of smooth factor
%           BG:             background without signal
%           varFit:         the relationship between baseline intensity and
%                           noise
% output:   curvature_merged:   merged principal curvature
%           curvature_all:      principal curvature for all smooth factor
%
% 9/29/2022 by Wei Zheng


curvature_all=zeros([size(dat) length(smFactorLst)]);
curvature_merged=zeros(size(dat));
varFitPara.minVal=varFit(1,1);
varFitPara.unit=varFit(2,1)-varFit(1,1);
varFitPara.sigmaLst=sqrt(varFit(:,2));

N_smNum=length(smFactorLst);
for smCnt=1:N_smNum
    smFactor=smFactorLst(smCnt);
    [curvature_temp,sigmaIdMap]=getCurvature_3D_v2d1(dat,smFactor,varFitPara);
    curvature_null=curvature_temp(BG);
    sigmaMap=varFitPara.sigmaLst(sigmaIdMap);
    null_mu=sigmaMap*mean(curvature_null)/varFitPara.sigmaLst(1);
    null_sigma=sigmaMap*std(curvature_null)/varFitPara.sigmaLst(1);
    curvature_all(:,:,:,smCnt)=(curvature_temp-null_mu)./null_sigma;

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged(validRegion)=curvature_temp(validRegion);
end



end