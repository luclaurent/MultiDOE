%% Sorting of sample points
% L. LAURENT -- 03/09/2013 -- luc.laurent@lecnam.net

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


function nbT = Mfprintf(varargin)

%adding text in front of the original text
txtAdd='multiDOE';

%check if the first argument is a double (corresponding to a file id)
if isa(varargin{1},'double')
    %argOk=varargin{2:end};
    %use the classical fprintf function
    nbT=fprintf(varargin{:});
else
    argOk=varargin;   
    
    %convert all inputs to a string
    str = sprintf(argOk{:});
    
    %find new lines
    strSplit=regexp(str,'\n','split');
    
    % display text and adding new keyword
    nbT=0;
    for itS=1:numel(strSplit)
        if itS==numel(strSplit)&&isempty(strSplit{itS})
        else
            txtD=[ txtAdd ' | ' strSplit{itS}];
            nbytes=fprintf(txtD);
            nbT=nbT+nbytes;
        end
        if itS<numel(strSplit)
            nbytes=fprintf('\n');
            nbT=nbT+nbytes;
        end
    end
end
end