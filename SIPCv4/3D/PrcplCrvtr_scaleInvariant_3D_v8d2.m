function [curvature_merged,FGmap,curvature_all]=PrcplCrvtr_scaleInvariant_3D_v8d2(dat,smFactorLst,zRatio,BG)
%scale invariant principal curvature for 3D data, v8.1
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
%%
[X,Y,Z]=size(dat);
Roverlap=ceil(max(smFactorLst)*3);
% PatchSzX=floor(10e8/(Y*Z))-2*Roverlap;
PatchSzX=floor(gpuDevice().AvailableMemory/4/12/(Y*Z))-2*Roverlap;
patchNum=ceil(X/PatchSzX);

%% estimate noise
for smCnt=1
%     disp(smCnt);
%     tic;
    smFactor=[1 1 1/zRatio]*1e-2;
    curvature_temp=zeros(size(dat),"single");
    for patchCnt=1:patchNum
        
        xStartRaw=(patchCnt-1)*PatchSzX+1;
        xEndRaw=min(patchCnt*PatchSzX,X);
        xStart=xStartRaw-Roverlap;
        xEnd=xEndRaw+Roverlap;
        if patchCnt==1
            xStart=xStartRaw;
        end
        if patchCnt==patchNum
            xEnd=xEndRaw;
        end

        temp=getCurvature_3D_v4d4(dat(xStart:xEnd,:,:),smFactor);
        curvature_temp(xStartRaw:xEndRaw,:,:)=temp(xStartRaw-xStart+1:end-(xEnd-xEndRaw),:,:);
    end
    
    [~,sigmaLstHF,muLstHF]=PCThreshold(curvature_temp,BG,smFactor);
%     toc;
end
%% iteratively get optimal curvature
for smCnt=1:N_smNum
%     disp(smCnt);
%     tic;
    smFactor=[1 1 1/zRatio]*smFactorLst(smCnt);
    curvature_temp=zeros(size(dat),"single");
    for patchCnt=1:patchNum
        
        xStartRaw=(patchCnt-1)*PatchSzX+1;
        xEndRaw=min(patchCnt*PatchSzX,X);
        xStart=xStartRaw-Roverlap;
        xEnd=xEndRaw+Roverlap;
        if patchCnt==1
            xStart=xStartRaw;
        end
        if patchCnt==patchNum
            xEnd=xEndRaw;
        end

        temp=getCurvature_3D_v4d4(dat(xStart:xEnd,:,:),smFactor);
        curvature_temp(xStartRaw:xEndRaw,:,:)=temp(xStartRaw-xStart+1:end-(xEnd-xEndRaw),:,:);
    end
    
%     [~,sigmaLst(smCnt),muLst(smCnt)]=PCThreshold(curvature_temp,BG,smFactor);
    curvature_all(:,:,:,smCnt)=curvature_temp;
%     toc;
end
%% 
fprintf('Start merge principal curvature! \n');
curvature_all_modified=(curvature_all-muLstHF)/sigmaLstHF;
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