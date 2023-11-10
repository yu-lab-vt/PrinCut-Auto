function [Dxx, Dyy, Dxy, F] = Hessian2D(Volume,Sigma)
%  This function Hessian3D filters the image with an Gaussian kernel
%  followed by calculation of 2nd order gradients, which aprroximates the
%  2nd order derivatives of the image.
% 
% [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz] = Hessian3D(I,Sigma)
% 
% inputs,
%   I : The image volume, class preferable double or single
%   Sigma : The sigma of the gaussian kernel used. If sigma is zero
%           no gaussian filtering.
%
% outputs,
%   Dxx, Dyy, Dzz, Dxy, Dxz, Dyz: The 2nd derivatives
%
% Function is written by D.Kroon University of Twente (June 2009)
% defaults

F = Volume * 0;
for i=1:size(F,3)
    F(:,:,i) = imgaussian(Volume(:,:,i), Sigma);
end

% F=gpuArray(F);
Dy=gradient3(F,'y');
Dyy=gather(gradient3(Dy,'y'));
clear Dy;

Dx=gradient3(F,'x');
Dxx=gather(gradient3(Dx,'x'));
Dxy=gather(gradient3(Dx,'y'));
clear Dx;

