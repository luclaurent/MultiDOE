% Copyright or © or Copr. Luc LAURENT (30/06/2016)
% luc.laurent@lecnam.net
% 
% This software is a computer program whose purpose is to generate sampling
% using dedicated techniques.
% 
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software.  You can  use, 
% modify and/ or redistribute the software under the terms of the CeCILL
% license as circulated by CEA, CNRS and INRIA at the following URL
% "http://www.cecill.info". 
% 
% As a counterpart to the access to the source code and  rights to copy,
% modify and redistribute granted by the license, users are provided only
% with a limited warranty  and the software's author,  the holder of the
% economic rights,  and the successive licensors  have only  limited
% liability. 
% 
% In this respect, the user's attention is drawn to the risks associated
% with loading,  using,  modifying and/or developing or reproducing the
% software by the user in light of its specific status of free software,
% that may mean  that it is complicated to manipulate,  and  that  also
% therefore means  that it is reserved for developers  and  experienced
% professionals having in-depth computer knowledge. Users are therefore
% encouraged to load and test the software's suitability as regards their
% requirements in conditions enabling the security of their systems and/or 
% data to be ensured and,  more generally, to use and operate it in the 
% same conditions as regards security. 
% 
% The fact that you are presently reading this means that you have had
% knowledge of the CeCILL license and that you accept its terms.

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

