
gradFltr_X=[0.5 0 -0.5];
gradFltr_XX=conv(gradFltr_X,gradFltr_X);

smFactorLst=1:20;
ScoreLst=zeros(size(smFactorLst));

for i=1:length(smFactorLst)
    smFactor=smFactorLst(i);
    L=round(smFactor*4*20)+1;
    G=images.internal.createGaussianKernel(smFactor, L);
    F1=conv(gradFltr_XX,G);

%     F0=images.internal.createGaussianKernel(smFactor*1, L);
    F0=F1/max(F1);

    F2=conv(F0,F1);
    ScoreLst(i)=max(F2);
end

plot(smFactorLst,ScoreLst.*(smFactorLst.^2))
%
for i=1:length(smFactorLst)
    smFactor=smFactorLst(i);
    L=round(smFactor*4*20)+1;
    G=images.internal.createGaussianKernel(smFactor, L);
    F1=conv(gradFltr_XX,G);

%     F0=images.internal.createGaussianKernel(smFactor*1, L);
%     F0=F0/max(F0);
    F0=F1/max(F1);

    F2=conv(F0,F1/sum(abs(F1)));
    ScoreLst(i)=max(F2);
end
hold on
plot(smFactorLst,ScoreLst.*(smFactorLst.^0))