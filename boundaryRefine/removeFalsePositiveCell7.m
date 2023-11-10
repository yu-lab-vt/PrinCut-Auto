function [replaceIdx,zscore,SIGMA,FG,BG]=removeFalsePositiveCell7(i,subIdMap,subVid)

%% initialize
replaceIdx=0;
SIGMA=-1;
zscore=-inf;

se0 = strel('disk',1);
se = strel('disk',5);

FGmap=subIdMap==i;
FG=subVid(FGmap);
BGmap0=imdilate(FGmap,se0)&~FGmap;
BGmap1=BGmap0&~subIdMap;
envRatio=length(find(BGmap1))/length(find(BGmap0));
envelopedCellFlag=isempty(setdiff(unique(subIdMap(BGmap1)),0)) && envRatio<0.3;

BGmap=imdilate(FGmap,se)&~FGmap&~subIdMap;
BG=subVid(BGmap);

%% remove envoloped cells
if isempty(find(BGmap1,1)) || envelopedCellFlag
    replaceIdx=0;
    return;
end

%% remove small cells
if length(FG)<=100
    replaceIdx=0;
    return;
end

%% remove dark cells
SIGMA=std(BG);
[mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
F=mean(FG)-mean(BG);

[X,Y,Z]=size(subIdMap);

DwnSmplRatioLst=1:5;
Ndownsample=length(DwnSmplRatioLst);

NFGraw=length(FG);

zscoreLstHat=zeros(1,Ndownsample);
for DwnSmplRatioCnt=1:Ndownsample
    DwnSmplRatio=DwnSmplRatioLst(DwnSmplRatioCnt);
    FGmap_temp=downsample_Wei(FGmap,DwnSmplRatio)==1;
    NFGnew=length(find(FGmap_temp));
    if NFGnew>0
        zscoreLstHat(DwnSmplRatioCnt) = (F/(SIGMA/DwnSmplRatioCnt)-mu)/(sigma*sqrt(NFGraw)/sqrt(NFGnew));
    else
        zscoreLstHat(DwnSmplRatioCnt) = -inf;
    end
end

[~,I]=max(zscoreLstHat);


DwnSmplRatio=DwnSmplRatioLst(I);
X2=round(X/DwnSmplRatio);Y2=round(Y/DwnSmplRatio);
subVid_temp = imresize3(subVid, [X2 Y2 Z],'linear');
FGmap_temp = imresize3(FGmap, [X2 Y2 Z],'nearest');
BGmap_temp = imresize3(BGmap, [X2 Y2 Z],'nearest');
FG=subVid_temp(FGmap_temp);BG=subVid_temp(BGmap_temp);SIGMA=std(BG);
[mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
F=mean(FG)-mean(BG);
zscore = (F/SIGMA-mu)/sigma;

if zscore>5
    replaceIdx=i;
end


end