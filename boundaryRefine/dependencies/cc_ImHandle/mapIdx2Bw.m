function [bw, st_pt, idx] = mapIdx2Bw(idx, idx_sz, map_sz)
% Given a set of voxel index, map them into a 3D binary map;
% If the map size is not given, we will return the bounding box of the
% region that idx denotes.
% All the size should follow the direction of y-x-z

if nargin == 2
    map_sz = [];
end
st_pt = [1 1 1];
if ~isempty(map_sz)
    bw = false(map_sz);
    if size(idx,1) == 1 || size(idx,2)==1
        bw(idx) = true;
    else
        idx = sub2ind(idx_sz, idx(:,1), idx(:,2), idx(:,3));
        bw(idx) = true;
    end
else
    %loc_yxz: if idx's size is nx3, it must in y-x-z direction.
    if size(idx,1) == 1 || size(idx,2)==1
        [yy, xx, zz] = ind2sub(idx_sz, idx);
        loc_yxz = [yy, xx, zz];
    else
        loc_yxz = idx;
    end
    
    st_pt = min(loc_yxz, [], 1);
    end_pt = max(loc_yxz, [], 1);
    bw_sz = ceil(end_pt-st_pt + 1); % must be integer
    bw = false(bw_sz);
    loc_yxz = loc_yxz - st_pt + 1;
    idx = sub2ind(bw_sz, loc_yxz(:,1), loc_yxz(:,2), loc_yxz(:,3));
    bw(idx) = true;
end
