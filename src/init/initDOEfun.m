%% Initialisation of the design space for some analytical functions
%% L. LAURENT -- 16/01/2014 -- luc.laurent@lecnam.net

function [espM,dim]=initDOEfun(dim,fct)

switch fct
    case 'manu'
        espM=[-1 5];
        dim=1;
    case 'ackley'
        val=1.5;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case {'rosenbrock','rosenbrockM'}
        val=2.048;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'branin'
        xmin=-5;xmax=10;ymin=0;ymax=15;
        espM=[xmin xmax;ymin ymax];
    case 'gold'
        val=2;xmin=-val;xmax=val;ymin=-val;ymax=val;
        espM=[xmin xmax;ymin ymax];
    case 'peaks'
        val=3;xmin=-val;xmax=val;ymin=-val;ymax=val;
        espM=[xmin xmax;ymin ymax];
    case 'sixhump'
        xmin=-2;xmax=2;ymin=-1;ymax=1;
        espM=[xmin xmax;ymin ymax];
    case 'schwefel'
        val=500;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'mystery'
        val=5;xmin=0;xmax=val;ymin=0;ymax=val;
        espM=[xmin xmax;ymin ymax];
    case {'bohachevsky1','bohachevsky2','bohachevsky3'}
        val=100;
        espM=[-val,val;-val,val];
    case 'booth'
        val=10;
        espM=[-val,val;-val,val];
    case 'colville'
        val=10;
        espM=val*[-1,1;-1,1;-1,1;-1,1];
    case {'dixon','sphere','sumsquare'}
        val=10;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'michalewicz'
        val=pi;
        espM=val*[zeros(dim,1),ones(dim,1)];
    case {'null','cst','slope'}
        val=5;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case {'dejong','AHE','rastrigin'}
        val=5.12;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'RHE'
        val=65.536;
        espM=val*[-ones(dim,1),ones(dim,1)];
    otherwise
        error(['>> Unavailable test function (see',mfilename,')']);
end