close all
% plot figures of NCS and EMG together 
ExpDate='emg1';
Feat_ver=['filt_0.1_5'];
LoadPath=['D:\RFMG\data\',ExpDate,'\','feat_all\','Data_17_6_comb',Feat_ver,'.mat'];
SavePath=['D:\RFMG\data\',ExpDate,'\','fig_all\'];
SaveFeatPath=['D:\RFMG\data\',ExpDate,'\','feat_all\'];
load(LoadPath);


% crop wavform into 5s 
fsDS=500;
timeInd=fsDS*1+1:fsDS*6;
feature_all=feature_all(timeInd,:,:);
feature_all_emg=feature_all_emg(timeInd,:,:);


%%

ch_NCS=11;  % use TX2RX2 AMP channel 
ch_EMG=2; % EMG channel 


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



gestureName={'Rest','Grasp','Grasp*2','Point Thumb','Point Thumb*2','Point Index','Point Index*2',...
    'Point Ind+Mid','Point Ind+Mid *2','Point 4','Point 4*2',...
    'Slow Grasp','Slow Fist','Slow Point Thumb','Slow Point Index','Slow Point Ind+Mid','Slow Point 4',...
    'Wrist Up','Wrist Up*2','Wrist Down','Wrist Down*2',...
    'Slow Wrist Up','Slow Wrist Down'};

%% use average DTW to plot all gestures' average shape 

data_ges_all={};
data_ges={};
avg_ges_all={};
for i=1:23
  ind_temp=ind_ges{i};
  for j =1:size(ind_temp,1)
      data_ges_all{i,j}=feature_all(:,ch_NCS,ind_temp(j));
      data_ges{j}=feature_all(:,ch_NCS,ind_temp(j));
      
      
  end
  
  avg_ges_all{i}=DBA(data_ges);
  
end

data_ges_all_emg={};
data_ges_emg={};
avg_ges_all_emg={};
for i=1:23
  ind_temp=ind_ges{i};
  for j =1:size(ind_temp,1)
      data_ges_all_emg{i,j}=feature_all_emg(:,ch_EMG,ind_temp(j));
      data_ges_emg{j}=feature_all_emg(:,ch_EMG,ind_temp(j));
      
      
  end
  
  avg_ges_all_emg{i}=DBA(data_ges_emg);
  
end
save([SaveFeatPath,'avg_dwt_waveform_ges','NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'.mat'],'avg_ges_all','avg_ges_all_emg');

load([SaveFeatPath,'avg_dwt_waveform_ges','NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'.mat']);

%% plot figures 
avg_ges_all=cell2mat(avg_ges_all);
avg_ges_all_emg=cell2mat(avg_ges_all_emg);

ind=[l_q+1,1];
h(1)=fig_feat2(avg_ges_all(:,ind),avg_ges_all_emg(:,ind),ind-1,gestureName,'Quick Gestures');
ind=l_q2+1;
h(2)=fig_feat2(avg_ges_all(:,ind),avg_ges_all_emg(:,ind),ind-1,gestureName,'Double Quick Gestures');
ind=l_s+1;
h(3)=fig_feat2(avg_ges_all(:,ind),avg_ges_all_emg(:,ind),ind-1,gestureName,'Slow Gestures');



figName = [SavePath,'NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'dba_waveEpoch_q'];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);
figName = [SavePath,'NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'dba_waveEpoch_q2'];
print(h(2),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(2),[figName,'.fig']);
figName = [SavePath,'NCS',num2str(ch_NCS),'EMG',num2str(ch_EMG),'dba_waveEpoch_s'];
print(h(3),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(3),[figName,'.fig']);




function h=fig_feat2(NCS_data,EMG_data,label,Name,tle)

% NCS_data is 2 dimension 2500* num 
fs=500;
n=8;
col_n=1;
sz=11;
figNum=ceil(size(NCS_data,2)/n);

    
h=figure;
for j=1:n
    ind=j;
    if ind <= size(NCS_data,2)
    subplot(col_n*2,n,j);

    NCS_temp = NCS_data(:,ind);

    if label(ind)~=0
    NCS_temp = normalize(NCS_temp);

    end
        t=(1:length(NCS_temp))/fs;
        plot(t,NCS_temp,'LineWidth',1,'color','blue');

    xlim([0,5])
    if label(ind)==0
    ylim([-4,4])
    end
    ges=Name{label(ind)+1};
    title((ges),'FontSize',sz);
    end
        if ind <= size(NCS_data,2)
    subplot(col_n*2,n,j+n);

    EMG_temp = EMG_data(:,ind);

    if label(ind)~=0
    EMG_temp = normalize(EMG_temp);

    end
        t=(1:length(EMG_temp))/fs;
        plot(t,EMG_temp,'LineWidth',1,'color','red');

    xlim([0,5])
    if label(ind)==0
    ylim([-4,4])
    end
    ges=Name{label(ind)+1};
    title((ges),'FontSize',sz);
    end
   
    sgtitle(tle)
    set(gcf,'Position',[100,100,1500,400]);
end


end

function h=fig_feat(NCS_data,label,Name,opt,tle)

% NCS_data is 2 dimension 2500* num 
fs=500;
n=8;
col_n=2;
sz=11;
figNum=ceil(size(NCS_data,3)/n);

for i =1:figNum
    
    h(i)=figure;
    for j=1:n
        ind=(i-1)*n+j;
        if ind <= size(NCS_data,2)
        subplot(col_n,n/col_n,j);
       
        NCS_temp = NCS_data(:,ind);

        if label(ind)~=0
        NCS_temp = normalize(NCS_temp);

        end

        
        
        if opt.peak==0
            
            t=(1:length(NCS_temp))/fs;
            plot(t,NCS_temp,'LineWidth',1);
            
        else 
            findpeaks(NCS_temp,fs,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin);
       
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