function curvature=getCurvature_3D_v2d6(dat,smFactor)
%get z direction curvatrue of 3D data with AUC normalization, get the
%noise level id map, v2.2.
%
% Don't directly use this function.
% This function should be used by PrcplCrvtr_scaleInvariant_2D_v2d1
%
% input:    dat:                3D input data
%           smFactor:           the Gaussian smooth filter std
% output:   curvature:          2D principal curvature for 3D data
% 
% 10/4/2022 by Wei Zheng 

%% get curvature
% L=ceil(smFactor*3);
% SZ_smFltr=L*2+1;
% GaussFltr=fspecial('gaussian',SZ_smFltr,smFactor);
% % parameters
% gradFltr_X=[0.5;0;-0.5];
% GX=convn(GaussFltr,gradFltr_X);
% GXX=convn(GX,gradFltr_X);
% ratio=sum(abs(GXX(:)));

dat=gpuArray(dat);

F = dat * 0;
for i=1:size(F,3)
    F(:,:,i) = imgaussian(dat(:,:,i), smFactor);
end
Dz=gradient3(F,'z');
Dzz=(gradient3(Dz,'z'));
curvature=Dzz;