function curvature=getCurvature_2D_v4d3(dat,smFactor)
%get 2D principal curvatrue of 3D data with AUC normalization, get the
%noise level id map, v2.1.
%
% Don't directly use this function.
% This function should be used by PrcplCrvtr_scaleInvariant_2D_v2d1
%
% input:    dat:                3D input data
%           smFactor:           the Gaussian smooth filter std
%                               relationship
% output:   curvature:          2D principal curvature for 3D data
% 
% 9/29/2022 by Wei Zheng 

%% get curvature
if length(smFactor)==1
    smFactor(2)=smFactor(1);
end

%%
[xx, yy, xy, ~] = Hessian2D_v4(gpuArray(dat),smFactor);


c=cal_pc_2d(xx,yy,xy);

curvature=c/max(c(:))+yy/max(yy(:));

end