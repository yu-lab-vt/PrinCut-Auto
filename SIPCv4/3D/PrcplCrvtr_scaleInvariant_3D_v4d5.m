function [curvature_merged,curvature_all]=PrcplCrvtr_scaleInvariant_3D_v4d5(dat,smFactorLst,zRatio)
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
curvature_all=zeros([size(dat) N_smNum],class(dat));
%% iteratively get optimal curvature
for smCnt=1:N_smNum
    disp(smCnt);
    tic;

    %% get XY direction principal curvature
    smFactor=[1 1 1/zRatio]*smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v4d3(dat,smFactor);
    curvature_all(:,:,:,smCnt)=curvature_temp;

    % find the optimal smooth factor
    validRegion=curvature_temp>curvature_merged;
    curvature_merged(validRegion)=curvature_temp(validRegion);
    toc;

end
curvature_merged=double(curvature_merged);

end