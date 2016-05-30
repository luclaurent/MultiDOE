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


%% Initialization of the directories (MATLAB's path)
%% L. LAURENT -- 06/01/2014 -- luc.laurent@lecnam.net

function foldersLoad=initDirMultiDOE(pathcustom,other)

% variable 'other' (optional) of type cell must constain the list of other
% toolboxes to load (they must be in '../.')

% variable 'pathcustom' (optional) contains the specific folder from where
% the directories must be loaded

%folders of the MultiDOE toolbox
foldersLoad={'src',...
    'src/crit',...
    'src/disp',...
    'src/DOE',...
    'src/init',...
    'src/libs',...
    'src/libs/LHS',...
    'src/libs/IHS',...
    'src/various',...
    'src/libs',...
    'src/libs/m2html'};

%depending on the parameters
specifDir=true;
if nargin==0
    specifDir=false;
elseif nargin>1
    if isempty(pathcustom)
        specifDir=false;
    end
end
%if no specified directory
if ~specifDir
    pathcustom=pwd;
end

%absolute paths
pathAbsolute=cellfun(@(c)[pathcustom '/' c],foldersLoad,'uni',false);

%add to the PATH
cellfun(@addpath,pathAbsolute);

if nargin==2
    %Load other toolbox
    if ~iscell(other);other={other};end
    %absolute paths
    pathAbsolute=cellfun(@(c)[pathcustom '/../' c],other,'uni',false);
    %add to the PATH
    cellfun(@addpath,pathAbsolute);
    %add other toolbox to the PATH
    namFun=cellfun(@(c)['initDir' c],other,'uni',false);
    cellfun(@feval,namFun,pathAbsolute)
end

%display
fprintf(' ## Toolbox: MultiDOE loaded\n');
end
