function pitch_scaled_sp=EPS(x,Fs,scaling_factor)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% EPS function implements ESOLA pitch-scale modification for speech signals.
% EPS performs pitch-scaling by first time-scaling the input speech signal using ETS and 
% resampling the time-scaled signal at a suitable rate.
%
% usage example : pitch_scaled_sp =EPS(x,Fs,scaling_factor)
%
% INPUTS:
%             x : speech signal
%            Fs : sampling frequency of the read speech signal x
%  pitch-scaling_factor: Typically, "0.5 <= scaling_factor <= 2"  
% 
% OUTPUTS:
%       pitch_scaled_sp : pitch scale modified speech signal
%    
% Coded by: Sunil R, Department of Electrical Engineering, Indian Institute of Science (IISc), Bangalore, India. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


[p,q]=rat(1/scaling_factor);
time_scaled_sp=ETS(x,Fs,p/q); % First, time-scale the speech signal
pitch_scaled_sp=resample(time_scaled_sp,p,q); % Resample the time-scaled speech signal

end