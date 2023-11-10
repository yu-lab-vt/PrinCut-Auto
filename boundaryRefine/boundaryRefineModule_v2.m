function [newIdMap,thresholdMap]=boundaryRefineModule_v2(idMap,eig3d, vid,option)
%% parameters for region grow
q = initial_q();
q.shift(3)=ceil(q.shift(1)/option.zRatio);
option.shift=q.shift;
%% parameters for fg detection and gap significance test
idMap_current = idMap;
vid_current = vid;
%% start crop local region
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

%% start boundary refine
fprintf('Start boundary refine! \n')
parfor i=1:numel(s.VoxelIdxList)
    disp(i+"/"+N);
    seed_id = seed_proc_order(i);
    [newLabel, comMaps_temp] = refineOneRegion_with_seed_parallel_Wei_v2(seed_id, comMaps{i},option);
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

end