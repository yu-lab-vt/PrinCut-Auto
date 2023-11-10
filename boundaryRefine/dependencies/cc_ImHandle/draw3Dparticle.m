function [orgIm3d, label_pix] = draw3Dparticle(orgIm3d,  particleYXZ, particleSize, cl)
% draw sphere on a 3D image, cl is the color specified
% orgIm3D: an image of h*w*3
if nargin<4 % color is not specified
    maxInt = max(orgIm3d(:));
    cl = [1 0 0]*maxInt; % red particle
end
linePts = findValpts(particleYXZ, particleSize);
[h,w, c,z] = size(orgIm3d); % c=3
if c~=3
    error('Input is not a color image');
end
zIdx = round(linePts(:, 3));

label_pix = cell(3,1);
for i=1:z
    tmpY = round(linePts(zIdx==i, 1));
    tmpX = round(linePts(zIdx==i, 2));
    valIdx = tmpY>0 & tmpX>0 & tmpY<=h & tmpX<=w;
    tmpY = tmpY(valIdx);
    tmpX = tmpX(valIdx);
%     ptIdx = sub2ind([h,w], tmpY,tmpX);
    if cl(1)>0
        ptIdx = sub2ind(size(orgIm3d), tmpY,tmpX,...
            tmpY*0+1, tmpY*0+i);
        orgIm3d(ptIdx) = cl(1);
        label_pix{1} = cat(1, label_pix{1}, ptIdx);
%         r = orgIm3d(:,:,1,i);
%         r(ptIdx) = cl(1);
%         orgIm3d(:,:,1,i) = r;
    end
    if cl(2)>0
        ptIdx = sub2ind(size(orgIm3d), tmpY,tmpX,...
            tmpY*0+2, tmpY*0+i);
        orgIm3d(ptIdx) = cl(2);
        label_pix{2} = cat(1, label_pix{2}, ptIdx);

%         g = orgIm3d(:,:,2,i);
%         g(ptIdx) = cl(2);
%         orgIm3d(:,:,2,i) = g;
    end
    if cl(3)>0
        ptIdx = sub2ind(size(orgIm3d), tmpY,tmpX,...
            tmpY*0+3, tmpY*0+i);
        orgIm3d(ptIdx) = cl(3);
        label_pix{3} = cat(1, label_pix{3}, ptIdx);
%         b = orgIm3d(:,:,3,i);
%         b(ptIdx) = cl(3);
%         orgIm3d(:,:,3,i) = b;
    end
end
end

function pts = findValpts(curPt, linWidth)
    [X, Y, Z] = meshgrid(curPt(2)-linWidth:curPt(2)+linWidth,curPt(1)-linWidth:curPt(1)+linWidth,curPt(3)-linWidth:curPt(3)+linWidth);
    distance = bsxfun(@minus, [Y(:), X(:), Z(:)], curPt);
    validPt = sqrt(sum(distance.^2, 2))<=linWidth;
    validPt = reshape(validPt, size(X));
    pts = [Y(validPt), X(validPt), Z(validPt)];
end