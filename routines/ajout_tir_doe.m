%% Fonction assurant l'enrichissement de la base de points echantillonnes 
%% L. LAURENT -- 04/12/2011 -- laurent@lmt.ens-cachan.fr

function new_tir=ajout_tir_doe(old_tirages,doe)

Xmin=doe.Xmin;
Xmax=doe.Xmax;

nb_samples=size(old_tirages,1);

% en fonction du type de tirages initial
switch doe.type
    case 'LHS_R'
        [~,new_tir]=lhsu_R(Xmin,Xmax,nb_samples,old_tirages,1);
    case 'IHR_R'
        [~,new_tir]=ihs_R(Xmin,Xmax,nb_samples,old_tirages,1);
    otherwise
        fprintf('>>>> Seul les tirages de type LHS_R et IHS_R \n permettent l''enrichissement\n')
        pts=[];
end