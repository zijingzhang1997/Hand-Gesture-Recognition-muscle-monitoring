ExpDate='2_1';
loadPath=['D:\RFMG\data\',ExpDate,'\','feat_all_complex\'];

load([loadPath,'Data_17_6_combfilt_0.05_10_complex.mat']);


feature_all2=cat(2,feature_all,feature_all_complex);
fs=500;
timeInd=fs*1+1:fs*6;
feature_all2=feature_all2(timeInd,:,:);
feature_all2=permute(feature_all2,[3 2 1]);  % case * channel * ( feature )

for i=1: size(feature_all2,1)  %case 
   
   for j=1: size(feature_all2,2)  %channel
    feat=feature_all2(i,j,:);
  
   [feature_stft(i,j,:,:),feature_stft2(i,j,:,:)]=stft_2d(feat,50);
    feature_cwt(i,j,:,:)=cwt_2d(feat,50);
    feature_wvd(i,j,:,:)=wvd_2d(feat,25);
    
    
    
   end 
end
    

feature_cwt=single(feature_cwt);
feature_wvd=single(feature_wvd);
feature_stft=single(feature_stft);
feature_stft2=single(feature_stft2);
Feat_ver='filt_0.05_10'
ExpDate='2_1';
SavePath=['D:\RFMG\data\',ExpDate,'\','feat_all_complex\'];
save([SavePath,'Data_23_ensemble4_2dfeat',Feat_ver,'_abs.mat'],...
'feature_cwt',...
'feature_wvd',...
'feature_stft','feature_stft2',...
'label_all',...
'caseNum_all','RoutineNum_all',...
'label_all','count','-v7.3');

function [h1,h2]=stft_2d(X,fsDS)   % fsDS=50. frequency to -25,25 Hz,  45*45  40*41 freq*time
fs=500;
fsDS=50;
win = hamming(fsDS*0.6);
X=resample(X,fsDS,fs);

[h1]=stft(X,fsDS,'Window',win,'OverlapLength',fsDS*0.5,'FFTLength',fsDS*1,'FrequencyRange','centered');
h1([1,2,3,50,49],:)=[];  % cut to be square 

win = hamming(fsDS*1);   
[h2]=stft(X,fsDS,'Window',win,'OverlapLength',fsDS*0.9,'FFTLength',fsDS*1,'FrequencyRange','centered');
 % cut to be square 

h2([1:9],:)=[];
% h1=mag2db(abs(h1));
% h2=mag2db(abs(h2));
h1=abs(h1);
h2=abs(h2);
end

function wt=cwt_2d(X,fsDS)   % fsDS=50. frequency to 20Hz,  51*125  freq* time 
fs=500;

X=resample(X,fsDS,fs);
[wt,f] = cwt(X,fs); 
wt=wt(:,:,1);
wt = (downsample(wt',2))';
%wt=mag2db(abs(wt));
wt=abs(wt);
end

function h0=wvd_2d(X,fsDS)   % fsDS=25. frequency to 12.5Hz,  50*50 freq*time 
fs=500;

X=resample(X,fsDS,fs);
[h,f,t]=wvd(X,fsDS,'SmoothedPseudo','NumFrequencyPoints',100,'NumTimePoints',100);
h0 = h(1:50,:);
h0 = (downsample(h0',2))';
h0=abs(h0);
%h0=mag2db(abs(h0));
end





