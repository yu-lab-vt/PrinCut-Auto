function [curvature_merged,curvature_merged_noise]=PrcplCrvtr_scaleInvariant_3D_v2d3(dat,smFactorLst,BG,varFit,normalizationMethod,zRatio)
%scale invariant principal curvature for 3D data, v2.2
% normalize based on noise expectiation, the noise change with baseline
% Calculate xy direction and z direction seperately
%
% input:    dat:                3D input data
%           smFactorLst:        vector of smooth factor
%           BG:                 background without signal
%           varFit:             the relationship between baseline intensity and
%                               noise
%           normalizationMethod:"Noise"(default),"AUC"
% output:   curvature_merged:   merged principal curvature
%           curvature_all:      principal curvature for all smooth factor
%
% 9/29/2022 by Wei Zheng

%% initialize

varFitPara.minVal=varFit(1,1);
varFitPara.unit=varFit(2,1)-varFit(1,1);
varFitPara.sigmaLst=sqrt(varFit(:,2));
N_smNum=length(smFactorLst);


curvature_merged=zeros(size(dat));

if normalizationMethod == "Noise"
    curvature_merged_noise=zeros(size(dat));
end

%% iteratively get optimal curvature
for smCnt=1:N_smNum
    %% get XY direction principal curvature
    smFactor=smFactorLst(smCnt);
    [curvature_temp,sigmaIdMap]=getCurvature_3D_v2d3(dat,smFactor,zRatio,varFitPara);

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged(validRegion)=curvature_temp(validRegion);

    if normalizationMethod == "Noise"
        curvature_null=curvature_temp(BG);
        sigmaMap=varFitPara.sigmaLst(sigmaIdMap);
        null_mu=sigmaMap*mean(curvature_null)/varFitPara.sigmaLst(1);
        null_sigma=sigmaMap*std(curvature_null)/varFitPara.sigmaLst(1);
        curvature_temp=(curvature_temp-null_mu)./null_sigma;

        curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
        curvature_merged_temp=curvature_merged_noise;
        curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
        validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
        curvature_merged_noise(validRegion)=curvature_temp(validRegion);
    end

end

%% post process


if normalizationMethod == "Noise"
    SeedRegion=curvature_merged_noise<0;
    curvature_merged(SeedRegion)=min(curvature_merged(SeedRegion),-1e-5);
    curvature_merged(~SeedRegion)=max(curvature_merged(~SeedRegion),1e-5);
else
    SeedCandidate=curvature_merged<0;
    invalidSeed=removeLargeCC(SeedCandidate,1);
    curvature_merged(invalidSeed)=1e-5;
    curvature_merged_noise=[];
end

end