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

%% Initialization of the directories (MATLAB's path)
%% L. LAURENT -- 06/01/2014 -- luc.laurent@lecnam.net

function [foldersLoad,pathAtAbsolute]=initDirMultiDOE(pathcustom,other)

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
    'src/libs'};

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
    pathcustom=strrep(which(mfilename),[mfilename '.m'],'');
end

%absolute paths
pathAbsolute=cellfun(@(c)fullfile(pathcustom,c),foldersLoad,'uni',false);

%scan all directory to find "@" folder (used for classes)
folderAt=scanATfolder(pathcustom);
for iP=1:numel(pathAbsolute)
    folderAtTmp=scanATfolder(pathAbsolute{iP});
    folderAt=[folderAt;folderAtTmp'];
end

%absolute paths
pathAtAbsolute=cellfun(@(c)strrep(c,pathcustom,''),folderAt,'uni',false);

%add to the PATH
flA=cellfun(@(x)addpathExisted(x),pathAbsolute);
flB=[];
if nargin==2
    if ~isempty(other)
        %Load other toolbox
        if ~iscell(other);other={other};end
        %absolute paths
        pathAbsolute=cellfun(@(c)fullfile(pathcustom,'/../',c),other,'uni',false);
        %add to the PATH
        cellfun(@(x)addpathExisted(x),pathAbsolute);
        %add other toolbox to the PATH
        namFun=cellfun(@(c)['initDir' c],other,'uni',false);
        flB=cellfun(@feval,namFun,pathAbsolute);
    end
end

if any([flA flB]==2)
    %display
    Mfprintf(' ## Toolbox: MultiDOE loaded\n');
end
end


%check if a directory exists in the path or not and add it to the path if not
function flag=addpathExisted(folder)
flag=1;
folder=fullfile(folder);
if ispc
  % Windows is not case-sensitive
  onPath = contains(lower(path),lower(folder));
else
  onPath = contains(path,folder);
end
if exist(folder,'dir')&&~onPath
    flag=2;
    addpath(folder)
end
end

%scan folder for finding "@" (classes) folder
function listDir=scanATfolder(folder)
%scan the folder
resScan=dir(folder);
%
listDir={};
for ii=1:numel(resScan)
    if resScan(ii).isdir
        if resScan(ii).name(1)=='@'
            if ~isempty(folder)
                listDir{end+1}=fullfile(folder,resScan(ii).name);
            else
                listDir{end+1}=resScan(ii).name;
            end
        end
    end
end
end

