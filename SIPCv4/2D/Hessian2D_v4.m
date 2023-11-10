function [Dxx, Dyy, Dxy, F] = Hessian2D_v4(Volume,Sigma)

% F=imgaussfilt(Volume,Sigma,'Padding','replicate');

F=imgaussian_v4(Volume,Sigma);

Dy=gradient3(F,'y');
Dyy=gather(gradient3(Dy,'y'));
clear Dy;

Dx=gradient3(F,'x');
Dxx=gather(gradient3(Dx,'x'));
Dxy=gather(gradient3(Dx,'y'));
clear Dx;