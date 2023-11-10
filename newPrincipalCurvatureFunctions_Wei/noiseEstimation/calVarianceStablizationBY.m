function [varMap, sigma2, xx] = calVarianceStablizationBY(imregion1, varRatio, gap)

if nargin < 3
    gap = 2;
end
if gap == 0
    localmean = imboxfilt3(imregion1,[3,3,3]);
    n = 27;
    imregion2 = imregion1(2:end-1, 2:end-1,2:end-1);
    localmean2 = localmean(2:end-1, 2:end-1,2:end-1);
elseif gap == 2 % default
    se = ones(5,5,5);
    se(2:4,2:4,2:4) = 0;
    se(:,:,1:2) = 0;
    se(:,:,4:5) = 0;
    n = sum(se(:));
    se = se./n;
    localmean = imfilter(imregion1,se);
    imregion2 = imregion1(3:end-2, 3:end-2,:);
    localmean2 = localmean(3:end-2, 3:end-2,:);
elseif gap == 3 % circular-neighbor in 2D
    sph = strel('sphere', gap);
    se_outer = sph.Neighborhood(:,:,gap+1);
    sph = strel('sphere', gap-1);
    se_innter = sph.Neighborhood(:,:,gap);
    
    se = se_outer;
    se(2:end-1, 2:end-1) = se(2:end-1, 2:end-1) - se_innter;
    
    n = sum(se(:));
    se = se./n;
    localmean = imfilter(imregion1,se);
    imregion2 = imregion1(4:end-3, 4:end-3,:);
    localmean2 = localmean(4:end-3, 4:end-3,:);
end

diff = (imregion2 - localmean2);%.*27./26
levels = 200;
minVal = min(localmean2(:));
unit = (max(localmean2(:)) - minVal)/(levels-1);

localmean2x = floor((localmean2 - minVal)./ unit) + 1;

eleCnt = 0;
ele0 = length(find(localmean2x == 1));
xx = nan(levels,1);
target_i = levels;
for i = 2: levels
    %fprintf([num2str(i) '/' num2str(levels) '\n'])
    cur_loc = find(localmean2x == i);
    nei = 1;
    while length(cur_loc)<100
        lb = max(1, i-nei);
        ub = min(i+nei, levels);
        cur_loc = find(ismember(localmean2x, lb:ub));
        nei = nei + 1;
        if nei>5
            break;
        end
    end
    varDifferentInt = diff(cur_loc);
    varCur = varByTruncate(varDifferentInt, 2, 3);
    xx(i) = (n/(n+1))*varCur;%
    eleCnt = eleCnt + length(cur_loc);
    if i < target_i && ...
            (eleCnt/(numel(localmean2x)-ele0) > varRatio)
        %if we only want to use a fixed point to reprsent all the variance
        target_i = i;
    end
end
sigma2 = xx(target_i);
if max(max(localmean2(:))>20)
    xx(1:3) = nan;
else
    xx(1:15) = nan;
end
level_idx = floor((localmean - minVal)./ unit) + 1;

level_idx(level_idx<1) = 1;
level_idx(level_idx>levels) = levels;
varMap = xx(level_idx);
end