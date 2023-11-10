function out_idx = coordinate_transfer(in_idx, orgSz, cropStart, cropSz)
% change the idx if we crop the original volume

if iscell(in_idx)
    out_idx = cell(numel(in_idx), 1); % label current region

    for j=1:numel(in_idx)
        [y, x, z] = ind2sub(orgSz, in_idx{j});
        out_idx{j} = [x, y, z] - (cropStart-1);
        out_idx{j} = sub2ind(cropSz, out_idx{j}(:,2), ...
            out_idx{j}(:,1), out_idx{j}(:,3));
    end
else
    [y, x, z] = ind2sub(orgSz, in_idx);
    out_idx = [x, y, z] - (cropStart-1);
    out_idx = sub2ind(cropSz, out_idx(:,2), ...
        out_idx(:,1), out_idx(:,3));
end

end