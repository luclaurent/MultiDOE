%%fonction de calcul intersite d'un tirages
%% L. LAURENT -- 03/04/2013 -- laurent@lmt.ens-cachan.fr

function [distmat,dist,uniq_dist,nb_paires,ecart] = distir(tirages,q)

%si q non specifie calcul d'une distance Euclidienne
if nargin==1
    q=2;
end

%nombre de points et nombre de variables
nb_val=size(tirages,1);

%generation des combinaison
comb=fullfact([nb_val nb_val]);
comb1=comb(:,1);comb2=comb(:,2);
diff=comb1-comb2;
ind=diff~=0;
indd=diff<0;

ind=ind&indd;

comb1=comb1(ind);
comb2=comb2(ind);
%[comb1 comb2]
%calcul des distances interpoints
pti=tirages(comb1,:);
ptj=tirages(comb2,:);
ecart.val=pti-ptj;
dist=sum(abs(ecart.val).^q,2).^(1/q);
%convertion en matrice
distmat=zeros(nb_val);
IX=sub2ind([nb_val nb_val],comb1,comb2);
distmat(IX)=dist;
distmat=distmat+distmat';
ecart.ind=IX;
ecart.sub=[comb1 comb2];

if nargout>1
    %concatenation des distances
    dist_cat=dist(:);    
    if nargout>2
        %suppression des doublons
        uniq_dist=unique(dist_cat);
        if nargout>3
            %construction de la table de multiplicité des longueurs
            nb_paires=zeros(size(uniq_dist));
            for ii=1:length(uniq_dist)
                nb_paires(ii)=sum(ismember(dist_cat,uniq_dist(ii)));
            end
        end
    end
end

