%close all

Feat_ver=['filt_0.1_5'];

SavePath=['D:\RFMG\matlab code\for_fig_manuscript\fig\emg\'];


feat1_q1=[];feat1_q2=[];feat2_q1=[];feat2_q2=[];
ExpDate='emg1';
LoadPath=['D:\RFMG\data\',ExpDate,'\','feat_all\','Data_17_6_comb',Feat_ver,'.mat'];
[feat1_q1_t,feat1_q2_t,feat2_q1_t,feat2_q2_t]=detect_peak_all(LoadPath,11,2);
feat1_q1=feat1_q1_t;feat1_q2=feat1_q2_t;feat2_q1=feat2_q1_t;feat2_q2=feat2_q2_t;

ExpDate='emg2';
LoadPath=['D:\RFMG\data\',ExpDate,'\','feat_all\','Data_17_6_comb',Feat_ver,'.mat'];
[feat1_q1_t,feat1_q2_t,feat2_q1_t,feat2_q2_t]=detect_peak_all(LoadPath,11,1);
feat1_q1=cat(3,feat1_q1,feat1_q1_t);
feat1_q2=cat(3,feat1_q2,feat1_q2_t);
feat2_q1=cat(3,feat2_q1,feat2_q1_t);
feat2_q2=cat(3,feat2_q2,feat2_q2_t);
ExpDate='emg3';
LoadPath=['D:\RFMG\data\',ExpDate,'\','feat_all\','Data_17_6_comb',Feat_ver,'.mat'];
[feat1_q1_t,feat1_q2_t,feat2_q1_t,feat2_q2_t]=detect_peak_all(LoadPath,31,2);
feat1_q1=cat(3,feat1_q1,feat1_q1_t);
feat1_q2=cat(3,feat1_q2,feat1_q2_t);
feat2_q1=cat(3,feat2_q1,feat2_q1_t);
feat2_q2=cat(3,feat2_q2,feat2_q2_t);

SaveFeatPath=['D:\RFMG\data\',ExpDate,'\','feat_all\'];
save([SaveFeatPath,'peak_feat2_all_per_v2','.mat'],'feat1_q1','feat1_q2','feat2_q1','feat2_q2');
%% plot scatter figure 
 a=linspace(0,5,10);
 b=a;
 sz=12;
 n=2;m=1;
 feat_num=2;
 
Mean1 = mean(feat1_q1(1,feat_num,:) - feat2_q1(1,feat_num,:));
Mean2 = mean(feat1_q2(1,feat_num,:) - feat2_q2(1,feat_num,:));
Mean3 = mean(feat1_q2(2,feat_num,:) - feat2_q2(2,feat_num,:));
Mean=mean([Mean1,Mean2,Mean3]);
[r1,p1] = corrcoef(feat1_q1(1,feat_num,:),feat2_q1(1,feat_num,:)); 
r1 = r1(1,2);
[r2,p1] = corrcoef(feat1_q2(2,feat_num,:),feat2_q2(1,feat_num,:)); 
r2 = r2(1,2);
[r3,p1] = corrcoef(feat1_q2(2,feat_num,:),feat2_q2(2,feat_num,:)); 
r3 = r3(1,2);
r=mean([r1,r2,r3]);
h(1)=figure;
subplot(m,n,1)
% peak location 
scatter(feat1_q1(1,feat_num,:),feat2_q1(1,feat_num,:),'+');
hold on
scatter(feat1_q2(1,feat_num,:),feat2_q2(1,feat_num,:),'x');
scatter(feat1_q2(2,feat_num,:),feat2_q2(2,feat_num,:),'o');
plot(a,b,'color',[0.5,0.5,0.5],'LineStyle',':','LineWidth',2)
xlabel('RMG Time(s)','FontSize',sz)
ylabel('EMG Time(s)','FontSize',sz)
title('Peak Location','FontSize',sz);
max=5;
xlim([0 max]);
ylim([0 max]);
legend('Quick Gesture','Double Quick Gesture 1st','Double Quick Gesture 2nd',...
'FontSize',sz,'location','bestoutside','orientation','horizontal');
legend('boxoff')  
text(max*0.8,max*0.9,['\bf', 'r=',num2str(r,3)],'FontSize',sz)
text(max*0.7,max*0.4,['\bf', '\mu(diff) =',num2str(Mean,3)],'FontSize',sz)




subplot(m,n,2)
 a=linspace(0,1.5,10);
 b=a;
feat_num=3; % peak width
scatter(feat1_q1(1,feat_num,:),feat2_q1(1,feat_num,:),'+');
hold on
scatter(feat1_q2(1,feat_num,:),feat2_q2(1,feat_num,:),'x');
scatter(feat1_q2(2,feat_num,:),feat2_q2(2,feat_num,:),'o');
plot(a,b,'color',[0.5,0.5,0.5],'LineStyle',':','LineWidth',2)
xlabel('RMG Time(s)','FontSize',sz)
ylabel('EMG Time(s)','FontSize',sz)
title('Peak Width','FontSize',sz);
max=1;
xlim([0 max]);
ylim([0 max]);





figName = [SavePath,'scatter_peakFeat3_quickGes_all_per'];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);






%%  if peak is not detected, use 0 

% if feature is 0, delete the case, only return non-zero peaks 
