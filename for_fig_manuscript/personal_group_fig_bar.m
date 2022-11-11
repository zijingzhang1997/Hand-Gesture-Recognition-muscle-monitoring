
% personal model figure  2.3.  
loadPath='D:\RFMG\matlab code\for_fig_manuscript\mat_file\personal\';
savePath='D:\RFMG\matlab code\for_fig_manuscript\fig\personal\';
k=7;
mVer1='Kfold'; mVer2='groupKfold';
m=mVer1;
DataVer='personal_per8';
fileName=['result_all_max_',num2str(k),mVer1,'_',DataVer,'.mat'];
load([loadPath,fileName]);
y1=[acc_max]*100; 
fileName=['result_all_max_',num2str(k),mVer2,'_',DataVer,'.mat'];
load([loadPath,fileName]);
y2=[acc_max]*100; 


y_all=[y1; y2]';
y_all=y_all;
sz=12;

h(1)=figure;
x_cell=1:8;


b = bar(y_all,'group');
set(gca, 'XTickLabel',x_cell)


ylabel(['Accuracy (%) '])
ylim([(min(y2(:))-5) 100])
xlabel ('Participants')
legend('7-fold','Routine 7-fold')
legend('boxoff')
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
set(gcf,'Position',[500,500,700,300]);
% SaveN='kfold_groupfold_vit';
% figName = [dataPath,'fig\',DataVer,'_',num2str(k),m,'_',SaveN];
% print(h(1),[figName,'.tiff'],'-dtiff','-r300');
% savefig(h(1),[figName,'.fig']);


%% plot CNN VS. VIT  kfold, routine f-fold, 

mVer1='Kfold'; mVer2='groupKfold';
DataVer='personal_per8';
fileName=['result_all_max_',num2str(k),mVer1,'_',DataVer,'.mat'];
load([dataPath,'mat_file\',fileName]);
y1_v=[acc_max_mean]*100; 
fileName=['result_all_max_',num2str(k),mVer2,'_',DataVer,'.mat'];
load([dataPath,'mat_file\',fileName]);
y2_v=[acc_max_mean]*100; 


DataVer='personal_per8_CNN';
fileName=['result_all_max_',num2str(k),mVer1,'_',DataVer,'.mat'];
load([dataPath,'mat_file\',fileName]);
y1_c=[acc_max_mean]*100; 
fileName=['result_all_max_',num2str(k),mVer2,'_',DataVer,'.mat'];
load([dataPath,'mat_file\',fileName]);
y2_c=[acc_max_mean]*100; 

DataVer='personal_per8';
fileName=['result_1d_cnn',num2str(k),mVer1,'_',DataVer,'.mat'];
load([dataPath,'mat_file\',fileName]);

y1_1d=[acc_mean]*100; 
fileName=['result_1d_cnn',num2str(k),mVer2,'_',DataVer,'.mat'];
load([dataPath,'mat_file\',fileName]);
y2_1d=[acc_mean]*100; 




y1=[y1_v y1_c];
y2=[y2_v y2_c];
y_all=[y1_v y2_v; y1_c y2_c]';

sz=12;

h(2)=figure;

x_cell={'ViT','CNN'};
b = bar(y_all,'group');
set(gca, 'XTickLabel',x_cell)
y1=[y1_v y1_v];
a = (1:size(y_all,1)).';
x = [a-0.2  a+0.2];
for k=1:size(y_all,1)
    for j = 1:size(y_all,2)
        text(x(k,j),y_all(k,j),num2str(y_all(k,j),'%.1f%%'),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom','FontSize',sz)
    end
end


ylabel(['Accuracy (%) '])
ylim([(min(y2(:))-2) 100])
xlabel ('Models','FontSize',sz+2)
legend('7-fold','Routine 7-fold','FontSize',sz)
legend('boxoff')
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
set(gcf,'Position',[500,500,300,300]);



% SaveN='kfold_groupfold_vit';
% figName = [savePath,DataVer,'_',num2str(k),m,'_',SaveN];
% print(h(1),[figName,'.tiff'],'-dtiff','-r300');
% savefig(h(1),[figName,'.fig']);

SaveN='mean_vit_cnn';
figName = [savePath,DataVer,'_',num2str(k),m,'_',SaveN];
print(h(2),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(2),[figName,'.fig']);