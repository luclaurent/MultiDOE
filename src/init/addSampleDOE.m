%% Function for adding new points in an existing sampling
% L. LAURENT -- 04/12/2011 -- luc.laurent@lecnam.net
%
% the enrichment requires the library 'R.matlab' in R software

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

function newSampling=addSampleDOE(oldSampling,nsAdd,doe)

Xmin=doe.Xmin;
Xmax=doe.Xmax;

%extract the right information
if isstruct(oldSampling);
    oldSampling=oldSampling.unsorted;
end

% depending on the initial sampling
switch doe.type
    case 'LHS_R'
        [newSampling]=lhsuR(Xmin,Xmax,nsAdd,oldSampling);
    case 'IHS_R'
        [newSampling]=ihsR(Xmin,Xmax,nsAdd,oldSampling);
    otherwise
        Mfprintf('>>>> Only LHS_R et IHS_R sampling \n allow enrichment\n')
        newSampling=[];
end