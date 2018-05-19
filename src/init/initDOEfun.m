%     MultiDOE - Toolbox for sampling a bounded space
%     Copyright (C) 2016  Luc LAURENT <luc.laurent@lecnam.net>
%
% sources available here:
% https://bitbucket.org/luclaurent/multidoe/
% https://github.com/luclaurent/multidoe/
%  
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%     

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