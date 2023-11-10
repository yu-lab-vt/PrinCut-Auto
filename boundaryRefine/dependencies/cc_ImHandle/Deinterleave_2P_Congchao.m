% select the file path you want to analysis
filePath = 'C:\Users\Congchao\Desktop\Bing\GCaMP_perfusing AITC stimulation\';
% read all tif files' names
files = dir([filePath,'*.tif']);

% read the files one by one
flag = 1;
for i=1:numel(files)
    fprintf('Reading the %d tif file\n', i);
    FileTif=files(i).name;
    InfoImage=imfinfo([filePath,FileTif]);
    mImage=InfoImage(1).Width;
    nImage=InfoImage(1).Height;
    NumberImages=length(InfoImage);
    FinalImage1=[];
    FinalImage2=[];
    % read the odd frames--channel 1
    for j=1:2:NumberImages
        %disp(j);
        if isempty(FinalImage1)
            FinalImage1=imread([filePath,FileTif],'Index',j);
        else
            FinalImage1(:,:,end+1)=imread([filePath,FileTif],'Index',j);
        end
        
    end
    % read the even frames--channel 2
    for j=2:2:NumberImages
        %disp(j);
        if isempty(FinalImage2)
            FinalImage2=imread([filePath,FileTif],'Index',j);
        else
            FinalImage2(:,:,end+1)=imread([filePath,FileTif],'Index',j);
        end
    end
    % save channel 1 and channel 2 to stack 1 and stack 2
    %if min(FinalImage1(:))<0% there is a wired thing here that unit16 image have negative pixel intensity
    %    FinalImage1 = FinalImage1-min(FinalImage1(:));
    %%end
    %if min(FinalImage2(:))<0
    %    FinalImage2 = FinalImage2-min(FinalImage2(:));
    %end
    %FinalImage1 = im2double(FinalImage1);
    %FinalImage2 = im2double(FinalImage2);
    FinalImage1 = double(FinalImage1)/double(max(FinalImage1(:)));
    FinalImage2 = double(FinalImage2)/double(max(FinalImage2(:)));
    if flag% if this is the first frame, generate a new tif file
        imwrite(FinalImage1(:,:,1), [filePath,'stack1.tif']);
        for k = 2:size(FinalImage1,3)
            imwrite(FinalImage1(:,:,k),  [filePath,'stack1.tif'], 'writemode', 'append');
        end
        
        imwrite(FinalImage2(:,:,1), [filePath,'stack2.tif']);
        for k = 2:size(FinalImage2,3)
            imwrite(FinalImage2(:,:,k),  [filePath,'stack2.tif'], 'writemode', 'append');
        end
        flag = 0;
    else% if not, just appending the frames to existing files
        
        for k = 1:size(FinalImage1,3)
            imwrite(FinalImage1(:,:,k),  [filePath,'stack1.tif'], 'writemode', 'append');
        end
        
        for k = 1:size(FinalImage2,3)
            imwrite(FinalImage2(:,:,k),  [filePath,'stack2.tif'], 'writemode', 'append');
        end
    end
end

