function [replaceIdx,baseline,SIGMA,FG,BG]=removeFalsePositiveCell4(i,subIdMap,subVid,varFit)

replaceIdx=0;
baseline=-1;
SIGMA=-1;

se = strel('disk',3);

FGmap=subIdMap==i;
FG=subVid(FGmap);
BGmap_raw=imdilate(FGmap,se);
BGmap=BGmap_raw&~subIdMap;
BG=subVid(BGmap);

if isempty(BG)
    replaceIdx=max(subIdMap(BGmap_raw));
else

    if length(FG)>100
    
        baseline=mean(BG);
        SIGMAidx=find(baseline>varFit(:,1),1,"last");
        SIGMA=sqrt(varFit(SIGMAidx,2));
        [mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
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