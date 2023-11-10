function yyshow(datIn,evtLst1,evtLst2,regLst)
% GUI for curve visualization with events
% use circle to show events

if ~exist('datIn','var')
    warning('datIn is needed');
    return
end

fh = figure('Visible','off','Position',[360,500,520,580],'WindowButtonDownFcn', @img_click);

hImg = axes('Units','pixels','Position',[10,70,500,500],'Tag','aImage');
hImg.XTick = [];
hImg.YTick = [];

hReset = uicontrol(fh,'Style','pushbutton','String','Reset','Position',[10 40 40 20],...
    'HorizontalAlignment','left','Callback',@reset_view);
hTextTime = uicontrol(fh,'Style','text','String','Frame:','Position',[60 37 100 20],...
    'HorizontalAlignment','left','Tag','aTextTime');
hImgSlider = uicontrol(fh,'Style','slider','Position',[10 10 500 25],...
    'Tag','imageScroll','Callback',@img_slider);

hImg.Units = 'normalized';
hTextTime.Units = 'normalized';
hImgSlider.Units = 'normalized';
hReset.Units = 'normalized';

fh.Visible = 'on';
data = guihandles(fh);

% get image info
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

% initialize scroll bar
data.imageScroll.Value = 1;
data.imageScroll.Min = 1;
data.imageScroll.Max = T;
if T>1
    data.imageScroll.SliderStep = [1/T,1/T];
else
    data.imageScroll.SliderStep = [1,1];
end

% initialize image scale
imshow(vid0,'Parent',hImg);
data.imgXLim = data.aImage.XLim;
data.imgYLim = data.aImage.YLim;

% save image and circles
data.vid = datIn;
szDat = [size(datIn,1),size(datIn,2),T];
if exist('evtLst1','var')
    data.cir1 = getLocInfo(evtLst1,szDat);
else
    data.cir1 = [];
end
if exist('evtLst2','var')
    data.cir2 = getLocInfo(evtLst2,szDat);
else
    data.cir2 = [];
end
if exist('regLst','var')
    tmp = getLocInfo(regLst,szDat);
    data.reg = tmp{1};
else
    data.reg = [];
end

guidata(fh,data)
img_slider(fh);

% for nn=1:T
%     data.imageScroll.Value = nn;
%     guidata(fh,data)
%     img_slider(fh);
%     pause(0.1);
% end

end


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
    val = data.vid(curY,curX,n);
    fprintf('Value: %f\n',val);
end
guidata(hObj,data);
end

function img_slider(hObj, eventdata)
data = guidata(hObj);
xLimits = data.aImage.XLim;
yLimits = data.aImage.YLim;
if isfield(data,'vid')
    n = round(data.imageScroll.Value);
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
    
    % draw circles on events
    if ~isempty(data.reg)
        vis0 = data.reg;
    else
        vis0 = [];
    end
    if ~isempty(vis0)
        viscircles(vis0.loc,vis0.rad,'Color',[0,0,0.5],'LineWidth',0.1,'EnhanceVisibility',false);
    end
    
    if ~isempty(data.cir1)
        vis0 = data.cir1{n};
    else
        vis0 = [];
    end
    if ~isempty(vis0)
        viscircles(vis0.loc,vis0.rad,'Color',[0.95,0.95,0],'LineWidth',0.5);
    end
    
    if ~isempty(data.cir2)
        vis0 = data.cir2{n};
    else
        vis0 = [];
    end
    if ~isempty(vis0)
        viscircles(vis0.loc,vis0.rad,'Color',[0,1,1],'LineWidth',0.2);
    end
    
    data.aImage.XLim = xLimits;
    data.aImage.YLim = yLimits;
    data.aTextTime.String = ['Frame: ',num2str(n)];
end
end

function reset_view(hObj, eventdata)
data = guidata(hObj);
data.aImage.XLim = data.imgXLim;
data.aImage.YLim = data.imgYLim;
end

function circs = getLocInfo(evtLst,movSize)
H = movSize(1);
W = movSize(2);
T = movSize(3);

numEvt = length(evtLst);
locy = zeros(numEvt,1);     % event center y-coordinate
locx = zeros(numEvt,1);     % event center x-coordinate
loct = zeros(numEvt,1);
evtRadiuses = zeros(numEvt,1);  % event radius: all events are viewed as circles
evtCells = cell(numEvt,1);  % event coordinates (2D)
rgVec = zeros(numEvt,2);

for ii=1:numel(evtLst)
    [locyAll,locxAll, loctAll] = ind2sub([H,W,T],evtLst{ii});
    rgVec(ii,1) = min(loctAll);
    rgVec(ii,2) = max(loctAll);
    uniLoc = unique([locyAll,locxAll],'rows');
    evtCells{ii} = (uniLoc(:,2)-1)*H+uniLoc(:,1);
    locy(ii) = round(mean(uniLoc(:,1)));
    locx(ii) = round(mean(uniLoc(:,2)));
    loct(ii) = min(loctAll);
    evtRadiuses(ii) = sqrt(length(evtCells{ii})/pi);
end

% shapes in each frame
circs = cell(T,1);
for tt=1:T
    tmp = [];
    idx = find(rgVec(:,1)<=tt & rgVec(:,2)>=tt);
    if ~isempty(idx)
        tmp.loc = [locx(idx),locy(idx)];
        tmp.rad = evtRadiuses(idx);
        circs{tt} = tmp;
    end
end

end




