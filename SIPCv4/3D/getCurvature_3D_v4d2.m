function curvature=getCurvature_3D_v4d2(dat,smFactor)
%get 3D principal curvatrue of 3D data with AUC normalization, get the
%noise level id map, v2.1.
%
% Don't directly use this function.
% This function should be used by PrcplCrvtr_scaleInvariant_2D_v2d1
%
% input:    dat:                3D input data
%           smFactor:           the Gaussian smooth filter std
%                               relationship
% output:   curvature:          2D principal curvature for 3D data
% 
% 10/20/2022 by Wei Zheng 

%% get curvature
L=ceil(smFactor*3)*2+9;
hrow = images.internal.createGaussianKernel(smFactor(1), L(1));
hcol = images.internal.createGaussianKernel(smFactor(2), L(2))';
hslc = images.internal.createGaussianKernel(smFactor(3), L(3));
hslc = reshape(hslc, 1, 1, L(3));
GaussFltr = pagemtimes(hrow*hcol,hslc);

%% method 2
gradFltr_X=[0.5;0;-0.5];
gradFltr_Y=gradFltr_X';
gradFltr_Z=[0.5;0;-0.5];
gradFltr_Z =reshape(gradFltr_Z,1,1,[]);

% xx, yy, xy direction
GX=convn(GaussFltr,gradFltr_X);
GY=convn(GaussFltr,gradFltr_Y);
GZ=convn(gradFltr_Z,GaussFltr);

GXX=convn(GX,gradFltr_X);
GYY=convn(GY,gradFltr_Y);
GZZ=convn(gradFltr_Z,GZ);

GXX=GXX(5:end-4,:,:);
GYY=GYY(:,5:end-4,:);
GZZ=GZZ(:,:,5:end-4);

ratio_xx=sqrt(sum(GXX(:).^2));
ratio_yy=sqrt(sum(GYY(:).^2));
ratio_zz=sqrt(sum(GZZ(:).^2));
ratio_xy=sqrt(ratio_xx*ratio_yy);
ratio_xz=sqrt(ratio_xx*ratio_zz);
ratio_yz=sqrt(ratio_yy*ratio_zz);
%%

[xx, yy, zz, xy, xz, yz, ~] = Hessian3D_v4(gpuArray(dat),smFactor);
% [xx, yy, zz, xy, xz, yz, ~] = Hessian3D_v4(dat,smFactor);

xx=xx/ratio_xx;
xy=xy/ratio_xy;
yy=yy/ratio_yy;
zz=zz/ratio_zz;
xz=xz/ratio_xz;
yz=yz/ratio_yz;

curvature = cal_pc_3D(xx, yy, zz, xy, xz, yz);

end