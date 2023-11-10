function [out_bw, rm_flag, idx] = pickLargestReg(bw, connect, valid_idx)
% pick up the largest connected component
if nargin == 2
    valid_idx = [];
end
[l,n] = bwlabeln(bw, connect);
rm_flag = false;
if n == 1
    out_bw = bw;
    if nargout == 3
        if ~isempty(valid_idx)
            idx = valid_idx;
        else
            idx = find(out_bw);
        end
    end
elseif n==0
    out_bw = [];
    if nargout == 3
        idx = [];
    end
else
    rm_flag = true;
    if isempty(valid_idx)
        max_id = mode(l(bw));
    else
        fg_ids = l(valid_idx);
        max_id = mode(fg_ids);
    end
    out_bw = l == max_id;
    
    if nargout == 3
        if isempty(valid_idx)
            idx = find(out_bw);
        else
            idx = valid_idx(fg_ids==max_id);
        end
    end
end

end