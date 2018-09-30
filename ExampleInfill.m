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

%% Example of use of the enrichment of IHS 
% L. LAURENT -- 06/01/2014 -- luc.laurent@lecnam.net

%initialize folders of the toolbox
initDirMultiDOE;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load configuration
doe=initDOE(3);
%
doe.Xmin=[-1 -2 -3];
doe.Xmax=[3 2 1];
doe.type='LHS_R'; %or LHS_R
doe.ns=5;
doe.sort.on=false; %w/o sorting
doe.disp=true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%build DOE
sampling=buildDOE(doe);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%enrichment
doe.ns=2;
newSample=addSampleDOE(sampling,doe);
displayDOE(newSample,doe)