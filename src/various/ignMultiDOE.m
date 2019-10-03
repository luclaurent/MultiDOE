%% Generate list of ignored files and manually added ones for documentation
% L. LAURENT -- 03/10/2019  -- luc.laurent@lecnam.net

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

function [ignPattern,addFiles]=ignMultiDOE()

ignPattern= {'.git',char(126),'m2html','.DS_Store',...
    'lightspeed','mmx','mtimesx','Multiprod',...
    'sqplab-0.4.5-distrib','toolbox','PSOt',...
    'monomial_basis','.travis.yml','optigtest',...
    'multidoe','PSOt','matlab2tikz','multiprod',...
    'old','ToBeValidate','Monomial'};

addFiles={};

end