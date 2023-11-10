function newLabel=removeFalsePositiveCell2(newLabel,comMaps_temp)

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
%         SIGMAidx=find(mean(BG)>varFit(:,1),1,"last");
%         SIGMA=sqrt(varFit(SIGMAidx,2));
        SIGMA=std(BG);
        [mu, sigma] = ksegments_orderstatistics_fin(FG, BG);
        F=mean(FG)-mean(BG);
        zscore = (F/SIGMA-mu)/sigma;

%         n1=length(FG);n2=length(BG);
%         F=mean(FG)-mean(BG);
%         zscore=F/SIGMA*sqrt(1/n1+1/n2);

        if zscore<-inf
            newLabel(FGmap)=0;
        end
    else
        newLabel(FGmap)=0;
    end
end

newLabel = region_sanity_check(newLabel, 1);

end