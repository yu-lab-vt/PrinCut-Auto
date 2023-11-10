function [curvature,Vshape,VShiftX,VShiftY]=getVCurvature_2D_2(dat,smFactor)
%Get V shape curvature


% curvature filter
L=round(smFactor*3);
GaussFltr = fspecial( 'gaussian',L*2+1,smFactor);

gradFltr_X=[0.5 1 0.5;0 0 0;-0.5 -1 -0.5];
gradFltr_Y=gradFltr_X';

GX=conv2(GaussFltr,gradFltr_X);
GY=conv2(GaussFltr,gradFltr_Y);
GXX=conv2(GX,gradFltr_X);
GXY=conv2(GX,gradFltr_Y);
GYY=conv2(GY,gradFltr_Y);

GXX=GXX./sum(abs(GXX(:)));
GXY=GXY./sum(abs(GXY(:)));
GYY=GYY./sum(abs(GYY(:)));


% get curvature
SZ_pad=size(GXX);
SZ_Pad=SZ_pad(1)+(SZ_pad(1)-1)/2;
dat_pad=padarray(dat,SZ_pad,'replicate','both');

xx=conv2(dat_pad,GXX);
xy=conv2(dat_pad,GXY);
yy=conv2(dat_pad,GYY);

xx=xx(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad);
xy=xy(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad);
yy=yy(1+SZ_Pad:end-SZ_Pad,1+SZ_Pad:end-SZ_Pad);



% get prinicpal curvature
[X,Y]=size(dat);
curvature=zeros(X,Y);
Vshape=zeros(X,Y);
VShiftX=zeros(X,Y);
VShiftY=zeros(X,Y);
for i=1:numel(dat)
    MM = [xx(i) xy(i);xy(i) yy(i)];
    [v_all,e] = eig(MM);
    e = diag( e );
    [curvature(i),idx] = max(e);

    % get smooth data
    [TiltRectangleFltr,L_smEdge]=getTiltRectangleFltr(v_all(:,idx),smFactor);
    dat_sm=conv2(dat,TiltRectangleFltr);
%     [X_sm,Y_sm]=size(dat_sm);
%     x=ones(X_sm,Y_sm).*(1:X_sm)';y=ones(X_sm,Y_sm).*(1:Y_sm);
%     sf = fit([x(:), y(:)],dat_sm(:),'linearinterp');

    Vshift=round(v_all(:,idx)*smFactor*2);
%     Vshift=v_all(:,idx)*1;
    VShiftX(i)=v_all(1,idx);VShiftY(i)=v_all(2,idx);
    x=mod(i,X);
    if x==0
        x=X;
    end
    y=(i-x)/X+1;
    x=x+L_smEdge;
    y=y+L_smEdge;

    Vshape(i)=min(dat_sm(x+Vshift(1),y+Vshift(2)),dat_sm(x-Vshift(1),y-Vshift(2)))-dat_sm(x,y);
%     Vshape(i)=min(sf(x+Vshift(1),y+Vshift(2)),sf(x-Vshift(1),y-Vshift(2)))-dat_sm(x,y);
end



end