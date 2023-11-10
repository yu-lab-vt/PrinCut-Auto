function sMap_new=getSmartSeed(scoreMap,fMap,sMap,smartSeedRegion)

try
     [dat_in, src, sink] = shortestPath_negHandle_mat(scoreMap, fMap, sMap, ...
            smartSeedRegion, 10, [1 2], true);       % before fusion
     G = digraph(dat_in(:,1),dat_in(:,2),dat_in(:,3));
    
     P = shortestpath(G,src, sink);
    
     sMap_new = false(size(fMap));
     sMap_new(P(2:end-1))=true;
catch
    sMap_new=sMap;
end

end