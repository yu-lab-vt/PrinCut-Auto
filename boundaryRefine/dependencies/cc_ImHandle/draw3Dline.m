function [orgIm3d, label_pix] = draw3Dline(orgIm3d, headYXZ, tailYXZ, lineWidth, cl)
% draw line on a 3D image, cl is the color specified
% orgIm3D: an image of h*w*3
% headYXZ, tailYXZ: position of line start and end
if nargin<5 % color is not specified
    maxInt = max(orgIm3d(:));
    cl = [0 1 0]*maxInt; % green linkage
end
label_pix = cell(3,1);


stX = floor(min(headYXZ(2),tailYXZ(2)));
stY = floor(min(headYXZ(1),tailYXZ(1)));
stZ = floor(min(headYXZ(3),tailYXZ(3)));
endX = ceil(max(headYXZ(2),tailYXZ(2)));
endY = ceil(max(headYXZ(1),tailYXZ(1)));
endZ = ceil(max(headYXZ(3),tailYXZ(3)));

delta = headYXZ-tailYXZ;
[val, pos] = max(abs(delta));
if val<1
    return;
end
if pos==2
    pts = cell(endX-stX+1,1);
    for i=stX:endX
        lambda = (i-headYXZ(2))/delta(2);
        curPt = lambda*delta+headYXZ;
        pts{i} = findValpts(curPt, lineWidth);
    end
elseif pos==1
    pts = cell(endY-stY+1,1);
    for i=stY:endY
        lambda = (i-headYXZ(1))/delta(1);
        curPt = lambda*delta+headYXZ;
        pts{i} = findValpts(curPt, lineWidth);
    end
elseif pos==3
    pts = cell(endZ-stZ+1,1);
    for i=stZ:endZ
        lambda = (i-headYXZ(3))/delta(3);
        curPt = lambda*delta+headYXZ;
        pts{i} = findValpts(curPt, lineWidth);
    end
end
linePts = cat(1, pts{:});

[h,w, c,z] = size(orgIm3d); % c=3
if c~=3
    error('Input is not a color image');
end
zIdx = round(linePts(:, 3));
for i=1:z
    tmpY = round(linePts(zIdx==i, 1));
    tmpX = round(linePts(zIdx==i, 2));
    valIdx = tmpY>0 & tmpX>0 & tmpY<=h & tmpX<=w;
%     ptIdx = sub2ind([h,w], tmpY(valIdx),tmpX(valIdx));
%     if cl(1)>0
%         r = orgIm3d(:,:,1,i);
%         r(ptIdx) = cl(1);
%         orgIm3d(:,:,1,i) = r;
%     end
%     if cl(2)>0
%         g = orgIm3d(:,:,2,i);
%         g(ptIdx) = cl(2);
%         orgIm3d(:,:,2,i) = g;
%     end
%     if cl(3)>0
%         b = orgIm3d(:,:,3,i);
%         b(ptIdx) = cl(3);
%         orgIm3d(:,:,3,i) = b;
%     end
    
    tmpY = tmpY(valIdx);
    tmpX = tmpX(valIdx);
    if cl(1)>0
        ptIdx = sub2ind(size(orgIm3d), tmpY,tmpX,...
            tmpY*0+1, tmpY*0+i);
        orgIm3d(ptIdx) = cl(1);
        label_pix{1} = cat(1, label_pix{1}, ptIdx);
        %labelMap(ptIdx) = cl(1);
    end
    if cl(2)>0
        ptIdx = sub2ind(size(orgIm3d), tmpY,tmpX,...
            tmpY*0+2, tmpY*0+i);
        orgIm3d(ptIdx) = cl(2);
        label_pix{2} = cat(1, label_pix{2}, ptIdx);
        %labelMap(ptIdx) = cl(2);
    end
    if cl(3)>0
        ptIdx = sub2ind(size(orgIm3d), tmpY,tmpX,...
            tmpY*0+3, tmpY*0+i);
        orgIm3d(ptIdx) = cl(3);
        label_pix{3} = cat(1, label_pix{3}, ptIdx);
        %labelMap(ptIdx) = cl(3);
    end
end
end

function pts = findValpts(curPt, linWidth)
    [X, Y, Z] = meshgrid(curPt(2)-linWidth:curPt(2)+linWidth,curPt(1)-linWidth:curPt(1)+linWidth,curPt(3)-linWidth:curPt(3)+linWidth);
    distance = bsxfun(@minus, [Y(:), X(:), Z(:)], curPt);
    distance = sqrt(sum(distance.^2, 2));
    linWidth = max(min(distance), linWidth);
    validPt = distance<=linWidth;
    validPt = reshape(validPt, size(X));
    pts = [Y(validPt), X(validPt), Z(validPt)];
end