function [Dxx, Dyy, Dzz, Dxy, Dxz, Dyz, F] = Hessian3D(Volume,Sigma)
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
if nargin < 2, Sigma = 1; end

if length(Sigma)==1
    if(Sigma>0)
        F=imgaussian(Volume,Sigma);
    else
        F=Volume;
    end
else
    if Sigma(end) == 0
        F = Volume * 0;
        for i=1:size(F,3)
            F(:,:,i) = imgaussian(Volume(:,:,i), Sigma(1));
        end
    elseif length(Sigma) == 2
        F = imgaussfilt3(Volume,[Sigma(1), Sigma(1), Sigma(2)]);
    elseif length(Sigma) == 3
        F = imgaussfilt3(Volume,[Sigma(1), Sigma(2), Sigma(3)]);
    else
        F=Volume;
    end
end
% Create first and second order diferentiations
F=gpuArray(F);
Dz=gradient3(F,'z');
Dzz=gather(gradient3(Dz,'z'));
clear Dz;

Dy=gradient3(F,'y');
Dyy=gather(gradient3(Dy,'y'));
Dyz=gather(gradient3(Dy,'z'));
clear Dy;

Dx=gradient3(F,'x');
Dxx=gather(gradient3(Dx,'x'));
Dxy=gather(gradient3(Dx,'y'));
Dxz=gather(gradient3(Dx,'z'));
clear Dx;

