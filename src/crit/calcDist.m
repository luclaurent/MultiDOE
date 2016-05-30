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

%% function for computing inter-sample distances
%% L. LAURENT -- 03/04/2013 -- luc.laurent@lecnam.net

function [distMat,distVect,uniqDist,multiDOE] = calcDist(sampling,q)

%if q is not specified, the euclidian distance will be used
if nargin==1
    q=2;
end

%number of variables
ns=size(sampling,1);

%geenrate combinations
comb=fullfact([ns ns]);
comb1=comb(:,1);comb2=comb(:,2);
diffC=comb1-comb2;
iX=diffC~=0;
iXX=diffC<0;

iX=iX&iXX;

comb1=comb1(iX);
comb2=comb2(iX);
%[comb1 comb2]
%compute inter-sample points distances
pti=sampling(comb1,:);
ptj=sampling(comb2,:);
distVect=sum(abs(ptj-pti).^q,2).^(1/q);
%store in a matrix
distMat=zeros(ns);
IX=sub2ind([ns ns],comb1,comb2);
distMat(IX)=distVect;
distMat=distMat+distMat';

if nargout>1
    %concatenate distance
    dist_cat=distVect(:);    
    if nargout>2
        %remove duplicates
        uniqDist=unique(dist_cat);
        if nargout>3
            %build table of the multiplicity of the distances
            multiDOE=zeros(size(uniqDist));
            for ii=1:length(uniqDist)
                multiDOE(ii)=sum(ismember(dist_cat,uniqDist(ii)));
            end
        end
    end
end

