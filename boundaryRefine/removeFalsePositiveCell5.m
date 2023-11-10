function [replaceIdx,zscore,SIGMA,FG,BG]=removeFalsePositiveCell5(i,subIdMap,subVid)

[X,Y,Z]=size(subIdMap);
X2=round(X/2);Y2=round(Y/2);
subVid = imresize3(subVid, [X2 Y2 Z],'linear');
subIdMap = imresize3(subIdMap, [X2 Y2 Z],'nearest');

replaceIdx=0;
baseline=-1;
SIGMA=-1;
zscore=-inf;

se = strel('disk',2);

FGmap=subIdMap==i;
FG=subVid(FGmap);
BGmap_raw=imdilate(FGmap,se)&~FGmap;
BGmap=BGmap_raw&~subIdMap;
BG=subVid(BGmap);

if isempty(BG)
    replaceIdx=max([subIdMap(BGmap_raw);0]);
else

    if length(FG)>25
    
        SIGMA=std(BG);
        [mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
        baseline=mean(BG);
        F=mean(FG)-baseline;
        zscore = (F/SIGMA-mu)/sigma;

        if F<SIGMA
            replaceIdx=0;
        else
            if zscore>5
                replaceIdx=i;
            end
        end
    else
        replaceIdx=0;
    end

end


end