%% Script d'ajout des chemins de la Toolbox LMTir
%% L. LAURENT -- 06/01/2014 -- laurent@lmt.ens-cachan.fr

function doss=init_rep_LMTir(chemin)

%dossier de la Toolbox LMTir
doss={'routines','routines/divers',...
    'routines/libs','routines/libs/m2html',...
    'tirages','tirages/IHS','tirages/LHS'};

%en fonction des parametres
specif_chemin=true;
if nargin==0
    specif_chemin=false;
elseif nargin>1
    if isempty(chemin)
        specif_chemin=false;
    end
end
%si pas de chemin specifie
if ~specif_chemin
    chemin=pwd;
end

%chemins absolus
chemin_full=cellfun(@(c)[chemin '/' c],doss,'uni',false);

%ajout au PATH
cellfun(@addpath,chemin_full);

if nargin==2
    %%chargement des autres toolbox
    if ~iscell(other);other={other};end
    %chemins absolus
    chemin_full=cellfun(@(c)[chemin '/../' c],other,'uni',false);
    %ajout au PATH
    cellfun(@addpath,chemin_full);
    
    %ajout des toolbox dans le PATH
    nom_fct=cellfun(@(c)['init_rep_' c],other,'uni',false);
    cellfun(@feval,nom_fct,chemin_full)
end
end
