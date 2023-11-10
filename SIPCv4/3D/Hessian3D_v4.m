function [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz, F] = Hessian3D_v4(Volume,Sigma)
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

% F = imgaussfilt3(Volume,[Sigma(1), Sigma(2), Sigma(3)],'Padding','replicate');
F=imgaussian_v4(Volume,Sigma);
clear Volume;
% Create first and second order diferentiations
Dz=gradient3(F,'z');
Dzz=gather(gradient3(Dz,'z'));
% Dzz=gradient3(Dz,'z');
clear Dz;

Dy=gradient3(F,'y');
Dyy=gather(gradient3(Dy,'y'));
Dyz=gather(gradient3(Dy,'z'));
% Dyy=gradient3(Dy,'y');
% Dyz=gradient3(Dy,'z');
clear Dy;

Dx=gradient3(F,'x');
Dxx=gather(gradient3(Dx,'x'));
Dxy=gather(gradient3(Dx,'y'));
Dxz=gather(gradient3(Dx,'z'));
% Dxx=gradient3(Dx,'x');
% Dxy=gradient3(Dx,'y');
% Dxz=gradient3(Dx,'z');
clear Dx;