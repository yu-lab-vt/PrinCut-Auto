%%
smFactorLst=3:30;zRatio=5;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d1(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d1(dat_noise,smFactorLst,zRatio);

mu=mean(PC_null(:));
sigma=std(PC_null(:));
PC3=max((PC_raw-mu)./sigma,0);
%%
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d2(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d2(dat_noise,smFactorLst,zRatio);

mu=mean(PC_null(:));
sigma=std(PC_null(:));
PC2=max((PC_raw-mu)./sigma,0);
%%
smFactorLst=10;zRatio=5;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d2(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d2(dat_noise,smFactorLst,zRatio);

mu=mean(PC_null(:));
sigma=std(PC_null(:));
PC1=max((PC_raw-mu)./sigma,0);
%%
smFactorLst=10;zRatio=5;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d3(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d3(dat_noise,smFactorLst,zRatio);

mu=mean(PC_null(:));
sigma=std(PC_null(:));
PC0=max((PC_raw-mu)./sigma,0);
%%


figure;
ax(1)=subplot(2,2,1);
imagesc(dat(1+L:end-L,1+L:end-L))

crange=[0 10];

ax(2)=subplot(2,2,2);
imagesc(PC0(1+L:end-L,1+L:end-L))
caxis(crange);

% ax(2)=subplot(2,2,2);
% imagesc(PC1(1+L:end-L,1+L:end-L))
% caxis(crange);

ax(3)=subplot(2,2,3);
imagesc(PC2(1+L:end-L,1+L:end-L))
caxis(crange);
ax(4)=subplot(2,2,4);
imagesc(PC3(1+L:end-L,1+L:end-L))
caxis(crange);

linkaxes(ax);