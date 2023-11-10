function [idMap, cnt, map] = rearrange_id(idMap)
% re-arrange the id in idMap
% INPUT:
% idMap: the original id map, the ids may not be consecutive
% OUTPUT:
% idMap: new id map, the ids are consecutive now

% ccwang@vt.edu, 07/22/2020
% this is new version and faster than before
max_id = max(idMap(:));
if max_id == 0
    cnt = 0;
    map = [];
    return;
end

map = zeros(max_id,1);

val_locs = idMap>0;
valid_ids = unique(idMap(val_locs)); % ascend sorted
cnt = length(valid_ids);
map(valid_ids) = (1:cnt)';
idMap(val_locs) = map(idMap(val_locs));

map = cat(2, valid_ids, (1:cnt)');

end