function out_bw = pickLargestReg(bw, connect)
% pick up the largest connected component
[l,n] = bwlabeln(bw, connect);
    
if n == 1
    out_bw = bw;
elseif n==0
    out_bw = [];
else
    s = regionprops3(l,'Volume');
    [~,od] = max([s.Volume]);
    out_bw = ismember(l, od);
end

end