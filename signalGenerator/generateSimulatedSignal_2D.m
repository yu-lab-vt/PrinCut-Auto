function dat=generateSimulatedSignal_2D()

L=200;
N_signalNum=50;

x1 = 1:L;
x2 = x1;
[X1,X2] = meshgrid(x1,x2);
X = [X1(:) X2(:)];

dat=zeros(L);
LocLst=rand(N_signalNum,2)*L;
SZLst=rand(N_signalNum,1)*50+5;
AmpLst=rand(N_signalNum,1)*5+5;

for Cnt_signal=1:N_signalNum
    y_single= mvnpdf(X,LocLst(Cnt_signal,:),eye(2)*SZLst(Cnt_signal));
    y_single=y_single/max(y_single)*AmpLst(Cnt_signal);
    y_single = reshape(y_single,length(x2),length(x1));
    dat=dat+y_single;
end

y_noise=randn(size(dat))*0.5;
dat=dat+y_noise;



end