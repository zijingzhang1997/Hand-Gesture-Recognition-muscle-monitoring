close all
% plot figures of NCS and EMG together 
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

ch_NCS=11;  % use TX2RX2 AMP channel 
ch_EMG=2; % EMG channel 

seed=0;
rng(seed);%  if randomly generate epochs examples control random epochs generation 
idx_temp=5;
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
ind_ges={};
for i=0:22
   ind_ges{i+1}=find(label_all==i);
   
end

% randmonly choose one out of all the same gesture class  
% or choose a same sequence 
idx_q=[];

for i=1:length(l_q)
  
 
  idx_q(i)=ind_ges{l_q(i)+1}(idx_temp);
end
idx_q2=[];
for i=1:length(l_q2)
  
%   idx_temp=randperm(length(ind_ges{l_q2(i)+1}),1);
  idx_q2(i)=ind_ges{l_q2(i)+1}(idx_temp);
end
idx_s=[];
l_s_all=[0,l_s];%% add 0 gesture into slow class   
for i=1:length(l_s_all)
  
%   idx_temp=randperm(length(ind_ges{l_s(i)+1}),1);
  idx_s(i)=ind_ges{l_s_all(i)+1}(idx_temp);
end

gestureName={'Rest','Grasp','Grasp*2','Point Thumb','Point Thumb*2','Point Index','Point Index',...
    'Point Ind+Mid','Point Ind+Mid *2','Point 4','Point 4*2',...
    'Slow Grasp','Slow Fist','Slow Point Thumb','Slow Point Index','Slow Point Ind+Mid','Slow Point 4',...
    'Wrist Up','Wrist Up*2','Wrist Down','Wrist Down*2',...
    'Slow Wrist Up','Slow Wrist Down'};




opt.hmin=1;
opt.pmin=0.5;   % quick 1 gestures 
opt.np=1;

ind=idx_q;
opt.peak=0;
h(1)=fig_feat(feature_all(:,ch_NCS,ind),feature_all_emg(:,ch_EMG,ind),label_all(ind),gestureName,opt,'Quick Gestures');
ind=idx_q2;
opt.peak=0;
h(2)=fig_feat(feature_all(:,ch_NCS,ind),feature_all_emg(:,ch_EMG,ind),label_all(ind),gestureName,opt,'Double Quick Gestures');
ind=idx_s;
opt.peak=0;
h(3)=fig_feat(feature_all(:,ch_NCS,ind),feature_all_emg(:,ch_EMG,ind),label_all(ind),gestureName,opt,'Slow Gestures');




figName = [SavePath,'NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'seq',num2str(idx_temp),'eg_waveEpoch_q'];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);
figName = [SavePath,'NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'seq',num2str(idx_temp),'eg_waveEpoch_q2'];
print(h(2),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(2),[figName,'.fig']);
figName = [SavePath,'NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'seq',num2str(idx_temp),'eg_waveEpoch_s'];
print(h(3),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(3),[figName,'.fig']);




function h=fig_feat(NCS_data,EMG_data,label,Name,opt,tle)
fs=500;
n=9;
col_n=3;
sz=11;
figNum=ceil(size(NCS_data,3)/n);
for i =1:figNum
    
    h(i)=figure;
    for j=1:n
        ind=(i-1)*n+j;
        if ind <= size(NCS_data,3)
        subplot(col_n,n/col_n,j);
       
        NCS_temp = NCS_data(:,1,ind);
        EMG_temp = EMG_data(:,1,ind);
        if label(ind)~=0
        NCS_temp = normalize(NCS_temp);
        EMG_temp = normalize(EMG_temp);
        end

        
        
        if opt.peak==0
            
            t=(1:length(NCS_temp))/fs;
            plot(t,NCS_temp,'LineWidth',1);
            hold on
            plot(t,EMG_temp,'LineWidth',1);
        else 
            findpeaks(NCS_temp,fs,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin);
            hold on 
            findpeaks(EMG_temp,fs,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin);
        end
        xlim([0,5])
        if label(ind)==0
        ylim([-4,4])
        end
        ges=Name{label(ind)+1};
        title((ges),'FontSize',sz);
        end
        
        
    end
    sgtitle(tle)
    legend('NCS','EMG','FontSize',sz,'Position',[0.65 0.92 0.1 0.05],'EdgeColor','w')
    % The first two values, left and bottom, specify the distance from the lower left corner of the 
    % figure to the lower left corner of the legend. The last two values, width and height, specify the legend dimensions
    set(gcf,'Position',[100,100,800,700]);
    
end



end