
gradFltr_X=[0.5 0 -0.5];
gradFltr_XX=conv(gradFltr_X,gradFltr_X);

sz=12;smRefLst=0.5:0.01:4;
smFactor=1*sz;
L=ceil(smFactor*max(smRefLst)*3)*2+1;
dat=images.internal.createGaussianKernel(smFactor, L);

smFactorLst=smRefLst.*sz;
scoreLst_x=zeros(size(smFactorLst));

for i=1:length(smFactorLst)
    smFactor=smFactorLst(i);
    L=ceil(smFactor*3)*2+1;
    G=images.internal.createGaussianKernel(smFactor, L);
    F1=conv(gradFltr_XX,G);

%     F0=images.internal.createGaussianKernel(smFactor*1, L);
    F0=F1/sqrt(sum(F1.^2));

    F2=conv(F0,F1);
    scoreLst_x(i)=F2((L+1)/2);
end

%%
%%
[V,I]=max(scoreLst_x);
scoreLst_x_n=scoreLst_x/max(V);
smFactorLst_n=(smFactorLst-smFactorLst(I))/smFactorLst(I);
Thres=0.95;
Idx=find(scoreLst_x_n>Thres);

figure;
plot(smFactorLst_n,scoreLst_x_n);
hold on;
plot(smFactorLst_n,ones(size(smFactorLst_n))*0.95,'red');

scatter(smFactorLst_n(Idx(1)),Thres,25,'filled');
scatter(smFactorLst_n(Idx(end)),Thres,25,'filled');

title("signal size = "+sz);
axis([-inf inf 0.5 1]);