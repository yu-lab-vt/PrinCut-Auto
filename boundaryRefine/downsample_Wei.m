function newMap=downsample_Wei(FGmap,DwnSmplRatio)
FGmap=double(FGmap);
[X,Y,Z]=size(FGmap);
X2=floor(X/DwnSmplRatio);Y2=floor(Y/DwnSmplRatio);
idxx=(1:DwnSmplRatio:X2*DwnSmplRatio)-1;
idxy=(1:DwnSmplRatio:Y2*DwnSmplRatio)-1;
newMap=zeros(X2,Y2,Z);
for i=1:DwnSmplRatio
    for j=1:DwnSmplRatio
        newMap=newMap+FGmap(idxx+i,idxy+j,:);
    end
end
newMap=newMap/DwnSmplRatio^2;
end