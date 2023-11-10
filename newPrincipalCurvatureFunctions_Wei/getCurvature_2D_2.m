function curvature_temp=getCurvature_2D_2(dat,smFactor)

X=-smFactor*3:smFactor*3;
Y=normpdf(X,0,smFactor);
GaussFltr=Y'*Y;
GaussFltr=GaussFltr/sum(GaussFltr(:));

gradFltr_X=[0.5 1 0.5;0 0 0;-0.5 -1 -0.5];
gradFltr_Y=gradFltr_X';

GX=conv2(GaussFltr,gradFltr_X);
GY=conv2(GaussFltr,gradFltr_Y);
GXX=conv2(GX,gradFltr_X);
GXY=conv2(GX,gradFltr_Y);
GYY=conv2(GY,gradFltr_Y);

GXX=GXX./sum(abs(GXX(:)));
GXY=GXY./sum(abs(GXY(:)));
GYY=GYY./sum(abs(GYY(:)));

SZ_pad=size(GXX);
SZ_Pad=SZ_pad(1)+(SZ_pad(1)-1)/2;
dat_pad=padarray(dat,SZ_pad,'replicate','both');

xx=conv2(dat_pad,GXX);
xy=conv2(dat_pad,GXY);
yy=conv2(dat_pad,GYY);

xx=xx(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad);
xy=xy(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad);
yy=yy(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad);

curvature_temp=zeros(size(dat));
for i=1:numel(dat)
    MM = [xx(i) xy(i);xy(i) yy(i)];
    [~,Eval] = eig(MM);
    dEval = diag(Eval);
    c = sort(dEval,'descend');
    curvature_temp(i) = c(1);
end


end