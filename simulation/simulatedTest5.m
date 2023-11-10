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

R_pad=50;L1=50;L2=80;

x1 = 1:(L1+R_pad*2);
x2 = 1:(L2+R_pad*2);
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];
dat=zeros(max(x2),max(x1));

d=4;I=20;
y_single= mvnpdf(X,[L1/2+R_pad-d L2/4+R_pad],[1 0;0 1]*10);
y_single=y_single/max(y_single)*I;
y_single = reshape(y_single,length(x2),length(x1));
dat=dat+y_single;

y_single= mvnpdf(X,[L1/2+R_pad+d L2/4+R_pad],[1 0;0 1]*10);
y_single=y_single/max(y_single)*I;
y_single = reshape(y_single,length(x2),length(x1));
dat=dat+y_single;

y_single= mvnpdf(X,[L1/2+R_pad L2/4*3+R_pad],[1 0;0 1]*30);
y_single=y_single/max(y_single)*7;
y_single = reshape(y_single,length(x2),length(x1));
dat=dat+y_single;

dat_signal=dat;
dat_noise=randn(size(dat))*1;
dat=dat+dat_noise;

%
smFactorLst=1;zRatio=1;R=max(smFactorLst)*3;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d4(dat,smFactorLst,zRatio);

PC_null=PrcplCrvtr_scaleInvariant_2D_v4d4(dat_noise,smFactorLst,zRatio);
zThres=2;
[N,edges] = histcounts(PC_null(R:end-R,R:end-R));
[muCnt,muIdx]=max(N);
p = normpdf(zThres)*normpdf(0);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)>muIdx),1,"first");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(T-mu)/zThres;
PC_old1=max((PC_raw-mu)./sigma,0);

%
smFactorLst=3;zRatio=1;R=max(smFactorLst)*3;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d4(dat,smFactorLst,zRatio);

PC_null=PrcplCrvtr_scaleInvariant_2D_v4d4(dat_noise,smFactorLst,zRatio);
zThres=2;
[N,edges] = histcounts(PC_null(R:end-R,R:end-R));
[muCnt,muIdx]=max(N);
p = normpdf(zThres)*normpdf(0);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)>muIdx),1,"first");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(T-mu)/zThres;
PC_old2=max((PC_raw-mu)./sigma,0);

%
smFactorLst=1.2.^(0:6);zRatio=1;R=ceil(max(smFactorLst)*3);
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d4(dat,smFactorLst,zRatio);

PC_null=PrcplCrvtr_scaleInvariant_2D_v4d4(dat_noise,smFactorLst,zRatio);
zThres=2;
[N,edges] = histcounts(PC_null(R:end-R,R:end-R));
[muCnt,muIdx]=max(N);
p = normpdf(zThres)*normpdf(0);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)>muIdx),1,"first");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(T-mu)/zThres;
PC_new=max((PC_raw-mu)./sigma,0);
%
crange=[0 4];
subplot(1,4,1);
imagesc(dat(1+R_pad:end-R_pad,1+R_pad:end-R_pad));
title("raw data");
axis off;

subplot(1,4,2);
imagesc(PC_old1(1+R_pad:end-R_pad,1+R_pad:end-R_pad));
caxis(crange);
title("smooth factor = 1");
axis off;

subplot(1,4,3);
imagesc(PC_old2(1+R_pad:end-R_pad,1+R_pad:end-R_pad));
caxis(crange);
title("smooth factor = 3");
axis off;

subplot(1,4,4);
imagesc(PC_new(1+R_pad:end-R_pad,1+R_pad:end-R_pad));
caxis(crange);
title("multiscale");
axis off;