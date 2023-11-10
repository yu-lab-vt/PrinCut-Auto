%%
addpath(genpath("./signalGenerator"));
addpath(genpath("./newPrincipalCurvatureFunctions_Wei"));
addpath(genpath("./detector_Wei"));
addpath(genpath("./imageIO_Wei"));
addpath(genpath("./boundaryRefine"));
addpath(genpath("./SIPCv4"));
%% generated signal
szLst=4*1.2.^(8:-1:0);
intLst=1*1.2.^(13:-1:2);

% szLst=10:-1:1;
% intLst=1.1.^(20:-2:1);
zRatio=1;
Ratio=[1 1/zRatio];

N_sz=length(szLst);
N_int=length(intLst);
R=round(max(szLst(:))*Ratio(2:-1:1))*2; L=2*R+1;


x1 = 1:N_int*L(2);
x2 = 1:N_sz*L(1);
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];

r=0.5;

dat=zeros(max(x2),max(x1));
for i=1:N_sz
    for j=1:N_int

        mu=[i j].*L-R+szLst(i).*Ratio(2:-1:1)*r;
        y_single= mvnpdf(X,mu(2:-1:1),[Ratio(1) 0;0 Ratio(2)]*szLst(i));
        y_single=y_single/max(y_single)*intLst(j);
        y_single = reshape(y_single,length(x2),length(x1));
        dat=dat+y_single;

        mu=[i j].*L-R-szLst(i).*Ratio(2:-1:1)*r;
        y_single= mvnpdf(X,mu(2:-1:1),[Ratio(1) 0;0 Ratio(2)]*szLst(i));
        y_single=y_single/max(y_single)*intLst(j);
        y_single = reshape(y_single,length(x2),length(x1));
        dat=dat+y_single;
    end
end

dat_noise=randn(size(dat))*1;
dat_gt=dat;
dat=dat+dat_noise;

%%
smFactorLst=3;
% smFactorLst=1:2;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d4(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d4(dat_noise,smFactorLst,zRatio);
zThres=2;

[N,edges] = histcounts(PC_null);
[muCnt,muIdx]=max(N);
p = normpdf(zThres)*normpdf(0);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)>muIdx),1,"first");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(T-mu)/zThres;
PC1=max((PC_raw-mu)./sigma,0);
%%
smFactorLst=1*1.2.^(0:10);
% smFactorLst=1:2;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d4(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d4(dat_noise,smFactorLst,zRatio);
zThres=2;

[N,edges] = histcounts(PC_null);
[muCnt,muIdx]=max(N);
p = normpdf(zThres)*normpdf(0);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)>muIdx),1,"first");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(T-mu)/zThres;
PC2=max((PC_raw-mu)./sigma,0);

%%


figure;ax=[];
ax(1)=subplot(3,2,1);
imagesc(dat(1+L:end-L,1+L:end-L))
% title("data");
axis off;
caxis([-4 6]);

ax(1)=subplot(3,2,2);
imagesc(dat_gt(1+L:end-L,1+L:end-L))
% title("data");
axis off;
caxis([-4 6]);



crange=[0 10];

ax(2)=subplot(3,2,3);
imagesc(PC1(1+L:end-L,1+L:end-L))
caxis(crange);
% title("smooth factor=3");
axis off;

ax(3)=subplot(3,2,5);
imagesc(PC2(1+L:end-L,1+L:end-L))
caxis(crange);
linkaxes(ax);
% title("multi-scale");
axis off;

ax(4)=subplot(3,2,4);
imagesc(PC1(1+L:end-L,1+L:end-L)>2)
linkaxes(ax);
% title("z score > 2");
axis off;

ax(5)=subplot(3,2,6);
imagesc(PC2(1+L:end-L,1+L:end-L)>2)
linkaxes(ax);
% title("z score > 2");
axis off;

colormap gray

colormap(ax(2),"jet")
colormap(ax(3),"jet")