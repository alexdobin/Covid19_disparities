function out1=bootStrapRmult(vx,mx,vy)

out1=zeros(size(mx,2),3);

nCI=1000;
rng default

for ii=1:size(mx,2)
    fprintf(1, '%i ', ii);
    vx1=mx(:,ii);
    vv=vx1>=0;
    vy1=vy(vv);
    vx=vx(vv);
    vx1=vx1(vv);
    
    out1(ii,1)=fitR2mult([vx vx1], vy1);
    out1(ii,2:3)=bootci(nCI, @fitR2mult, [vx vx1], vy1)'
    %disp(out1(ii,:));
end

