%% Build documentation (using builddoc submodule)
% L. LAURENT -- 03/10/2019 -- luc.laurent@lecnam.net

%     GRENAT - GRadient ENhanced Approximation Toolbox
%     A toolbox for generating and exploiting gradient-enhanced surrogate models
%     Copyright (C) 2016-2017  Luc LAURENT <luc.laurent@lecnam.net>
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

%path of this script
fp=mfilename('fullpath');
fps=strsplit(fp,filesep);
fps{1}='/';
%
folderSrc=fullfile(fps{1:end-2});
folderLibs=fullfile(folderSrc,'libs');
folderDocs=fullfile(folderLibs,'builddoc');

% update the submodule
system(['cd ' folderLibs ';git submodule update builddoc']);

% add builddoc in path
addpath(folderDocs);

% run buildDoc
buildDoc('MultiDOE')

