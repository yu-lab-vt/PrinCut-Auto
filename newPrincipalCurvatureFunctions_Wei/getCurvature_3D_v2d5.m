function curvature=getCurvature_3D_v2d5(dat,smFactor)
%get 2D principal curvatrue of 3D data with AUC normalization, get the
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
L=round(smFactor*3);
GaussFltr = fspecial( 'gaussian',L*2+1,smFactor);

gradFltr_X=[0.5;0;-0.5];
% gradFltr_Y=gradFltr_X';

GX=conv2(GaussFltr,gradFltr_X);
% GY=conv2(GaussFltr,gradFltr_Y);
GXX=conv2(GX,gradFltr_X);
% GXY=conv2(GX,gradFltr_Y);
% GYY=conv2(GY,gradFltr_Y);
ratio=sum(abs(GXX(:)));

[xx, yy, xy, ~] = Hessian2D(gpuArray(dat),smFactor);

xx=xx/ratio;
xy=xy/ratio;
yy=yy/ratio;

curvature=cal_pc_2d(xx,yy,xy);

end