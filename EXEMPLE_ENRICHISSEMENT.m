%Exemple d'enrichissement tirage LHS_R
% L. LAURENT -- 06/01/2014 -- laurent@lmt.ens-cachan.fr

%initialisation des dossiers
init_rep_LMTir;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%chargement de la configuration
doe=init_doe(3);
%
doe.Xmin=[-1 -2 -3];
doe.Xmax=[3 2 1];
doe.type='LHS_R_enrich';
doe.nb_samples=5;
dor.tri.on=false; %tri desactive (!!)
doe.nbs_max=30; %nb d'ajout maxi
doe.aff=false;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generation du tirage
tirage=gene_doe(doe);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%enrichissement
doe.nb_samples=2;
new_tirage=ajout_tir_doe(tirage,doe);
aff_doe(new_tirage)