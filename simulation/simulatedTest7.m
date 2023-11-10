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

L1=20;L2=20;

x1 = 1:L1;
x2 = 1:L2;
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];

y_single= mvnpdf(X,[L1/2 L2/2],[1 0;0 1/6]*5);
y_single=y_single/max(y_single)*7;
y_single = reshape(y_single,length(x2),length(x1));
dat=y_single;

sigma=0.5;
dat_noise=randn(size(dat))*sigma;


% dat_noise=randn(size(dat)*100)*sigma;

%%
smFactorLst=2;zRatio=6;R=max(smFactorLst)*3;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d2(dat,smFactorLst,zRatio);
PC_noise=PrcplCrvtr_scaleInvariant_2D_v4d2(dat_noise,smFactorLst,zRatio);
PC_noise=PC_noise(R:end-R,R:end-R);

% PC_old1=(PC_raw-mean(PC_noise(:)))/std(PC_noise(:));
PC_old1=PC_raw/std(PC_noise(:));
% PC_old1=PC_noise/std(PC_noise(:));
%%
smFactorLst=2;zRatio=6;R=max(smFactorLst)*3;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d3(dat,smFactorLst,zRatio);
PC_noise=PrcplCrvtr_scaleInvariant_2D_v4d3(dat_noise,smFactorLst,zRatio);
PC_noise=PC_noise(R:end-R,R:end-R);

% PC_old2=(PC_raw-mean(PC_noise(:)))/std(PC_noise(:));
PC_old2=PC_raw/std(PC_noise(:));
% PC_old2=PC_noise/std(PC_noise(:));

%%
smFactorLst=2;zRatio=6;R=ceil(max(smFactorLst)*3);
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d4(dat,smFactorLst,zRatio);
PC_noise=PrcplCrvtr_scaleInvariant_2D_v4d4(dat_noise,smFactorLst,zRatio);
PC_noise=PC_noise(R:end-R,R:end-R);

% PC_new=(PC_raw-mean(PC_noise(:)))/std(PC_noise(:));
PC_new=PC_raw/std(PC_noise(:));
% PC_new=PC_noise/std(PC_noise(:));
%%
% crange=[0 4];
subplot(2,4,1);
imagesc(dat);
title("raw data");
axis off;

crange=[-1 1]*10;
subplot(2,4,2);
imagesc(PC_old1);
caxis([0 1]*max(PC_old1(:)));
title("traditional curvature");
axis off;

subplot(2,4,3);
imagesc(PC_old2);
caxis([0 1]*max(PC_old2(:)));
title("2D+1D");
axis off;

subplot(2,4,4);
imagesc(PC_new);
caxis([0 1]*max(PC_new(:)));
title("multi-resolution");
axis off;
%%
dat=dat+dat_noise;
%%
smFactorLst=2;zRatio=6;R=max(smFactorLst)*3;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d2(dat,smFactorLst,zRatio);
PC_noise=PrcplCrvtr_scaleInvariant_2D_v4d2(dat_noise,smFactorLst,zRatio);
PC_noise=PC_noise(R:end-R,R:end-R);

% PC_old1=(PC_raw-mean(PC_noise(:)))/std(PC_noise(:));
PC_old1=PC_raw/std(PC_noise(:));
% PC_old1=PC_noise/std(PC_noise(:));
%%
smFactorLst=2;zRatio=6;R=max(smFactorLst)*3;
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d3(dat,smFactorLst,zRatio);
PC_noise=PrcplCrvtr_scaleInvariant_2D_v4d3(dat_noise,smFactorLst,zRatio);
PC_noise=PC_noise(R:end-R,R:end-R);

% PC_old2=(PC_raw-mean(PC_noise(:)))/std(PC_noise(:));
PC_old2=PC_raw/std(PC_noise(:));
% PC_old2=PC_noise/std(PC_noise(:));

%%
smFactorLst=2;zRatio=6;R=ceil(max(smFactorLst)*3);
PC_raw=PrcplCrvtr_scaleInvariant_2D_v4d4(dat,smFactorLst,zRatio);
PC_noise=PrcplCrvtr_scaleInvariant_2D_v4d4(dat_noise,smFactorLst,zRatio);
PC_noise=PC_noise(R:end-R,R:end-R);

% PC_new=(PC_raw-mean(PC_noise(:)))/std(PC_noise(:));
PC_new=PC_raw/std(PC_noise(:));
% PC_new=PC_noise/std(PC_noise(:));
%%
% crange=[0 4];
subplot(2,4,5);
imagesc(dat);
title("raw data");
axis off;

crange=[-1 1]*10;
subplot(2,4,6);
imagesc(PC_old1);
caxis([0 1]*max(PC_old1(:)));
title("traditional curvature");
axis off;

subplot(2,4,7);
imagesc(PC_old2);
caxis([0 1]*max(PC_old2(:)));
title("2D+1D");
axis off;

subplot(2,4,8);
imagesc(PC_new);
caxis([0 1]*max(PC_new(:)));
title("multi-resolution");
axis off;