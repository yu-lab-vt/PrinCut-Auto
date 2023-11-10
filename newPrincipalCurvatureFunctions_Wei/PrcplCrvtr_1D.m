function curvature=PrcplCrvtr_1D(y,smFactorLst)
%principal curvature detection v1.0
% curvature=PrcplCrvtr_1D(y) return the curvature of y



y=y(:)';
curvature=-inf(size(y));

% smFactorLst=1:10;
N_smNum=length(smFactorLst);
curFltr=[0.25 0 -0.5 0 0.25];
for smCnt=1:N_smNum
    smFactor=smFactorLst(smCnt);
    gauFltr_0=normpdf(-smFactor*10:smFactor*10,0,smFactor);
    gauFltr=gauFltr_0/sum(gauFltr_0);
    finalFltr=conv(curFltr,gauFltr);
%     finalFltr=finalFltr/sum(abs(finalFltr));
    SZpad=length(finalFltr);
    y_pad=[ones(1,SZpad)*y(1) y ones(1,SZpad)*y(end)];
    y1=conv(y_pad,finalFltr);
    newSZpad=(SZpad-1)/2+SZpad;
    y_2=y1(1+newSZpad:end-newSZpad);
    curvature=max(curvature,y_2);
end

end