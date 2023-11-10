function y0=generateSimulatedSignal_1D()

L=5000;
N_signalNum=randi(50);


y0=zeros(1,L);
LocLst=rand(N_signalNum,1)*L;
SZLst=rand(N_signalNum,1)*50+5;
AmpLst=rand(N_signalNum,1)*5+5;

for Cnt_signal=1:N_signalNum
    x0=1:L;
    y_single=normpdf(x0,LocLst(Cnt_signal),SZLst(Cnt_signal));
    y_single=y_single/max(y_single)*AmpLst(Cnt_signal);
    y0=y0+y_single;
end

y_noise=randn(size(y0))*0.5;
y0=y0+y_noise;


end