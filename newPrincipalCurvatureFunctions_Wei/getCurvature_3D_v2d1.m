function [curvature,sigmaIdMap]=getCurvature_3D_v2d1(dat,smFactor,varFitPara)
%get 2D principal curvatrue of 3D data with AUC normalization, get the
%noise level id map, v2.1.
%
% Don't directly use this function.
% This function should be used by PrcplCrvtr_scaleInvariant_2D_v2d1
%
% input:    dat:                3D input data
%           smFactor:           the Gaussian smooth filter std
%           varFitPara.minVal:  min intensity of intensity noise variance
%                               relationship
%           varFitPara.unit:    unit of intensity of intensity noise variance
%                               relationship
% output:   curvature:          2D principal curvature for 3D data
%           sigmaIdMap:         the Id map of intensity noise variance
%                               relationship
% 
% 9/29/2022 by Wei Zheng 

%% get curvature
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

xx=convn(dat_pad,GXX);
xy=convn(dat_pad,GXY);
yy=convn(dat_pad,GYY);

xx=xx(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad,:);
xy=xy(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad,:);
yy=yy(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad,:);



curvature=cal_pc_2d(xx,yy,xy);

% curvature=zeros(size(dat));
% for i=1:numel(dat)
%     MM = [xx(i) xy(i);xy(i) yy(i)];
%     [~,Eval] = eig(MM);
%     dEval = diag(Eval);
%     c = sort(dEval,'descend');
%     curvature(i) = c(1);
% end
%% get sigmaIdMap
if nargin < 3
    sigmaIdMap = [];
else
    G=convn(dat_pad,GaussFltr);
    SZ_Pad_G=SZ_pad+L;
    G=G(1+SZ_Pad_G:end-SZ_Pad_G,1+SZ_Pad_G:end-SZ_Pad_G,:);
    sigmaIdMap = floor((G - varFitPara.minVal)./ varFitPara.unit) + 1;
    sigmaIdMap=min(max(sigmaIdMap,1),200);
end


end