function [curvature,sigmaIdMap]=getCurvature_3D_v2d3(dat,smFactor,zRatio,varFitPara)
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
if isempty(zRatio)
    zRatio=1;
end

smFactor_z=smFactor/zRatio;
L=ceil(smFactor*3);
L_z=ceil(smFactor_z*3);
SZ_smFltr=[L L L_z]*2+1;
GaussFltr=fspecial3('gaussian',SZ_smFltr,[smFactor smFactor smFactor_z]);

% padding
SZ_pad=[L L L_z]+2;
dat_pad=padarray(dat,SZ_pad,'replicate','both');

% parameters
gradFltr_X=[0.5 1 0.5;0 0 0;-0.5 -1 -0.5];
gradFltr_Y=gradFltr_X';
gradFltr_Z=[1;0;-1];
gradFltr_Z =reshape(gradFltr_Z,1,1,[]);

% xx, yy, xy direction
GX=convn(GaussFltr,gradFltr_X);
GY=convn(GaussFltr,gradFltr_Y);
GXX=convn(GX,gradFltr_X);
GXY=convn(GX,gradFltr_Y);
GYY=convn(GY,gradFltr_Y);

GXX=GXX./sum(abs(GXX(:)));
GXY=GXY./sum(abs(GXY(:)));
GYY=GYY./sum(abs(GYY(:)));

SZ_conv=SZ_pad*2+[0 0 -2];

xx=convn(dat_pad,GXX);
xy=convn(dat_pad,GXY);
yy=convn(dat_pad,GYY);
xx=xx(1+SZ_conv(1):end-SZ_conv(1),1+SZ_conv(2):end-SZ_conv(2),1+SZ_conv(3):end-SZ_conv(3));
xy=xy(1+SZ_conv(1):end-SZ_conv(1),1+SZ_conv(2):end-SZ_conv(2),1+SZ_conv(3):end-SZ_conv(3));
yy=yy(1+SZ_conv(1):end-SZ_conv(1),1+SZ_conv(2):end-SZ_conv(2),1+SZ_conv(3):end-SZ_conv(3));

% zz direction
GZ=convn(gradFltr_Z,GaussFltr);
GZZ=convn(gradFltr_Z,GZ);

GZZ=GZZ./sum(abs(GZZ(:)));

SZ_conv=SZ_pad*2+[-2 -2 0];

zz=convn(dat_pad,GZZ);
zz=zz(  1+SZ_conv(1):end-SZ_conv(1),...
        1+SZ_conv(2):end-SZ_conv(2),....
        1+SZ_conv(3):end-SZ_conv(3));

% xz, yz dirrection
GXZ=convn(GX,gradFltr_Z);
GYZ=convn(GY,gradFltr_Z);
GXZ=GXZ./sum(abs(GXZ(:)));
GYZ=GYZ./sum(abs(GYZ(:)));

SZ_conv=SZ_pad*2+[-1 -1 -1];

xz=convn(dat_pad,GXZ);
yz=convn(dat_pad,GYZ);
xz=xz(1+SZ_conv(1):end-SZ_conv(1),1+SZ_conv(2):end-SZ_conv(2),1+SZ_conv(3):end-SZ_conv(3));
yz=yz(1+SZ_conv(1):end-SZ_conv(1),1+SZ_conv(2):end-SZ_conv(2),1+SZ_conv(3):end-SZ_conv(3));


curvature = cal_pc_3D(xx, yy, zz, xy, xz, yz);
%% get sigmaIdMap
if isempty(varFitPara)
    sigmaIdMap = [];
else
    G=convn(dat_pad,GaussFltr);
    SZ_conv=SZ_pad*2+[-2 -2 -2];
    G=G(1+SZ_conv(1):end-SZ_conv(1),1+SZ_conv(2):end-SZ_conv(2),1+SZ_conv(3):end-SZ_conv(3));
    sigmaIdMap = floor((G - varFitPara.minVal)./ varFitPara.unit) + 1;
    sigmaIdMap=min(max(sigmaIdMap,1),200);
end


end