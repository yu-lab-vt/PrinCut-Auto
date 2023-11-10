function [curvature_merged,FGmap]=PrcplCrvtr_scaleInvariant_3D_v4d8(dat,smFactorLst,zRatio,BG)
%scale invariant principal curvature for 3D data, v3.1
% Detect 2D+3D curvature.
% This version is based on Noise normalization.
%
% input:    dat:                3D input data
%           smFactorLst:        vector of smooth factor
% output:   curvature_merged:   scale-invariant principal curvature
%
% 9/29/2022 by Wei Zheng

fprintf('Start curvature calculation! \n');
zThres=4;
dat=single(dat);
%% initialize
N_smNum=length(smFactorLst);
curvature_all=zeros([size(dat) N_smNum],class(dat));
sigmaLst=zeros(1,N_smNum);
muLst=zeros(1,N_smNum);
%% iteratively get optimal curvature
for smCnt=1:N_smNum
%     disp(smCnt);
%     tic;
    %% get XY direction principal curvature
    smFactor=[1 1 1/zRatio]*smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v4d2(dat,smFactor);
    [~,sigmaLst(smCnt),muLst(smCnt)]=PCThreshold(curvature_temp,BG,smFactor);
    curvature_all(:,:,:,smCnt)=curvature_temp;
%     toc;
end
curvature_all=(curvature_all-mean(muLst))/mean(sigmaLst);

%%
[curvature_merged2,Imin] = min(curvature_all,[],4);
BGmap=curvature_merged2>-abs(zThres);
Imin(BGmap)=N_smNum;
FGmap=~BGmap;
invalidRegion=false(size(curvature_all));
for smCnt=1:N_smNum
    invalidRegion(:,:,:,smCnt)=Imin<smCnt;
end
curvature_all(invalidRegion)=nan;
curvature_merged = max(curvature_all,[],4);

fprintf('End curvature calculation! \n');
end