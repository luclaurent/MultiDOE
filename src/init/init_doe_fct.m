%% Initialisation bornes de l'espace d'etude pour des fonctions analytiques définies
%% L. LAURENT -- 16/01/2014 -- laurent@lmt.ens-cachan.fr

function [esp,dim]=init_doe_fct(dim,fct)

switch fct
    case 'manu'
        esp=[-1 5];
        dim=1;
    case 'ackley'
        val=1.5;
        esp=val*[-ones(dim,1),ones(dim,1)];
    case {'rosenbrock','rosenbrockM'}
        val=2.048;
        esp=val*[-ones(dim,1),ones(dim,1)];
    case 'branin'
        xmin=-5;xmax=10;ymin=0;ymax=15;
        esp=[xmin xmax;ymin ymax];
    case 'gold'
        val=2;xmin=-val;xmax=val;ymin=-val;ymax=val;
        esp=[xmin xmax;ymin ymax];
    case 'peaks'
        val=3;xmin=-val;xmax=val;ymin=-val;ymax=val;
        esp=[xmin xmax;ymin ymax];
    case 'sixhump'
        xmin=-2;xmax=2;ymin=-1;ymax=1;
        esp=[xmin xmax;ymin ymax];
    case 'schwefel'
        val=500;
        esp=val*[-ones(dim,1),ones(dim,1)];
    case 'mystery'
        val=5;xmin=0;xmax=val;ymin=0;ymax=val;
        esp=[xmin xmax;ymin ymax];
    case {'bohachevsky1','bohachevsky2','bohachevsky3'}
        val=100;
        esp=[-val,val;-val,val];
    case 'booth'
        val=10;
        esp=[-val,val;-val,val];
    case 'colville'
        val=10;
        esp=val*[-1,1;-1,1;-1,1;-1,1];
    case {'dixon','sphere','sumsquare'}
        val=10;
        esp=val*[-ones(dim,1),ones(dim,1)];
    case 'michalewicz'
        val=pi;
        esp=val*[zeros(dim,1),ones(dim,1)];
    case {'null','cste','pente'}
        val=5;
        esp=val*[-ones(dim,1),ones(dim,1)];
    case {'dejong','AHE','rastrigin'}
        val=5.12;
        esp=val*[-ones(dim,1),ones(dim,1)];
    case 'RHE'
        val=65.536;
        esp=val*[-ones(dim,1),ones(dim,1)];
    otherwise
        error('>> Fonction non prise en compte (doe.fct)');
end