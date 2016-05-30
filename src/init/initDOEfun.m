% Copyright or © or Copr. Luc LAURENT (30/06/2016)
% luc.laurent@lecnam.net
% 
% This software is a computer program whose purpose is to generate sampling
% using dedicated techniques.
% 
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software.  You can  use, 
% modify and/ or redistribute the software under the terms of the CeCILL
% license as circulated by CEA, CNRS and INRIA at the following URL
% "http://www.cecill.info". 
% 
% As a counterpart to the access to the source code and  rights to copy,
% modify and redistribute granted by the license, users are provided only
% with a limited warranty  and the software's author,  the holder of the
% economic rights,  and the successive licensors  have only  limited
% liability. 
% 
% In this respect, the user's attention is drawn to the risks associated
% with loading,  using,  modifying and/or developing or reproducing the
% software by the user in light of its specific status of free software,
% that may mean  that it is complicated to manipulate,  and  that  also
% therefore means  that it is reserved for developers  and  experienced
% professionals having in-depth computer knowledge. Users are therefore
% encouraged to load and test the software's suitability as regards their
% requirements in conditions enabling the security of their systems and/or 
% data to be ensured and,  more generally, to use and operate it in the 
% same conditions as regards security. 
% 
% The fact that you are presently reading this means that you have had
% knowledge of the CeCILL license and that you accept its terms.

%% Initialisation of the design space for some analytical functions
%% L. LAURENT -- 16/01/2014 -- luc.laurent@lecnam.net

function [espM,dim]=initDOEfun(dim,fct)

switch fct
    case 'Manu'
        espM=[-1 5];
        dim=1;
    case 'Ackley'
        val=1.5;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case {'Rosenbrock','RosenbrockM'}
        val=2.048;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'Branin'
        xmin=-5;xmax=10;ymin=0;ymax=15;
        espM=[xmin xmax;ymin ymax];
    case 'Gold'
        val=2;xmin=-val;xmax=val;ymin=-val;ymax=val;
        espM=[xmin xmax;ymin ymax];
    case 'Peaks'
        val=3;xmin=-val;xmax=val;ymin=-val;ymax=val;
        espM=[xmin xmax;ymin ymax];
    case 'SixHump'
        xmin=-2;xmax=2;ymin=-1;ymax=1;
        espM=[xmin xmax;ymin ymax];
    case 'Schwefel'
        val=500;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'Mystery'
        val=5;xmin=0;xmax=val;ymin=0;ymax=val;
        espM=[xmin xmax;ymin ymax];
    case {'Bohachevsky1','Bohachevsky2','Bohachevsky3'}
        val=100;
        espM=[-val,val;-val,val];
    case 'Booth'
        val=10;
        espM=[-val,val;-val,val];
    case 'Colville'
        val=10;
        espM=val*[-1,1;-1,1;-1,1;-1,1];
    case {'Dixon','Sphere','SumSquare'}
        val=10;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'Michalewicz'
        val=pi;
        espM=val*[zeros(dim,1),ones(dim,1)];
    case {'Null','Cst','Slope'}
        val=5;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case {'Dejong','AHE','Rastrigin'}
        val=5.12;
        espM=val*[-ones(dim,1),ones(dim,1)];
    case 'RHE'
        val=65.536;
        espM=val*[-ones(dim,1),ones(dim,1)];
    otherwise
        error(['>> Unavailable test function (see ',mfilename,')']);
end