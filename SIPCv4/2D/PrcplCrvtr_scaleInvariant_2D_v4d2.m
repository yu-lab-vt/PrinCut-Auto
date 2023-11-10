function curvature_merged=PrcplCrvtr_scaleInvariant_2D_v4d2(dat,smFactorLst,zRatio)
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

%% initialize
N_smNum=length(smFactorLst);
curvature_merged=-inf(size(dat),class(dat));
%% iteratively get optimal curvature
for smCnt=1:N_smNum
    disp(smCnt);
    tic;

    %% get XY direction principal curvature
    smFactor=[1/zRatio 1]*smFactorLst(smCnt);
    curvature_temp=getCurvature_2D_v4d2(dat,smFactor);
    curvature_temp=curvature_temp*smFactor(1);

    % find the optimal smooth factor
    validRegion=curvature_temp>curvature_merged;
    curvature_merged(validRegion)=curvature_temp(validRegion);
    toc;

end
curvature_merged=double(curvature_merged);

end