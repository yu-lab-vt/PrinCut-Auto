function [idx, valid, linidx] = neighbours(ind, YourMatrix,connect)
%returns the indices of the 26 3-D neighbors of location i, j, k within Your3DMatrix
%In the first output, indices are returned as a 26 x 3 matrix of row, column, page triples.
%Since on the border areas neighbours might be outside of the matrix, the
%second output is a vector indicating which of the rows are valid.
%The third output is the linear indices -- useful for extracting content

if size(YourMatrix,3) > 1
    if numel(ind)==1
        [i,j,k] = ind2sub(size(YourMatrix), ind);
    else
        i=ind(1);
        j=ind(2);
        k=ind(3);
    end
    [rows, cols, pages] = size(YourMatrix);
    if connect == 26
        [R, C, P] = ndgrid(i-1:i+1, j-1:j+1, k-1:k+1);
        idx = [R(:), C(:), P(:)];
        idx(14,:) = [];     %remove center
        
    elseif connect == 6
        idx = [[i, i, i, i, i-1, i+1]', [j, j, j-1, j+1, j, j]',...
            [k-1, k+1, k, k, k, k]'];
    elseif connect == 8
        idx = [[i-1, i-1, i-1, i, i, i+1, i+1, i+1]', ...
               [j-1, j, j+1, j-1, j+1, j-1, j, j+1]',...
               [k, k, k, k, k, k, k, k]'];
    elseif connect == 4
        idx = [[i-1, i, i, i+1]', ...
               [j, j-1, j+1, j]',...
               [k, k, k, k]'];
    elseif connect == 10
        idx = [[i, i, i-1, i-1, i-1, i, i, i+1, i+1, i+1]', ...
               [j, j, j-1, j, j+1, j-1, j+1, j-1, j, j+1]',...
               [k-1, k+1, k, k, k, k, k, k, k, k]'];
    elseif connect == 18
        idx = [[i,i,i,i-1,i+1, i,i,i,i-1,i+1, ...
            i-1, i-1, i-1, i, i, i+1, i+1, i+1]', ...
               [j-1,j,j+1,j,j, j-1,j,j+1,j,j, ...
            j-1, j, j+1, j-1, j+1, j-1, j, j+1]',...
               [k-1,k-1,k-1,k-1,k-1, k+1,k+1,k+1,k+1,k+1, ...
            k, k, k, k, k, k, k, k]'];
    else
        error('Connected neighbors not supported!/n');
    end
    valid = idx(:,1) >= 1 & idx(:,2) >= 1 & idx(:,3) >= 1 & idx(:,1) <= rows & idx(:,2) <= cols & idx(:,3) <= pages;
    idx = idx(valid,:);
    %linidx = nan(size(valid));
    %linidx(valid) = sub2ind( [rows, cols, pages], idx(valid,1), idx(valid,2), idx(valid,3) );
    linidx = sub2ind( [rows, cols, pages], idx(:,1), idx(:,2), idx(:,3));
else
    if numel(ind)==1
        [i,j] = ind2sub(size(YourMatrix),ind);
    else
        i=ind(1);
        j=ind(2);
    end
    [rows, cols] = size(YourMatrix);
    [R, C] = ndgrid(i-1:i+1, j-1:j+1);
    idx = [R(:), C(:)];
    if connect == 4
        idx([1 3 5 7 9],:) = [];
    else
        idx(5,:) = [];     %remove center
    end
    valid = idx(:,1) >= 1 & idx(:,2) >= 1 & idx(:,1) <= rows & idx(:,2) <= cols;
    %     linidx = nan(size(valid));
    %     linidx(valid) = sub2ind( [rows, cols], idx(valid,1), idx(valid,2));
    linidx = sub2ind( [rows, cols], idx(valid,1), idx(valid,2));
end
