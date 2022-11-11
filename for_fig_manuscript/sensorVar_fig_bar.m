
% trans  model figure 5fold on new unseen all participant vit 
loadPath='D:\RFMG\matlab code\for_fig_manuscript\mat_file\trans\';
savePath='D:\RFMG\matlab code\for_fig_manuscript\fig\trans\';
k=5;
mVer1='Kfold'; mVer2='groupKfold';
m=mVer1;
DataVer='trans1_per8';
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'.mat'];
load([loadPath,fileName]);
y1_5=[acc_max]*100;
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'_cnn','.mat'];
load([loadPath,fileName]);
y1_5_cnn=[acc_max]*100; 

DataVer='trans0_per8';
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'.mat'];
load([loadPath,fileName]);
y2_5=[acc_max]*100; 
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'_cnn','.mat'];
load([loadPath,fileName]);
y2_5_cnn=[acc_max]*100; 

k=4;
DataVer='trans1_per8';
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'.mat'];
load([loadPath,fileName]);
y1_4=[acc_max]*100; 
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'_cnn','.mat'];
load([loadPath,fileName]);
y1_4_cnn=[acc_max]*100; 

DataVer='trans0_per8';
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'.mat'];
load([loadPath,fileName]);
y2_4=[acc_max]*100; 
fileName=['result_all_max_',num2str(k),'fold','_',DataVer,'_cnn','.mat'];
load([loadPath,fileName]);
y2_4_cnn=[acc_max]*100; 



y_all=y1_5;
sz=12;

h(1)=figure;
x_cell=1:8;


b = bar(y_all,0.4);
set(gca, 'XTickLabel',x_cell)

text(1:length(y_all),y_all,num2str([y_all'], '%.1f%%'),'vert','bottom','horiz','center','FontSize',sz); 
ylabel(['Accuracy (%) '])
ylim([(min(y_all(:))-3) 100])
xlabel ('Participants')
title('Transfer learning by 1/5 data of unseen participant','FontSize',sz)
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
set(gcf,'Position',[500,500,600,300]);



%% plot Compare w/ wo trans. 5 fold and 4 fold 

y1=[mean(y1_5)  mean(y1_5_cnn) mean(y1_4) mean(y1_4_cnn)];

y0=[mean(y2_5) mean(y2_5_cnn) mean(y2_4) mean(y2_4_cnn)];

y_all=[y1 ;  y0  ];

sz=12;

h(2)=figure;

x_cell={'w. Trans.','wo. Trans.','FontSize',sz+1};
b = bar(y_all,'group');
set(gca, 'XTickLabel',x_cell)

b(1).FaceColor=[0 0.4470 0.7410];
b(2).FaceColor=	[0.8500 0.3250 0.0980];
b(3).FaceColor=[0 0.4470 0.7410]*1.3;
b(4).FaceColor=	[0.9290 0.6940 0.1250];
b(1).EdgeColor = b(1).FaceColor;b(2).EdgeColor = b(2).FaceColor;b(3).EdgeColor = b(3).FaceColor;b(4).EdgeColor = b(4).FaceColor;

a = (1:size(y_all,1)).';
x = [a-0.3 a-0.08 a+0.08 a+0.3];
for k=1:size(y_all,2)
    for j = 1:size(y_all,1)
        text(x(j,k),y_all(j,k),num2str(y_all(j,k),'%.1f%%'),...
            'HorizontalAlignment','center',...
            'VerticalAlignment','bottom','FontSize',sz)
    end
end


ylabel(['Accuracy (%) '])
ylim([(min(y_all(:))-2) 100])


legend('ViT  n=5','CNN  n=5','ViT  n=4','CNN  n=4','FontSize',sz)
legend('boxoff')
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
set(gcf,'Position',[500,500,500,400]);



SaveN='_vit';
figName = [savePath,DataVer,'_',num2str(k),'fold','_',SaveN];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);

SaveN='w_wo_trans_vit_cnn';
figName = [savePath,DataVer,'_',num2str(k),m,'_',SaveN];
print(h(2),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(2),[figName,'.fig']);