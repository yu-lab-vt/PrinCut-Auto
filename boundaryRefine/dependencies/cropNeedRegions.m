function comMaps = cropNeedRegions(vid, vid_stb, idMap, reg_id, eig2d, ...
    eig3d, yxz, improc, shift)
% crop the info we need that only contains the targeted region(s)
% region is defined by yxz and shift
comMaps = [];
comMaps.idComp = crop3D(idMap, yxz, shift);
reg_map = comMaps.idComp == reg_id;
[comMaps.regComp, ~] = pickLargestReg(reg_map, 26);%

%%
[comMaps.vidComp,comMaps.linerInd, ~, loc_org_xyz] = crop3D(vid, yxz, shift);
%% build the foreground map                                                % This part include two regions, a larger one(yxz) and a smaller
seed_idx_in_cropReg = coordinate_transfer(yxz, size(vid), loc_org_xyz, ... % one(regComp). The candidate foreground is between the two
    size(comMaps.idComp));
seed_map4fg = comMaps.regComp;
if ~isempty(find(comMaps.idComp(seed_idx_in_cropReg)~=reg_id, 1))            % exist region ~= reg_id
    % the idx yxz is larger the area covered by reg_id in label map, we add  
    % yxz as our standard to detect the foreground (and only for foreground)
    seed_map4fg(seed_idx_in_cropReg) = true;                                 % if exist other region, we select all but pick the largest
    seed_map4fg = pickLargestReg(seed_map4fg, 26);
    if ~isempty(find(seed_map4fg & comMaps.regComp,1))...
        && ~isempty(find(seed_map4fg & ~comMaps.regComp,1))
        comMaps.regComp = seed_map4fg;                                       % update regComp
    end
end
%% build 3d/2d principal curveture score map
eig3dComp = crop3D(eig3d, yxz, shift);
eigPosMap = eig3dComp>0; % gaps detected by principal curvature
eig3dComp(eigPosMap<0) = 0;

comMaps.score3dMap = eig3dComp;%scale_image(eig3dComp, 1e-3,1);


comMaps.newIdComp = comMaps.regComp;
comMaps.newIdComp(eigPosMap) = 0; % if we segment current region further

end