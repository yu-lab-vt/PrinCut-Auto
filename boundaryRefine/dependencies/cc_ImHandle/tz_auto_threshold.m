function threshold = tz_auto_threshold( stack )
%TZ_AUTO_THRESHOLD Summary of this function goes here
%   Detailed explanation goes here
% get the threshold of a microscopy based on the histogram curve
if ndims(stack) == 3
    locmax = imregionalmax(stack, 18);  
    CC = bwconncomp(locmax, 18);
else
    locmax = imregionalmax(stack);
    CC = bwconncomp(locmax);
end
locmax = false(size(stack));
for i=1:CC.NumObjects
    locmax(CC.PixelIdxList{i}(1)) = true;
end
nozerostack = stack(locmax);
clear locmax;
maxv = max(nozerostack);
minv = min(nozerostack);

if (maxv == minv)
    threshold = minv;
    return;
end

maxv = maxv - 1;

stackhist = histc(nozerostack, minv:1:maxv);
clear nozerostack;

[~, maxIndex] = max(stackhist);

minIndex = maxv - minv + 1;
while (minIndex > maxIndex && stackhist(minIndex) == 0)
    minIndex = minIndex - 1;
end
for i=(minIndex-1):-1:maxIndex
    if (stackhist(i) > 0 && stackhist(i) < stackhist(minIndex))
        minIndex = i;
    end
end

if (maxIndex == minIndex)
    threshold = minv;
    return;
end

stackhist = stackhist(maxIndex:minIndex);

length = double(minIndex-maxIndex+1);
stackhist = (stackhist-stackhist(end))*(length-1)/(stackhist(1)-stackhist(end));

threshold = 0;
bestScore = stackhist(1);

for i=2:length
    if stackhist(i) > 0
        score = stackhist(i) + i - 1;
        if score < bestScore
            bestScore = score;
            threshold = i-1;
        end
    end
end

threshold = threshold + maxIndex-1 + minv;

end
