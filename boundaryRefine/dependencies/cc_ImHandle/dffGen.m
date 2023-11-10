function viddff=dffGen(vid,basestart,baseend)
% generate the DFF of a 3D matrix
t = size(vid,3);
base = mean(vid(:,:,basestart:baseend),3);
base = repmat(base, 1,1,t);
viddff = (vid-base)./base;

end