function [replaceIdx,zscore,SIGMA,FG,BG]=removeFalsePositiveCell9(i,subIdMap,subVid)

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
zscore = (F/SIGMA-mu)/sigma;


if zscore>5
    replaceIdx=i;
end


end