function out=label2RGB_HD_v2(L)

% L=gpuArray(uint32(L));
sz=size(L);

if length(sz)==2
    SZ=[sz(1:2) 1];
else
    SZ=[sz(1:2) 1 sz(3:end)];
end

L = reshape(L,SZ);
L=L(:)+1;


N=max(L);
cmap=jet(double(N));
rd=randperm(N);
cmap=cmap(rd,:);

chOut=cell(1,1,3);
if isgpuarray(L)
    for clrCnt=1:3
        chOut{clrCnt}=gpuArray(zeros(SZ,"uint8"));
    end
else
    for clrCnt=1:3
        chOut{clrCnt}=zeros(SZ,"uint8");
    end
end

for cCnt=1:3
    cmap_temp=[ 0 ; cmap(:,cCnt)];
    cmap_temp=uint8(cmap_temp*128);
    chOut{cCnt}(:)=cmap_temp(L);
end

out=cat(3,chOut{1},chOut{2},chOut{3});

end