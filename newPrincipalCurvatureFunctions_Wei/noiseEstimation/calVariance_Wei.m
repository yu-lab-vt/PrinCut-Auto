function [sigmaMap, varFit] = calVariance_Wei(dat_all)

%% get filter
gap=3;
sph = strel('sphere', gap);
se_outer = sph.Neighborhood(:,:,gap+1);
sph = strel('sphere', gap-1);
se_innter = sph.Neighborhood(:,:,gap);
se = se_outer;
se(2:end-1, 2:end-1) = se(2:end-1, 2:end-1) - se_innter;
n = sum(se(:));
se = se./n;

%%
localmean = imfilter(dat_all,se);
imregion2 = dat_all(4:end-3, 4:end-3,:,:);
localmean2 = localmean(4:end-3, 4:end-3,:,:);

%%
diff = (imregion2 - localmean2);%.*27./26
levels = 200;
minVal = min(localmean2(:));
maxVal = max(localmean2(:));
unit = (maxVal - minVal)/(levels-1);
localmean2x = floor((localmean2 - minVal)./ unit) + 1;
%%

modeId=mode(localmean2x,'all');

pixelNumThreshold=1000;
avgWindow=10;

xx = nan(levels,1);
pixelNum=zeros(levels,1);
pixelNum(1)=inf;
for i = modeId: levels
%     fprintf([num2str(i) '/' num2str(levels) '\n'])
    cur_loc = find(localmean2x == i);
    pixelNum(i)=length(cur_loc);
    if pixelNum(i)<pixelNumThreshold
        xx(i:end)=median(xx(max(i-avgWindow,1):i-1));
        break;
    end
    varDifferentInt = diff(cur_loc);
    varCur = varByTruncate(varDifferentInt, 2, 3);
    xx(i) = (n/(n+1))*varCur;%
end
xx(1:modeId-1)=xx(modeId);

yy = xx;
y1 = movmedian(xx,avgWindow);
unreliableIdx=pixelNum<pixelNumThreshold*10;
yy(unreliableIdx) = y1(unreliableIdx);

%%
level_idx = floor((localmean - minVal)./ unit) + 1;
level_idx(level_idx<1) = 1;
level_idx(level_idx>levels) = levels;
varMap = yy(level_idx);
sigmaMap=sqrt(varMap);

varFit=[(minVal:unit:maxVal)' yy pixelNum];

% yyaxis left
% plot(xx);
% yyaxis right
% plot(yy);

end