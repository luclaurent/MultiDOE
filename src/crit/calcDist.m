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
%     

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

