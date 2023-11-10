function [replaceIdx,zscore,SIGMA,FG,BG]=removeFalsePositiveCell_v5d6(i,subIdMap,subVid)

%% initialize
replaceIdx=0;
SIGMA=-1;
zscore=-inf;

se0 = strel('disk',2);
se1 = strel('disk',6);

FGmap=subIdMap==i;
FG=subVid(FGmap);

BGmap0=imdilate(FGmap,se0)&~FGmap;
BGmap1=BGmap0&~subIdMap;
envRatio=length(find(BGmap1))/length(find(BGmap0));
envelopedCellFlag=isempty(setdiff(unique(subIdMap(BGmap1)),0)) && envRatio<0.5;

BGmap_unreliable=imdilate(subIdMap>0,se0);

BGmap=imdilate(FGmap,se1)&~BGmap_unreliable;
BG=subVid(BGmap);

%% remove envoloped cells
if isempty(find(BGmap1,1)) || envelopedCellFlag || length(BG)<10
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
subVid_temp = downsample_Wei(subVid,DwnSmplRatio);
FGmap_raw = downsample_Wei(FGmap,DwnSmplRatio);
BGmap_raw = downsample_Wei(BGmap,DwnSmplRatio);
FGmapAll_raw = downsample_Wei(BGmap_unreliable,DwnSmplRatio);
BGmap_temp=BGmap_raw>0.5&FGmapAll_raw==0;FGmap_temp=FGmap_raw==1;
FG=subVid_temp(FGmap_temp);BG=subVid_temp(BGmap_temp);
if ~isempty(FG) && ~isempty(BG)
    SIGMA=std(BG);
    [mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
    F=mean(FG)-mean(BG);
    zscoreTemp = (F/SIGMA-mu)/sigma;
    if zscoreTemp>zscore
        zscore=zscoreTemp;
    end
end


if zscore>5
    replaceIdx=i;
end


end