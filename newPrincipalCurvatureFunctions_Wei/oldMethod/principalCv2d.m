function eig_all= principalCv2d(vid, sigma)
% use principle curvature to segment connected cells
% INPUT:
% vid: original 3d image data
% synId: regions detected by synQuant
% sigma: smoothness scale, (sigma of gaussian, isotropic)
% save_folder: the folder to save results
% OUTPUT:
% eig_all: eigen value of all the foreground voxels (maximum eigen value)
% overlay_cl: overlapping the foreground with the detected valid gaps (gaps
% mean the voxels with positive eigen value)

% contact: ccwang@vt.edu, 02/01/2020
fmap = [];
synId=zeros(size(vid));

[h,w,z] = size(synId);
% get 2nd order derivative  % x direction is horiztional and y is vertical
Dxx = zeros(size(synId));
Dyy = zeros(size(synId));
Dxy = zeros(size(synId));
Dyx = zeros(size(synId));
sm_vid = zeros(h,w,z);
for i=1:z
    im = vid(:,:,i);
    im = imgaussfilt(im,sigma);
    sm_vid(:,:,i) = im;
    [lx, ly] = gradient(im);
    [lxx,lyx] = gradient(lx);
    [lxy, lyy] = gradient(ly);
    Dxx(:,:,i) = lxx;
    Dyy(:,:,i) = lyy;
    Dxy(:,:,i) = lxy;
    Dyx(:,:,i) = lyx;
end

% test each connected component
eig_all = zeros(size(synId));
eig1 = zeros(size(synId));
if isempty(fmap)
    fmap = imdilate(synId>0, strel('sphere', 5));
end
% fmap = scale_image(sm_vid,0,255)>50;%

fmap = ones(size(fmap)); % if we cal all the voxes
s = regionprops3(fmap, {'VoxelIdxList'});

for i=1:numel(s.VoxelIdxList)%[3 47 76]%
    %disp(i);
    vox = s.VoxelIdxList{i};
    xx = Dxx(vox); yy = Dyy(vox);
    xy = Dxy(vox); yx = Dyx(vox);
    
    C = zeros(numel(s.VoxelIdxList{i}),2);
    parfor j=1:numel(s.VoxelIdxList{i})
        MM = [xx(j) xy(j);yx(j) yy(j)];
        [~,Eval] = eig(MM);
        dEval = diag(Eval);
        c = sort(dEval,'descend');
        C(j,:) = c';
    end
    eig_all(vox) = C(:,1);
   
end

end