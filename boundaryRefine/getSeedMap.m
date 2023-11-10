function seedMap=getSeedMap(eig_res_3d,FGmap,maxSZ)

seedMap=zeros(size(FGmap));

CC=bwlabeln(eig_res_3d<0);
s = regionprops3(CC, {'VoxelIdxList'});
N=numel(s.VoxelIdxList);
k=0;
for i=1:N
    if length(s.VoxelIdxList{i})<maxSZ
        if ~isempty(find(FGmap(s.VoxelIdxList{i}), 1))
            k=k+1;
            seedMap(s.VoxelIdxList{i})=k;
        end
    end
end

end