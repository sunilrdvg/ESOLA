function [scaled_sp,zff_array_y]=ETS_func(x,Fs,scaling_factor1,zff_gci)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ETS_func performs ESOLA (overlap and adding of speech segments based on epoch positions)
% usage example : scaled_sp = ETS(x,Fs,scaling_factor1,zff_gci)

% INPUTS:
%             x : speech signal
%            Fs : sampling frequency of the speech signal x
% scaling_factor: speaking rate/time-scaling factor. Typically, "0.5 <= scaling_factor <= 2"  
%   If 1x is normal speaking rate, then 'scaling_factor=0.7' means time
%   scaled output speech will have speaking rate of 0.7x
%       zff_gci : an array representing epoch positions in speech signal x
% 
% OUTPUTS:
%       scaled_sp : time-scale modified speech signal
%           
% Coded by: Sunil R, Department of Electrical Engineering, Indian Institute of Science (IISc), Bangalore, India. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% pitch marks from ZFF algorithm %%%%%
L=length(x);
zff_array=zff_gci;
%%%%%%%%%%%%%%%%%%
frame_len=floor(0.02*Fs);  %frame length in samples....20ms window
scaling_factor=1/scaling_factor1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%% Set parameters of the algorithm %%%%%%%%%%%%%%
shift_val=floor(frame_len/2); 
hamming_win=hamming(2*(shift_val));
Ss=frame_len-shift_val; % synthesis frame shift
output_len=round(L*scaling_factor);
ylast=shift_val;
zff_array_y=zeros(1,output_len);
scaled_sp=zeros(1,output_len);
Kmax=round(0.01*Fs); % maximum allowable shift 
zff_array=cat(1,zeros(shift_val,1),zff_array,zeros(Kmax+shift_val,1));
x=cat(1,zeros(shift_val,1),x,zeros(Kmax+shift_val,1));
zff_array_y(1:shift_val)=zff_array(1:shift_val);
scaled_sp(1:shift_val)=x(1:shift_val); % time-scaled speech
i=0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  ALIGN PITCH MARKS (ESOLA) %%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for y_last=shift_val:Ss:(output_len-frame_len)
        
    search_strt_pt_Sa=round(y_last/scaling_factor);
    search_end_pt_Sa=search_strt_pt_Sa+frame_len-1;
    
    search_strt_pt_y=ylast-shift_val+1;
    search_end_pt_y=ylast;
          
    mat_ind_Sa=find(zff_array(search_strt_pt_Sa:search_end_pt_Sa)>0);
    mat_ind_y=find(zff_array_y(search_strt_pt_y:search_end_pt_y)>0);
    
    %%%%%%%% synchronizing epochs/pitch marks
      i=i+1;
      if((isempty(mat_ind_Sa)==1)||(isempty(mat_ind_y)==1)||((mat_ind_Sa(1)-mat_ind_y(1))>Kmax))
           km(i)=0;
      else
           valid_ind=find(mat_ind_Sa>mat_ind_y(1));
           if(isempty(valid_ind)==1)
               km(i)=0;
           else
               km(i)=mat_ind_Sa(valid_ind(1))-mat_ind_y(1);
           end
      end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    y_ovrlp=ylast-shift_val+1:ylast;
    y_nonovrlp=ylast+1:ylast+Ss;
    x_ovrlp=search_strt_pt_Sa+km(i):search_strt_pt_Sa+km(i)+shift_val-1;
    x_nonovrlp=search_strt_pt_Sa+km(i)+shift_val:search_end_pt_Sa+km(i);
    
    
    zff_array_y(y_ovrlp)=zff_array_y(y_ovrlp)+zff_array(x_ovrlp)';
    zff_array_y(y_nonovrlp)=zff_array(x_nonovrlp);
         
    %%%% Uses Hamming windowing at the overlapping parts of frames
     scaled_sp(y_ovrlp)=(scaled_sp(y_ovrlp).*hamming_win(shift_val+1:end)')+(x(x_ovrlp).*hamming_win(1:shift_val))';
     scaled_sp(y_nonovrlp)=x(x_nonovrlp);
   %%%%%%%%%%%%%%%%%%%%%%%%
   ylast=ylast+Ss;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% END OF ALIGNING EPOCHS %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end