function [curvature,sigmaIdMap]=getCurvature_2D_3(dat,smFactor,varFitPara)
%% get 2D principal curvatrue of 2D data with AUC normalization, get the noise level id map
%%
L=round(smFactor*3);
GaussFltr = fspecial( 'gaussian',L*2+1,smFactor);

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


curvature=zeros(size(dat));
for i=1:numel(dat)
    MM = [xx(i) xy(i);xy(i) yy(i)];
    [~,Eval] = eig(MM);
    dEval = diag(Eval);
    c = sort(dEval,'descend');
    curvature(i) = c(1);
    
end
%%

G=conv2(dat_pad,GaussFltr);
SZ_Pad_G=SZ_pad+L;
G=G(1+SZ_Pad_G:end-SZ_Pad_G,1+SZ_Pad_G:end-SZ_Pad_G);
sigmaIdMap = floor((G - varFitPara.minVal)./ varFitPara.unit) + 1;
sigmaIdMap=min(max(sigmaIdMap,1),200);


end