function [replaceIdx,zscore,SIGMA,FG,BG]=removeFalsePositiveCell8(i,subIdMap,subVid)

%% initialize
replaceIdx=0;
SIGMA=-1;
zscore=-inf;

se0 = strel('disk',1);
se = strel('disk',6);

FGmap=subIdMap==i;
FG=subVid(FGmap);

BGmap0=imdilate(FGmap,se0)&~FGmap;
BGmap1=BGmap0&~subIdMap;
envRatio=length(find(BGmap1))/length(find(BGmap0));
envelopedCellFlag=isempty(setdiff(unique(subIdMap(BGmap1)),0)) && envRatio<0.3;

BGmap_unreliable=imdilate(subIdMap>0,se0);

BGmap=imdilate(FGmap,se)&~BGmap_unreliable;
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

DwnSmplRatioLst=1:5;
Ndownsample=length(DwnSmplRatioLst);

for DwnSmplRatioCnt=1:Ndownsample
    DwnSmplRatio=DwnSmplRatioLst(DwnSmplRatioCnt);
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
end


if zscore>5
    replaceIdx=i;
end


end