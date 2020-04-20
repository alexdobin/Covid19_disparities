function RatioCIall=bootStrapCorrFit(vx,vy,vx1)
vy=vy(vx>0);
vx=vx(vx>0);

fit1=fit(vx,vy,'poly1')
[R,p]=corr(vx,vy);
disp ([R p])

nCI=10000;
rng default

RCI=bootci(nCI,@corr,vx,vy);
disp(['R CI = ' num2str([R RCI'])])

Ratio=polyval(polyfit(vx,vy,1),vx1(end))/polyval(polyfit(vx,vy,1),vx1(1));
RatioCI=bootci(nCI, @(x,y) polyval(polyfit(x,y,1),vx1(end))/polyval(polyfit(x,y,1),vx1(1)), vx, vy);
disp(['Ratio CI = ' num2str([Ratio RatioCI'])])

for ii=1:length(vx1)
    RatioCIall(ii,:)=bootci(nCI, @(x,y) polyval(polyfit(x,y,1),vx1(ii)), vx, vy);
end

