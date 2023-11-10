function [newIdMap_refined,thresholdMap] = regionWiseAnalysis4d_Wei_v11(seedMap,eig3d, vid,option)

%% refine boundary
newIdMap_boundary=boundaryRefineModule_v2(seedMap,eig3d, vid,option);
%% remove false positive
newIdMap_remove=removeFalsePositiveModule(newIdMap_boundary,vid);
%% refine boundary again
idMap_current = region_sanity_check(seedMap.*(newIdMap_remove>0),1);
[newIdMap_refined,thresholdMap]=boundaryRefineModule_v2(idMap_current,eig3d, vid,option);
end