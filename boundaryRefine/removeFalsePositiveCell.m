function newLabel=removeFalsePositiveCell(newLabel,comMaps_temp,SIGMA)

N=max(newLabel,[],'all');
se = strel('disk',3);
for i=1:N
    FGmap=newLabel==i;
    FG=comMaps_temp.vidComp(FGmap);
    BGmap_raw=imdilate(FGmap,se);
    BGmap=BGmap_raw&~newLabel;
    BG=comMaps_temp.vidComp(BGmap);
    if isempty(BG)
        newLabel(FGmap)=max(newLabel(BGmap_raw));
        continue;
    end

    if length(FG)>100
        [mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
        F=mean(FG)-mean(BG);
        zscore = (F/SIGMA-mu)/sigma;
        if zscore<1
            newLabel(FGmap)=0;
        end
    else
        newLabel(FGmap)=0;
    end
end

newLabel = region_sanity_check(newLabel, 1);

end