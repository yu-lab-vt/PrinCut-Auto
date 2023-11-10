%% get curvature
szLst=1:30;
N=length(szLst);
sLst=zeros(size(szLst));
nLst=zeros(size(szLst));

rLst=zeros(size(szLst));;

for n=1:N
    disp(n)
    sz=szLst(n);
    smFactor=[1 1 1/6]*sz;
    L=round(smFactor*11)+1;
    hrow = images.internal.createGaussianKernel(smFactor(1), L(1));
    hcol = images.internal.createGaussianKernel(smFactor(2), L(2))';
    hslc = images.internal.createGaussianKernel(smFactor(3), L(3));
    hslc = reshape(hslc, 1, 1, L(3));
    GaussFltr = pagemtimes(hrow*hcol,hslc);
    
    gradFltr_X=[0.5;0;-0.5];
    gradFltr_Y=gradFltr_X';
    gradFltr_Z=[0.5;0;-0.5];
    gradFltr_Z =reshape(gradFltr_Z,1,1,[]);
    
    % xx, yy, xy direction
    GX=convn(GaussFltr,gradFltr_X);
    GY=convn(GaussFltr,gradFltr_Y);
    GZ=convn(gradFltr_Z,GaussFltr);
    
    GXX=convn(GX,gradFltr_X);
    GYY=convn(GY,gradFltr_Y);
    GZZ=convn(gradFltr_Z,GZ);
    
    sxx=sum(abs(GXX(:)));
    syy=sum(abs(GYY(:)));
    szz=sum(abs(GZZ(:)));
    
    
    nxx=sqrt(sum(GXX(:).^2));
    nyy=sqrt(sum(GYY(:).^2));
    nzz=sqrt(sum(GZZ(:).^2));
    
    sLst(n)=szz/sxx;
    nLst(n)=nzz/nxx;

%     GXX1D=conv(conv(hrow,gradFltr_X),gradFltr_X);
%     GXX1D=GXX1D/sum(abs(GXX1D));
%     GZZ1D=conv(conv(hslc(:),gradFltr_X),gradFltr_X);
%     GZZ1D=GZZ1D/sum(abs(GZZ1D));
% 
%     rLst(n)=sum(GZZ1D.^2)/sum(GXX1D.^2);

end

yyaxis left
plot(szLst,sLst);
axis([-inf inf 0 36]);
% hold on;
% plot(szLst,nLst);
yyaxis right;
plot(szLst,nLst);
axis([-inf inf 0 36]);

% yyaxis left
% plot(szLst,nLst./sLst);
% axis([-inf inf 0 inf]);
% yyaxis right;
% plot(szLst,rLst);
% axis([-inf inf 0 inf]);
