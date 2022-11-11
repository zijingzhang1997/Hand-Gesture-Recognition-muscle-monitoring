%close all
ExpDate='emg3';
Feat_ver=['filt_0.1_5'];
LoadPath=['D:\RFMG\data\',ExpDate,'\','feat_all\','Data_17_6_comb',Feat_ver,'.mat'];
SavePath=['D:\RFMG\data\',ExpDate,'\','fig_all\'];
load(LoadPath);


% crop wavform into 5s 
fsDS=500;
timeInd=fsDS*1+1:fsDS*6;
feature_all=feature_all(timeInd,:,:);
feature_all_emg=feature_all_emg(timeInd,:,:);


%%
gestureLabel={'R','G','G*2','P1','P1*2','P2','P2*2','P23','P23*2','P4','P4*2','sG','sF','sP1','sP2','sP23','sP4',...
    'U','U*2','D','D*2','sU','sD'}';
% divide into quick / quick double /slow /0   gesture groups 
l_q=[2,4,6,8,10,18,20]-1;
l_q2=[3,5,7,9,11,19,21]-1;% quick motions 
l_s=[12,13,14,15,16,17,22,23]-1;
l_0=0;
ind_q=[];ind_q2=[];ind_s=[];ind_0=[];
for i=1:size(l_q,2)
   ind_temp=find(label_all==l_q(i));
   ind_q=cat(1,ind_q ,ind_temp);
end
for i=1:size(l_q2,2)
   ind_temp=find(label_all==l_q2(i));
   ind_q2=cat(1,ind_q2 ,ind_temp);
end
for i=1:size(l_s,2)
   ind_temp=find(label_all==l_s(i));
   ind_s=cat(1,ind_s ,ind_temp);
end
for i=1:size(l_0,2)
   ind_temp=find(label_all==l_0(i));
   ind_0=cat(1,ind_0 ,ind_temp);
end


ch_NCS=31;  % use TX2RX2 AMP channel 
ch_EMG=2; % EMG channel 
opt.hmin=1.5;
opt.pmin=1.5;   % quick 1 gestures 
opt.np=1;
[feat1_q1, feat2_q1]=peak_feat_multi(feature_all,feature_all_emg,[ch_NCS,ch_EMG],ind_q,opt);
mean_q1=cat(1,mean(feat1_q1,3), mean(feat2_q1,3));


opt.pmin=0.5;   % quick 2 gestures 
opt.np=2;
[feat1_q2, feat2_q2]=peak_feat_multi(feature_all,feature_all_emg,[ch_NCS,ch_EMG],ind_q2,opt);
mean_q2=cat(1,mean(feat1_q2,3), mean(feat2_q2,3));


opt.pmin=1;   % slow  gestures 
opt.np=1;
[feat1_s, feat2_s]=peak_feat_multi(feature_all,feature_all_emg,[ch_NCS,ch_EMG],ind_s,opt);
mean_s=cat(1,mean(feat1_s,3), mean(feat2_s,3));



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
xlabel('NCS (s)','FontSize',sz)
ylabel('EMG (s)','FontSize',sz)
title('Peak Location','FontSize',sz);
max=5;
xlim([0 max]);
ylim([0 max]);
legend('Quick Gesture','Double Quick Gesture 1st','Double Quick Gesture 2nd',...
'FontSize',sz,'location','bestoutside','orientation','horizontal');
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
xlabel('NCS (s)','FontSize',sz)
ylabel('EMG (s)','FontSize',sz)
title('Peak Width','FontSize',sz);
max=1;
xlim([0 max]);
ylim([0 max]);





figName = [SavePath,'NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'scatter_peakFeat3_quickGes'];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);






%%  if peak is not detected, use 0 

% if feature is 0, delete the case, only return non-zero peaks 
function [feat1, feat2]=peak_feat_multi(NCS_all,EMG_all,ch,index,opt)

NCS_all=NCS_all(:,ch(1),:);
EMG_all=EMG_all(:,ch(2),:);

zero_ind=[]
for i=1:size(index)
    [feat1(:,:,i), feat2(:,:,i)]=peak_feat(NCS_all(:,index(i)),EMG_all(:,index(i)),opt);
if feat1(:,:,i)==0 | feat2(:,:,i)==0 
    zero_ind=[zero_ind;i];
end
end
 
feat1(:,:,zero_ind)=[];
feat2(:,:,zero_ind)=[];


end

function [feat1, feat2]=peak_feat(NCS_temp,EMG_temp,opt)
NCS_temp = normalize(NCS_temp);
EMG_temp = normalize(EMG_temp);
fsDS=500;
[p1,loc1,wid1,pro1]=findpeaks(NCS_temp,fsDS,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin,'Npeaks',opt.np);
feat1=[p1,loc1,wid1,pro1];


[p2,loc2,wid2,pro2]=findpeaks(EMG_temp,fsDS,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin,'Npeaks',opt.np);
feat2=[p2,loc2,wid2,pro2];


if size(feat1,1)~=opt.np
    feat1=zeros(opt.np,4);
end
if size(feat2,1)~=opt.np
    feat2=zeros(opt.np,4);
end  

% figure()
% findpeaks(NCS_temp,fsDS,'MinPeakProminence',opt.pmin,'Npeaks',opt.np);
% hold on 
% findpeaks(EMG_temp,fsDS,'MinPeakProminence',opt.pmin,'Npeaks',opt.np);

end