function [newLabel, comMaps] = refineOneRegion_with_seed_parallel_Wei(seed_id, comMaps)
% refine the seed region indicate by index in yxz

% It remove the crop part outside for parallel computation 
% by mengfan  10/05/2022

% NOTE: it is possible the yxz is not exactly the same as seed_id label
% indicates, e.g. the seed is relabeled. We view yxz as the correct one.


%% gap detection based on min cut
comMaps.score3dMap(comMaps.score3dMap<0) = 0;
min_pv = min(comMaps.score3dMap(:));
max_pv = max(comMaps.score3dMap(:));
comMaps.score3dMap = scale_image(comMaps.score3dMap, 1e-3,1, min_pv, max_pv);

strel_rad = 20;
strel_ker = getKernel(strel_rad);
fMap = comMaps.regComp;
fMap = imdilate(fMap,strel_ker);
fMap((comMaps.idComp ~= seed_id) & (comMaps.idComp > 0)) = 0;
com = bwconncomp(comMaps.newIdComp);
newLabel = zeros(size(fMap));
for ii = 1:com.NumObjects
    sMap = false(size(fMap));
    sMap(com.PixelIdxList{ii}) = true;
    tMap = true(size(fMap));
    tMap(fMap) = false;
    tMap(comMaps.newIdComp) = true;
    tMap(com.PixelIdxList{ii}) = false;
    scoreMap = comMaps.score3dMap; % before fusion
%     scoreMap = comMaps.score3dMap; % after fusion
    scoreMap(scoreMap<0) = 0;
    [dat_in, src, sink] = graphCut_negHandle_mat(scoreMap, fMap, sMap, ...
        tMap, 10, [1 1], true);       % before fusion
%     [dat_in, src, sink] = graphCut_negHandle_mat(scoreMap, fMap, sMap, ...
%         tMap, 26, [1 1], true);       % after fusion
    G = digraph(dat_in(:,1),dat_in(:,2),dat_in(:,3));
    if ~isempty(find(isnan(dat_in(:)), 1)) || isnan(sink)
        continue;
    end
    [~,~,cs,~] = maxflow(G, src, sink); % cs: fg, ct: bg
    cs = cs(cs<=numel(newLabel));
    %cs = cs(fMap(cs));
    cur_l = newLabel(cs);
    if length(unique(cur_l))>2
        keyboard;
    end
    newLabel(cs) = ii;
end
% graphCut_negHandle_mat(vid,fMap,...
%     sMap, tMap, connect, cost_design, bg2sink)


end

function strel_ker = getKernel(strel_rad)
    strel_ker = ones(strel_rad*2+1, strel_rad*2+1,ceil(strel_rad/5)*2+1);
    [xx,yy,zz] = ind2sub_direct(size(strel_ker), find(strel_ker));
    dist = sqrt( (xx - strel_rad-1).^2 + (yy - strel_rad-1).^2 + ( (zz - ceil(strel_rad/5)-1)*5 ).^2 );
    strel_ker(dist>=strel_rad) = 0;
    strel_ker = strel(strel_ker);
end