%% Script dedicated to the initiailisation, the measure and the display of the spent time
%% L.LAURENT -- 15/05/2012 -- luc.laurent@lecnam.net

function [tictoc_compt,tInit]=mesuTime(compteur,tps_init)

if nargin==0
    %initialization tic-toc count
    tictoc_compt=tic;
    %Measure initial CPU time
    tInit=cputime;
    
elseif nargin==2
    tElapsed=toc(compteur);
    tCPUElapsed=cputime-tps_init;
    fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
    fprintf('  #### Time/CPU time (s): %4.2f s / %4.2f s\n',tElapsed,tCPUElapsed);
end
