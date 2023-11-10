%% addpath
addpath(genpath("./signalGenerator"));
addpath(genpath("./newPrincipalCurvatureFunctions_Wei"));
addpath(genpath("./detector_Wei"));
addpath(genpath("./imageIO_Wei"));
addpath(genpath("./boundaryRefine"));
addpath(genpath("./SIPCv4"));
%% generate data
sz=6;smRefLst=0.7:0.1:5;
smFactor=[1 1 1]*sz;
L=round(smFactor*3*max(smRefLst))*2+1;
hrow = images.internal.createGaussianKernel(smFactor(1), L(1));
hcol = images.internal.createGaussianKernel(smFactor(2), L(2))';
hslc = images.internal.createGaussianKernel(smFactor(3), L(3));
hslc = reshape(hslc, 1, 1, L(3));
dat = pagemtimes(hrow*hcol,hslc);
dat=dat/max(dat(:));
% dat=dat>0.1;
%% get curvature
smFactorLst=smRefLst.*sz;zRatio=6;
N=length(smFactorLst);
scoreLst_x=zeros(size(smFactorLst));
scoreLst_y=zeros(size(smFactorLst));
scoreLst_z=zeros(size(smFactorLst));
parfor i=1:N
    disp(i);
    PC_raw=PrcplCrvtr_scaleInvariant_3D_v4d2(dat,smFactorLst(i),zRatio);
    scoreLst_x(i)=max(PC_raw(:,(L(2)+1)/2,(L(3)+1)/2),[],"all");
%     scoreLst_y(i)=max(PC_raw((L(1)+1)/2,:,(L(3)+1)/2),[],"all");
    scoreLst_z(i)=max(PC_raw((L(1)+1)/2,(L(2)+1)/2,:),[],"all");
end

%%
[V,I]=max(scoreLst_x);
scoreLst_x_n=scoreLst_x/max(V);
smFactorLst_n=(smFactorLst-smFactorLst(I))/smFactorLst(I);
Thres=0.95;
Idx=find(scoreLst_x_n>Thres);

figure;
plot(smFactorLst_n,scoreLst_x_n);
hold on;
% plot(smFactorLst,scoreLst_z);
% legend('x','z');
plot(smFactorLst_n,ones(size(smFactorLst_n))*Thres,'red');

LB=smFactorLst_n(Idx(1));HB=smFactorLst_n(Idx(end));
scatter(LB,Thres,25,'filled');
text(LB,Thres-0.02,num2str(LB,'%.2f'));
scatter(HB,Thres,25,'filled');
text(HB,Thres-0.02,num2str(HB,'%.2f'));

title("3D Gaussian, z=x/6, grow factor = "+num2str((1+HB)/(1+LB),'%.2f'));
axis([-inf inf 0.5 1]);
ylabel("score accuracy");
xlabel("normalized distance to optimal scale");