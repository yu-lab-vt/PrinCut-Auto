function [yy, xx, zz] = ind2sub_direct(sz, idx)
% the same function as ind2sub

if length(sz) == 3
    yx_sz = sz(1)*sz(2);
    zz = floor(idx / (yx_sz++1e-5));
    residual = idx - zz.*yx_sz;
    zz = zz + 1;
    xx = floor(residual / (sz(1)+1e-5));
    yy = residual - xx.*sz(1);
    xx = xx + 1;
else
    xx = floor(idx / (sz(1)+1e-5));
    yy = idx - xx.*sz(1);
    xx = xx + 1;
    zz = ones(size(xx));
end


end