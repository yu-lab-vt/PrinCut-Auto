function comMaps = get_local_area(vid, vid_stb, idMap, i,...
    eig2d, eig3d, yxz, OrSt, q)
% crop out the local surrounding area for a given seed region
% i is the id labeling the seed region in idMap, yxz is its location
% indexs.

comMaps = cropNeedRegions(vid, vid_stb, idMap, i, ...
    eig2d, eig3d, yxz, OrSt.imProcMethod, q.shift);
