%% for plot STFT CWT 2D waveform example 
% import data from colab 
% only have first 200 samples 
close all
load("data_all_per2.mat");
per_num=2;
fsDS=500;
gestureName={'Rest','Grasp','Double Grasp','Point Thumb','Double Point Thumb','Point Index','Point Index',...
    'Point Ind+Mid','Double Point Ind+Mid','Point 4','Double Point 4',...
    'Slow Grasp','Slow Fist','Slow Point Thumb','Slow Point Index','Slow Point Ind+Mid','Slow Point 4',...
    'Wrist Up','Double Wrist Up','Wrist Down','Double Wrist Down',...
    'Slow Wrist Up','Slow Wrist Down'};
SavePath='D:\RFMG\data\for_fig_manuscript\fig\';
h=figure('DefaultAxesFontSize',11)
s_list=[2,5,35];  % 1,2, 12 label 
set(gcf,'Position',[100,100,500,650]);
for i=1:3
sample=s_list(i);
ch=11;
feat_1d=feature_1d_per(sample,ch,:);
feat_1d=reshape(feat_1d,size(feat_1d,3),1);
x_t=((0:(length(feat_1d)-1))/fsDS)';
cwtmatr=feature_cwt_per(sample,ch,:,:);
cwtmatr=reshape(cwtmatr,size(cwtmatr,3),size(cwtmatr,4))';
cwt2matr=feature_cwt2_per(sample,ch,:,:);
cwt2matr=reshape(cwt2matr,size(cwt2matr,3),size(cwt2matr,4))';
cwt3matr=feature_cwt3_per(sample,ch,:,:);
cwt3matr=reshape(cwt3matr,size(cwt3matr,3),size(cwt3matr,4))';
cwt_t=linspace(0,5,size(cwtmatr,2));
cwt_f=linspace(0.1,10,30);
[cwt_T,cwt_F] = meshgrid(cwt_t,cwt_f);

stftmatr=feature_stft_per(sample,ch,:,:);
stftmatr=reshape(stftmatr,size(stftmatr,3),size(stftmatr,4));
stft_t=linspace(0.3,4.7,size(stftmatr,2));
stft_f=linspace(0,15.7,size(stftmatr,1));
[stft_T,stft_F] = meshgrid(stft_t,stft_f);


stft2matr=feature_stft2_per(sample,ch,:,:);
stft2matr=reshape(stft2matr,size(stft2matr,3),size(stft2matr,4));
stft2_t=linspace(0.5,4.5,size(stft2matr,2));
stft2_f=linspace(0,6.7,size(stft2matr,1));
[stft2_T,stft2_F] = meshgrid(stft2_t,stft2_f);


n=4;
m=length(s_list);
first=i;
subplot(n,m,i); 
plot(x_t,feat_1d);
gesN=gestureName{(label_all_per(sample)+1)};
xlabel('Time (s)')
ylabel('Amp (a.u.)')
xlim([0 5])
title(gesN);

subplot(n,m,i+m); 
s=pcolor(stft_T,stft_F,stftmatr);
s.FaceColor = 'interp';
set(s, 'EdgeColor', 'none');
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('STFT ');


subplot(n,m,i+m*2); 
s=pcolor(cwt_T,cwt_F,cwtmatr);
s.FaceColor = 'interp';
set(s, 'EdgeColor', 'none');
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('CWT 1');
% subplot(n,m,3); 
% s=pcolor(cwt_T,cwt_F,cwt2matr);
% s.FaceColor = 'interp';
% set(s, 'EdgeColor', 'none');
% xlabel('Time (s)')
% ylabel('Frequency (Hz)')
% title('CWT 2');

subplot(n,m,i+m*3); 
s=pcolor(cwt_T,cwt_F,cwt3matr);
s.FaceColor = 'interp';
set(s, 'EdgeColor', 'none');
xlabel('Time (s)')
ylabel('Frequency (Hz)')
title('CWT 2');
end 


figName = [SavePath,'NCS_ch',num2str(ch),'per',num2str(per_num),'eg3_STFT_CWT'];
print(h(1),[figName,'.tiff'],'-dtiff','-r300');
savefig(h(1),[figName,'.fig']);