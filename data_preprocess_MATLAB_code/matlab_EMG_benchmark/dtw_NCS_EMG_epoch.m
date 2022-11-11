ExpDate='emg1';
Feat_ver=['filt_0.1_5'];
LoadPath=['D:\RFMG\data\',ExpDate,'\','feat_all\','Data_17_6_comb',Feat_ver,'.mat'];

load(LoadPath);

fsDS=500;
timeInd=fsDS*1+1:fsDS*6;
feature_all=feature_all(timeInd,:,:);
feature_all_emg=feature_all_emg(timeInd,:,:);



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



num=50;

NCS_temp=feature_all(:,11,num);  % use TX2RX2 AMP channel 
EMG_temp=feature_all_emg(:,2,num);

NCS_temp = normalize(NCS_temp);
EMG_temp = normalize(EMG_temp);
[r1,p1] = corrcoef(NCS_temp,EMG_temp); 
r_cor = r1(1,2);
[x,r]=xcorr(NCS_temp,EMG_temp,500,'coeff');
max_coef=max(x);
max_r=r(find(x==max_coef))/fsDS;




figure()
plot(NCS_temp);
hold on
plot(EMG_temp);

title(labelName_all(num));
figure()

figure()
dtw(NCS_temp,EMG_temp)
