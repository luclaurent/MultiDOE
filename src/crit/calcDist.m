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

