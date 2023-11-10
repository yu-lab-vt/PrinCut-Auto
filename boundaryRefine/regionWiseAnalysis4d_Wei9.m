function newIdMap_refined = regionWiseAnalysis4d_Wei9(idMap,eig3d, vid)
% region grow: shrink the 3d gaps detected by 3d principal curvature
% considering the 4-d information (pre- and post frames)
% the idea is based on boyu's graph-cut (max-flow)
% INPUT:
% idMap: cells of 3 components, each of which is the label map of h*w*z
% eig2dMaps: cells of 3 components, each of which is the 2d principal curvature
% values of foreground in idMap
% eigThres: the threshold of principal curvature for eigMap
% vid: cells of 3 components, each of which is the orgriginal data
% save_folder: the folder to save images for sanity check
% over_seg_flag: true, oversegment the region and then merge, false
% otherwise
% OUTPUT:
% newIdMap: detected regions with each region one unique id
%
% contact: ccwang@vt.edu, 09/15/2020
% tic;
%% parameters for region grow
q = initial_q();
%% parameters for fg detection and gap significance test
idMap_current = idMap;
vid_current = vid;

%% start the main functions
fprintf('Start pre-processing! \n')
[idMap2, redundant_flag] = region_sanity_check(idMap_current, q.minSeedSize); % remove small objects
if redundant_flag
    idMap_current = idMap2;
end
s = regionprops3(idMap_current, {'VoxelIdxList'});
N=numel(s.VoxelIdxList);
% process from brightest seed to dimmest ones
seed_levels = cellfun(@(x) mean(vid_current(x)), s.VoxelIdxList);
[~, seed_proc_order] = sort(seed_levels,'descend');
idMap = idMap_current;
loc_cells = cell(numel(s.VoxelIdxList),1);
comMaps = cell(numel(s.VoxelIdxList),1);
for ii=1:numel(s.VoxelIdxList)
%     disp(ii+"/"+N);
    % crop needed information
    seed_id = seed_proc_order(ii);
    yxz = s.VoxelIdxList{seed_id};
    ids = idMap_current(yxz);
    yxz = yxz(ids==seed_id);
    comMaps{ii} = get_local_area_Wei(vid,idMap,seed_id,eig3d,yxz,q.shift);    
end
% toc
%% start boundary refine
fprintf('Start parallel computation! \n')
parfor i=1:numel(s.VoxelIdxList)
%     disp(i+"/"+N);
    seed_id = seed_proc_order(i);
    [newLabel, comMaps_temp] = refineOneRegion_with_seed_parallel_Wei(seed_id, comMaps{i});
    valid_newLabel = newLabel(:)>0;
    loc_cells{i} = cell(2,1);
    loc_cells{i}{1} = [comMaps_temp.linerInd(valid_newLabel), newLabel(valid_newLabel)];
    loc_cells{i}{2} = round(quantile(comMaps_temp.vidComp(valid_newLabel),0.5));
    
end

% label the new ID Map
newIdMap = zeros(size(idMap_current));
thresholdMap = zeros(size(idMap_current));
regCnt = 0;
for i=1:numel(loc_cells)
    if ~isempty(loc_cells{i}{1})
        cur_locs = loc_cells{i}{1}(:,1);
        cur_labels = loc_cells{i}{1}(:,2);
        newIdMap(cur_locs) = cur_labels + regCnt;
        thresholdMap(cur_locs) = loc_cells{i}{2};
        regCnt = regCnt + max(cur_labels);
    end
end

% toc
%% remove false positive
fprintf('Start removing false positive! \n')
shift=[6,6,1];
s = regionprops3(newIdMap, {'VoxelIdxList'});
regionIdxLst=s.VoxelIdxList;
N=numel(regionIdxLst);
vidCropLst=cell(N,1);
idMapCropLst=cell(N,1);
for i=1:N
%     disp(i);
    [vidCropLst{i},idMapCropLst{i}]=crop3D_Wei(regionIdxLst{i},shift,newIdMap,vid);
end

replaceLst=zeros(N,1);
parfor i=1:N
%     disp(i);
    replaceLst(i)=removeFalsePositiveCell8(i,idMapCropLst{i},vidCropLst{i});
end

newIdMap_refined=newIdMap;
for i=1:N
    newIdMap_refined(regionIdxLst{i})=replaceLst(i);
end
newIdMap_refined = region_sanity_check(newIdMap_refined, 1);

% toc
end