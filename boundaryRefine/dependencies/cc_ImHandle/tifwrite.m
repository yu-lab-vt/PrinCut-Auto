function tifwrite(outLabel, ImName)
if size(outLabel,4)==1 
    if size(outLabel,3) ~= 3
        imwrite(outLabel(:,:,1),[ImName,'.tif']);
        for i = 2:size(outLabel,3)
            imwrite(outLabel(:,:,i),[ImName,'.tif'],'WriteMode','append');
        end
    else
        imwrite(outLabel,[ImName,'.tif']);
    end
else
    
    imwrite(outLabel(:,:,:,1),[ImName,'.tif']);
    for i = 2:size(outLabel,4)
        %disp(i);
        imwrite(outLabel(:,:,:,i),[ImName,'.tif'],'WriteMode','append');
    end
end
end