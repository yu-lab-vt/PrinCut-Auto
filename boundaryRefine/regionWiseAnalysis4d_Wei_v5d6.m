function newIdMap_refined = regionWiseAnalysis4d_Wei_v5d6(seedMap,eig3d, vid)
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

%% refine boundary
newIdMap_boundary=boundaryRefineModule(seedMap,eig3d, vid);
%% remove false positive
newIdMap_remove=removeFalsePositiveModule_v5d6(newIdMap_boundary,vid);
%% refine boundary again
idMap_current = region_sanity_check(seedMap.*(newIdMap_remove>0),1);
newIdMap_refined=boundaryRefineModule(idMap_current,eig3d, vid);
end