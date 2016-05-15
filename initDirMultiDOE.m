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
    'src/various'};

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
end
