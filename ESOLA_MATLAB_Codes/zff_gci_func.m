function zff_gci=zff_gci_func(x, Fs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function implements ZFF-based epoch extraction algorithm.
% Details of the algorithm can be found in the paper: K. S. R. Murthy and
% B. Yegnanarayana, "Epoch extraction from speech signals," IEEE
% Transactions on Audio, Speech, and Language Processing, vol. 16, no. 8, pp.1602-1613, 2008. 

% INPUTS :
%           x : speech signal
%          Fs : sampling frequency of read speech signal x
% OUTPUTS:
%     zff_gci : an array representing epoch positions in the speech signal x
%
% Coded by: Sunil R, Department of Electrical Engineering, Indian Institute of Science (IISc), Bangalore, India. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

L=length(x);

s=zeros(L,1);
s(1,1)=x(1,1);
s(2:L,1)=x(2:L,1)-x(1:(L-1),1);

ak = [1, -2, 1];  % zero freq resonator 
y1 = filter(1,ak,s);    % ZFR output 1
y2 = filter(1,ak,y1);   % ZFR output 2
 

%%%%%%%%%   To find the length 'N' over which trend has to be removed %%%%%%%% 
%%%%%%%%%%  In other words, to find the average pitch period (in samples) %%%%

W=floor(0.03*Fs); %30ms window for autocorrelation
strt=floor(0.032*Fs);   % changed
stpt=floor(0.045*Fs);   % changed
no_samples_one_ms=floor(0.001*Fs);
sp_mat=enframe(s,hamming(W),floor(W/2));
sp_mat=sp_mat';
ham_win=xcorr(hamming(W),'coeff');

for j=1:size(sp_mat,2)
    Rx=xcorr(sp_mat(:,j),'coeff')./ham_win;
    [maxval indm]=max(Rx(strt:stpt));
    ind(j)=indm+2*no_samples_one_ms; % changed
end

for j=1:14
    xax(j)=(j+1)*no_samples_one_ms;
end

[pp,fr]=hist(ind,xax);
[m_pitch,m_pitch_ind]=max(pp);


pitch=fr(m_pitch_ind)*1000/Fs; % average pitch period in ms
N=floor(1.5*fr(m_pitch_ind)/2); % average pitch period as number of samples


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% FOR MOST OF THE SPEECH SIGNALS WE CAN USE FOLLOWING VALUE OF N %%
%N=round(Fs*2/1000);   %%Window of 10 ms for mean subtraction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%% End of code that finds average pitch period 'N' %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% For speech signal of duration of few seconds, trend removal has to be done several times
% Remove local mean 4 times iteratively to make it 0 bias.
% This is done 4 times as there are 4 integrals in 4 pole resonator.

y22 = [zeros(N,1);y2;zeros(N,1)];
zfr_sig1 =  zeros(length(y22),1);
for j = 1:3
    fltavg = ones(2*N+1,1)/(2*N+1);
    yavg = conv(y22,fltavg,'same');
    zfr_sig1(1+N:length(y22)-N) = y22(1+N:length(y22)-N)-yavg(N+1:length(yavg)-N);
    y22 = zfr_sig1;
end

zfr_sig = y22(N+1:length(y22)-N);

zff_gci1=cat(1,0,diff(sign(zfr_sig))/2);
zc_ind=find(zff_gci1>0);
zff_gci=zeros(L,1);
zff_gci(zc_ind)=1;

end

