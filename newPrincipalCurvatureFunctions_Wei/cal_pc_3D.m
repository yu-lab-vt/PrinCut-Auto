function eig3 = cal_pc_3D(xx, yy, zz, xy, xz, yz) 

%%
eig3 = zeros(size(xx));
a = -(xx + yy + zz);
a = a(:);
b = -(yz.^2 + xy.^2 + xz.^2 - xx.*zz -yy.*zz -xx.*yy);
b = b(:);
c = -(xx.*yy.*zz + 2*xy.*yz.*xz - xx.*(yz.^2) - zz.*(xy.^2) - yy.*(xz.^2));
c = c(:);

%%
p = b - a.^2/3;
q = 2*(a.^3)/27 - (a.*b)/3 + c;

temp=3*q./(2*p).*sqrt(-3./p);
temp=min(max(temp,-1),1);
eig3(:) = 2/sqrt(3)*(sqrt(-p)).*cos(1/3.*acos(temp)) - a/3;

end