function newVid = tifplay(vid, segmask,maskclass,tipmask)

if nargin==1
    implay(vid);
    newVid = vid;
    return;
end
edgelevel = max(vid(:));
[h,w,t] = size(vid);
if t==1
    if strcmp(maskclass,'e')%edge
        newVid = zeros(h,w,3);
            tmpf = vid;
            tmpf(segmask) = edgelevel;
            newVid(:,:,1) = tmpf;
            newVid(:,:,2)= vid;
            newVid(:,:,3) = vid;
    end
    if strcmp(maskclass,'b')%edge
        newVid = zeros(h,w,3);

            tmpf = vid;
            tmpmask = segmask;
            B = bwboundaries(tmpmask);
            B = cat(1,B{:});
            tmpf((B(:,2)-1)*h+B(:,1)) = edgelevel;
            newVid(:,:,1) = tmpf;
            newVid(:,:,2) = vid;
            newVid(:,:,3) = vid;
    end
    if strcmp(maskclass,'l')%label
        newVid = zeros(h,w,3);
        tmpf = vid;
        numSeg = max(segmask(:));
        B = [];
        for i = 1:numSeg
            tmpB = bwboundaries(segmask==i);
            B = cat(1,B,tmpB{:});
        end
        
        tmpf((B(:,2)-1)*h+B(:,1)) = edgelevel;
        newVid(:,:,1) = tmpf;
        newVid(:,:,2) = vid;
        newVid(:,:,3) = vid;
    end
    if nargin==4% also have tip segmentation results

            tmpf2 = newVid(:,:,2);
            tmpmask = tipmask;
            B = bwboundaries(tmpmask);
            B = cat(1,B{:});
            tmpf2((B(:,2)-1)*h+B(:,1)) = edgelevel;
            newVid(:,:,2) = tmpf2;
            
            tmpf1 = newVid(:,:,1);
            tmpf1((B(:,2)-1)*h+B(:,1)) = edgelevel;
            newVid(:,:,1) = tmpf1;
    end
    imshow(newVid,'Border','tight');
    return;
end

if strcmp(maskclass,'e')%edge
    newVid = zeros(h,w,3,t);
    for i=1:t
        tmpf = vid(:,:,i);
        tmpf(segmask(:,:,i)) = edgelevel;
        newVid(:,:,1,i) = tmpf;
        newVid(:,:,2,i)= vid(:,:,i);
        newVid(:,:,3,i) = vid(:,:,i);
    end
end
if strcmp(maskclass,'b')%edge
    newVid = zeros(h,w,3,t);
    for i=1:t
        tmpf = vid(:,:,i);
        tmpmask = segmask(:,:,i);
        B = bwboundaries(tmpmask);
        B = cat(1,B{:});
        tmpf((B(:,2)-1)*h+B(:,1)) = edgelevel;
        newVid(:,:,1,i) = tmpf;
        newVid(:,:,2,i) = vid(:,:,i);
        newVid(:,:,3,i) = vid(:,:,i);
    end
end
if strcmp(maskclass,'l')%label
    newVid = zeros(h,w,3,t);
    for i=1:t
        tmpf = vid(:,:,i);
        numSeg = max(segmask(:));
        B = [];
        for j = 1:numSeg
            tmpB = bwboundaries(segmask==j);
            B = cat(1,B,tmpB{:});
        end
        tmpf((B(:,2)-1)*h+B(:,1)) = edgelevel;
        newVid(:,:,1,i) = tmpf;
        newVid(:,:,2,i) = vid(:,:,i);
        newVid(:,:,3,i) = vid(:,:,i);
    end
end
if nargin==4% also have tip segmentation results
    for i=1:t
        tmpf2 = newVid(:,:,2,i);
        tmpmask = tipmask(:,:,i);
        B = bwboundaries(tmpmask);
        B = cat(1,B{:});
        tmpf2((B(:,2)-1)*h+B(:,1)) = edgelevel;
        newVid(:,:,2,i) = tmpf2;
        
        tmpf1 = newVid(:,:,1,i);
        tmpf1((B(:,2)-1)*h+B(:,1)) = edgelevel;
        newVid(:,:,1,i) = tmpf1;

    end
end
implay(newVid);
end