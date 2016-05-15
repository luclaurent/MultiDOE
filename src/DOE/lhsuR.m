%% Generation de plan d'experience LHS a partir de R (avec pretirage de LHS enrichi)
% L. LAURENT -- 14/01/2012 -- laurent@lmt.ens-cachan.fr


function [tir,new_tir]=lhsu_R(Xmin,Xmax,nb_samples,old_tir)

%% INPUT:
%    - Xmin,Xmax: bornes min et max de l'espace de concpetion
%    - nb_samples: nombre d'echantillons requis
%    - nb_enrich: nombre d'echantillons requis pour enrichir
%% OUTPUT
%   - tir: echantillons
%   - new_tir: nouveaux echantillons en phase d'enrichissement
%%

%chemin librairies pour bonne execution R
setenv('DYLD_LIBRARY_PATH','/usr/local/bin/');

%%declaration des options
% repertoire de stockage
rep='LHS_R';
%nombre de plans pretires
nb_pretir=0;
%nom du fichier script r
nom_script='lhsu_R_';
ext_script='.r';
%nom du fichier de donnees R
nom_dataR='dataR_';
nom_dataM=nom_dataR;
ext_dataR='.dat';
ext_dataM='.mat';
%temps de pause apres execution R
tps_pause=0;

nb_old=0;
if nargin==4
    nb_old=size(old_tir,1);
else
    nb_old=1;
end

% recuperation dimensions (nombre de variables et nombre d'echantillon)
nbs=nb_samples;
nbv=numel(Xmin);
%nom fichier complet
nom_script=[nom_script num2str(nbv) '_' num2str(nbs+nb_old) ext_script];
%nom fichier donnees complet
nom_dataR=[nom_dataR num2str(nbv) '_' num2str(nbs+nb_old) ext_dataR];
%nom fichier tirage .mat
nom_dataM=[nom_dataM num2str(nbv) '_' num2str(nbs+nb_old) ext_dataM];
%chargement librairie LHS
load_LHS='library(lhs)\n';
%chargement librairie R.matlab
load_Rmat='library(R.matlab)\n';
%procedure stockage tirage
stock_tir=['write.table(a,file="' nom_dataR '",row.names=FALSE,col.names=FALSE)\n'];

%phase de creation des plans
if nargin==3
    %%ecriture d'un script R
    %Creation du repertoire de stockage (s'il n'existe pas)
    if exist(rep,'dir')~=7
        cmd=['mkdir ' rep];
        unix(cmd);
    end
    
    %ecriture du script r
    %procedure de creation du tirage initial
    text_init=['a<-randomLHS(' num2str(nbs) ',' num2str(nbv) ')\n'];
    %creation et ouverture du fichier de script
    fid=fopen([rep '/' nom_script],'w','n','UTF-8');
    %ecriture chargement librairie
    fprintf(fid,load_LHS);
    %ecriture tirage initial
    fprintf(fid,text_init);
    
    %ecriture de la procedure de sauvegarde
    fprintf(fid,stock_tir);
    %fermeture du fichier
    fclose(fid);
    
    %phase d'enrichissement
elseif nargin==4
    %normalisation ancien tirage
    nold_tir=norm_tir(old_tir,Xmin,Xmax);
    %ecriture fichier .mat ancien tirage
    save([rep '/' nom_dataM],'nold_tir');
    %recharge ancien tirage
    text_charg=sprintf('a<-readMat(''%s'')\n a<-a$nold.tir\n',nom_dataM);
    %procedure d'enrichissement
    text_enrich=sprintf('a<-augmentLHS(a,%i)\n',nb_samples);
    %creation et ouverture du fichier de script
    fid=fopen([rep '/' nom_script],'w','n','UTF-8');
    %ecriture chargement librairies
    fprintf(fid,load_LHS);
    fprintf(fid,load_Rmat);
    %ecriture chargement ancien tirage
    fprintf(fid,text_charg);
    %ecriture enrichissement
    fprintf(fid,text_enrich);
    
    %ecriture de la procedure de sauvegarde
    fprintf(fid,stock_tir);
end

%%execution du script R (necessite d'avoir r installe)
%test de l'existence de
[e,~]=unix('which R');
if e~=0
    error('R non installe (absent du PATH)');
else
    [~,~]=unix(['cd ' rep ' && R -f ' nom_script]);
    pause(tps_pause)
end
%lecture du fichier de donnees R
A=load([rep '/' nom_dataR]);
%tirage obtenu
tir=denorm_tir(A,Xmin,Xmax);
%tirages ajoutes
new_tir=tir(nb_old:end,:);
end

%fonctions de normalisation/denormalisation des tirages
function ntir=norm_tir(tirage,Xmin,Xmax)
nbs=size(tirage,1);
ntir=(tirage-repmat(Xmin(:)',nbs,1))./repmat(Xmax(:)'-Xmin(:)',nbs,1);
end

function dntir=denorm_tir(tirage,Xmin,Xmax)
nbs=size(tirage,1);
dntir=tirage.*repmat(Xmax(:)'-Xmin(:)',nbs,1)+repmat(Xmin(:)',nbs,1);
end
