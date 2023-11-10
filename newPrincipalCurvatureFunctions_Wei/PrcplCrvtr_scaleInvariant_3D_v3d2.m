function curvature_merged=PrcplCrvtr_scaleInvariant_3D_v3d2(dat,smFactorLst)
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
curvature_merged_xy=zeros(size(dat),class(dat));
curvature_merged_z=zeros(size(dat),class(dat));
%% iteratively get optimal curvature
for smCnt=1:N_smNum
    disp(smCnt);
    tic;

    %% get XY direction principal curvature
    smFactor=smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v2d5(dat,smFactor);

    curvature_temp=gpuArray(curvature_temp);
    curvature_temp=curvature_temp*smFactor;

    % find the optimal smooth factor
    positiveRegion1=curvature_temp>0;
    curvature_temp(positiveRegion1)=curvature_temp(positiveRegion1)*2;
    curvature_merged_temp=gpuArray(curvature_merged_xy);
    positiveRegion2=curvature_merged_temp>0;
    curvature_merged_temp(positiveRegion2)=curvature_merged_temp(positiveRegion2)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged_xy(validRegion)=curvature_temp(validRegion);

    clear curvature_temp curvature_merged_temp positiveRegion1 positiveRegion2


    %% get XYZ direction principal curvature
    curvature_temp=getCurvature_3D_v2d6(dat,smFactor);

    curvature_temp=gpuArray(curvature_temp);
    curvature_temp=curvature_temp*smFactor;

    % find the optimal smooth factor
    positiveRegion1=curvature_temp>0;
    curvature_temp(positiveRegion1)=curvature_temp(positiveRegion1)*2;
    curvature_merged_temp=gpuArray(curvature_merged_z);
    positiveRegion2=curvature_merged_temp>0;
    curvature_merged_temp(positiveRegion2)=curvature_merged_temp(positiveRegion2)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged_z(validRegion)=curvature_temp(validRegion);

    clear curvature_temp curvature_merged_temp positiveRegion1 positiveRegion2

    toc;


end
%% merge XY direction and XYZ direction curvature
% curvature_merged=double(curvature_merged_xy+curvature_merged_z)/2;
curvature_merged=double(max(curvature_merged_xy,curvature_merged_z));

end