function out=label2RGB_HD(label)

sz=size(label);

if length(sz)==2
    SZ=[sz(1:2) 1];
else
    SZ=[sz(1:2) 1 sz(3:end)];
end

L = reshape(label,SZ);
L=L(:)+1;


N=max(L);
cmap=jet(double(N));
rd=randperm(N);
cmap=cmap(rd,:);

chOut=cell(1,1,3);
for clrCnt=1:3
    chOut{clrCnt}=zeros(SZ);
end

for cCnt=1:3
    cmap_temp=[ 0 ; cmap(:,cCnt)];
    chOut{cCnt}(:)=cmap_temp(L);
end

out=cell2mat(chOut);

end