function locLst=findFirstLocalMaxMin(curvature_all)
[~,Fcur]=gradient(curvature_all);
BiFcur=Fcur>0;
localOptimal=(abs(BiFcur-BiFcur(1,:)))>0;

[N_smNum,~]=size(localOptimal);
locMatrix=ones(size(localOptimal)).*(1:N_smNum)';
locMatrix(~localOptimal)=inf;
locLst=min(locMatrix,[],1);
locLst(locLst==inf)=1;
end