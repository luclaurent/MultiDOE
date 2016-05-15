%% Fonction assurant l'initialisation et l'affichage des infos temporelles dans les fonctions
%% L.LAURENT -- 15/05/20012 -- laurent@lmt.ens-cachan.fr

function [tictoc_compt,tInit]=mesu_time(compteur,tps_init)

if nargin==0
    %initialisation compteur tic-toc
    tictoc_compt=tic;
    %mesure tps CPU initial
    tInit=cputime;
    
elseif nargin==2
    tElapsed=toc(compteur);
    tCPUElapsed=cputime-tps_init;
    fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
    fprintf('  #### Tps/Tps CPU (s): %4.2f s / %4.2f s\n',tElapsed,tCPUElapsed);
end
