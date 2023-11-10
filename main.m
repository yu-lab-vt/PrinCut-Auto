clc;clear;
%% addpath
addpath(genpath("./signalGenerator"));
addpath(genpath("./newPrincipalCurvatureFunctions_Wei"));
addpath(genpath("./detector_Wei"));
addpath(genpath("./imageIO_Wei"));
addpath(genpath("./boundaryRefine"));
addpath(genpath("./SIPCv4"));
%% parameters
zThres=2;        % z threshold of multi-scale principal curvature
zRatio=5;        % resolution ratio between z axis and x axis
smStart=2;       % smallest smooth factor for multi-scale principal curvature
smEnd=5;         % largest smooth factor for multi-scale principal curvature
BG_thres_min=0;  % min background intesntiy for noise estimation
BG_thres_max=50; % max background intensity for noise estimation
%%
filePath=".\data";      

fileLst=dir(filePath+"/*.tif");
N=length(fileLst);
%%
for fileCnt=1:N
    %%
    disp("Cnt: "+fileCnt);
    tic;
    %% read data
    ImName=fileLst(fileCnt).name;
    dat=tifread(fullfile(filePath,ImName));
    %% get MSPC
    N=ceil(log(smEnd/smStart)/log(1.2));
    smFactorLst=1.2.^(0:N).*smStart;
    BG=dat>BG_thres_min&dat<BG_thres_max;
    [PC_raw,FGmap,curvature_all]=PrcplCrvtr_scaleInvariant_3D_v9(dat,smFactorLst,zRatio,BG);
    curvature_fisrt=curvature_all(:,:,:,1);
    %% get seed
    eig_res_3d=PC_raw-zThres;
    gapMap=eig_res_3d>0;
    maxSZ=10000;
    eig_res_3d=curvature_fisrt;
    eig_res_3d(gapMap)=max(eig_res_3d(gapMap),1e-3);
    eig_res_3d(~gapMap)=-1;
    seedMap=getSeedMap(eig_res_3d,FGmap,maxSZ);
    %% boundary refine
    option.costDesign=2;
    option.zRatio=zRatio;
    [refine_res,~]=regionWiseAnalysis4d_Wei_v11(seedMap,eig_res_3d,dat,option);
    refine_res=uint16(refine_res);
    %% write data
    out_dat=gray2RGB_HD(max(min(mat2gray(dat)*2,1),0));
    out_newId=label2RGB_HD(refine_res);
    out=out_dat*0.8+out_newId*0.5;
    tifPath=convertStringsToChars(fullfile(filePath,ImName(1:end-4)+"_vis"));
    tifwrite(out, tifPath);
    tifPath=convertStringsToChars(fullfile(filePath,ImName(1:end-4)+"_label"));
    tifwrite(refine_res, tifPath);
    toc;
end