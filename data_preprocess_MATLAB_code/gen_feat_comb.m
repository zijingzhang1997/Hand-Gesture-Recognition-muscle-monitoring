

ExpDate='2_24';



ExpDate1=ExpDate;
ExpDate2=ExpDate1;
SavePath1=['D:\RFMG\data\',ExpDate1,'\','feat_all\'];  % Routine gestures 17
SavePath2=['D:\RFMG\data\',ExpDate2,'\','feat_all\'];  % only wrist Routine, new gestures 6
filt=[0.1 5; 0.1 1 ;0.05 10];

for i=1:3
    Feat_ver=['filt_',num2str(filt(i,1)),'_',num2str(filt(i,2))];
    load([SavePath1,'Data_all','Routine2',Feat_ver,'.mat']);
    
    feature_all_17=feature_all;feature_all_complex_17=feature_all_complex;
    label_all_17=label_all;labelName_all_17=labelName_all;caseNum_all_17=caseNum_all;
    opt_17=opt_all;count_17=count;
    RoutineNum_all_17=RoutineNum_all;
    
    
    load([SavePath2,'Data_all','Routine4',Feat_ver,'.mat']);
    feature_all_6=feature_all;feature_all_complex_6=feature_all_complex;
    label_all_6=label_all;labelName_all_6=labelName_all;caseNum_all_6=caseNum_all;
    opt_6=opt_all;count_6=count;
    caseNum_all_6=caseNum_all_6+max(caseNum_all_17);  % caseNum should add the number of Routine 2, or overlap
    RoutineNum_all_6=RoutineNum_all;
    
    feature_all=cat(3,feature_all_17,feature_all_6);
    feature_all_complex=cat(3,feature_all_complex_17,feature_all_complex_6);
    label_all=cat(1,label_all_17,label_all_6);
    labelName_all=cat(1,labelName_all_17,labelName_all_6);
    caseNum_all=cat(1,caseNum_all_17,caseNum_all_6);
    RoutineNum_all=cat(1,RoutineNum_all_17,RoutineNum_all_6);
    
    
    count.label_count =uniqueCount(label_all);
    
    count.case_count =uniqueCount(caseNum_all);
    
    save([SavePath2,'Data_17_6_comb',Feat_ver,'.mat'],...
        'feature_all',...
        'feature_all_complex',...
        'label_all',...
        'caseNum_all','RoutineNum_all','Chan_Name','labelName_all','labelName',...
        'opt_6','opt_17','count','-v7.3');
    
end
