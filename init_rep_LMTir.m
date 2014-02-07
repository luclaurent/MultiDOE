%% Script d'ajout des chemins de la Toolbox LMTir
%% L. LAURENT -- 06/01/2014 -- laurent@lmt.ens-cachan.fr

function doss=init_rep_LMTir(chemin)

%dossier de la Toolbox LMTir
doss={'routines','routines/divers',...
    'routines/libs','routines/libs/m2html',...
    'tirages','tirages/IHS','tirages/LHS'};

%si pas de chemin spécifié
if nargin==0
    chemin=pwd;
end

%chemins absolus
chemin_full=cellfun(@(c)[chemin '/' c],doss,'uni',false);

%ajout au PATH
cellfun(@addpath,chemin_full);
