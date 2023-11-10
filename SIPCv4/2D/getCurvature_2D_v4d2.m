function curvature=getCurvature_2D_v4d2(dat,smFactor)
%get 2D principal curvatrue of 3D data with AUC normalization, get the
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
% 9/29/2022 by Wei Zheng 

%% get curvature
if length(smFactor)==1
    smFactor(2)=smFactor(1);
end

L=round(smFactor*6)+1;
hrow = images.internal.createGaussianKernel(smFactor(1), L(1));
hcol = images.internal.createGaussianKernel(smFactor(2), L(2))';
GaussFltr=hrow*hcol;

%% method 1
gradFltr_X=[0.5;0;-0.5];
GX=conv2(GaussFltr,gradFltr_X);
GXX=conv2(GX,gradFltr_X);
ratio=sum(abs(GXX(:)))*(smFactor(1)^2);
ratio_xx=1/(smFactor(1)^2);
ratio_yy=1/(smFactor(2)^2);
ratio_xy=1/(smFactor(1)*smFactor(2));

%% method 2
% gradFltr_X=[0.5;0;-0.5];
% gradFltr_Y=gradFltr_X';
% GX=conv2(GaussFltr,gradFltr_X);
% GY=conv2(GaussFltr,gradFltr_Y);
% GXX=conv2(GX,gradFltr_X);
% GYY=conv2(GY,gradFltr_Y);
% ratio_xx=sum(abs(GXX(:)));
% ratio_yy=sum(abs(GYY(:)));
% ratio_xy=sqrt(ratio_xx*ratio_yy);

%%
[xx, yy, xy, ~] = Hessian2D_v4(gpuArray(dat),smFactor);

xx=xx/ratio_xx;
yy=yy/ratio_yy;
xy=xy/ratio_xy;

curvature=cal_pc_2d(xx,yy,xy);

end