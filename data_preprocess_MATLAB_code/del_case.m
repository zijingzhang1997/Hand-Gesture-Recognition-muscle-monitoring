%% record delete cases in every experiment 

function del=del_case(ExpDate,R,caseNum_all)

del=[];
if strcmp(ExpDate,'2_24') & R==2
del_temp=find(caseNum_all==5);    
del(end+1)=del_temp(5);  
del_temp=find(caseNum_all==7);    
del(end+1)=del_temp(21);  
del(end+1)=del_temp(41);  
 
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 


if strcmp(ExpDate,'2_17') & R==4
del_temp=find(caseNum_all==3);  
del(end+1)=del_temp(24);  
del(end+1)=del_temp(25); 
del(end+1)=del_temp(26);  
del(end+1)=del_temp(30);  
del_temp=find(caseNum_all==4);  
del(end+1)=del_temp(7);
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 
if strcmp(ExpDate,'2_17') & R==2
del_temp=find(caseNum_all==5);    
del(end+1)=del_temp(47);  
del_temp=find(caseNum_all==5);    
del(end+1)=del_temp(37);  
del(end+1)=del_temp(10);  
 
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 




if strcmp(ExpDate,'2_14') & R==4
del_temp=find(caseNum_all==4);    
del(end+1)=del_temp(54);  

fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 
if strcmp(ExpDate,'2_14') & R==2
del_temp=find(caseNum_all==2);    
del(end+1)=del_temp(34);  
del(end+1)=del_temp(47);  
del(end+1)=del_temp(48);  
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 


if strcmp(ExpDate,'2_15') & R==2
del_temp=find(caseNum_all==2);    
del(end+1)=del_temp(52);  
del_temp=find(caseNum_all==8);    
del(end+1)=del_temp(22);  
del(end+1)=del_temp(23);  
del_temp=find(caseNum_all==9);    
del(end+1)=del_temp(37);  
del(end+1)=del_temp(38);  
del(end+1)=del_temp(39);  

fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 

if strcmp(ExpDate,'2_15') & R==4
del_temp=find(caseNum_all==2);    
del(end+1)=del_temp(31);  
del_temp=find(caseNum_all==4);    
del(end+1)=del_temp(31);  
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 






if strcmp(ExpDate,'2_11') & R==2
del_temp=find(caseNum_all==1);    
del(end+1)=del_temp(31);  
del(end+1)=del_temp(34); 
del(end+1)=del_temp(37); 
del(end+1)=del_temp(46);
del_temp=find(caseNum_all==2);    
del(end+1)=del_temp(34);  

fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 

if strcmp(ExpDate,'2_11') & R==4

del_temp=find(caseNum_all==2);    
del(end+1)=del_temp(20);  

fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 




if strcmp(ExpDate,'2_10') & R==2
del_temp=find(caseNum_all==4);    
del(end+1)=del_temp(16);  
del(end+1)=del_temp(17); 
del(end+1)=del_temp(18); 
del(end+1)=del_temp(43); 
del(end+1)=del_temp(44); 
del(end+1)=del_temp(45); 
del(end+1)=del_temp(46); 
del_temp=find(caseNum_all==9);    
del(end+1)=del_temp(47);  
del(end+1)=del_temp(48); 
del(end+1)=del_temp(49); 
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 

if strcmp(ExpDate,'2_10') & R==4
del_temp=find(caseNum_all==2);    
del(end+1)=del_temp(52);  

del_temp=find(caseNum_all==3);    
del(end+1)=del_temp(20);  
del(end+1)=del_temp(50); 

fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 




if strcmp(ExpDate,'2_9') & R==2
del_temp=find(caseNum_all==2);    
del(1)=del_temp(19);  

fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 


if strcmp(ExpDate,'2_4') & R==2
del_temp=find(caseNum_all==1);    
del(1)=del_temp(10);  
del_temp=find(caseNum_all==2);
del(end+1)=del_temp(16); 
del_temp=find(caseNum_all==4);
del(end+1)=del_temp(25); 
del_temp=find(caseNum_all==5);
del(end+1)=del_temp(23);
del_temp=find(caseNum_all==6);
del(end+1)=del_temp(10);
del_temp=find(caseNum_all==9);
del(end+1)=del_temp(43);
del_temp=find(caseNum_all==10);
del(end+1)=del_temp(37);
del(end+1)=del_temp(38);
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 


if strcmp(ExpDate,'2_1') & R==2
del_temp=find(caseNum_all==5);
del(1)=del_temp(41);  
del_temp=find(caseNum_all==7);
del(end+1)=del_temp(16); 
del(end+1)=del_temp(17);  
del(end+1)=del_temp(18); 
del(end+1)=del_temp(41); 
del_temp=find(caseNum_all==10);
del(end+1)=del_temp(16);
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 


if strcmp(ExpDate,'2_1') & R==4
del_temp=find(caseNum_all==2);
del(1)=del_temp(31);  
del_temp=find(caseNum_all==3);
del(end+1)=del_temp(3); 
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 

if strcmp(ExpDate,'2_3') & R==2
del_temp=find(caseNum_all==5);
del(1)=del_temp(16);  
del_temp=find(caseNum_all==6);
del(end+1)=del_temp(16); 
del(end+1)=del_temp(17);
del(end+1)=del_temp(18);
del_temp=find(caseNum_all==8);
del(end+1)=del_temp(41); 
del_temp=find(caseNum_all==9);
del(end+1)=del_temp(41);
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 

if strcmp(ExpDate,'2_3') & R==4

    for i=1:10    % delete all starting Down gestures 
del_temp=find(caseNum_all==i);
del(end+1)=del_temp(11); 
del(end+1)=del_temp(24); 
del(end+1)=del_temp(39); 
del(end+1)=del_temp(52); 
    end
del_temp=find(caseNum_all==6);
del(end+1)=del_temp(31);  
del_temp=find(caseNum_all==8);
del(end+1)=del_temp(3); 
fprintf(' Exp %s Routine %d\n',ExpDate,R);
end 

