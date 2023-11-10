function idx = sub2ind_direct(sz, yy, xx, zz)
% the same function as sub2ind

if length(sz) == 3
    yx_sz = sz(1)*sz(2);
    idx = yy + (xx-1)*sz(1) + (zz-1)*yx_sz;
else
    idx = yy + (xx-1)*sz(1);
end


end