function zzshow(datIn)
% GUI for curve visualization
fh = figure('Visible','off','Position',[360,500,520,580],'WindowButtonDownFcn', @img_click);

hImg = axes('Units','pixels','Position',[10,70,500,500],'Tag','aImage');
hImg.XTick = [];hImg.YTick = [];

hReset = uicontrol(fh,'Style','pushbutton','String','Reset','Position',[10 40 40 20],...
    'HorizontalAlignment','left','Callback',@reset_view);
hTextTime = uicontrol(fh,'Style','text','String','Frame:','Position',[60 37 100 20],...
    'HorizontalAlignment','left','Tag','aTextTime');

% hTextTime = uicontrol(fh,'Style','text','String','Frame:','Position',[10 25 500 20],'Tag','aTextTime');
hImgSlider = uicontrol(fh,'Style','slider','Position',[10 10 500 25],'Tag','imageScroll','Callback',@img_slider);

hImg.Units = 'normalized';
hTextTime.Units = 'normalized';
hImgSlider.Units = 'normalized';
hReset.Units = 'normalized';

fh.Visible = 'on';
data = guihandles(fh);
if exist('datIn','var')
    if length(size(datIn))==2
        vid0 = datIn;
        T = 1;
    end
    if length(size(datIn))==3
        vid0 = datIn(:,:,1);
        T = size(datIn,3);
    end
    if length(size(datIn))==4
        vid0 = datIn(:,:,:,1);
        T = size(datIn,4);
    end
    
    % vid0 = (vid0 - iL)/(iH-iL);
    imshow(vid0,'Parent',hImg);
    % draw particles
    if exist('2DImage\movieinfoForzzShow.mat','file')
        hold on;
        load('2DImage\movieinfoForzzShow.mat');
        for i=1:numel(movieInfo.tracks)
            fms = movieInfo.frames(movieInfo.tracks{i});
            node = find(fms==1, 1);% at most one
            if ~isempty(node)
                if length(movieInfo.tracks{i})==1
                    scatter(movieInfo.xCoord(movieInfo.tracks{i}),movieInfo.yCoord(movieInfo.tracks{i}), 50, 'y','filled');
                    hold on;
                else
                        tail = movieInfo.tracks{i}(1);
                        head = movieInfo.tracks{i}(1);
                        plot([movieInfo.xCoord(tail),movieInfo.xCoord(head)],[movieInfo.yCoord(tail),movieInfo.yCoord(head)],...
                            'r-o','LineWidth',4);%, 'MarkerSize',6
                        hold on;
                end
            end
        end
    end
    % change scroll bar
    data.imageScroll.Value = 1;
    data.imageScroll.Min = 1;
    data.imageScroll.Max = T;
    if T>1
        data.imageScroll.SliderStep = [1/T,1/T*10];
    else
        data.imageScroll.SliderStep = [1,1];
    end
    
    data.imgXLim = data.aImage.XLim;
    data.imgYLim = data.aImage.YLim;
    
    data.vid = datIn;
    data.iL = 0;
    data.iH = 1;
end
guidata(fh,data)
end

%% selection callback
function img_click(hObj,eventdata)
data = guidata(hObj);

cursorPoint = data.aImage.CurrentPoint;
curX = round(cursorPoint(1,1));
curY = round(cursorPoint(1,2));
xLimits = data.aImage.XLim;
yLimits = data.aImage.YLim;

if (curX > min(xLimits) && curX < max(xLimits) && curY > min(yLimits) && curY < max(yLimits))
    n = round(data.imageScroll.Value);
    fprintf('(H,W,T): (%d,%d,%d) --',curY,curX,n)
    %disp(['Cursor coordinates are (' num2str(curX) ', ' num2str(curY) ').']);
    val = data.vid(curY,curX,n);
    fprintf('Value: %f\n',val);
end
guidata(hObj,data);
end

%% controls callback
function img_slider(hObj, eventdata)
slideValue = get(hObj,'Value');
data = guidata(hObj);
xLimits = data.aImage.XLim;
yLimits = data.aImage.YLim;
if isfield(data,'vid')
    n = round(slideValue);
    if length(size(data.vid))==2
        vid0 = data.vid;
    end
    if length(size(data.vid))==3
        vid0 = data.vid(:,:,n);
    end
    if length(size(data.vid))==4
        vid0 = data.vid(:,:,:,n);
    end
    imshow(vid0,'Parent',data.aImage);
    data.aImage.XLim = xLimits;
    data.aImage.YLim = yLimits;
    data.aTextTime.String = ['Frame: ',num2str(n)];
    
    % draw tracks
    if exist('2DImage\movieinfoForzzShow.mat','file')
        hold on;
        load('2DImage\movieinfoForzzShow.mat');
        for i=1:numel(movieInfo.tracks)
            fms = movieInfo.frames(movieInfo.tracks{i});
            % continuous path
            node = find(fms==n);% at most one
            if ~isempty(node)
                if length(movieInfo.tracks{i})==1
                    scatter(movieInfo.xCoord(movieInfo.tracks{i}),movieInfo.yCoord(movieInfo.tracks{i}), 50, 'y','filled');
                    hold on;
                elseif n==1 || node==1
                    tail = movieInfo.tracks{i}(1);
                    head = movieInfo.tracks{i}(1);
                    plot([movieInfo.xCoord(tail),movieInfo.xCoord(head)],[movieInfo.yCoord(tail),movieInfo.yCoord(head)],...
                        'r-o','LineWidth',4);%, 'MarkerSize',6
                    hold on;
                else
                    for j = node:-1:2
                        tail = movieInfo.tracks{i}(j-1);
                        head = movieInfo.tracks{i}(j);
                        plot([movieInfo.xCoord(tail),movieInfo.xCoord(head)],[movieInfo.yCoord(tail),movieInfo.yCoord(head)],...
                            'r-o','LineWidth',4);%, 'MarkerSize',6
                        hold on;
                    end
                end
            else
                % if the path is jumping this frame
                if sum(fms>n) && sum(fms<n)
                    node = find(fms<n);
                    node = node(end);
                    if node==1
                        tail = movieInfo.tracks{i}(1);
                        head = movieInfo.tracks{i}(1);
                        plot([movieInfo.xCoord(tail),movieInfo.xCoord(head)],[movieInfo.yCoord(tail),movieInfo.yCoord(head)],...
                            'g-o','LineWidth',4);%, 'MarkerSize',6
                        hold on;
                    else
                        for j = node:-1:2
                            tail = movieInfo.tracks{i}(j-1);
                            head = movieInfo.tracks{i}(j);
                            plot([movieInfo.xCoord(tail),movieInfo.xCoord(head)],[movieInfo.yCoord(tail),movieInfo.yCoord(head)],...
                                'g-o','LineWidth',4);%, 'MarkerSize',6
                            hold on;
                        end
                    end
                end
            end
        end
        hold off;
    end
end
end

function reset_view(hObj, eventdata)
data = guidata(hObj);
data.aImage.XLim = data.imgXLim;
data.aImage.YLim = data.imgYLim;
end












