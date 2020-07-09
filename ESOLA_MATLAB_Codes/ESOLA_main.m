%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Demo of Epoch-synchronous-based overlap and add (ESOLA) time- and pitch-scale modification of speech signals.
%
% This program makes use of two functions:
% 1. ETS.m: ESOLA time-scale (ETS) modification
% 2. EPS.m: ESOLA pitch-scale (ETS) modification

% Coded by: Sunil R, Department of Electrical Engineering, Indian Institute of Science (IISc), Bangalore, India. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clc
clear all
close all

% Read the speech file
[x,Fs]=audioread('hindi.wav');
% Play the original speech file
% sound(x,Fs);  

% Specify speaking rate/time-scaling factor. Typically, 0.5 <= time_scaling_factor <= 2. 
time_scaling_factor=0.75;  
% Call ESOLA time-scale modification (ETS) algorithm
time_scaled_sp=ETS(x,Fs,time_scaling_factor); 
% Play the time scale modified speech file
% sound(time_scaled_sp,Fs); 

% Specify pitch-scaling factor. Typically, 0.5 <= pitch_scaling_factor <= 2.
pitch_scaling_factor=1.25;  
% Call ESOLA pitch-scale modification (EPS) algorithm
pitch_scaled_sp=EPS(x,Fs,pitch_scaling_factor); 
% Play the time scale modified speech file
% sound(pitch_scaled_sp,Fs);





