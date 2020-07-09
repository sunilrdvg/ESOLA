This folder contains the MATLAB codes for ESOLA time- and pitch-scale modification of speech signals.


1. To start with, please run the file 'ESOLA_main.m' -- It is the main file.

2. The information about time- and pitch-scaling functions can be found in the relevant comments in    
'ESOLA_main.m' 

3. The process of time/pitch scaling can be made further efficient and faster by making a change in  the file 'zff_gci_func.m,' which estimates epoch locations in the given speech file using the zero-frequency filtering filter (ZFF).

ZFF technique requires one to estimate average pitch period (denoted by 'N' in 'zff_gci_func.m'). This average pitch period (in terms of number of samples) is used to remove the mean from the zero-frequency filtered signal in a sliding window fashion. 

The function 'zff_gci_func' has a section that estimates average pitch period (N). If one has a good estimate of the average pitch period of the speaker, then one could substitute that value to 'N' instead of calculating it. This will make the algorithm faster.  

4. For any clarifications, please contact: Sunil R (Email: sunilr.dvg@gmail.com). 
