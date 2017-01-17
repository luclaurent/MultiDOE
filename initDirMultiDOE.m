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
%     

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
flA=cellfun(@(x)addpathExisted(x),pathAbsolute);
flB=[];
if nargin==2
    if ~isempty(other)
        %Load other toolbox
        if ~iscell(other);other={other};end
        %absolute paths
        pathAbsolute=cellfun(@(c)[pathcustom '/../' c],other,'uni',false);
        %add to the PATH
        cellfun(@(x)addpathExisted(x),pathAbsolute);
        %add other toolbox to the PATH
        namFun=cellfun(@(c)['initDir' c],other,'uni',false);
        cellfun(@feval,namFun,pathAbsolute)
    end
end

if any([flA flB]==2)
    %display
    Mfprintf(' ## Toolbox: MultiDOE loaded\n');
end
end


%check if a directory exists or not and add it to the path if not
function flag=addpathExisted(folder)
flag=1;
if ~exist(folder,'dir')
    flag=2;
    addpath(folder)
end
end

