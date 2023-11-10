function BiMap=removeLargeCC(BiMap,minSz)

regLabel=bwlabeln(BiMap);
stats_org = regionprops3(regLabel,'Volume', 'VoxelIdxList');
v = find([stats_org.Volume]>minSz);

if ~isempty(v)
    BiMap(ismember(regLabel, v)) = 0;
end

end