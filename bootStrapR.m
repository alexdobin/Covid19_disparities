function out1=bootStrapR(mx,vy)

out1=zeros(size(mx,2),3);

nCI=10000;
rng default

for ii=1:size(mx,2)
    fprintf(1, '%i ', ii);
    vx1=mx(:,ii);
    vy1=vy(vx1>=0);
    vx1=vx1(vx1>=0);    
    out1(ii,1)=corr(vx1, vy1);
    out1(ii,2:3)=bootci(nCI, @(x,y) corr(x,y), vx1, vy1)';
    %disp(out1(ii,:));
end

