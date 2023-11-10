function I=imgaussian_v4(I,sigma)
% IMGAUSSIAN filters an 1D, 2D color/greyscale or 3D image with an 
% Gaussian filter. This function uses for filtering IMFILTER or if 
% compiled the fast  mex code imgaussian.c . Instead of using a 
% multidimensional gaussian kernel, it uses the fact that a Gaussian 
% filter can be separated in 1D gaussian kernels.
%
% J=IMGAUSSIAN(I,SIGMA,SIZE)
%
% inputs,
%   I: The 1D, 2D greyscale/color, or 3D input image with 
%           data type Single or Double
%   SIGMA: The sigma used for the Gaussian kernel
%   SIZE: Kernel size (single value) (default: sigma*6)
% 
% outputs,
%   J: The gaussian filtered image
%
% note, compile the code with: mex imgaussian.c -v
%
% example,
%   I = im2double(imread('peppers.png'));
%   figure, imshow(imgaussian(I,10));
% 
% Function is written by D.Kroon University of Twente (September 2009)
if(sigma>0)
    % Filter each dimension with the 1D Gaussian kernels\
    if(length(sigma)==1)
        L=ceil(sigma*3)*2+1;
        Hx = images.internal.createGaussianKernel(sigma(1), L(1));
        I=imfilter(I,Hx, 'same' ,'replicate');
    elseif(length(sigma)==2)
        L=ceil(sigma*3)*2+1;
        Hx = images.internal.createGaussianKernel(sigma(1), L(1));
        Hy = images.internal.createGaussianKernel(sigma(2), L(2))';
        I=imfilter(imfilter(I,Hx, 'same' ,'replicate'),Hy, 'same' ,'replicate');
    elseif(length(sigma)==3)
        L=ceil(sigma*3)*2+1;
        Hx = images.internal.createGaussianKernel(sigma(1), L(1));
        Hy = images.internal.createGaussianKernel(sigma(2), L(2))';
        Hz = images.internal.createGaussianKernel(sigma(3), L(3));
        Hz = reshape(Hz, 1, 1, L(3));
        I=imfilter(imfilter(imfilter(I,Hx, 'same' ,'replicate'),Hy, 'same' ,'replicate'),Hz, 'same' ,'replicate');
    end
end