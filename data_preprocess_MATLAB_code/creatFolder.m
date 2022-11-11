SavePath='D:\RFMG\data';
FolderName='timeTest';

creatFolder1=[SavePath,'\',FolderName];

creatFolder2=[SavePath,'\',FolderName,'\','feat_all'];
creatFolder3=[SavePath,'\',FolderName,'\','feature'];
creatFolder4=[SavePath,'\',FolderName,'\','fig_case'];



status = mkdir(creatFolder2);
status = mkdir(creatFolder3);
status = mkdir(creatFolder4);


filt=[0.1 5; 0.1 1 ;0.05 10]; % filt options filt (,1)= low freq ; filt (,2)= high freq 
filt=[0.1 5; 0.1 1 ;0.05 10];

for i =1:3

Feat_ver=['filt_',num2str(filt(i,1)),'_',num2str(filt(i,2))];
creatFolder_f=[SavePath,'\',FolderName,'\','feature\',Feat_ver];
creatFolder_fig=[SavePath,'\',FolderName,'\','fig_case\',Feat_ver];
status = mkdir(creatFolder_f);
status = mkdir(creatFolder_fig);
end