function curvature=getCurvature_3D_v4d4(dat,smFactor)
%get 3D principal curvatrue of 3D data with AUC normalization, get the
%noise level id map, v2.1.
%
% Don't directly use this function.
% This function should be used by PrcplCrvtr_scaleInvariant_2D_v2d1
%
% input:    dat:                3D input data
%           smFactor:           the aussian smooth filter std
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

[xx, yy, zz, xy, xz, yz, ~] = Hessian3D_v5(gpuArray(dat),smFactor);


xx=xx/ratio_xx;
xy=xy/ratio_xy;
yy=yy/ratio_yy;
zz=zz/ratio_zz;
xz=xz/ratio_xz;
yz=yz/ratio_yz;

a = -(xx + yy + zz);
a = a(:);
b = -(yz.^2 + xy.^2 + xz.^2 - xx.*zz -yy.*zz -xx.*yy);
b = b(:);
c = -(xx.*yy.*zz + 2*xy.*yz.*xz - xx.*(yz.^2) - zz.*(xy.^2) - yy.*(xz.^2));
c = c(:);
clear xx yy zz xy xz yz

p = b - a.^2/3;
q = 2*(a.^3)/27 - (a.*b)/3 + c;
clear b c

curvature = zeros(size(dat));
p=min(p,-1e-9);
temp=3*q./(2*p).*sqrt(-3./p);
temp=min(max(temp,-1),1);
curvature(:) = 2/sqrt(3)*(sqrt(-p)).*cos(1/3.*acos(temp)) - a/3;

end