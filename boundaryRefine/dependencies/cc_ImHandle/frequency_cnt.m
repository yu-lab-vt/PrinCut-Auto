function out = frequency_cnt(data)
% calculate the frequency of each element in an array data
% credit from : Andrei Bobrov 

% contact: ccwang@vt.edu
if isempty(data)
    out = [0 0];
    return;
end
data = data(:);
uni_data = unique(data);
out = [uni_data,histc(data,uni_data)];

end