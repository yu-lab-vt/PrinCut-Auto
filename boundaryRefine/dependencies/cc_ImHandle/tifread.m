function ImStack = tifread(impath,crop,imnum)
% read a tif file
% impath: tif path e.g. 'C:\\a.tif'
% crop:
% imnum: specify the frame that want to read
% ImStack is h*w*#frames double
% contact: ccwang@vt.edu
info = imfinfo(impath);
num_images = numel(info);
if nargin<2
    crop = [];
end
org_h = info(1).Height;
org_w = info(1).Width;
if ~isempty(crop)
    new_size = round([org_h,org_w]*crop);
    new_h = new_size(1);
    new_w = new_size(2);
    if info(1).BitDepth==24
        ImStack = zeros(new_h,new_w,3,num_images);
    else
        ImStack = zeros(new_h,new_w,num_images);
    end

else
    if info(1).BitDepth==24
        ImStack = zeros(org_h,org_w,3,num_images);
    else
        ImStack = zeros(org_h,org_w,num_images);
    end


end
if nargin<3
    if info(1).BitDepth==24
        for i = 1:num_images
            Im = imread(impath,i);
            if ~isempty(crop)
                ImStack(:,:,:,i) = double(imresize(Im,new_h,new_w));
            else
                ImStack(:,:,:,i) = double(Im);
            end
        end
    else
        for i = 1:num_images
            Im = imread(impath,i);
            if ~isempty(crop)
                ImStack(:,:,i) = double(imresize(Im,new_h,new_w));
            else
                ImStack(:,:,i) = double(Im);
            end
        end
    end
else
    Im = imread(impath,imnum);
    if ~isempty(crop)
        ImStack = double(imresize(Im,new_h,new_w));
    else
        ImStack = double(Im);
    end
end

end