function [newLabel, comMaps] = refineOneRegion_with_seed_Wei(seed_id, ...
    yxz, vid, vid_stb, idMap, eig2d, eig3d, OrSt, q)
% refine the seed region indicate by index in yxz
% NOTE: it is possible the yxz is not exactly the same as seed_id label
% indicates, e.g. the seed is relabeled. We view yxz as the correct one.
%% crop needed information
comMaps = get_local_area(vid, vid_stb, idMap, seed_id,...
    eig2d, eig3d, yxz, OrSt, q);

%% gap detection based on min cut
fMap = comMaps.regComp;
fMap = imdilate(fMap,strel("sphere",10));
fMap((comMaps.idComp ~= seed_id) & (comMaps.idComp > 0)) = 0;

%% modify start: remove small seed in comMaps.newIdComp
regLabel = region_sanity_check(bwlabeln(comMaps.newIdComp), 10);
comMaps.newIdComp=regLabel>0;

%% modify end (Wei, 10/3/2022) 
com = bwconncomp(comMaps.newIdComp);
newLabel = zeros(size(fMap));
for ii = 1:com.NumObjects
    sMap = false(size(fMap));
    sMap(com.PixelIdxList{ii}) = true;
    tMap = true(size(fMap));
    tMap(fMap) = false;
    tMap(comMaps.newIdComp) = true;
    tMap(com.PixelIdxList{ii}) = false;
    scoreMap = comMaps.score3dMap;
    scoreMap(scoreMap<0) = 0;
    [dat_in, src, sink] = graphCut_negHandle_mat(scoreMap, fMap, sMap, ...
        tMap, 26, [1 2], true);
    G = digraph(dat_in(:,1),dat_in(:,2),dat_in(:,3));
    if ~isempty(find(isnan(dat_in(:)), 1)) || isnan(sink)
        keyboard;
    end
    [~,~,cs,~] = maxflow(G, src, sink); % cs: fg, ct: bg
    cs = cs(cs<numel(newLabel));
    %cs = cs(fMap(cs));
    cur_l = newLabel(cs);
    if length(unique(cur_l))>2
        keyboard;
    end
    newLabel(cs) = ii;
end

fgReDo = false;

end
