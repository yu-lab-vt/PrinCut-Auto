function [PC_org,sigma,mu]=PCThreshold(PC_raw,BG,smFactorMax)
zThres=1;R=ceil(smFactorMax*3)*2;
BG2=imerode(BG,true(R+1));
ValidRigion=false(size(BG2));
ValidRigion(1+R(1):end-R(1),1+R(2):end-R(2),1+R(3):end-R(3))=true;
BG2(~ValidRigion)=false;

if length(find(BG2))<100
    PC_org=nan;
    sigma=nan;
    mu=nan;
    return
end

PC_null=PC_raw(BG2);
[N,edges] = histcounts(PC_null);
[muCnt,muIdx]=max(N);
p = normpdf(zThres);
CntThres=muCnt*p;
TIdx=find((N<CntThres)&(1:length(N)>muIdx),1,"first");

mu=mean(edges(muIdx:muIdx+1));
T=mean(edges((TIdx-1):TIdx));
sigma=(T-mu)/zThres;
PC_org=(PC_raw-mu)./sigma;
end
