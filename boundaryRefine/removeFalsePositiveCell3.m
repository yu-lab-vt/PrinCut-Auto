function [replaceIdx,zscore,SIGMA,FG,BG]=removeFalsePositiveCell3(i,subIdMap,subVid)

replaceIdx=0;
baseline=-1;
SIGMA=-1;
zscore=-inf;

se0 = strel('disk',1);
se = strel('disk',5);

FGmap=subIdMap==i;
FG=subVid(FGmap);
BGmap0=imdilate(FGmap,se0)&~FGmap;
BGmap1=BGmap0&~subIdMap;


BGmap=imdilate(FGmap,se)&~FGmap&~subIdMap;
BG=subVid(BGmap);

if isempty(find(BGmap1,1))
    replaceIdx=max(subIdMap(BGmap0));
else

    if length(FG)>100
    
        SIGMA=std(BG);
        [mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
        baseline=mean(BG);
        F=mean(FG)-baseline;
        zscore = (F/SIGMA-mu)/sigma;
    
        if zscore>5
            replaceIdx=i;
        end
    else
        replaceIdx=0;
    end

end


end