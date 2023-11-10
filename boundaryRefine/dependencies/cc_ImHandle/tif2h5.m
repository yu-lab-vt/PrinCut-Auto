function tif2h5(in_folder, file_prefix, h5_label, outfolder, zyx_flag)
% transfer tif files to h5 files

if nargin == 4
    zyx_flag = false;
end
tifs = dir(fullfile(in_folder, [file_prefix, '*.tif']));
if ~isfolder(outfolder)
    mkdir(outfolder);
end
for i = 1:numel(tifs)
    file = tifread(fullfile(tifs(i).folder, tifs(i).name));
    max_val = max(file(:));
    if zyx_flag
        [h, w, zz] = size(file);
        new_file = zeros(zz, h, w);
        for j = 1:size(file,3)
            new_file(j,:,:) = file(:,:, j);
        end
        file = new_file;
    end
    
    [h, w, zz] = size(file);
    sz = [h, w, zz];
    if max_val > 1
        if max_val < 256
            file = uint8(file);
        elseif max_val < 65536
            file = uint16(file);
        end
    end
    h5fileName = fullfile(outfolder, [tifs(i).name(1:end-3), 'h5']);
    h5create(h5fileName, ['/', h5_label], sz,'Datatype','uint16');
    h5write(h5fileName, ['/', h5_label], file);
end
end