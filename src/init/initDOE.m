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

%% Initialization on the DOE structure (definition of the options)
%% L. LAURENT -- 05/01/2011 -- luc.laurent@lecnam.net

%% usable syntaxes
%init_doe
%init_doe(dim)
%init_doe(dim,esp)
%init_doe(dim,esp,funT)

%% INPUT variables
% -dim : number of design variables
% -espM : matrix for defining the bounds of the design space
%       -nb of row=dim
%       -nb of columns=2 (lower and upper bounds)
% -funT : name of a test function (see below)
% if the test function is available in the matlab's path the function will
% create the right 'doe' structure that conatins the right options

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

function [doe]=initDOE(dim,espM,funT)


fprintf('=========================================\n')
fprintf('      >>> DOE INITIALIZATION <<<\n');
[tMesu,tInit]=mesuTime;

%depending on the number of parameters
if nargin==0
    funT=[];
    dim=[];
    espM=[];
elseif nargin==1
    espM=[];
    funT=[];
elseif nargin==2
    funT=[];
end

%automatic definition
if ~isempty(funT)
    [espM,dim]=initDOEfun(dim,funT);
end

%number of design variables
doe.dimPB=dim;
%number of sample points
doe.ns=[];

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

%display sampling
doe.disp=true;

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

%kind of sampling
doe.type='LHS';

%show information
if ~isempty(funT)
    fprintf('++ Test function: %s (%iD)\n',funT,dim);
else
    if ~isempty(dim)
        fprintf('++ Number of variables: %i\n',dim)
    end
end
fprintf('++ Design space: ');
if isempty(doe.Xmin)
    fprintf('UNDEFINED\n')
else
    fprintf('   Min  |');
    fprintf('%+4.2f|',doe.Xmin);fprintf('\n');
    fprintf('   Max  |');
    fprintf('%+4.2f|',doe.Xmax);fprintf('\n');
end
fprintf('++ Sorting of the sampling du tirages: ');
if ~doe.sort.on
    fprintf('NO\n');
else
    fprintf('YES\n');
    fprintf('Used methods for sorting: %s (%g)\n',doe.sort.type,doe.sort.para);
end
fprintf('++ Display sampling: ');
if doe.disp; fprintf('Yes\n');else fprintf('NO\n');end

mesuTime(tMesu,tInit);
fprintf('=========================================\n')
