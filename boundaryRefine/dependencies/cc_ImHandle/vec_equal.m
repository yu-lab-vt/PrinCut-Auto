function flag = vec_equal(v1,v2, sort_flag)
% tell if two vectors are exactly the same

if nargin < 3
    sort_flag = 0;
end
if length(v1) ~= length(v2)
    flag = false;
    return;
end
if ~sort_flag
    v1 = sort(v1);
    v2 = sort(v2);
end

flag = false;
if sum(abs(v1-v2))==0
    flag = true;
end
end