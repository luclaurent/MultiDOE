%% Example of use of the MultiDOE toolbox
% L. LAURENT -- 06/01/2014 -- luc.laurent@lecnam.net

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

%initialize folders of the toolbox
initDirMultiDOE;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load configuration
doe=initDOE(3);
%
doe.Xmin=[-1 -2 -3];% -1 -2 -3 -1 -2 -3 -3];
doe.Xmax=[3 2 1];% 3 2 1 3 2 1 1];

% available sampling techniques :
% - ffact "full factorial"
% - LHS_R
% - OLHS_R
% - MMLHS_R
% - GLHS_R
% - IHS_R
% - HALTON
% - SOBOL
% - LHSD --> MATLAB (lhsdesign)
% - LHSD_CORRMIN
% - LHSD_MAXMIN
% - LHSD_NS
% - LHS 
% - IHS
% - LHS_O1
% - IHS_R_manu_infill
% - LHS_R_manu_infill
% - rand
% - perso

doe.type='IHS_R_manu';
doe.ns=32;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%build DOE
[sampling,infos]=buildDOE(doe);
sampling.sorted
sampling.unsorted