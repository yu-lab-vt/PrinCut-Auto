function label=rearrangeLabel(label)

stats_org = regionprops3(label,'Volume','VoxelIdxList');

validLst=stats_org.Volume>0;

validIdLst=find(validLst);
invalidLst=find(~validLst);
invalidLst=invalidLst(end:-1:1);

while ~isempty(invalidLst)&&~isempty(validLst)&&invalidLst(end)<validIdLst(end)
    label(stats_org.VoxelIdxList{validIdLst(end)})=invalidLst(end);
    validIdLst(end)=[];invalidLst(end)=[];
end

end