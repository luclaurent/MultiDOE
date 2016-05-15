%% Fonction assurant l'enrichissement de la base de points echantillonnes 
%% L. LAURENT -- 04/12/2011 -- luc.laurent@lecnam.net

% l'enrichissement necessite la presence du package 'R.matlab' dans R

function new_tir=ajout_tir_doe(old_tirages,doe)

Xmin=doe.Xmin;
Xmax=doe.Xmax;

nb_samples=doe.nb_samples;

% en fonction du type de tirages initial
switch doe.type
    case 'LHS_R'
        [new_tir]=lhsu_R(Xmin,Xmax,nb_samples,old_tirages);
    case 'IHS_R'
        [new_tir]=ihs_R(Xmin,Xmax,nb_samples,old_tirages);
    otherwise
        fprintf('>>>> Seul les tirages de type LHS_R et IHS_R \n permettent l''enrichissement\n')
        pts=[];
end