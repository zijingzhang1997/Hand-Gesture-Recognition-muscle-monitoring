%% personal model figure  1. ensemble vs. feat sets 
dataPath='D:\RFMG\matlab code\for_fig_manuscript\'
k=7;
mVer1='Kfold'; mVer2='groupKfold';
m=mVer1;
DataVer='personal_per8';
fileName=['result_all_max_',num2str(k),m,'_',DataVer,'.mat'];
load([dataPath,'mat_file\personal\',fileName]);

acc_all_meanper=mean(acc_all,1);
sz=11;

acc_all_meanper_corrected=acc_all_meanper;
acc_all_meanper_corrected(5)=acc_all_meanper(4);
acc_all_meanper_corrected(4)=acc_all_meanper(5);

h(1)=figure
y1=[acc_max_mean  acc_all_meanper_corrected ]*100;
x_cell={'Ensemble','STFT1','STFT2','CWT1','CWT2','CWT3'};


b = bar(y1,0.5,'FaceColor','flat');
b.CData(1,:) = [1 0 0];
set(gca, 'XTickLabel',x_cell)
text(1:length(y1),y1,num2str([y1'], '%.1f%%'),'vert','bottom','horiz','center','FontSize',sz); 

ylabel(['Accuracy (%) '])
ylim([min(y1)-2 100])
set(gca, 'FontSize',sz)
set(gca, 'FontName', 'Times New Roman');
xlabel ('Feature sets','FontSize',sz+2)
set(gcf,'Position',[500,500,450,270]);
SaveN='feat_ver_vit';

figName = [dataPath,'fig\personal\',DataVer,'_',num2str(k),m,'_',SaveN];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);