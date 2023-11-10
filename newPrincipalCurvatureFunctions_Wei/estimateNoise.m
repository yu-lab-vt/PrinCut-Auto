function [Mu,Sigma]=estimateNoise(img)
img=img(:);
Num=min(1000000,length(img));
img=double(img(1:Num));
MAX=max(img);
MIN=min(img);
edges=MIN:MAX;
N = histcounts(img,edges);
[~,I]=max(N);
I_up=2*I;
Int_up=edges(I_up+1);
Mu=edges(I);
Sigma=std(img(img<Int_up));
end