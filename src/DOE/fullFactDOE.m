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

%% Building a full factorial doe with nD variables
% L. LAURENT -- 07/10/2011 -- luc.laurent@lecnam.net

function sampling=fullFactDOE(ns,Xmin,Xmax)

%number of variables
np=numel(Xmin);
%reodering
if length(ns)==1
    ns=ns*ones(1,np);
elseif length(ns)~=1&&length(ns)~=np
    error(['wrong definition of the number of required sample points (',mfilename,')']);
end

%initialize matrix for storing sample points
nsTot=prod(ns);
sampling=zeros(nsTot,np);

%values for each variables
valVar=cell(np,1);
for ii=1:np
    valVar{ii}=linspace(Xmin(ii),Xmax(ii),ns(ii));
end

%% compute values of the sampling matrix
% along the varibales
temp1=[];
for ii=1:np
    if ii>1
        nbTerPre=prod(ns(1:ii-1));
    else
        nbTerPre=1;
    end
    %along values per variables
    for jj=1:length(valVar{ii})
        temp=repmat(valVar{ii}(jj),nbTerPre,1);
        temp1=[temp1;temp];
    end
    temp2=repmat(temp1,prod(ns(ii+1:end)),1);
    temp1=[];
    sampling(:,ii)=temp2;
end
end

