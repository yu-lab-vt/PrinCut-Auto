function [curvature_merged,curvature_all]=PrcplCrvtr_scaleInvariant_3D_v4d4(dat,smFactorLst,zRatio,BG)
%scale invariant principal curvature for 3D data, v3.1
% Detect 2D+3D curvature.
% This version is based on Noise normalization.
%
% input:    dat:                3D input data
%           smFactorLst:        vector of smooth factor
% output:   curvature_merged:   scale-invariant principal curvature
%
% 9/29/2022 by Wei Zheng

% dat=gpuArray(dat);
dat=single(dat);
zThres=2;

%% initialize
N_smNum=length(smFactorLst);
curvature_merged=zeros(size(dat),class(dat));
curvature_all=zeros([size(dat) N_smNum],class(dat));
%% iteratively get optimal curvature
for smCnt=1:N_smNum
    disp(smCnt);
    tic;

    %% get XY direction principal curvature
    smFactor=[1 1 1/zRatio]*smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v4d2(dat,smFactor);

    PC_norm=PCThreshold(curvature_temp,BG,smFactor);

    curvature_all(:,:,:,smCnt)=PC_norm;

    % find the optimal smooth factor
    validRegion1=abs(PC_norm)>zThres;
    validRegion2=abs(PC_norm)>abs(curvature_merged);
    validRegion3=(PC_norm.*curvature_merged)>=0;
    validRegion=validRegion1&validRegion2&validRegion3;
    curvature_merged(validRegion)=PC_norm(validRegion);
    toc;

end
curvature_merged=double(curvature_merged);

end