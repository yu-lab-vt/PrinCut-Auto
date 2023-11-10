function [vidOut,IdMapOut]=crop3D_Wei(yxz,shift,IdMapIn,vidIn)

[h,w,z] = size(vidIn);
[yy,xx,zz] = ind2sub([h,w,z],yxz);

ymin = max(1, min(yy)-shift(1)); ymax = min(h, max(yy)+shift(1));
xmin = max(1, min(xx)-shift(2)); xmax = min(w, max(xx)+shift(2));
zmin = max(1, min(zz)-shift(3)); zmax = min(z, max(zz)+shift(3));

vidOut = vidIn(ymin:ymax, xmin:xmax, zmin:zmax);
IdMapOut = IdMapIn(ymin:ymax, xmin:xmax, zmin:zmax);

end