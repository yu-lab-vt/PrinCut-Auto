function comMaps = get_local_area_Wei(vid,idMap,reg_id, eig3d, yxz, shift)

%%
% crop the info we need that only contains the targeted region(s)
% region is defined by yxz and shift
comMaps = [];
comMaps.idComp = crop3D(idMap, yxz, shift);
comMaps.regComp = (comMaps.idComp == reg_id);

%%
[comMaps.vidComp,comMaps.linerInd, ~, ~] = crop3D(vid, yxz, shift);
%% build 3d/2d principal curveture score map
eig3dComp = crop3D(eig3d, yxz, shift);
eigPosMap = eig3dComp>0; % gaps detected by principal curvature
eig3dComp(eigPosMap<0) = 0;

comMaps.score3dMap = eig3dComp;%scale_image(eig3dComp, 1e-3,1);


comMaps.newIdComp = comMaps.regComp;
comMaps.newIdComp(eigPosMap) = 0; % if we segment current region further

end


