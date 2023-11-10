function eig_all = principalCv3d(vid, sigma)
% use principle curvature to segment connected cells

% get the hessian matrix
[Dxx, Dyy, Dzz, Dxy, Dxz, Dyz, ~] = Hessian3D(vid,sigma);

eig_all = zeros(size(vid));

dir_y = zeros(size(vid));
dir_x = zeros(size(vid));
dir_z = zeros(size(vid));


fmap = ones(size(vid)); % if we cal all the voxes
s = regionprops3(fmap, {'VoxelIdxList'});
for i=1:numel(s.VoxelIdxList)%[3 47 76]%
    %disp(i);
    vox = s.VoxelIdxList{i};
    xx = Dxx(vox); yy = Dyy(vox); zz = Dzz(vox);
    xy = Dxy(vox); xz = Dxz(vox); yz = Dyz(vox);
    
    C = zeros(numel(s.VoxelIdxList{i}),3);
    dir_xyz = zeros(numel(s.VoxelIdxList{i}),3);
    parfor j=1:numel(s.VoxelIdxList{i})
        MM = [xx(j), xy(j), xz(j);...
            xy(j), yy(j), yz(j);...
            xz(j), yz(j), zz(j)];
        [Evec,Eval] = eig(MM);
        dEval = diag(Eval);
        %[~,od] = sort(abs(dEval),'descend');
        %C(j,:) = dEval(od)';
        [c,od] = sort(dEval,'descend');
        C(j,:) = c';
        dir_xyz(j,:) = Evec(:, od(1))';
    end
    dir_x(vox) = dir_xyz(:,1);
    dir_y(vox) = dir_xyz(:,2);
    dir_z(vox) = dir_xyz(:,3);
    eig_all(vox) = C(:,1);

end


end