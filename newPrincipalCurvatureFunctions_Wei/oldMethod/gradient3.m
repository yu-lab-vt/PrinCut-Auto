function D = gradient3(F,option)
% This function does the same as the default matlab "gradient" function
% but with one direction at the time, less cpu and less memory usage.
%
% Example:
%
% Fx = gradient3(F,'x');

[k,l,m] = size(F);
if isgpuarray(F)
    D  = gpuArray(zeros(size(F),class(gather(F))));
else
    D  = zeros(size(F),class(F)); 
end

switch lower(option)
case 'x'
    % Take forward differences on left and right edges
    D(1,:,:) = (F(2,:,:) - F(1,:,:));
    D(k,:,:) = (F(k,:,:) - F(k-1,:,:));
    % Take centered differences on interior points
    D(2:k-1,:,:) = (F(3:k,:,:)-F(1:k-2,:,:))/2;
case 'y'
    D(:,1,:) = (F(:,2,:) - F(:,1,:));
    D(:,l,:) = (F(:,l,:) - F(:,l-1,:));
    D(:,2:l-1,:) = (F(:,3:l,:)-F(:,1:l-2,:))/2;
case 'z'
    D(:,:,1) = (F(:,:,2) - F(:,:,1));
    D(:,:,m) = (F(:,:,m) - F(:,:,m-1));
    D(:,:,2:m-1) = (F(:,:,3:m)-F(:,:,1:m-2))/2;
otherwise
    disp('Unknown option')
end

% switch lower(option)
% case 'x'
%     F1=cat(1,F(2,:,:),F(2:k,:,:));
%     F2=cat(1,F(1:k-1,:,:),F(k-1,:,:));
%     parfor i=1:m
%         D(:,:,i) = (F1(:,:,i)-F2(:,:,i))/2;
%     end
% case 'y'
%     F1=cat(2,F(:,2,:),F(:,2:l,:));
%     F2=cat(2,F(:,1,:),F(:,1:l-1,:));
%     parfor i=1:m
%         D(:,:,i) = (F1(:,:,i)-F2(:,:,i))/2;
%     end
% case 'z'
%     F1=cat(3,F(:,:,2),F(:,:,2:m));
%     F2=cat(3,F(:,:,1),F(:,:,1:m-1));
%     parfor i=1:m
%         D(:,:,i) = (F1(:,:,i)-F2(:,:,i))/2;
%     end
%     
% otherwise
%     disp('Unknown option')
% end
      
        