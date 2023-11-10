function [maxEig,ridges] = ridgefilt(img,sigma)
    % [ridges,maxEig] = ridgefilt( img,L,sigma,alpha )
    %
    % detects ridges in a 2D image "img" via eigenvalues of local Hessian
    % matricies for each pixel. The Hessian describes the "ridge" vs.
    % "valley" structure from the local gradients of the pixels.
    %
    % Inputs:
    %   img:
    %       2D image of any type
    %
    %   L:
    %       the size (in pixels) of the gaussian kernel used for computing
    %       smoothg gradients 
    %   
    %   sigma:
    %       the SD of the gaussian, which determines the spatial frequency
    %       for the convolution
    %
    %   alpha:
    %       the quantile (as a fraction) for thresholding. Ridges are
    %       refined by thresholding the maxEig matrix above the quantile
    %       specified by alpha
    %
    % By Jordan Sorokin, 4/20/2018
    
    % create gaussian kernel and its first and second derivatives
    
    L=6*sigma+1;
    g = fspecial( 'gaussian',L,sigma);
    [gx,gy] = gradient( g );
    [gxx,gxy] = gradient( gx );
    [~,gyy] = gradient( gy );
    
    % convolve the original image with gx, gy, gxx, gxy, and gyy to get
    % derivatives of each pixel
    rx = conv2( img,gx,'same' );
    ry = conv2( img,gy,'same' );
    rxx = conv2( img,gxx,'same' );
    rxy = conv2( img,gxy,'same' );
    ryy = conv2( img,gyy,'same' );
    
    % loop over pixels and compute the hessian. Then find eigenvalues of this
    % hessian matrix and determine if it is a ridge (1) or valley (-1)
    [n,m] = size( img );
    N = n*m;
    maxEig = zeros( n,m,class( img ) );
    ridges = zeros( n,m );
    
    for i = 1:N
        H = [rxx(i),rxy(i);
             rxy(i),ryy(i)];

        [v,e] = eig( H );
        e = diag( e );
        [maxEig(i),idx] = max( abs( e ) );
        
        % compute the variable "t" for determining if the directional
        % derivative vanishes at this pixel i
        t = -[rx(i),ry(i)] * v(:,idx) / (rxx(i)*v(1,idx)^2 + 2*rxy(i)*v(1,idx)*v(2,idx) + ryy(i)*v(2,idx)^2);
        ridges(i) = t;
    end
    
end