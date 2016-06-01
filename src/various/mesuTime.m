%% Script dedicated to the initiailisation, the measure and the display of the spent time
% L. LAURENT -- 15/05/2012 -- luc.laurent@lecnam.net

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

function [tictoc_compt,tInit]=mesuTime(compteur,tps_init)

if nargin==0
    %initialization tic-toc count
    tictoc_compt=tic;
    %Measure initial CPU time
    tInit=cputime;
    
elseif nargin==2
    tElapsed=toc(compteur);
    tCPUElapsed=cputime-tps_init;
    fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
    fprintf('  #### Time/CPU time (s): %4.2f s / %4.2f s\n',tElapsed,tCPUElapsed);
end
