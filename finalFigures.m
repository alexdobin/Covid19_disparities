addpath /scratch/dobin/Software/MyMatlabToolbox/
% addpath /sonas-hs/gingeras/nlsas_norepl/user/dobin/Analysis/Common/
% addpath \\vega\dobin/data/scratch/Software/MatlabToolbox/
% addpath \\vega\dobin/data/scratch/Software/MyMatlabToolbox/
addpath /scratch/dobin/Software/MatlabToolbox/altmany-export_fig-d8b9f4a

dbstop if error

%%
table1=readtable('COVID-19_Suffolk_County_04-10-20.csv');
table1=table1(table1.Population>=1000,:);

%%
iFig=1010;
plotScatterTrend(100-table1.White, table1.CasesPer1000/10, iFig, 'Minority population %', 'Attack rate (% of population)', 0:10:100)
set(gca,'FontSize',36)
% saveas(iFig, 'AttackRateVsMinorityPopulation.png')
% saveas(iFig, 'AttackRateVsMinorityPopulation.eps', 'epsc')
export_fig 'AttackRateVsMinorityPopulation.pdf' -dpdf -painters

%%
iFig=1020;
plotScatterCircleColor(table1.PerCapitaIncome, table1.CasesPer1000/10, 100-table1.White, iFig, 'Per capita income (thousands of dollars)', 'Attack rate (% of population)')
text(100,3.1,'Minority population %','FontSize',30);
% saveas(iFig, 'AttackRateVsIncomePerCapita.png')
% saveas(iFig, 'AttackRateVsIncomePerCapita.eps','epsc')
set(gca,'FontSize',36)
export_fig 'AttackRateVsIncomePerCapita.pdf' -dpdf -painters

%%
iFig=1021;
vv=table1.PerCapitaIncome>0;
vx=100-table1.White(vv);
vy=table1.PerCapitaIncome(vv);
plotScatterTrend(vx, vy, iFig, 'Minority population %', 'Per capita income (thousands of dollars)')
% legend({'LLS fit', '95% Confidence Interval'},'Location','NorthWest')
vx1=0:10:100;
fit1 = fit(vx,vy,'poly2');
line(vx1,fit1(vx1),'Color','Red', 'LineWidth', 3);

set(gca,'FontSize',36)
export_fig 'IncomePerCapitaVsMinorityPopulation.pdf' -dpdf -painters

% saveas(iFig, 'IncomePerCapitaVsMinorityPopulation.png')
% print('-depsc',  'IncomePerCapitaVsMinorityPopulation.eps')
% figpos = get(gcf, 'Position');
% set(gcf, 'PaperSize', figpos(3:4));
% print('-dpdf',  'IncomePerCapitaVsMinorityPopulation.pdf')

%% Attack rate vs income for non-minority
vv=table1.White>80;
bootStrapR(table1.PerCapitaIncome(vv), table1.CasesPer1000(vv)/10)
bootStrapR(table1.PerHouseholdIncome(vv), table1.CasesPer1000(vv)/10)

%% Attack rate fold
vComm={'Huntington Station', 'Brentwood', 'Wyandanch'};
for ii=1:length(vComm)
    ic=find(strcmp(vComm{ii},table1.Community));
    disp([table1.Community{ic} '   ' num2str(table1.CasesPer1000(ic)/mean(table1.CasesPer1000))]);
end


%%
mat1=[table1.CasesPer1000/10, 100-table1.White, table1.Black, table1.Hispanic, table1.Asian, ...
      table1.PerCapitaIncome, table1.PerHouseholdIncome, table1.Poverty, table1.MedianAge,  table1.TransportationToWork];
% plotmatrix(mat1);
%%
% metr1={'Attack rate', 'Minority', 'Black', 'Hispanic', 'Asian', ...
%        'Per capita income', 'Mean household income', 'Below poverty line', 'Median age', 'Mean travel time to work'};
metr1={'Attack rate', 'Minority', 'Black', 'Hispanic', 'Asian', ...
       'Per capita income', 'Household income', 'Below poverty line', 'Age', 'Travel time to work'};

cmat1=corr(mat1);   
for ii=1:length(cmat1)
    cmat1(ii,ii)=NaN;
end

iFig=1030;
myFigure(iFig)
hHeatmap=heatmap(metr1, metr1, cmat1, 'FontSize', 20, 'CellLabelFormat', '%0.2f');
gca1=get(gca);
pos1=gca1.Position;
pos1=[max(pos1(1:2)) max(pos1(1:2)) min(pos1(3:4)) min(pos1(3:4))];
set(gca,'Position',pos1);

cm1=[0 0 0.5]+(0:0.1:1)'*[1 1 0.5];
cm1=[cm1; [1 1 1]+(0.1:0.1:1)'*[-0.5 -1 -1]];
caxis([-1 1])
colormap(cm1)
colorbar off

% saveas(iFig, 'CorrelationMatrix.png')
% print('-depsc', 'CorrelationMatrix.eps')
set(gca,'Position',[0.31 0.31 0.68 0.68]);
set(struct(hHeatmap).NodeChildren(3), 'XTickLabelRotation', 45);
set(gca,'FontSize',28)
% export_fig 'CorrelationMatrix.pdf' -dpdf -painters
export_fig 'CorrelationMatrix.png' -dpng -painters -m2

%%
RvsEach=bootStrapR(mat1(:,2:end), mat1(:,1));

%%
iFig=1040;
myFigure(iFig);
color1=[0 0 0.7];
errorbar(1:size(RvsEach,1), RvsEach(:,1), RvsEach(:,3)-RvsEach(:,1), RvsEach(:,2)-RvsEach(:,1), 'o', ...
         'LineWidth', 3, 'MarkerSize', 15, 'MarkerFaceColor', color1, 'Color', color1);
box on;grid on;
set(gca,'Position',[0.15 0.26 0.83 0.72]);
set(gca, 'Xtick', 1:size(RvsEach,1), 'XtickLabel', metr1(2:end), 'XTickLabelRotation', 45);
set(gca,'Ytick', -1:0.2:1)
ylabel('Correlation Coefficient')
axis([0 size(RvsEach,1)+1 -1 1]);

set(gca,'FontSize',30)
export_fig 'RvsAllPredcitors.pdf' -dpdf -painters

%% multilinear regression
% %%
% warning('off','all');
% for ii=1:size(mat1,2)-1
%     R2multVsEach(ii,:)=bootStrapRmult(mat1(:,2), mat1(:,ii+1), mat1(:,1));
% end
% R2multVsEach=R2multVsEach(2:end,:);
% %%
% iFig=1041;
% myFigure(iFig);
% errorbar(1:size(R2multVsEach,1), R2multVsEach(:,1), R2multVsEach(:,3)-R2multVsEach(:,1), R2multVsEach(:,2)-R2multVsEach(:,1), 'o', 'LineWidth', 3, 'MarkerSize', 15, 'MarkerFaceColor', 'Blue', 'Color', 'Blue');
% box on;grid on;
% set(gca,'Position',[0.15 0.25 0.83 0.73]);
% set(gca, 'Xtick', 1:size(R2multVsEach,1), 'XtickLabel', metr1(2:end), 'XTickLabelRotation', 45);
% ylabel('Correlation Coefficient')
% axis([0 size(R2multVsEach,1)+1 0 0.65]);
