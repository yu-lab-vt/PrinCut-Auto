%%
addpath(genpath("./signalGenerator"));
addpath(genpath("./newPrincipalCurvatureFunctions_Wei"));
addpath(genpath("./detector_Wei"));
addpath(genpath("./imageIO_Wei"));
addpath(genpath("./boundaryRefine"));
addpath(genpath("./SIPCv4"));
%% generated signal
% szLst=90:-10:11;
% intLst=1.1.^(20:-2:1);

szLst=10:-1:1;
intLst=1.1.^(20:-2:1);
zRatio=6;
Ratio=[1 1/zRatio];

N_sz=length(szLst);
N_int=length(intLst);
R=round(max(szLst(:))*Ratio(2:-1:1))*2; L=2*R+1;


x1 = 1:N_int*L(2);
x2 = 1:N_sz*L(1);
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];

r=0.3;

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
dat=dat+dat_noise;

%%
% smFactorLst=3:30;
smFactorLst=1:2;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d1(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d1(dat_noise,smFactorLst,zRatio);
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

% PC3=PC_raw;
%%
% smFactorLst=2:25;zRatio=5;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d2(dat,smFactorLst,zRatio);
PC_null=PrcplCrvtr_scaleInvariant_2D_v4d2(dat_noise,smFactorLst,zRatio);
zThres=2;

[N,edges] = histcounts(PC_null);
[muCnt,muIdx]=max(N);
p = normpdf(zThres)*normpdf(0);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)>muIdx),1,"first");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(T-mu)/zThres;
PC0=max((PC_raw-mu)./sigma,0);

% PC2=PC_raw;
%%
% smFactorLst=10;zRatio=5;
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
PC3=max((PC_raw-mu)./sigma,0);

% PC0=PC_raw;
%%


figure;
ax(1)=subplot(2,2,1);
imagesc(dat(1+L:end-L,1+L:end-L))

crange=[0 10];

ax(2)=subplot(2,2,2);
imagesc(PC0(1+L:end-L,1+L:end-L))
caxis(crange);
ax(3)=subplot(2,2,3);
imagesc(PC2(1+L:end-L,1+L:end-L))
caxis(crange);
ax(4)=subplot(2,2,4);
imagesc(PC3(1+L:end-L,1+L:end-L))
caxis(crange);
linkaxes(ax);

figure;
zThres=2;
ax(1)=subplot(2,2,1);
imagesc(dat(1+L:end-L,1+L:end-L))
ax(2)=subplot(2,2,2);
imagesc(PC0(1+L:end-L,1+L:end-L)>zThres);
ax(3)=subplot(2,2,3);
imagesc(PC2(1+L:end-L,1+L:end-L)>zThres);
ax(4)=subplot(2,2,4);
imagesc(PC3(1+L:end-L,1+L:end-L)>zThres);

linkaxes(ax);