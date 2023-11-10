function curvature=getCurvature_3D_v4d1(dat,smFactor)
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
L=round(smFactor*6)+1;
hrow = images.internal.createGaussianKernel(smFactor(1), L(1));
hcol = images.internal.createGaussianKernel(smFactor(2), L(2))';
hslc = images.internal.createGaussianKernel(smFactor(3), L(3));
hslc = reshape(hslc, 1, 1, L(3));
GaussFltr = pagemtimes(hrow*hcol,hslc);

%% method 1
% gradFltr_X=[0.5;0;-0.5];
% GX=convn(GaussFltr,gradFltr_X);
% GXX=convn(GX,gradFltr_X);
% 
% ratio=sum(abs(GXX(:)))*(smFactor(1)^2);
% ratio_xx=ratio/(smFactor(1)^2);
% ratio_yy=ratio/(smFactor(2)^2);
% ratio_zz=ratio/(smFactor(3)^2);
% ratio_xy=ratio/(smFactor(1)*smFactor(2));
% ratio_xz=ratio/(smFactor(1)*smFactor(3));
% ratio_yz=ratio/(smFactor(2)*smFactor(3));

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

ratio_xx=sum(abs(GXX(:)));
ratio_yy=sum(abs(GYY(:)));
ratio_zz=sum(abs(GZZ(:)));
ratio_xy=sqrt(ratio_xx*ratio_yy);
ratio_xz=sqrt(ratio_xx*ratio_zz);
ratio_yz=sqrt(ratio_yy*ratio_zz);
%%

[xx, yy, zz, xy, xz, yz, ~] = Hessian3D_v4(gpuArray(dat),smFactor);

xx=xx/ratio_xx;
xy=xy/ratio_xy;
yy=yy/ratio_yy;
zz=zz/ratio_zz;
xz=xz/ratio_xz;
yz=yz/ratio_yz;

curvature = cal_pc_3D(xx, yy, zz, xy, xz, yz);

end