%% fast time test i=3 
clear all
close all
i=3;

dataPath=['D:\RFMG\data\timeTest\'];
SavePath='C:\RFMG\Zijing\RFMG data\timeTest\fig\';
CaseName=['Case',num2str(i)];
fileName=[CaseName,'Routine3'];
fs=5e3;
fsDS=500;
toff=[8:23]';
period=[toff(1),toff(end)];
msize=30;
if i==3
    msize =10;
end    


filePathName = [dataPath,fileName,'.tdms'];
filePathName_m = [dataPath,fileName,'.mat'];
if ~exist(filePathName_m,'file')
   convertTDMS(true,filePathName);
end
load(filePathName_m);


load([dataPath,fileName,'.mat']);

opt.filtType = 'LpHp'; opt.orderHP = 5;
opt.f3db = 0.1; opt.fpLP = 10; opt.fstLP = opt.fpLP+1;
Ch_num=cat(1,[3:18]',[23:38]');
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

%%
opt_emg.filtType = 'LpHp'; opt_emg.orderHP = 5;
opt_emg.f3db = 0.5; opt_emg.fpLP = 15; opt_emg.fstLP =opt_emg.fpLP+1;
opt_emg.SMorder=3;opt_emg.SMlen=99;  %% smoothing filter parameter , order less, length longer, more smooth 
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

Ch_data_filt=[Ch_data_filt,Ch_data_emg_filt];
Ch_data_filt=detrend(Ch_data_filt);
Ch_data_emg=cat(3,Ch_data_emg_raw,Ch_data_emg_en,Ch_data_emg_filt_raw,Ch_data_emg_filt);

ChName={'RMG','EMG'};
h_w=plotWaveform_s(Ch_data_filt(:,[31,34]),ChName,fsDS,msize);

% SavePath='D:\RFMG\matlab code\for_fig_manuscript\fig\timeTest\';
% figName = [SavePath,CaseName,'time_Waveform_2'];
% print(h_w,[figName,'.tiff'],'-dtiff','-r300');
% savefig(h_w,[figName,'.fig']);


%  for i=3 can detect all peaks opt.p1min=0.2;opt.h1min=0.5;  RMG 31
%  opt.p2min=0.7;opt.h2min=0.3; EMG 34

% for i=4 can detect all peaks opt.p1min=0.2;opt.h1min=0.2; opt.p2min=0.7;opt.h2 min=0.3;

opt.pmin=0.2;opt.hmin=0.2;

% channel 1 is RMG 
[p1,loc1,wid1,pro1]=findpeaks(Ch_data_filt(:,31),fsDS,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin);

% channel 2 is EMG 
[p2,loc2,wid2,pro2]=findpeaks(Ch_data_filt(:,34),fsDS,'MinPeakProminence',opt.pmin,'MinPeakHeight',opt.hmin);


% intermediate time is 1/frequency of motion (or BR estimation in old study)
interT_1=diff(loc1);
interT_2=diff(loc2);
inT1=[mean(interT_1) std(interT_1)];
inT2=[mean(interT_2) std(interT_2)];

% frequency estimation 
freq_1=60./interT_1;
freq_2=60./interT_2;
freqData1=[mean(freq_1) std(freq_1)];
freqData2=[mean(freq_2) std(freq_2)];

pro1m=[mean(pro1) std(pro1)];
pro2m=[mean(pro2) std(pro2)];

%%
function h=plotWaveform_s(Ch_data,ChName,fsDS,msize)

tOff=((0:(length(Ch_data)-1))/fsDS)';

h(1)=figure;
a=0;
sz=11;
cN={'blue','red'};
n=size(Ch_data,2);
for i =1:n
subplot(n,1,i);

plot(tOff,Ch_data(:,i),'LineWidth',0.5,'color',cN{i},'LineWidth',1);
[pk,loc,wid2,pro2]=findpeaks(Ch_data(:,i),fsDS,'MinPeakProminence',0.2,'MinPeakHeight',0.2);
hold on

scatter(tOff(round(loc*fsDS)),pk,msize,'green','filled','^')
xlabel('time (s)','FontSize',sz)
ylabel('Amp (a.u.)','FontSize',sz)
xlim([a round(max(tOff))])

legend(ChName{i},'FontSize',sz,'Location','northoutside')
legend('boxoff')
end

set(gcf,'Position',[100,100,450,300]);






end 
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
    
    [ampCh_en,~] = envelope(ampCh_raw,50,'peak');
    
    ampCh_en=detrend(ampCh_en);
    ampCh_filt = filterLpHp(ampCh_en,fsDS,opt); % th amp
    
    
    ampCh_filt_sm = sgolayfilt(ampCh_filt,opt.SMorder,opt.SMlen);
    %ampCh_filt_sm = smoothdata(ampCh_filt,'movmean',200);
    
    ampCh_filt_norm = normalize(ampCh_filt_sm);
    
end 

