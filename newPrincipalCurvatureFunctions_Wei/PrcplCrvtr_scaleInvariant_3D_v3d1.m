function curvature_merged=PrcplCrvtr_scaleInvariant_3D_v3d1(dat,smFactorLst)
%scale invariant principal curvature for 3D data, v3.1
% Detect 2D+3D curvature.
% This version is based on Noise normalization.
%
% input:    dat:                3D input data
%           smFactorLst:        vector of smooth factor
% output:   curvature_merged:   scale-invariant principal curvature
%
% 9/29/2022 by Wei Zheng

%% initialize
N_smNum=length(smFactorLst);

curvature_merged_xy=zeros(size(dat));
curvature_merged_z=zeros(size(dat));

%% iteratively get optimal curvature
for smCnt=1:N_smNum
    disp(smCnt);

    %% get XY direction principal curvature
    smFactor=smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v2d1(dat,smFactor);
    curvature_temp=curvature_temp*smFactor;

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged_xy;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged_xy(validRegion)=curvature_temp(validRegion);



    %% get XYZ direction principal curvature
    curvature_temp=getCurvature_3D_v2d2(dat,smFactor);
    curvature_temp=curvature_temp*smFactor;

    % find the optimal smooth factor
    curvature_temp(curvature_temp>0)=curvature_temp(curvature_temp>0)*2;
    curvature_merged_temp=curvature_merged_xy;
    curvature_merged_temp(curvature_merged_temp>0)=curvature_merged_temp(curvature_merged_temp>0)*2;
    validRegion=abs(curvature_temp)>abs(curvature_merged_temp);
    curvature_merged_z(validRegion)=curvature_temp(validRegion);



end

%% merge XY direction and Z direction curvature
curvature_merged=max(curvature_merged_xy,curvature_merged_z);

end