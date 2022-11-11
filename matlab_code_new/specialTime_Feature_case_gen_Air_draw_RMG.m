% 1. CreatFolder: create folders to save figures, mat files 
% 2. Feature_case_gen_Air_draw_RMG: main script for reading data from
% labview. Filer, segment, visualize data, read in sequence of different cases
% 3. gen_featureAll: combine all results in the same Routine 
% 4.gen_feat_comb: combine all different routines into one final result,
% will further be uploaded to coLAB for ML ALGORIHTM

%% data normalized to N(0,1)
%% devide into epochs  


close all 
clear all


% For all epochs (t win=5s), do we manually shift the waveform 
% in case the motion is not fully included in the epoch? 
% initiate all the time delay =0 
% waveform left shift 'a': time +a; waveform right shift 'a': time -a; 
opt.delay=zeros(40,1);
opt.delay(10:end-1)=-1; % if you have a -1 (second) shift for all epochs 


% iteration through all cases
Caseind=7;
% iteration through all filter types 
filtList=[0.1 5; 0.05 15 ;0.05 10];

RoutineN=[2]; % routine number 1,2 
for i=Caseind
    for j=1:length(RoutineN)
   for k=1:3  % loop through different filter type 
  main (i,opt,filtList(k,:),RoutineN(j))
end
    end
end

