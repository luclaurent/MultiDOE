%Exemple d'utilisation de la Toolbox LMTir
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
doe.type='LHS';
doe.nb_samples=30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generation du tirage
tirage=gene_doe(doe);