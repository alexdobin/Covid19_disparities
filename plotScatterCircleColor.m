function plotScatterCircleColor(vx, vy, vc, figNum, labelX, labelY)

vy=vy(vx>0);
vx=vx(vx>0);

myFigure(figNum)
scatter(vx, vy, 100, vc, 'filled')
box on; grid on;
xlabel(labelX)
ylabel(labelY)
colormap('jet')
caxis([0 100])
colorbar('Ytick',0:20:100)

% 
% fit1=fit(vx,vy,'poly1')
% [R,p]=corr(vx,vy);
% disp ([R p])
% 
% [R,p]=corr(vx,vy,'type','Spearman');
% disp ([R p])
