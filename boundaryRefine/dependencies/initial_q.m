function q = initial_q(scaling, tracking_flag)
% initialize the parameters for region grow
if nargin == 0
    scaling = 1;
    tracking_flag = false;
elseif nargin == 1
    tracking_flag = false;
end
q.minSeedSize = 1; % seed size
q.minSize = 1;% cell size

q.cost_design = [1, 2];
q.growConnectInTest = 4;
q.growConnectInRefine = 6;
q.edgeConnect = 48; % three circle of neighbors
% deal with one component each time
q.neiMap = 26;
q.shift = [20 20 4];%[10 10 2];%
q.shrinkFlag = true;
q.fgBoundaryHandle = 'leaveAloneFirst'; % leaveAloneFirst, compete or repeat:
% if the fg is touching the boundary of the intial foreground, we can choose to 
% (1) leaveAloneFirst: if after gap testing, the region is still large, we
% enlarge the foreground and re-do our pipeline
% (2) repeat: enlarge the foreground and re-do pipeline immediately, not 
% waiting for the next gap testing step
% (3) compete: using the boundary as another region to compete with seed 
% region the split the fg. This method is default when do tracking

q.saveInterMediateRes = false;
% If we scaled the data
if scaling ~= 1
    q.minSize = q.minSize/scaling;% cell size
    q.minSeedSize = q.minSeedSize/scaling; % seed size
    q.shift = floor(q.shift/scaling);
end
if tracking_flag
    % should we remove small regions?
    q.shortestTrack = 0; % the shortest path we want, cells in other tracks will be removed
    q.removeSamllRegion = true; % though we have threshold, we did not
    q.fgBoundaryHandle = 'leaveAloneFirst';
    q.growSeedTimes = 2;
    q.growSeedinTracking = true;
    q.multi_frames_flag = false; % we did not consider multiple frames. Otherwise
    % there may be results dominated by other bright cells
    q.multiSeedProcess = true; % did we add multiple cells simultaneously or one by one
    q.splitRegionInTracking = true;
    
    q.updateCellsAdjMissingCell = false;% when add missing cell, do we need to update other regions nearby
    q.sqrtDistance = false; % euclidian distance or squared euclidian distance
end
end