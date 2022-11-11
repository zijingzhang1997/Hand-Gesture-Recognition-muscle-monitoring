 function ncsAmp_Filt = ncs_filt(iqAmp,f_low,f_high,Fs,filtType)

   %% Filtering   
    
    % Initialize Filters

    orderHP = 4; % 20 original
    filtHP = fdesign.highpass('N,F3db',orderHP,f_low,Fs); % Nonlinear phase filter but better filtering characteristics
    HdHP = design(filtHP,'butter'); % 'butter' with 'N,F3db' specifications
    
    filtLP = fdesign.lowpass('N,F3db',orderHP,f_high,Fs); % Nonlinear phase filter but better filtering characteristics
%     filtLP = fdesign.lowpass('Fp,Fst,Ap,Ast',f_high,f_high+0.5,0.01,20,Fs); % Change Ast from 80 to 10 if filtfilt creates error
    HdLP = design(filtLP,'butter'); %kaiserwin is much faster than equiripple without much degradation (?)
    
    if strcmp(filtType,'lowpass') == 1        
%         ncsAmp_Filt = filtfilt(HdLP.Numerator,1,iqAmp);                  % Taking care of group delay
        ncsAmp_Filt = filtfilt(HdLP.sosMatrix,HdLP.ScaleValues,iqAmp);
%         ncsAmp_Filt = detrend(ncsAmp_Filt,'constant');
    elseif strcmp(filtType,'highpass') == 1
        ncsAmp_Filt = filtfilt(HdHP.sosMatrix,HdHP.ScaleValues,iqAmp);      % Taking care of group delay
    elseif strcmp(filtType,'bandpass') == 1
        ncsAmp_Filt = filtfilt(HdHP.sosMatrix,HdHP.ScaleValues,iqAmp);
        ncsAmp_Filt = filtfilt(HdLP.Numerator,1,ncsAmp_Filt);           % Taking care of group delay        
    else
        ncsAmp_Filt = detrend(iqAmp);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end