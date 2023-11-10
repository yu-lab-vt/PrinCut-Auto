function volOutput=imreadBF(datname,zplanesIn,rmtframesIn,channelIn, ZTflag)
%[vol]=imreadBF(datname,zplanes,tframes,channel)
%
%imports images using the BioFormats package
%you can load multiple z and t slices at once, e.g. zplanes=[1 2 5] loads
%first,second and fifth z-slice in a 3D-Stack

%rmtframes indicates the frames need to be removed
%[] no frames removed, 4==> 4 frames from last-3 to last frame, [1,2]
%==>first two frames
% zplanes indicate which z-stack we want to import, [] means
% all stacks; channel can only be one integeter
%if loading multiple z slices and tframes, everything is returned in one 3D
%Stack with order ZT.
%
%use imreadBFmeta() to get corresponding metadata of the image file
%
%To use the function, you have to download loci_tools.jar here: http://www.loci.wisc.edu/bio-formats/downloads
%make sure to have copied the file loci_tools.jar, in the folder where the
%function is placed (or to your work folder)
%
%
%
% For static loading, you can add the library to MATLAB's class path:
%     1. Type "edit classpath.txt" at the MATLAB prompt.
%     2. Go to the end of the file, and add the path to your JAR file
%        (e.g., C:/Program Files/MATLAB/work/loci_tools.jar).
%     3. Save the file and restart MATLAB.
%
%modified from bfopen.m
%christoph moehl 2011, cmohl@yahoo.com

if nargin < 5
    ZTflag = false; % output is YXCTZ (C is channel if color image)
    % if ZTflag = true, output is YXCZT
end

path = fullfile(fileparts(mfilename('fullpath')), 'loci_tools.jar');
javaaddpath(path);

if exist('lurawaveLicense')
    path = fullfile(fileparts(mfilename('fullpath')), 'lwf_jsdk2.6.jar');
    javaaddpath(path);
    java.lang.System.setProperty('lurawave.license', lurawaveLicense);
end

% check MATLAB version, since typecast function requires MATLAB 7.1+
canTypecast = versionCheck(version, 7, 1);

% check Bio-Formats version, since makeDataArray2D function requires trunk
bioFormatsVersion = char(loci.formats.FormatTools.VERSION);
isBioFormatsTrunk = versionCheck(bioFormatsVersion, 5, 0);

% initialize logging
loci.common.DebugTools.enableLogging('INFO');








r = loci.formats.ChannelFiller();
r = loci.formats.ChannelSeparator(r);
r.setId(datname);
numSeries = r.getSeriesCount();
volOutput = cell(numSeries,1);
for s=1:numSeries
    r.setSeries(s-1);
    width = r.getSizeX();
    height = r.getSizeY();
    pixelType = r.getPixelType();
    
    bpp = loci.formats.FormatTools.getBytesPerPixel(pixelType);
    fp = loci.formats.FormatTools.isFloatingPoint(pixelType);
    little = r.isLittleEndian();
    sgn = loci.formats.FormatTools.isSigned(pixelType);
    
    
    sizeT = r.getSizeT();
    if isempty(rmtframesIn)
        tframes = 1:sizeT;
    else
        tframes = 1:sizeT;
        tframes(rmtframesIn) = [];
    end
    sizeZ = r.getSizeZ();
    if isempty(zplanesIn)
        zplanes = 1:sizeZ;
    else
        zplanes = zplanesIn;
    end
    if isempty(channelIn)
        channelIn = 1:r.getSizeC();
    end
    
    channel=channelIn-1;
    zplane=zplanes-1;
    tframe=tframes-1;
    zahler=0;
    for j=1:length(tframe)
        for i=1:length(zplane)
            for cc = 1:length(channel)
                %['importing file via bioFormats\\ ',num2str(100*zahler/(length(tframe)*length(zplane))),'%']
                index=r.getIndex(zplane(i),channel(cc),tframe(j));
                plane = r.openBytes(index);
                zahler=zahler+1;
                if sgn
                    arr = loci.common.DataTools.makeDataArray2D(plane, ...
                        bpp, fp, little, height);
                else
                    % Java does not have explicitly unsigned data types;
                    % hence, we must inform MATLAB when the data is unsigned
                    % NB: arr will always be a vector here
                    arr = loci.common.DataTools.makeDataArray(plane, ...
                        bpp, fp, little);
                    switch class(arr)
                        case 'int8'
                            arr = typecast(arr, 'uint8');
                        case 'int16'
                            arr = typecast(arr, 'uint16');
                        case 'int32'
                            arr = typecast(arr, 'uint32');
                        case 'int64'
                            arr = typecast(arr, 'uint64');
                    end
                    arr = reshape(arr, [width,height])';
                end
                if zahler==1
                    if ZTflag
                        vol=zeros(height,width, length(channel),length(zplane), length(tframe), 'like', arr);
                    else
                        vol=zeros(height,width, length(channel), length(tframe),length(zplane), 'like', arr);
                    end
                end
                
                if ZTflag
                    vol(:,:,cc, i,j)=arr;
                else
                    vol(:,:,cc, j,i)=arr;
                end
            end
        end
    end
    volOutput{s} = vol;
end
r.close();
end



function [result] = versionCheck(v, maj, min)

tokens = regexp(v, '[^\d]*(\d+)[^\d]+(\d+).*', 'tokens');
majToken = tokens{1}(1);
minToken = tokens{1}(2);
major = str2num(majToken{1});
minor = str2num(minToken{1});
result = major > maj || (major == maj && minor >= min);
end