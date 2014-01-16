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

% Tirages possibles :
% - ffact "plan factoriel"
% - LHS_R
% - OLHS_R
% - MMLHS_R
% - GLHS_R
% - IHS_R
% - HALTON
% - SOBOL
% - LHSD --> MATLAB (lhsdesign)
% - LHSD_CORRMIN
% - LHSD_MAXMIN
% - LHSD_NS
% - LHS 
% - IHS
% - LHS_O1
% - IHS_R_manu_enrich
% - LHS_R_manu_enrich
% - rand
% - perso

doe.type='LHS';
doe.nb_samples=30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%generation du tirage
[tirage,infos]=gene_doe(doe);
tirage.tri
tirage.non_tri