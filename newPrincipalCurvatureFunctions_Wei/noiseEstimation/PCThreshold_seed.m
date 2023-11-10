function [PC_org,T]=PCThreshold_seed(PC_raw,BG,smFactorMax,zThres)
BG2=imerode(BG,ones(ceil(smFactorMax*7)));
PC_null=PC_raw(BG2);
[N,edges] = histcounts(PC_null);
[muCnt,muIdx]=max(N);
p = normpdf(zThres);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)<muIdx),1,"last");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(mu-T)/zThres;
PC_org=(PC_raw-mu)./sigma+zThres;
end