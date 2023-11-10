function [TiltRectangleFltr,L]=getTiltRectangleFltr(v,Sigma)

% v=[0.5 sqrt(3)/2];
% Sigma=1;

v=v/sqrt(sum(v.^2));
v=v(:)';

v_90=[v(2) -v(1)];
Lim1=1;Lim2=3;
L=ceil(sqrt(Lim1^2+Lim2^2))*Sigma;
TiltRectangleFltr=zeros(2*L+1);

for i=-L:L
    for j=-L:L
        d1=abs([i j]*v');
        if d1<Sigma*Lim1
            d2=abs([i j]*v_90');
            if d2<Sigma*Lim2
                TiltRectangleFltr(i+L+1,j+L+1)=1;
            end
        end
    end
end

TiltRectangleFltr=TiltRectangleFltr/sum(TiltRectangleFltr(:));

end