function sMap = getSmartSeedStandalone(seed_id, comMaps,option)
% refine the seed region indicate by index in yxz

% It remove the crop part outside for parallel computation 
% by mengfan  10/05/2022

% NOTE: it is possible the yxz is not exactly the same as seed_id label
% indicates, e.g. the seed is relabeled. We view yxz as the correct one.

smartSeedRegion=comMaps.score3dMap>0;
smartSeedRegion=comMaps.score3dMap==min(comMaps.score3dMap(smartSeedRegion));

%% gap detection based on min cut
comMaps.score3dMap(comMaps.score3dMap<0) = 0;
min_pv = min(comMaps.score3dMap(:));
max_pv = max(comMaps.score3dMap(:));
comMaps.score3dMap = scale_image(comMaps.score3dMap, 1e-3,1, min_pv, max_pv);

strel_rad = option.shift;
strel_ker = getKernel(strel_rad);
fMap = comMaps.regComp;
fMap = imdilate(fMap,strel_ker);
fMap((comMaps.idComp ~= seed_id) & (comMaps.idComp > 0)) = 0;

com = comMaps.newIdComp>0;

sMap = false(size(fMap));
sMap(com) = true;
scoreMap = comMaps.score3dMap; % before fusion
scoreMap(scoreMap<0) = 0;
sMap=getSmartSeed(scoreMap,fMap,sMap,smartSeedRegion);



end

function strel_ker = getKernel(strel_rad)
    strel_ker = ones(strel_rad*2+1);
    ratio=size(strel_ker,1)/size(strel_ker,3);

    [xx,yy,zz] = ind2sub_direct(size(strel_ker), find(strel_ker));
    dist = sqrt( (xx - strel_rad(1)-1).^2 + (yy - strel_rad(2)-1).^2 + ( (zz -strel_rad(3)-1)*ratio ).^2 );
    strel_ker(dist>=strel_rad(1)) = 0;
    strel_ker = strel(strel_ker);
end