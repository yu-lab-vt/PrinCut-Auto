function curvature=getCurvature_3D_v2d2(dat,smFactor)
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
L=round(smFactor*3);
GaussFltr = fspecial( 'gaussian',L*2+1,smFactor);
gradFltr_Z=[0.5;0;-0.5];
gradFltr_Z =reshape(gradFltr_Z,1,1,[]);
GZ=convn(gradFltr_Z,GaussFltr);
GZZ=convn(gradFltr_Z,GZ);
GZZ=GZZ./sum(abs(GZZ(:)));


SZ_pad=(size(GZZ)-1)/2;
dat_pad=padarray(dat,SZ_pad,'replicate','both');

zz=convn(dat_pad,GZZ);
SZ_conv=SZ_pad*2;

curvature=zz(  1+SZ_conv(1):end-SZ_conv(1),...
        1+SZ_conv(2):end-SZ_conv(2),....
        1+SZ_conv(3):end-SZ_conv(3));

end