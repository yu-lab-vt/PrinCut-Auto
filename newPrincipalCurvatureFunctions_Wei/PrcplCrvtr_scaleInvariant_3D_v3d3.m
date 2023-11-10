function [curvature_merged,curvature_merged_xy,curvature_merged_z]=PrcplCrvtr_scaleInvariant_3D_v3d3(dat,smFactorLst)
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
curvature_merged_xy=-inf(size(dat),class(dat));
curvature_merged_z=curvature_merged_xy;
%% iteratively get optimal curvature
for smCnt=1:N_smNum
    disp(smCnt);
    tic;

    %% get XY direction principal curvature
    smFactor=smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v2d5(dat,smFactor);
    curvature_temp=curvature_temp*smFactor;

    % find the optimal smooth factor
    validRegion=curvature_temp>curvature_merged_xy;
    curvature_merged_xy(validRegion)=curvature_temp(validRegion);
    clear curvature_temp validRegion

    %% get XYZ direction principal curvature
    curvature_temp=getCurvature_3D_v2d6(dat,smFactor);
    curvature_temp=curvature_temp*smFactor;

    % find the optimal smooth factor
    validRegion=curvature_temp>curvature_merged_z;
    curvature_merged_z(validRegion)=curvature_temp(validRegion);
    clear curvature_temp validRegion
    toc;

end
%% merge XY direction and XYZ direction curvature
% curvature_merged=double(curvature_merged_xy+curvature_merged_z)/2;
% curvature_merged_xy=curvature_merged_xy./max(curvature_merged_xy,[],"all");
% curvature_merged_z=curvature_merged_z./max(curvature_merged_z,[],"all");
curvature_merged=double(max(curvature_merged_xy,curvature_merged_z));

end