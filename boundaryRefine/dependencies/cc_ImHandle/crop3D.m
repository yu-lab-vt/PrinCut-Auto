function [vidOut, vIdx, yxz_edge_Flag, loc_org_xyz] = crop3D(vidIn, yxz, shift)
% crop a region from vidIn
%INPUT:
% vidIn: the vid to crop from
% yxz: different form. 1, n-by-1 or n-by-3 matix, which indicates the 
% overall voxel index; 2, TODO
% shift: (l+2*shift(1))*(w+2*shift(2))*(h+2*shift(shift(1)))

%OUTPUT:
% vidOut: the cropped region

% contact: ccwang@vt.edu
yxz_edge_Flag = false; % y, x, z
if ~iscell(vidIn)
    [h,w,z] = size(vidIn);
else % 3 cells for pre-frame, cur-frame, post-frame
    [h,w,z] = size(vidIn{2});
end


if size(yxz,2) ==1
    [yy,xx,zz] = ind2sub([h,w,z],yxz);
end
if length(shift)==1
    shift = [shift shift shift];
end


ymin = max(1, min(yy)-shift(1)); ymax = min(h, max(yy)+shift(1));
xmin = max(1, min(xx)-shift(2)); xmax = min(w, max(xx)+shift(2));
zmin = max(1, min(zz)-shift(3)); zmax = min(z, max(zz)+shift(3));

loc_org_xyz = [xmin, ymin, zmin];
if min(yy) == 1 || max(yy) == h || min(xx) == 1 || max(xx) == w% || min(zz) == 1 || max(zz) == z
    yxz_edge_Flag = true;
end

if ~iscell(vidIn)
    vidOut = vidIn(ymin:ymax, xmin:xmax, zmin:zmax);
else % 3 cells for pre-frame, cur-frame, post-frame
    vidOut = cell(numel(vidIn),1);
    for i=1:numel(vidIn)
        if ~isempty(vidIn{i})
            vidOut{i} = vidIn{i}(ymin:ymax, xmin:xmax, zmin:zmax);
        end
    end
end

vIdx = [];
if nargout > 1
    [R, C, P] = ndgrid(ymin:ymax, xmin:xmax, zmin:zmax);
    vIdx = sub2ind([h,w,z], R, C, P);
end
end