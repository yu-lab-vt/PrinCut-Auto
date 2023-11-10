function [regLabel, redundant_flag] = region_sanity_check(regLabel, minSz, ...
    check_multi_seeds)
% 1. remove region with given size constraint
% 2. check if the region indeed contains multiple connected components. it can
% sort the region ids at the same time.
%INPUT:
% regLabel: input label map
%OUTPUT:
% regLabel: the output label map with each region containing only one
% connected component for sures

% contact: ccwang@vt.edu, 02/12/2020

%[L, n] = bwlabeln(inLabel, 26);
if nargin == 1
    minSz = 20;
    check_multi_seeds = false;
end
if nargin == 2
    check_multi_seeds = false;
end
if ~check_multi_seeds
    stats_org = regionprops3(regLabel,'Volume', 'VoxelIdxList');
    v = find([stats_org.Volume]<minSz);
    if isempty(v)
        redundant_flag = false;
    else
        redundant_flag = true;
        regLabel(ismember(regLabel, v)) = 0;
        regLabel = rearrange_id(regLabel);
    end
else % not only check size, but also split regions with multiple connected comps
    n = double(max(regLabel(:)));
    stats_org = regionprops3(regLabel,'Volume', 'VoxelIdxList');
    new_l_map = bwlabeln(regLabel>0, 26);
    stats_new = regionprops3(new_l_map,'Volume', 'VoxelIdxList');
    redundant_flag = false;
    regCnt = 0;
    regLabelOut = zeros(size(regLabel));
    for i=1:n
        voxIdx = stats_org.VoxelIdxList{i};
        if length(voxIdx) <= minSz
            continue;
        end
        ids = unique(new_l_map(voxIdx));
        n0 = length(ids);
        if n0>1
            redundant_flag = true;
            %stats = regionprops3(L,'Volume', 'VoxelIdxList');
            for j=1:n0
                id = ids(j);
                if stats_new.Volume(id) > minSz
                    regCnt = regCnt + 1;
                    regLabelOut(intersect(stats_new.VoxelIdxList{id}, voxIdx)) = regCnt;
                end
            end
        else
            regCnt = regCnt + 1;
            regLabelOut(voxIdx) = regCnt;
        end
    end
    regLabel = regLabelOut;
end