function tifwrite(outLabel, ImName)
if size(outLabel,4)==1
    imwrite(outLabel(:,:,1),ImName);
    for i = 2:size(outLabel,3)
        imwrite(outLabel(:,:,i),ImName,'WriteMode','append');
    end
else
    imwrite(outLabel(:,:,:,1),ImName);
    for i = 2:size(outLabel,4)
        %disp(i);
        imwrite(outLabel(:,:,:,i),ImName,'WriteMode','append');
    end
end
end