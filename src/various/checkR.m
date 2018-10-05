%% Check R software
%check if the R software is available
% L. LAURENT -- 31/05/2016 -- luc.laurent@lecnam.net

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


function [rOk,TBXOk]=checkR()

rOk=false;
TBXOk=false;
%path declaration for R software
setenv('DYLD_LIBRARY_PATH','/usr/local/bin/');
setenv('PATH','/usr/local/bin/');

%load LHS library
loadLHS='library(lhs)';
%load R.matlab library
loadRmat='library(R.matlab)';

%check if available
[e,~]=unix('which R');
if e~=0
    error('R is not installed (not in the PATH)');
else
    rOk=true;
end

%check if lhs library is available
runRCMD='R --vanilla';
[e,~]=unix([runRCMD ' <<< ' loadLHS]);
if e~=0
    fprintf('The library lhs is not installed in R\n');
else
    TBXOk=true;
end

%check if R.matlab library is available
runRCMD='R --vanilla';
[e,~]=unix([runRCMD ' <<< ' loadRmat]);
if e~=0
    fprintf('The library R.matlab is not installed in R\n');
else
    TBXOk=TBXOk&true;
end
end



