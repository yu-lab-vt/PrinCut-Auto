function newIdMap_refined=removeFalsePositiveModule_v5d6(newIdMap,vid)

fprintf('Start removing false positive! \n')
shift=[10,10,1];
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
    replaceLst(i)=removeFalsePositiveCell_v5d6(i,idMapCropLst{i},vidCropLst{i});
end

newIdMap_refined=newIdMap;
for i=1:N
    newIdMap_refined(regionIdxLst{i})=replaceLst(i);
end
newIdMap_refined = region_sanity_check(newIdMap_refined, 1);

end