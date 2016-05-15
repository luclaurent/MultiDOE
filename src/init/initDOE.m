%% Initialisation bornes de l'espace d'etude
%% L. LAURENT -- 05/01/2011 -- luc.laurent@lecnam.net

%syntaxes possibles
%init_doe
%init_doe(dim)
%init_doe(dim,esp)
%init_doe(dim,esp,fct)
% -dim : nombre de variables du probleme
% -esp : matrice de définition des bornes des variables
%       -nb de lignes=dim
%       -nb de colonnes=2 (bornes sup et inf)
% -fct : nom d'une fonction test (voir le contenu de la routine init_doe)
% si fonction test disponible dans le PATH
% la routine assure la creation de la structure "doe" contenant les
% differentes options de tirages

% Sorties (modifiables)
% doe.dim_pb: nb variables
% doe.fct: nom fonction si specifiée (Peaks, Rosenbrock...) 
% doe.infos: infos disponibles sur la fonctions (minima...)
% doe.tri.on: tri actif
% doe.tri.type: 
%       - 'v' ou 'variable': tri par rapport à la variable dont le numero
%       est specifiee par la variable doe.tri.para
%       - 'nptp' ou 'normal_pt_to_pt'
%       - 'p' ou 'point':
%       - 'c' ou 'center'
%       - 'sac' ou 'sampling_center' (par défaut)
%       - 'sc' ou 'start_center'
%       - 'sasc' ou 'sampling_start_center'
% doe.tri.para: parametre methode de tri
% doe.tri.ptref: point de reference pour le tri
% voir le contenu du fichier exec_tri.m pour la signification de ces
% options
% doe.aff: affichage du tirage ou non (oui par défaut) apres son obtention
% doe.Xmin: liste des bornes inferieures des variables
% doe.Xmax: liste des bornes superieures des variables
% doe.type: type de tirage

function [doe]=init_doe(dim,def,fct)


fprintf('=========================================\n')
fprintf('      >>> INITIALISATION DOE <<<\n');
[tMesu,tInit]=mesu_time;

%en fonction des differents types de paramètres
if nargin==0
    fct=[];
    dim=[];
    def=[];
elseif nargin==1
    def=[];
    fct=[];
elseif nargin==2
    fct=[];
end


esp=[];
%definition automatique
if ~isempty(fct)
    [esp,dim]=init_doe_fct(dim,fct);
end

%nombre de variables du probleme
doe.dim_pb=dim;
%nombre de tirages
doe.nb_samples=[];

doe.fct=[];
doe.infos=[];
if ~isempty(fct)
    %sauvegarde nom fonction
    doe.fct=['fct_' fct];
    
    %si la fonction existe (dans un fichier .m)
    if exist(doe.fct,'file')==2
        %recuperation informations fonction (minima locaux et globaux)
        [~,~,doe.infos]=feval(doe.fct,[],dim);
    end
end

%tri du tirage
%critere v/nptp/p/c/sac/sc/sasc (cf. gene_doe)
%(variable/normal_pt_to_pt/point/center/sampling_center/start_center/sampling_start_center)
doe.tri.on=true;
doe.tri.type='sac';
doe.tri.para=1;
doe.tri.ptref=[];

%affichage tirages
doe.aff=true;


%definition manuelle
if ~isempty(def)
    doe.Xmin=def(:,1);
    doe.Xmax=def(:,2);
end
if ~isempty(esp)
    doe.Xmin=esp(:,1);
    doe.Xmax=esp(:,2);
end
%sinon vide
if ~isfield(doe,'Xmin')
    doe.Xmin=[];
    doe.Xmax=[];
end

%type de tirage
doe.type='LHS';


%affichage informations
if ~isempty(fct)
    fprintf('++ Fonction prise en compte: %s (%iD)\n',fct,dim);
else
    if ~isempty(dim)
        fprintf('++ Nombre de variables: %i\n',dim)
    end
end
fprintf('++ Espace etude: ');
if isempty(doe.Xmin)
    fprintf('NON SPECIFIE\n')
else
    fprintf('   Min  |');
    fprintf('%+4.2f|',doe.Xmin);fprintf('\n');
    fprintf('   Max  |');
    fprintf('%+4.2f|',doe.Xmax);fprintf('\n');
end
fprintf('++ Tri du tirages: ');
if ~doe.tri.on
    fprintf('Non\n');
else
    fprintf('Oui\n');
    fprintf('Methode de tri/parametre associe: %s (%g)\n',doe.tri.type,doe.tri.para);
end
fprintf('++ Affichage tirages: ');
if doe.aff; fprintf('Oui\n');else fprintf('Non\n');end

mesu_time(tMesu,tInit);
fprintf('=========================================\n')
