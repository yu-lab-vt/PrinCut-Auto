function nei_mat = neighbours_mat(ind, YourMatrix,connect)
%returns the indices of the 26 3-D neighbors of location i, j, k within Your3DMatrix
%In the first output, indices are returned as a 26 x 3 matrix of row, column, page triples.
%Since on the border areas neighbours might be outside of the matrix, the
%second output is a vector indicating which of the rows are valid.
%The third output is the linear indices -- useful for extracting content

[rows, cols, pages] = size(YourMatrix);
invalid_nei = false(rows+2, cols+2, pages+2);
invalid_nei([1,end],:,:)=true;
invalid_nei(:,[1,end],:)=true;
invalid_nei(:,:,[1,end])=true;
if size(ind,2)==1 || size(ind,1)==1
    [i,j,k] = ind2sub_direct([rows, cols, pages], ind);
else
    i=ind(:,1);
    j=ind(:,2);
    k=ind(:,3);
end
i=i+1; j=j+1; k=k+1;
[h,w,z] = size(invalid_nei);

page_sz = h*w;
if connect == 6
    neighbors = [-1, 1, -h, h, -page_sz, page_sz];
elseif connect == 26
    nei8 = [-h-1, -h, -h+1, -1, 1, h-1, h, h+1];
    neighbors = [nei8-page_sz, -page_sz, nei8, page_sz, nei8+page_sz];
elseif connect == 8
    neighbors = [-h-1, -h, -h+1, -1, 1, h-1, h, h+1];
elseif connect == 10
    neighbors = [-h-1, -h, -h+1, -1, 1, h-1, h, h+1, -page_sz, page_sz];
elseif connect == 4
    neighbors = [-1, 1, -h, h];
elseif connect == 18
    nei8 = [-h-1, -h, -h+1, -1, 1, h-1, h, h+1];
    nei5 = [-h, -1, 0, 1, h];
    neighbors = [nei5-page_sz, nei8, nei5+page_sz];
else
    error('Connected neighbors not supported!/n');
end
locs = sub2ind_direct([h,w,z], i, j, k);
nei_mat = repmat(locs, 1, length(neighbors)) +...
    repmat(neighbors, length(locs), 1);                                     % neighbor index of padded matrix
%invalid_idx = invalid_nei(nei_mat);
nei_mat(invalid_nei(nei_mat)) = nan;                                        % set invalid region = nan
[i,j,k] = ind2sub_direct([h,w,z], nei_mat);                                 

nei_mat = sub2ind_direct([rows, cols, pages], i-1, j-1, k-1);

%nei_mat(invalid_idx) = nan;