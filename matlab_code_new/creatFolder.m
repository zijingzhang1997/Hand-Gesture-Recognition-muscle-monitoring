SavePath='D:\air drawRMG\data\';
FolderName='ZZ_v3';

creatFolder1=[SavePath,'\',FolderName];

% create folder: feat_all : final result after intergrating all cases in the experiment 
creatFolder2=[SavePath,'\',FolderName,'\','feat_all'];
% create folder: feature : result from segmention, saved for each case we
% collected in the experiment 
creatFolder3=[SavePath,'\',FolderName,'\','feature'];
% create folder: fig_case: figures from segmention, corresponding mat files saved for each case ' feature'
creatFolder4=[SavePath,'\',FolderName,'\','fig_case'];



status = mkdir(creatFolder2);
status = mkdir(creatFolder3);
status = mkdir(creatFolder4);

% sub folders in 'feature' and 'fig_case'
% different bandpass filters 
filt=[0.1 5; 0.05 15 ;0.05 10]; % filt options filt (,1)= low freq ; filt (,2)= high freq 


for i =1:3

Feat_ver=['filt_',num2str(filt(i,1)),'_',num2str(filt(i,2))];
creatFolder_f=[SavePath,'\',FolderName,'\','feature\',Feat_ver];
creatFolder_fig=[SavePath,'\',FolderName,'\','fig_case\',Feat_ver];
status = mkdir(creatFolder_f);
status = mkdir(creatFolder_fig);
end