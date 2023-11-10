function [curvature_merged,FGmap,curvature_all]=PrcplCrvtr_scaleInvariant_3D_v6(dat,smFactorLst,zRatio,BG)
%scale invariant principal curvature for 3D data, v3.1
% Detect 2D+3D curvature.
% This version is based on Noise normalization.
%
% input:    dat:                3D input data
%           smFactorLst:        vector of smooth factor
% output:   curvature_merged:   scale-invariant principal curvature
%
% 9/29/2022 by Wei Zheng

fprintf('Start curvature calculation! \n');
zThres=4;
dat=single(dat);
%% initialize
N_smNum=length(smFactorLst);
curvature_all=zeros([size(dat) N_smNum],class(dat));
sigmaLst=zeros(1,N_smNum);
muLst=zeros(1,N_smNum);
%% iteratively get optimal curvature
for smCnt=1:N_smNum
%     disp(smCnt);
%     tic;
    smFactor=[1 1 1/zRatio]*smFactorLst(smCnt);
    curvature_temp=getCurvature_3D_v4d2(dat,smFactor);
    [~,sigmaLst(smCnt),muLst(smCnt)]=PCThreshold(curvature_temp,BG,smFactor);
    curvature_all(:,:,:,smCnt)=curvature_temp;
%     toc;
end
%% 
fprintf('Start merge principal curvature! \n');
curvature_all_modified=(curvature_all-mean(muLst))/mean(sigmaLst);
% curvature_all_modified=curvature_all;
%% remove result smaller than min valid smooth factor
% curvature_merged2 = min(curvature_all,[],4);
% BGmap=curvature_merged2>-abs(zThres);
% FGmap=~BGmap;
% for smCnt=1:N_smNum
%     temp=curvature_all(:,:,:,smCnt);
%     if median(temp(FGmap))>-2
%         % result smaller than min valid smooth factor
%         curvature_all_modified(:,:,:,smCnt)=nan;
%     else
%         % min smooth factor found
%         break;
%     end
% end
% disp("min valid smooth factor: "+smFactorLst(smCnt));
%% remove result larger than max valid smooth factor
[curvature_merged2,Imin] = min(curvature_all_modified,[],4);
BGmap=curvature_merged2>-abs(zThres);
Imin(BGmap)=N_smNum;
FGmap=~BGmap;
invalidRegion=false(size(curvature_all_modified));
for smCnt=1:N_smNum
    invalidRegion(:,:,:,smCnt)=Imin<smCnt;
end
curvature_all_modified(invalidRegion)=nan;
curvature_merged = max(curvature_all_modified,[],4);

end