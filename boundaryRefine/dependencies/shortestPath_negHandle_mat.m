function [dat_in, src_node, sink_node] = shortestPath_negHandle_mat(vid,fMap,...
    sMap, tMap, connect, cost_design, bg2sink)
% build a graph for graph cut, note that we only test the gaps inside the
% one region, if there is some obvious gaps, we will segment it; for those
% segmented regions, we will not grow the gaps between themshift
% INPUT:
% vid: 3D (TODO: 2D) matrix indicating the similarity of voxels, it can be
% principal curvature or the gradient. if it is principal curvature,
% there may be negative values.
% fMap: the valid foreground map for segmenting
% sMap and tMap: the voxel that definitely belongs to src or sink
% connect: 6, 26 (TODO: 10(8+2)) connection for edges in the graph
% cost_design: 1 means average; 2 means sqrt;
% OUTPUT:
% dat_in: the graph with n+1 indicating src and n+2 indicating sink; for a voxel at
% location ind, its node index should be ind+1

% contact: ccwang@vt.edu

if nargin == 6
    % if we did not link background to sink, no need to consider such
    % nodes, otherwise bg2sink is true
    bg2sink = true;
end
vox_num = numel(vid);
% 
valid_vox = find(fMap);

nei_mat = neighbours_mat(valid_vox, vid, connect);                          % [size(valid_vox) connect]
vox_mat = repmat(valid_vox, 1, connect);                
map = [vox_mat(:) nei_mat(:)];                                              % [size(valid_vox)*connect 2]
map = map(~isnan(map(:,2)),:);                                              % [vox_mat nei_mat]

if ~bg2sink
    map = map(fMap(map(:,2)),:);
end
p1 = vid(map(:,1));
p2 = vid(map(:,2));

costs = (sqrt(p1.*p2)).^cost_design(2);


adjMap = false(size(vid)); % map of neighbors
adjMap(map(:,2)) = 1;

dat_in = cat(1, [map, costs], [map(:,2) map(:,1), costs]);                  % bidirectional edge

% connections to src or sink
src_node = vox_num+1;
srcIds = find(sMap);

dat_in = cat(1, dat_in, [src_node + srcIds*0, srcIds, srcIds*0]);     % connect source to sMap

    
sink_node = vox_num+2;
sinkIds = find(adjMap & tMap);
if isempty(sinkIds)
    %keyboard;
    sink_node = nan;
end
dat_in = cat(1, dat_in, [sinkIds, sink_node + sinkIds*0, sinkIds*0]); % connect sink to sMap

end