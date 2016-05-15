%% Generation de plan d'experience LHS a partir de R (avec pretirage de LHS enrichi)
%% LHS S-optimal (genere en utilisant des permutations de colonnes)
%Refs: Stocki, R. (2005) A method to improve design reliability using optimal Latin hypercube sampling Computer Assisted Mechanics and Engineering Sciences 12, 87?105.
% L. LAURENT -- 02/01/2013 -- laurent@lmt.ens-cachan.fr



function [tir,new_tir]=olhs_R(Xmin,Xmax,nb_samples,old_tir,nb_enrich)

%% INPUT:
%    - Xmin,Xmax: bornes min et max de l'espace de conception
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
nb_pretir=0;;
%nom du fichier script r
nom_script='olhs_R_';
ext_script='.r';
%nom du fichier de donnees R
nom_dataR='dataR_';
ext_dataR='.dat';
%temps de pause apres execution R
tps_pause=0;
%options 
%nombre de permutation "Columnwise Pairwise"
nbperm=numel(Xmin);
%critere arret
crit_stop=1e-2;

%phase de creation des plans
if nargin==3
    
    % recuperation dimensions (nombre de variables et nombre d'echantillon)
    nbs=nb_samples;
    nbv=numel(Xmin);
    %nom fichier complet
    nom_script=[nom_script num2str(nbv) '_' num2str(nbs) ext_script];
    %nom fichier donnees complet
    nom_dataR=[nom_dataR num2str(nbv) '_' num2str(nbs) ext_dataR];
    
    %%ecriture d'un script R
    %Creation du repertoire de stockage (s'il n'existe pas)
    if exist(rep,'dir')~=7
        cmd=['mkdir ' rep];
        unix(cmd);
    end
    
    %ecriture du script r
    %procedure de creation du tirage initial
    text_init=['a<-optimumLHS(' num2str(nbs) ',' num2str(nbv) ','...
        num2str(nbperm) ',' num2str(crit_stop) ')\n'];
    %procedure d'enrichissement
    text_enrich=['a<-optAugmentLHS(a,1,4)\n'];
    %chargement librairie LHS
    load_LHS='library(lhs)\n';
    %procedure stockage tirage
    stock_tir=['write.table(a,file="' nom_dataR '",row.names=FALSE,col.names=FALSE)'];
    
    %creation et ouverture du fichier de script
    fid=fopen([rep '/' nom_script],'w','n','UTF-8');
    %ecriture chargement librairie
    fprintf(fid,load_LHS);
    %ecriture tirage initial
    fprintf(fid,text_init);
    %ecriture de l'enrichissement
    for ii=1:nb_pretir
        fprintf(fid,text_enrich);
    end
    %ecriture de la procedure de sauvegarde
    fprintf(fid,stock_tir);
    %fermeture du fichier
    fclose(fid);
    %%execution du script R (necessite d'avoir r installe)
    %test de l'existence de
    [e,t]=unix('which R');
    if e~=0
        error('R non installe (absent du PATH)');
    else
        [~,t]=unix(['cd ' rep ' && R -f ' nom_script]);
        pause(tps_pause)
    end
    %lecture du fichier de donnees R
    A=load([rep '/' nom_dataR]);
    %tirage obtenu
    tir=A(1:nbs,:).*repmat(Xmax(:)'-Xmin(:)',nbs,1)+repmat(Xmin(:)',nbs,1);
    new_tir=[];
    
    %phase d'enrichissement
elseif nargin==5
    
    %nombre d'echantillons dans le tirage precedent
    old_nbs=size(old_tir,1);
    
    %chargement du fichier de donnees R
    A=load([rep '/' nom_dataR]);
    
    %nouveaux tirages
    ind=old_nbs+1:old_nbs+nb_enrich;
    new_tir=A(ind,:).*repmat(Xmax(:)'-Xmin(:)',nb_enrich,1)+repmat(Xmin(:)',nb_enrich,1);
    %liste de tous les tirages
    tir=[old_tir;new_tir];
    
    
end
