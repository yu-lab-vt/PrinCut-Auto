function OrSt = inital_Orst()
% parameters for fg detection and gap significance test
OrSt.gapTestWay = 'localOrdStats';%'orderStats';%
OrSt.mu = [];
OrSt.sigma = [];
OrSt.p_thres = 0.01; % pvalue threshold
OrSt.imProcMethod = 'noStb';% 'stb' or 'noStb'
OrSt.fgVarSamplewiseEst = true;% or 'noStb'
OrSt.refine_cc = 'single_seed'; % use only the connected-component containing the testing seed
OrSt.fgTestWay = 'KSecApprox';%'ttest_varKnown';KSecApprox