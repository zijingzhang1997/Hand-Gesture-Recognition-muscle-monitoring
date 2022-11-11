%% data normalized to N(0,1)
%% devide into epochs  
%% Epochs extend time (begin +1,end +1)
% waveform left shift 'a': time +a; waveform right shift 'a': time -a; 
close all 
opt.delayTime=[-1.5,-1.5,-0.7];
%opt.delayTime=[-2.5,-2.5,-1.5];
a1=opt.delayTime(1);a2=opt.delayTime(2);a3=opt.delayTime(3);% add time delay: [ G - G*2 , P1- P4*2 and 0 , slow gestures sG-sP4 ]
opt.delay=[a1,a1,a1,a1,a1,a1,...  %'G','G','G','G*2','G*2','G*2'
    a2,a2,a2,a2,a2,a2,a2,a2,a2,a2,a2,a2,... %'P1','P1','P1','P1*2','P1*2','P1*2','P2','P2','P2','P2*2','P2*2','P2*2'
    a2,a2,a2,a2,a2,a2,a2,a2,a2,a2,a2,a2,... %'P23','P23','P23','P23*2','P23*2','P23*2','P4','P4','P4','P4*2','P4*2','P4*2'
    a2,a2,a2,... %'0','0','0',
    a3,a3,a3,a3,a3,a3,a3,a3,... %'0','sG','sG','sG','0','sF','sF','sF'
    a3,a3,a3,a3,a3,a3,a3,...%'0','sP1','sP1','sP1','sP2','sP2','sP2'
    a3,a3,a3,a3,a3,a3,0,0]; %'sP23','sP23','sP23','sP4','sP4','sP4','0','0'.



% 
ind=20:24; 
opt.delay(ind)=opt.delay(ind)+1.2;

ind=35:37; 
opt.delay(ind)=opt.delay(ind)-0.5;

ind=41; 
opt.delay(ind)=opt.delay(ind)+0.5;


ind=39; 
opt.delay(ind)=opt.delay(ind)-0.5;
ind=52:54; 
opt.delay(ind)=opt.delay(ind)+0.5;

ind=25; 
opt.delay(ind)=opt.delay(ind)+0.5;
% % 


% ind=1:10;
% ind(3)=[];


ind=1;

filt=[0.1,5];
for i=ind
   
  main (i,opt,filt)
end
filt=[0.1,1];


for i=ind
  main (i,opt,filt)
end
filt=[0.05,10];
for i=ind
   
  main (i,opt,filt)
end


