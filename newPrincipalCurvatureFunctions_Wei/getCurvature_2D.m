function curvature_temp=getCurvature_2D(dat,smFactor)

im = imgaussfilt(dat,smFactor);
[lx, ly] = gradient(im);
[xx,yx] = gradient(lx);
[xy, yy] = gradient(ly);
curvature_temp=zeros(size(dat));
for i=1:numel(dat)
    MM = [xx(i) xy(i);yx(i) yy(i)];
    [~,Eval] = eig(MM);
    dEval = diag(Eval);
    c = sort(dEval,'descend');
    curvature_temp(i) = c(1);
end


end