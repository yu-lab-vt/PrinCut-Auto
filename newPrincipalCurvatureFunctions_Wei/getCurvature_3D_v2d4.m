function curvature=getCurvature_3D_v2d4(dat,smFactor)
%get 3D principal curvatrue of 3D data with AUC normalization, get the
%noise level id map, v2.1.
%
% Don't directly use this function.
% This function should be used by PrcplCrvtr_scaleInvariant_2D_v2d1
%
% input:    dat:                3D input data
%           smFactor:           the Gaussian smooth filter std
%           varFitPara.minVal:  min intensity of intensity noise variance
%                               relationship
%           varFitPara.unit:    unit of intensity of intensity noise variance
%                               relationship
% output:   curvature:          2D principal curvature for 3D data
%           sigmaIdMap:         the Id map of intensity noise variance
%                               relationship
% 
% 9/29/2022 by Wei Zheng 

%% get curvature
L=ceil(smFactor*3);
SZ_smFltr=L*2+1;
GaussFltr=fspecial('gaussian',SZ_smFltr,smFactor);

% parameters
gradFltr_X=[0.5;0;-0.5];
% gradFltr_Y=gradFltr_X';
% gradFltr_Z=[0.5;0;-0.5];
% gradFltr_Z =reshape(gradFltr_Z,1,1,[]);

% xx, yy, xy direction
GX=convn(GaussFltr,gradFltr_X);
% GY=convn(GaussFltr,gradFltr_Y);
% GZ=convn(gradFltr_Z,GaussFltr);

GXX=convn(GX,gradFltr_X);
% GXY=convn(GX,gradFltr_Y);
% GYY=convn(GY,gradFltr_Y);
% GZZ=convn(gradFltr_Z,GZ);
% GXZ=convn(GX,gradFltr_Z);
% GYZ=convn(GY,gradFltr_Z);

ratio=sum(abs(GXX(:)));

[xx, yy, zz, xy, xz, yz, ~] = Hessian3D(dat/ratio,[smFactor smFactor 0]);

% xx=xx/ratio;
% xy=xy/ratio;
% yy=yy/ratio;
% zz=zz/ratio;
% xz=xz/ratio;
% yz=yz/ratio;

curvature = cal_pc_3D(xx, yy, zz, xy, xz, yz);

end