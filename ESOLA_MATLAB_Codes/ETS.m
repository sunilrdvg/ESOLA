function [scaled_sp, zff_gci]=ETS(x,Fs,scaling_factor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETS function implements ESOLA time-scale modification for speech signals.
% usage example : [scaled_sp, zff_gci]=ETS(x,Fs,scaling_factor)

% INPUTS:
%             x : speech signal
%            Fs : sampling frequency of the read speech signal x
% scaling_factor: speaking rate/time-scaling factor. Typically, "0.5 <= scaling_factor <= 2"  
%   If 1x is normal speaking rate, then 'scaling_factor=0.7' means time
%   scaled output speech will have speaking rate of 0.7x
% 
% OUTPUTS:
%       scaled_sp : time-scale modified speech signal
%         zff_gci : an array representing epoch positions in speech signal x
%    
% Coded by: Sunil R, Department of Electrical Engineering, Indian Institute of Science (IISc), Bangalore, India. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Select one channel in case of two channel audio
x=x(:,1); 

%%% Get epochs/pitch marks from Zero-frequency filtering (ZFF) algorithm by S. R. Murthy and B. Yegnanarayana 
zff_gci=zff_gci_func(x,Fs);

%%% Perform epoch-synchrounous overlap and add (ESOLA) 
scaled_sp=ETS_func(x,Fs,scaling_factor,zff_gci);

end