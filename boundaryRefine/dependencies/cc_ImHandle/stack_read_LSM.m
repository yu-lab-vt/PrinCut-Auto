function [ im, channelColors, channelNames, timeStamps ] = stack_read_LSM( filename, ROI )
% read zeiss lsm file to matrix height*width*depth*numChannel*numTime*numLocation
% ROI: [up down; left right; zup zdown; channelstart channelend]

if nargin > 1 && ~isempty(ROI)
    ROIup = ROI(1,1);
    ROIdown = ROI(1,2);
    ROIleft = ROI(2,1);
    ROIright = ROI(2,2);
    ROIzup = ROI(3,1);
    ROIzdown = ROI(3,2);
    ROIchannelStart = ROI(4,1);
    ROIchannelEnd = ROI(4,2);
else
    ROIup = 1;
    ROIdown = -1;
    ROIleft = 1;
    ROIright = -1;
    ROIzup = 1;
    ROIzdown = -1;
    ROIchannelStart = 1;
    ROIchannelEnd = -1;
end

imgs = tiffread(filename);
numDirectory = length(imgs);
if iscell(imgs(1).data)
    dataType = class(imgs(1).data{1});
else
    dataType = class(imgs(1).data);
end

lsmif = lsminfo(filename);
channelColors = {};
if (lsmif.ChannelColors.NumberColors > 0 && lsmif.ChannelColors.NumberColors == lsmif.DimensionChannels)
    channelColors = lsmif.ChannelColors.Colors;
end
channelNames = {};
if (lsmif.ChannelColors.NumberNames > 0 && lsmif.ChannelColors.NumberNames == lsmif.DimensionChannels)
    channelNames = lsmif.ChannelColors.Names;
end
timeStamps = [];
if (lsmif.TimeStamps.NumberTimeStamps > 0 && lsmif.TimeStamps.NumberTimeStamps == lsmif.DimensionTime)
    timeStamps = lsmif.TimeStamps.Stamps;
end

depth = lsmif.DimensionZ;
height = lsmif.DimensionY;
width = lsmif.DimensionX;
numTime = lsmif.DimensionTime;
numChannel = lsmif.DimensionChannels;
numLocation = numDirectory / (numTime*depth);

if ROIdown == -1 || ROIdown > height
    ROIdown = height;
end
if ROIright == -1 || ROIright > width
    ROIright = width;
end
if ROIzdown == -1 || ROIzdown > numFrames
    ROIzdown = depth;
end
if ROIchannelEnd == -1 || ROIchannelEnd > numChannel
    ROIchannelEnd = numChannel;
end

im = zeros([ROIdown-ROIup+1 ROIright-ROIleft+1 ROIzdown-ROIzup+1 ROIchannelEnd-ROIchannelStart+1 numTime numLocation], dataType);

depthIdx = 1;
timeIdx = 1;
locationIdx = 1;

for d=1:numDirectory
    if depthIdx >= ROIzup && depthIdx <= ROIzdown
        if iscell(imgs(d).data)
            for ch=ROIchannelStart:ROIchannelEnd
                im(:,:,depthIdx-ROIzup+1,ch-ROIchannelStart+1,timeIdx,locationIdx) = imgs(d).data{ch}(ROIup:ROIdown, ROIleft:ROIright);
            end
        else
            assert(ROIchannelStart == ROIchannelEnd);
            im(:,:,depthIdx-ROIzup+1,1-ROIchannelStart+1,timeIdx,locationIdx) = imgs(d).data(ROIup:ROIdown, ROIleft:ROIright);
        end
    end
    depthIdx = depthIdx + 1;
    if (depthIdx > depth)
        depthIdx = 1;
        timeIdx = timeIdx + 1;
        if timeIdx > numTime
            timeIdx = 1;
            locationIdx = locationIdx + 1;
        end
    end
end

assert(locationIdx == numLocation+1 && timeIdx == 1 && ...
    depthIdx == 1, 'read lsm file error');

end


