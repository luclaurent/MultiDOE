%% Initialization on the DOE structure (definition of the options)
% L. LAURENT -- 05/01/2011 -- luc.laurent@lecnam.net
%
%% usable syntaxes
%init_doe
%init_doe(dim)
%initDOE(dim,type)
%initDOE(dim,type,espM)
%initDOE(dim,type,espM,funT)
%initDOE(dim,type,espM,funT,stateAutonomous)
%
%% INPUT variables
% -type : type of DOE
% -dim : number of design variables
% -espM : matrix for defining the bounds of the design space
%       -nb of row=dim
%       -nb of columns=2 (lower and upper bounds)
% -funT : name of a test function (see below)
% if the test function is available in the matlab's path the function will
% create the right 'doe' structure that conatins the right options
%
%% OUTPUT variables
% doe.dimPB: nb of design variables
% doe.fctT: name of a test function (Peaks, Rosenbrock..., see below)
% doe.infos: available information about the test function
% doe.sort.on: active sorting
% doe.sort.type:
%       - 'v' or 'variable': sort wrt the specified variable (variable
%       doe.sort.para)
%       - 'nptp' or 'normal_pt_to_pt'
%       - 'p' or 'point':
%       - 'c' or 'center'
%       - 'sac' or 'sampling_center' (default)
%       - 'sc' or 'start_center'
%       - 'sasc' or 'sampling_start_center'
% doe.sort.para: parameter of the sorting method
% doe.sort.ptref: reference point used for sorting data (nptp, p)
% (see also buildDOE.m for the meaning of these options)
% doe.disp: display or not of the obatined sampling (true by default)
% doe.Xmin: lower bounds (vector)
% doe.Xmax: upper bounds (vector)
% doe.type: type of DOE

%     MultiDOE - Toolbox for sampling a bounded space
%     Copyright (C) 2016  Luc LAURENT <luc.laurent@lecnam.net>
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

function [doe]=initDOE(dim,type,espM,funT,stateAutonomous)


fprintf('=========================================\n')
fprintf('      >>> DOE INITIALIZATION <<<\n');


%depending on the number of parameters
if nargin==0
    type='LHS';
    funT=[];
    dim=[];
    espM=[zeros(dim,1) ones(dim,1)];
    stateAutonomous=true;
elseif nargin==1
    type='LHS';
    funT=[];
    espM=[zeros(dim,1) ones(dim,1)];
    stateAutonomous=true;
elseif nargin==2
    if isempty(type);type='LHS';end
    espM=[zeros(dim,1) ones(dim,1)];
    funT=[];
    stateAutonomous=true;
elseif nargin==3
    if isempty(type);type='LHS';end
    if isempty(espM);espM=[zeros(dim,1) ones(dim,1)];end
    funT=[];
    stateAutonomous=true;
elseif nargin==4
    if isempty(type);type='LHS';end
    if isempty(espM);espM=[zeros(dim,1) ones(dim,1)];end
    if isempty(funT);type=[];end
     stateAutonomous=true;
elseif nargin==5
    if isempty(type);type='LHS';end
    if isempty(espM);espM=[zeros(dim,1) ones(dim,1)];end
    if isempty(funT);funT=[];end   
end

%automatic definition
if ~isempty(funT)
    [espM,dim]=initDOEfun(dim,funT);
end

TimeCount=mesuTime;

%type of doe
doe.type=type;
%number of design variables
doe.dimPB=dim;
%number of sample points
doe.nS=[];

doe.funT=[];
doe.infos=[];
if ~isempty(funT)
    %save the name of the test function
    doe.funT=['fun' funT];
    
    %if the test function exists (in a .m file)
    if exist(doe.funT,'file')==2
        %recover informations about the function (local abnd global minima)
        [~,~,doe.infos]=feval(doe.funT,[],dim);
    end
end

%%sorting of the sampling
%criteria v/nptp/p/c/sac/sc/sasc (cf. buildDOE)
%(variable/normal_pt_to_pt/point/center/sampling_center/start_center/sampling_start_center)
doe.sort.on=true;
doe.sort.type='sac';
doe.sort.para=1;
doe.sort.ptref=[];
doe.sort.lnorm=2;

%display sampling
doe.disp=false;

%manual definition
if ~isempty(espM)
    doe.Xmin=espM(:,1);
    doe.Xmax=espM(:,2);
end
if ~isempty(espM)
    doe.Xmin=espM(:,1);
    doe.Xmax=espM(:,2);
end
%otherwise empty
if ~isfield(doe,'Xmin')
    doe.Xmin=[];
    doe.Xmax=[];
end

%show information
if stateAutonomous
    if ~isempty(funT)
        fprintf('++ Test function: %s (%iD)\n',funT,dim);
    else
        if ~isempty(dim)
            fprintf('++ Number of variables: %i\n',dim)
        end
    end
    fprintf('++ Type of DOE: ');
    if isempty(doe.type);fprintf('UNDEFINED\n');else fprintf('%s\n',doe.type);end
    fprintf('++ Design space: \n');
    if isempty(doe.Xmin)
        fprintf('UNDEFINED\n')
    else
        fprintf('   Min  |');
        fprintf('%+4.2f|',doe.Xmin);fprintf('\n');
        fprintf('   Max  |');
        fprintf('%+4.2f|',doe.Xmax);fprintf('\n');
    end
end
fprintf('++ Sorting of the sampling: ');
if ~doe.sort.on
    fprintf('NO\n');
else
    fprintf('YES\n');
    fprintf('+++ Used methods for sorting: %s (%g)\n',doe.sort.type,doe.sort.para);
end
fprintf('++ Display sampling: ');
if doe.disp; fprintf('Yes\n');else fprintf('NO\n');end

if stateAutonomous;TimeCount.stop;end
fprintf('=========================================\n')