function main(i,opt,filt)
close all
ExpDate='emg3';
dataPath=['D:\RFMG\data\',ExpDate,'\'];
SavePath=['D:\RFMG\data\',ExpDate,'\','feature\'];

%filt=[0.1,1];
%filt=[0.05,10];
Feat_ver=['filt_',num2str(filt(1)),'_',num2str(filt(2))];


ch_plot=31;  % 

CaseName=['Case',num2str(i)];


fileName=[CaseName,'Routine2'];
fs=5e3;
fsDS=500;
a=1; % if time length is short, usually starting time is late
toff=[4-a:284-a]';
opt.constantPad=1; %% pad 0 epochs with constant 


period=[toff(1),toff(end)];

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

gesture_all={'0','G','G','G','G*2','G*2','G*2',...
    'P1','P1','P1','P1*2','P1*2','P1*2','P2','P2','P2','P2*2','P2*2','P2*2',...
    'P23','P23','P23','P23*2','P23*2','P23*2','P4','P4','P4','P4*2','P4*2','P4*2',...
    '0','0','0',...
    '0','sG','sG','sG','0','sF','sF','sF',...
    '0','sP1','sP1','sP1','sP2','sP2','sP2',...
    'sP23','sP23','sP23','sP4','sP4','sP4','0'...
    };

Chan_Name={'Tx1Rx1 amp','TxRx1 ph','Tx2Rx1 amp','Tx2Rx1 ph','Tx3Rx1 amp','Tx3Rx1 ph','Tx4Rx1 amp','Tx4Rx1 ph',...
    'Tx1Rx2 amp','Tx1Rx2 ph','Tx2Rx2 amp','Tx2Rx2 ph','Tx3Rx2 amp','Tx3Rx2 ph','Tx4Rx2 amp','Tx4Rx2 ph',...
    'Tx1Rx3 amp','TxRx3 ph','Tx2Rx3 amp','Tx2Rx3 ph','Tx3Rx3 amp','Tx3Rx3 ph','Tx4Rx3 amp','Tx4Rx3 ph',...
    'Tx1Rx4 amp','TxRx4 ph','Tx2Rx4 amp','Tx2Rx4 ph','Tx3Rx4 amp','Tx3Rx4 ph','Tx4Rx4 amp','Tx4Rx4 ph'}';

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
  
  [Ch_data_emg_filt(:,i),Ch_data_emg_filt_raw(:,i),Ch_data_emg_en(:,i),Ch_data_emg_raw(:,i)]= filtSignal_emg(Ch_data_emg(:,i),toff,opt_emg);
  % Ch_data_emg_filt_raw : only filter, no smooth 
  % Ch_data_emg_filt  : filter + smooth + normalization
  Ch_data_emg_filt(:,i)=detrend(Ch_data_emg_filt(:,i));
end 
opt_emg.smOpt=0;
if opt_emg.smOpt==1
    Ch_data_emg_filt=smoothdata(Ch_data_emg_filt,1,'movmean',opt_emg.movmean);
end
%% 16 channels do vector normalization to get real and imagination part
opt.Vec_filtType='lowpass';opt.Vec_fLow=0.05;opt.Vec_fHigh=5;
for j=1:16
    
   [Ch_data_complex(:,j)]=vector_norm(Ch_data_raw(:,2*j-1),Ch_data_raw(:,2*j),toff,opt,fsDS,fs);

end

% combine NCS channels with EMG channel, and then segment 
Ch_data_filt=[Ch_data_filt,Ch_data_emg_filt];

h_w=plotWaveform(Ch_data_filt,CaseName,gesture_all,fsDS);


%% waveform segment into epochs 
% start from 5s,
gesture={'G','G','G','G*2','G*2','G*2',...
    'P1','P1','P1','P1*2','P1*2','P1*2','P2','P2','P2','P2*2','P2*2','P2*2',...
    'P23','P23','P23','P23*2','P23*2','P23*2','P4','P4','P4','P4*2','P4*2','P4*2',...
    '0','0','0',...
    '0','sG','sG','sG','0','sF','sF','sF',...
    '0','sP1','sP1','sP1','sP2','sP2','sP2',...
    'sP23','sP23','sP23','sP4','sP4','sP4','0',...
    };
opt.gesture_all=gesture;
 
label=[1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9,10,10,10,0,0,0,0,11,11,11,0,12,12,12,0,...
    13,13,13,14,14,14,15,15,15,16,16,16,0];

tWin=5; tSlide=5; tPadding=1; % add padding time in starting and ending time
 
tStart=5;

% start / end time of each epoch  2* epochNum
tEnd=toff(end)-toff(1)-tStart; 
StartEndT=cat(1,tStart:tSlide:tEnd, tStart+tWin:tSlide:tEnd+tWin);  


%  special time stamp add time delay
for i=1:length(StartEndT)


StartEndT(:,i)=StartEndT(:,i)+opt.delay(i); 

end




% extend the time window (begin -1,end +1)
StartEndT(1,find(label~=0))= StartEndT(1,find(label~=0))-tPadding; 
StartEndT(2,find(label~=0))= StartEndT(2,find(label~=0))+tPadding;



% divide waveform into epochs 
for i= find(label~=0)

Ch_data_epoch(:,:,i)=Ch_data_filt((StartEndT(1,i)*fsDS)+1:StartEndT(2,i)*fsDS,:);

Ch_data_epoch_complex(:,:,i)=Ch_data_complex((StartEndT(1,i)*fsDS)+1:StartEndT(2,i)*fsDS,:);



end
% for 0 epochs, extend by inside of epoch (or constant? ) 
for j = find(label==0)
   temp=Ch_data_filt((StartEndT(1,j)*fsDS)+1:StartEndT(2,j)*fsDS,:);
   
    temp_complex=Ch_data_complex((StartEndT(1,j)*fsDS)+1:StartEndT(2,j)*fsDS,:);
   
    % if option:  constant padding
   if opt.constantPad==1
    Ch_data_epoch(:,:,j)=cat(1,repmat(temp(1,:),[fsDS*tPadding 1]),temp,repmat(temp(end,:),[fsDS*tPadding 1]));   
    Ch_data_epoch_complex(:,:,j)=cat(1,repmat(temp_complex(1,:),[fsDS*tPadding 1]),temp_complex,repmat(temp_complex(end,:),[fsDS*tPadding 1])); 
  
    % if not constant padding extend by inside of epoch
  
   else 
    Ch_data_epoch(:,:,j)=cat(1,temp(1:fsDS*tPadding,:),temp,temp(length(temp)-fsDS*tPadding+1:length(temp),:));
   Ch_data_epoch_complex(:,:,j)=cat(1,temp_complex(1:fsDS*tPadding,:),temp_complex,temp_complex(length(temp_complex)-fsDS*tPadding+1:length(temp_complex),:));
       end
       
end
% detrend epochs
Ch_data_epoch=detrend(Ch_data_epoch); 
Ch_data_epoch_complex=detrend(Ch_data_epoch_complex); 

%set apart segmented channel data of NCS (32)+EMG(2) 
%waveform length * chan num * epoch num 

Ch_data_epoch_emg=Ch_data_epoch(:,33:34,:);
Ch_data_epoch=Ch_data_epoch(:,1:32,:);

%% plot figures 


% Ch_data_emg_filt(:,2)=csaps(Ch_data_emg_filt(:,2),0.2);
% Ch_data_emg_filt(:,2) = movmean(Ch_data_emg_filt(:,2),200);

%plot whole waveforms 4 main channels 
h_w=plotWaveform(Ch_data_filt,CaseName,gesture_all,fsDS);

h_w_emg=plotWaveform_emg(Ch_data_emg_raw,Ch_data_emg_en,Ch_data_emg_filt_raw,Ch_data_emg_filt,CaseName,gesture_all,fsDS);

Ch_data_emg=cat(3,Ch_data_emg_raw,Ch_data_emg_en,Ch_data_emg_filt_raw,Ch_data_emg_filt);

h_e=plotEpoch(Ch_data_epoch,ch_plot,gesture,fsDS,StartEndT,Chan_Name);

h_e_emg1=plotEpoch_emg(Ch_data_epoch_emg,1,gesture,fsDS,StartEndT);
h_e_emg2=plotEpoch_emg(Ch_data_epoch_emg,2,gesture,fsDS,StartEndT);
% save figures 
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
for i=1:length(h_w_emg)
figName = [dataPath,'fig_case','\',Feat_ver,'\',fileName,'EMG_waveform_',num2str(i)];
print(h_w_emg(i),[figName,'.tiff'],'-dtiff','-r300');
savefig(h_w_emg(i),[figName,'.fig']);
end
for j=1:length(h_e_emg1)
figName = [dataPath,'fig_case','\',Feat_ver,'\',fileName,'EMGch1_Epoch_',num2str(j)];
print(h_e_emg1(j),[figName,'.tiff'],'-dtiff','-r300');
savefig(h_e_emg1(j),[figName,'.fig']);
end
for j=1:length(h_e_emg2)
figName = [dataPath,'fig_case','\',Feat_ver,'\',fileName,'EMGch1_Epoch_',num2str(j)];
print(h_e_emg2(j),[figName,'.tiff'],'-dtiff','-r300');
savefig(h_e_emg2(j),[figName,'.fig']);
end


% delete some 0 epochs 
delind=[34,38,42,55]; 


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
% figure()
% for i=1:16
% subplot(1,16,i)
% plot(Ch_data_epoch(:,i,1))
% ylim([-1 1])
% end
% figure()
% for i=1:16
% subplot(1,16,i)
% plot(Ch_data_epoch(:,i+16,1))
% ylim([-1 1])
% end



function [ampCh_filt_norm,ampCh_filt]=filtSignal(ampCh,toff,opt)
    
    fs=5e3;
    fsDS=500;
    
  
    ampCh=resample(ampCh,fsDS,fs);
    ampCh=ampCh((toff(1)*fsDS):toff(size(toff))*fsDS);
    ampCh_filt = filterLpHp(ampCh,fsDS,opt); % th amp
    
    ampCh_filt_norm = normalize(ampCh_filt);

end 

function [ampCh_filt_norm,ampCh_filt,ampCh_en,ampCh_raw]=filtSignal_emg(ampCh,toff,opt)
    
    fs=1e3;  % biopac sampling rate =1e3 
    fsDS=500; % down sampling rate  same as NCS  
    
  
    ampCh=resample(ampCh,fsDS,fs);
    ampCh_raw=ampCh((toff(1)*fsDS):toff(size(toff))*fsDS);
    
    [ampCh_en,~] = envelope(ampCh_raw,100,'peak');
    
    ampCh_en=detrend(ampCh_en);
    ampCh_filt = filterLpHp(ampCh_en,fsDS,opt); % th amp
    
    
    ampCh_filt_sm = sgolayfilt(ampCh_filt,opt.SMorder,opt.SMlen);
    %ampCh_filt_sm = smoothdata(ampCh_filt,'movmean',200);
    
    ampCh_filt_norm = normalize(ampCh_filt_sm);
    
end 


