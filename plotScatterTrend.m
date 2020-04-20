function plotScatterTrend(vx,vy, figNum, labelX, labelY, vx1)

vy=vy(vx>0);
vx=vx(vx>0);

myFigure(figNum)
scatter(vx, vy, 100, 'LineWidth',2)
box on; grid on;
xlabel(labelX)
ylabel(labelY)

[R,p]=corr(vx,vy);
disp ([R p])
[R,p]=corr(vx,vy,'type','Spearman');
disp ([R p])

if exist('vx1')
    fit1 = fit(vx,vy,'poly1');
    line(vx1,fit1(vx1),'Color','Red', 'LineWidth', 3);

    cb1=bootStrapCorrFit(vx,vy,vx1);
    line(vx1,cb1,'Color','Magenta', 'LineStyle', '--', 'LineWidth', 3);
end

end

% vx1=min(vx)+(0:0.01:1)*(max(vx)-min(vx));
% fit1cb = predint(fit1,vx1,0.95,'functional','off');
% line(vx1,fit1cb,'Color','Magenta', 'LineStyle', '--', 'LineWidth', 2);
% predint(fit1,[0 100],0.95,'functional','off')

% fit2=fit(vx,vy,'poly2');
% line(vx,fit2(vx),'Color','Red', 'LineWidth', 2);

% fit3=fit(vx,vy,'linearinterp');
% line(vx,fit3(vx),'Color','Red', 'LineWidth', 2);