function main(i,opt,filt,RoutineN)
close all
ExpDate='KG_v1';
dataPath=['D:\air drawRMG\data\',ExpDate,'\'];
SavePath=['D:\air drawRMG\data\',ExpDate,'\','feature\'];


Feat_ver=['filt_',num2str(filt(1)),'_',num2str(filt(2))];


ch_plot=10;  % 

CaseName=['Case',num2str(i)];


fileName=[CaseName,'Routine',num2str(RoutineN)];
fs=5e3;
fsDS=500;

toff=[2:202]';  % truncate time: start from 4s, end 5s before the end of whole routine
toff_EMG=toff+6;
% toff=[3:203]';  % truncate time: start from 4s, end 5s before the end of whole routine
% toff_EMG=toff+5;


% if exist([SavePath,'\',Feat_ver,'\',CaseName,'.mat'],'file')
%     fprintf('found  case %s\n',fileName);
%     return
% end

filePathName = [dataPath,fileName,'.tdms'];
filePathName_m = [dataPath,fileName,'.mat'];
if ~exist(filePathName_m,'file')
   convertTDMS(true,filePathName);
end
load(filePathName_m);
%% label the gestures
if RoutineN==1
    basic_ges={'A','B','C','D','E','F','G','H','I','J','K','L','M'};
    basic_label=[1:13];
elseif RoutineN==2
    basic_ges={'N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};
    basic_label=[14:26];
end
gesture={};
label=[];

for i=1:length(basic_ges)
    gesture{3*i-2}=basic_ges{i};gesture{3*i-1}=basic_ges{i};gesture{3*i}=basic_ges{i};
    label(3*i-2)=basic_label(i);label(3*i-1)=basic_label(i);label(3*i)=basic_label(i);
end


%%
Chan_Name={'Tx1Rx1 amp','TxRx1 ph','Tx2Rx1 amp','Tx2Rx1 ph','Tx3Rx1 amp','Tx3Rx1 ph','Tx4Rx1 amp','Tx4Rx1 ph',...
    'Tx1Rx2 amp','Tx1Rx2 ph','Tx2Rx2 amp','Tx2Rx2 ph','Tx3Rx2 amp','Tx3Rx2 ph','Tx4Rx2 amp','Tx4Rx2 ph',...
    'Tx1Rx3 amp','TxRx3 ph','Tx2Rx3 amp','Tx2Rx3 ph','Tx3Rx3 amp','Tx3Rx3 ph','Tx4Rx3 amp','Tx4Rx3 ph',...
    'Tx1Rx4 amp','TxRx4 ph','Tx2Rx4 amp','Tx2Rx4 ph','Tx3Rx4 amp','Tx3Rx4 ph','Tx4Rx4 amp','Tx4Rx4 ph','EMG1','EMG1'}';

Ch_num=cat(1,[3:18]',[23:38]');


% filter type 
opt.filtType = 'LpHp'; opt.orderHP = 5;
opt.f3db = filt(1); opt.fpLP = filt(2); opt.fstLP = opt.fpLP+1;

for i = 1:32
  
  Ch_data(:,i)=ConvertedData.Data.MeasuredData(Ch_num(i)).Data; % ch1 amp
  Ch_data_raw=Ch_data;
    if mod(i,2) == 0  % if phase channel 
      Ch_data(:,i)=unwrap(deg2rad(Ch_data(:,i)));
  end
%   
  [Ch_data_filt(:,i),Ch_data_filt_raw(:,i)]= filtSignal(Ch_data(:,i),toff,opt);
  Ch_data_filt(:,i)=detrend(Ch_data_filt(:,i));
end 


%% preprocess EMG signals two channels on BIOPAC 
opt_emg.filtType = 'LpHp'; opt_emg.orderHP = 4;
opt_emg.f3db = 0.1; opt_emg.fpLP = 10; opt_emg.fstLP =opt_emg.fpLP+1;
opt_emg.SMorder=3;opt_emg.SMlen=299;  %% smoothing filter parameter , order less, length longer, more smooth 
opt_emg.movmean=200;
% opt_emg.SMlen=199; opt_emg.movmean=100;
Ch_num_emg=[19,20];
for i = 1:2  %% use first two channels of EMG 
  
  Ch_data_emg(:,i)=ConvertedData.Data.MeasuredData(Ch_num_emg(i)).Data; % ch1 amp
  
  [Ch_data_emg_filt(:,i),Ch_data_emg_filt_raw(:,i),Ch_data_emg_en(:,i),Ch_data_emg_raw(:,i)]= filtSignal_emg(Ch_data_emg(:,i),toff_EMG,opt_emg);
  % Ch_data_emg_filt_raw : only filter, no smooth 
  % Ch_data_emg_filt  : filter + smooth + normalization
  Ch_data_emg_filt(:,i)=detrend(Ch_data_emg_filt(:,i));
end 
opt_emg.smOpt=0;
if opt_emg.smOpt==1
    Ch_data_emg_filt=smoothdata(Ch_data_emg_filt,1,'movmean',opt_emg.movmean);
end
%% 16 channels do vector normalization to get real and imagination part
opt.Vec_filtType='lowpass';opt.Vec_fLow=0.05;opt.Vec_fHigh=15;
for j=1:16
    
   [Ch_data_complex(:,j)]=vector_norm(Ch_data_raw(:,2*j-1),Ch_data_raw(:,2*j),toff,opt,fsDS,fs);

end

% combine NCS channels with EMG channel, and then segment 
Ch_data_filt=[Ch_data_filt,Ch_data_emg_filt];




%% waveform segment into epochs 
% start from 5s,

opt.gesture_all=gesture;
 


tWin=5; tSlide=5; 
% Special timing!! tStart=5; if normal
tStart=1/2;

% start / end time of each epoch  2* epochNum
tEnd=toff(end)-toff(1)-tStart; 
StartEndT=cat(1,tStart:tSlide:tEnd, tStart+tWin:tSlide:tEnd+tWin);  


%  special time stamp add time delay
for i=1:length(StartEndT)


StartEndT(:,i)=StartEndT(:,i)+opt.delay(i); 

end

% divide waveform into epochs   
% NOT PADDING 5S SEGMENT  directly 
for i= 1:length(label)

Ch_data_epoch(:,:,i)=Ch_data_filt((StartEndT(1,i)*fsDS)+1:StartEndT(2,i)*fsDS,:);

Ch_data_epoch_complex(:,:,i)=Ch_data_complex((StartEndT(1,i)*fsDS)+1:StartEndT(2,i)*fsDS,:);



end
% detrend epochs
Ch_data_epoch=detrend(Ch_data_epoch); 
Ch_data_epoch_complex=detrend(Ch_data_epoch_complex); 

%set apart segmented channel data of NCS (32)+EMG(2) 
%waveform length * chan num * epoch num 

Ch_data_epoch_emg=Ch_data_epoch(:,33:34,:);


%% plot figures 



%plot  waveforms using the index 
ind=[1,2,11,12,21,22,31,32,33,34];
ind2=[3,4,9,10,23,24,29,30,33,34];

Ch_data_emg=cat(3,Ch_data_emg_raw,Ch_data_emg_en,Ch_data_emg_filt_raw,Ch_data_emg_filt);


%plot whole waveforms 4 main channels 
% X_axis label from 5s, not 0s.
h_w(1)=plotWaveform_s(Ch_data_filt(:,ind),Chan_Name(ind),ind,fsDS,['self CH'],gesture(2:end)); % self channels 
h_w(2)=plotWaveform_s(Ch_data_filt(:,ind2),Chan_Name(ind2),ind2,fsDS,['cross CH'],gesture(2:end)); % cross channels channels 


h_e_emg1=plotEpoch(Ch_data_epoch,33,gesture,fsDS,StartEndT,Chan_Name);
h_e=plotEpoch(Ch_data_epoch,ch_plot,gesture,fsDS,StartEndT,Chan_Name);
% save figures into pre created folders 
for i=1:length(h_w)
figName = [dataPath,'fig_case','\',Feat_ver,'\',fileName,'_waveform_',num2str(i)];
print(h_w(i),[figName,'.tiff'],'-dtiff','-r300');
savefig(h_w(i),[figName,'.fig']);
end
for j=1:length(h_e)
figName = [dataPath,'fig_case','\',Feat_ver,'\',fileName,'_Epoch_',num2str(j)];
print(h_e(j),[figName,'.tiff'],'-dtiff','-r300');
savefig(h_e(j),[figName,'.fig']);
end

for j=1:length(h_e_emg1)
figName = [dataPath,'fig_case','\',Feat_ver,'\',fileName,'EMGch1_Epoch_',num2str(j)];
print(h_e_emg1(j),[figName,'.tiff'],'-dtiff','-r300');
savefig(h_e_emg1(j),[figName,'.fig']);
end



% delete some  epochs, eg. some mistaken epochs reported from participants 
% initiate by [] 
delind=[]; 
Ch_data_epoch(:,:,delind)=[];
Ch_data_epoch_complex(:,:,delind)=[];
Ch_data_epoch_emg(:,:,delind)=[];
label_all=label; % all labels without delete 
label(delind)=[];
gesture(delind)=[];

opt.delind=delind;opt.StartEndTime=StartEndT;opt.label_all=label_all;
opt.dataPath=filePathName_m;opt.Case=fileName;opt.toff=toff;
opt.emg=opt_emg;opt.emgChName={'emg_raw','emg_envelop','emg_filter','emg_filter_smooth_norm'};

save([SavePath,'\',Feat_ver,'\',fileName,'.mat'],'Ch_data_epoch','Ch_data_epoch_complex','Ch_data_epoch_emg','label','gesture',...
    'Ch_data_complex','Ch_data_filt','Ch_data_emg','Chan_Name','opt');
end




function [ampCh_filt_norm,ampCh_filt]=filtSignal(ampCh,toff,opt)
    
    fs=5e3;  % NCS sampling rate =5e3, can be changed through LABVIEW 
    fsDS=500; % down sampling rate  same as BIOPAC 
    
  
    ampCh=resample(ampCh,fsDS,fs);
    ampCh=ampCh((toff(1)*fsDS):toff(size(toff))*fsDS);
    ampCh_filt = filterLpHp(ampCh,fsDS,opt); % th amp
    
    ampCh_filt_norm = normalize(ampCh_filt);

end 
%% BIOPAC for collecting EMG signals 
function [ampCh_filt_norm,ampCh_filt,ampCh_en,ampCh_raw]=filtSignal_emg(ampCh,toff,opt)
    
    fs=1e3;  % biopac sampling rate =1e3, fixed rate 
    fsDS=500; % down sampling rate  same as NCS  
    
  
    ampCh=resample(ampCh,fsDS,fs);
    ampCh_raw=ampCh((toff(1)*fsDS):toff(size(toff))*fsDS);
    
    [ampCh_en,~] = envelope(ampCh_raw,50,'peak');
    
    ampCh_en=detrend(ampCh_en);
    ampCh_filt = filterLpHp(ampCh_en,fsDS,opt); % th amp
    
    
    ampCh_filt_sm = sgolayfilt(ampCh_filt,opt.SMorder,opt.SMlen);
    %ampCh_filt_sm = smoothdata(ampCh_filt,'movmean',200);
    
    ampCh_filt_norm = normalize(ampCh_filt_sm);
    
end 


