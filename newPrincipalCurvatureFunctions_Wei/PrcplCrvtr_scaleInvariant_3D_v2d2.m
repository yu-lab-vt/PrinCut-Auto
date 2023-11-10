function [curvature_merged,curvature_merged_noise,curvature_merged_z]=PrcplCrvtr_scaleInvariant_3D_v2d2(dat,smFactorLst,BG,varFit,normalizationMethod)
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

if nargin == 4 || normalizationMethod ~= "AUC"
    normalizationMethod = "Noise";
end

varFitPara.minVal=varFit(1,1);
varFitPara.unit=varFit(2,1)-varFit(1,1);
varFitPara.sigmaLst=sqrt(varFit(:,2));
N_smNum=length(smFactorLst);


curvature_merged_xy=zeros(size(dat));
curvature_merged_z=zeros(size(dat));

if normalizationMethod == "Noise"
    curvature_merged_xy_noise=zeros(size(dat));
    curvature_merged_z_noise=zeros(size(dat));
end

%% iteratively get optimal curvature
for smCnt=1:N_smNum
    %% get XY direction principal curvature
    smFactor=smFactorLst(smCnt);
    [curvature_temp,sigmaIdMap]=getCurvature_3D_v2d1(dat,smFactor,varFitPara);

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged_xy;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged_xy(validRegion)=curvature_temp(validRegion);

    if normalizationMethod == "Noise"
        curvature_null=curvature_temp(BG);
        sigmaMap=varFitPara.sigmaLst(sigmaIdMap);
        null_mu=sigmaMap*mean(curvature_null)/varFitPara.sigmaLst(1);
        null_sigma=sigmaMap*std(curvature_null)/varFitPara.sigmaLst(1);
        curvature_temp=(curvature_temp-null_mu)./null_sigma;

        curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
        curvature_merged_temp=curvature_merged_xy_noise;
        curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
        validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
        curvature_merged_xy_noise(validRegion)=curvature_temp(validRegion);
    end

    %% get Z direction principal curvature
    curvature_temp=getCurvature_3D_v2d2(dat,smFactor);

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged_xy;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged_z(validRegion)=curvature_temp(validRegion);

    if normalizationMethod == "Noise"
        curvature_null=curvature_temp(BG);
        sigmaMap=varFitPara.sigmaLst(sigmaIdMap);
        null_mu=sigmaMap*mean(curvature_null)/varFitPara.sigmaLst(1);
        null_sigma=sigmaMap*std(curvature_null)/varFitPara.sigmaLst(1);
        curvature_temp=(curvature_temp-null_mu)./null_sigma;
        
        curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
        curvature_merged_temp=curvature_merged_z_noise;
        curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
        validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
        curvature_merged_z_noise(validRegion)=curvature_temp(validRegion);
    end
end

%% merge XY direction and Z direction curvature
curvature_merged=max(curvature_merged_xy,curvature_merged_z);

if normalizationMethod == "Noise"
    curvature_merged_noise=max(curvature_merged_xy_noise,curvature_merged_z_noise);

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