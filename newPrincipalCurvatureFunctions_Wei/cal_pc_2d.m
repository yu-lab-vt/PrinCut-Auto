function eig2=cal_pc_2d(xx,yy,xy)

Mu=xx+yy;
Delta=sqrt(max(Mu.^2-4*(xx.*yy-xy.^2),0));
eig2=(Mu+Delta)/2;

end