function [curvature_merged,curvature_all,FGmap]=PrcplCrvtr_scaleInvariant_3D_v4d6(dat,smFactorLst,zRatio,BG)
%scale invariant principal curvature for 3D data, v3.1
% Detect 2D+3D curvature.
% This version is based on Noise normalization.
%
% input:    dat:                3D input data
%           smFactorLst:        vector of smooth factor
% output:   curvature_merged:   scale-invariant principal curvature
%
% 9/29/2022 by Wei Zheng

% dat=randn(300,300,300);BG=true(size(dat));
dat=single(dat);
%% initialize
N_smNum=length(smFactorLst);
curvature_all=zeros([size(dat) N_smNum],class(dat));
sigmaLst=zeros(1,N_smNum);
muLst=zeros(1,N_smNum);
%% iteratively get optimal curvature
for smCnt=1:N_smNum
    disp(smCnt);
    smFactor=[1 1 1/zRatio]*smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v4d2(dat,smFactor);
    [~,sigmaLst(smCnt),muLst(smCnt)]=PCThreshold(curvature_temp,BG,smFactor);
    curvature_all(:,:,:,smCnt)=curvature_temp;
end
curvature_all=(curvature_all-mean(muLst))/mean(sigmaLst);

%%
zThres=4;
[curvature_merged,Imax] = max(curvature_all,[],4);
invalidRegion=false(size(curvature_all));
for smCnt=1:N_smNum
    invalidRegion(:,:,:,smCnt)=Imax<smCnt;
end
curvature_all(invalidRegion)=nan;
curvature_merged2 = min(curvature_all,[],4);
validRegion=curvature_merged2<-abs(zThres);
curvature_merged(validRegion)=curvature_merged2(validRegion);

FGmap = min(curvature_all,[],4)<-abs(zThres);

end