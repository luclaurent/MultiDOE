%% Tri de tirages
%% L. LAURENT -- 03/09/2013 -- laurent@lmt.ens-cachan.fr

function tiragesTRI = exec_tri(tirages,doe)
%pour normer
Xmin=doe.Xmin;
Xmax=doe.Xmax;

info_tri=doe.tri;
%norme employee
lnorm=info_tri.lnorm;
%nombre de points et variables
[nb_val,nb_var]=size(tirages);
%on norme
tirages=(tirages-repmat(Xmin(:)',nb_val,1))./repmat(Xmax(:)'-Xmin(:)',nb_val,1);

if info_tri.on
    tiragesTRI=zeros(nb_val,nb_var);
    tri_ok=true;
    %tri en fonction du parametre considere
    switch info_tri.type
        case {'v','variable'}
            %on trie par rapport a une variable
            if isfield(info_tri,'para')&&info_tri.para>0
                if info_tri.para<=size(tirages,1)
                    [~,ind]=sort(tirages(:,info_tri.para));
                    tiragesTRI=tirages(ind,:);
                end
            end
        case {'nptp','normal_pt_to_pt'}
            %on trie en debutant au nieme point (parametre) et en cherchant de point
            %en point (en utilisant la norme consideree
            
            %pt initial
            ptref=[];
            if isfield(info_tri,'ptref');if ~isempty(info_tri.ptref);ptref=info_tri.ptref;end, end
            if isfield(info_tri,'para');num_pt_ref=info_tri.para;else num_pt_ref=1;end
            if num_pt_ref<1||num_pt_ref>nb_var;num_pt_ref=1;end
            
            %triage
            if isempty(ptref)
                tiragesTRI=nptp(tirages,lnorm,num_pt_ref,'exist',doe);
            else
                ptref=(ptref-Xmin(:)')./Xmax(:)';
                tiragesTRI=nptp(tirages,lnorm,ptref,'don',doe);
            end
            
        case {'p','point'}
            %on trie en s'assurant que l'on cherche de point en point en
            %'tournant' autour du point initial en utilisant la norme retenue
            
            %pt initial
            ptref=[];
            if isfield(info_tri,'ptref');if ~isempty(info_tri.ptref);ptref=info_tri.ptref;end, end
            if isfield(info_tri,'para');num_pt_ref=info_tri.para;else num_pt_ref=1;end
            if num_pt_ref<1||num_pt_ref>nb_var;num_pt_ref=1;end
            
            %triage
            if isempty(ptref)
                tiragesTRI=barypt(tirages,lnorm,num_pt_ref,'exist',doe);
            else
                ptref=(ptref-Xmin(:)')./Xmax(:)';
                tiragesTRI=barypt(tirages,lnorm,ptref,'don',doe);
            end
            
        case {'c','center'}
            %on trie en s'assurant que l'on cherche de point en point en
            %'tournant' autour du centre (de l'espace) en utilisant la norme retenue
            %determination des coordonnees du centre de l'espace
            pt_centre=(Xmax(:)'+Xmin(:)')./2;
            %triage
            tiragesTRI=barypt(tirages,lnorm,pt_centre,'don',doe);
        case {'sac','sampling_center'}
            %on trie en s'assurant que l'on cherche de point en point en
            %'tournant' autour du centre (du tirage donne) en utilisant la norme retenue
            %determination des coordonnees du centre du tirage
            min_tirages=min(tirages);
            max_tirages=max(tirages);
            pt_centre=(max_tirages+min_tirages)./2;
            %triage
            tiragesTRI=barypt(tirages,lnorm,pt_centre,'don',doe);
        case {'sc','start_center'}
            %on trie en debutant par le point le plus proche du centre (de l'espace) et
            %en cherchant de point en point en utilisant la norme retenue
            %determination des coordonnees du centre de l'espace
            pt_centre=(Xmax(:)'+Xmin(:)')./2;
            %triage
            tiragesTRI=nptp(tirages,lnorm,pt_centre,'don',doe);
            
        case {'sasc','sampling_start_center'}
            %on trie en debutant par le point le plus proche du centre (du tirage donne) et
            %en cherchant de point en point en utilisant la norme retenue
            
            %determination des coordonnees du centre du tirage
            min_tirages=min(tirages);
            max_tirages=max(tirages);
            pt_centre=(max_tirages+min_tirages)./2;
            %triage
            tiragesTRI=nptp(tirages,lnorm,pt_centre,'don',doe);
        otherwise
            tri_ok=false;
            
    end
    
    if ~tri_ok
        fprintf('###############################################################\n');
        fprintf('## ##mauvais parametre de tri des tirages (tri desactive) ## ##\n');
        fprintf('###############################################################\n');
    end
else
    tiragesTRI=tirages;
end
%on denorme
tiragesTRI=tiragesTRI.*repmat(Xmax(:)'-Xmin(:)',nb_val,1)+repmat(Xmin(:)',nb_val,1);
end

%norme vecteur (meilleure fonctionnement que norm de matlab)
function N=normp(X,type)
%on test si on demande une norme infinie
norminf=isinf(type);
ninf=false;
%valeurs absolue des composantes
Xabs=abs(X);

if norminf
    if -abs(type)==type;ninf=true;end
    
    if ninf
        %norme -Inf
        N=min(Xabs,[],2);
    else
        %norme Inf
        N=max(Xabs,[],2);
    end
else
    %norme p
    N=sum(Xabs.^type,2).^(1/type);
end
end

%fonction assurant le tri de pts en pts avec pt initial choisi parmi les
%points existant (exist) ou a partir dun point donne (don)
function tirages_trie=nptp(tirages,lnorm,info_pt,type,doe)
%nombre de points et variables
[nb_val,nb_var]=size(tirages);
tirages_trie=zeros(nb_val,nb_var);
%liste des numeros de points
liste_num=1:nb_val;
%en fonction du type de pt initial
switch type
    case 'exist'
        %a partir dun point existant
        num_pt_ref=info_pt;
        pt_ref=tirages(num_pt_ref,:);
        tirages_trie(1,:)=pt_ref;
        liste_num(num_pt_ref)=[];
        debutfor=1;
    case 'don'
        %a partir d'un point donne
        pt_ref=info_pt;
        debutfor=0;
end
%pour normer les coordonnees
xnorm=doe.Xmax(:)'-doe.Xmin(:)';
%on trie
for ii=debutfor:nb_val-1
    %on calcule la distance du point considere aux points
    %restants
    xdiff=pt_ref(ones(1,nb_val-ii),:)-tirages(liste_num,:);
    xdiff=xdiff./xnorm(ones(1,nb_val-ii),:);
    dist=normp(xdiff,lnorm);
    %on cherche le minimum
    [~,IXD_min]=min(dist);
    num_pt_ref=liste_num(IXD_min(1));
    liste_num(IXD_min(1))=[];
    
    %nouveau point de reference
    pt_ref=tirages(num_pt_ref,:);
    tirages_trie(ii+1,:)=pt_ref;
end
end

%fonction assurant le tri de pts en pts avec pt initial choisi parmi les
%points existant (exist) ou a partir dun point donne (don) en 'tournant'
%autour du point initial (par pris en compte du barycentre des sites)
function tirages_trie=barypt(tirages,lnorm,info_pt,type,doe)
%parametre distance barycentre
dbary=0.5;
%nombre de points et variables
[nb_val,nb_var]=size(tirages);
tirages_trie=zeros(nb_val,nb_var);
%liste des numeros de points
liste_num=1:nb_val;
%en fonction du type de pt initial
switch type
    case 'exist'
        %a partir dun point existant
        num_pt_ref=info_pt;
        pt_ref=tirages(num_pt_ref,:);
        pt_init=pt_ref;
        tirages_trie(1,:)=pt_ref;
        liste_num(num_pt_ref)=[];
        debutfor=1;
    case 'don'
        %a partir d'un point donne
        pt_ref=info_pt;
        pt_init=pt_ref;
        debutfor=0;
end
%pour normer les coordonnees
xnorm=doe.Xmax(:)'-doe.Xmin(:)';
%on trie
for ii=debutfor:nb_val-1
    %on calcule la distance du point considere aux points
    %restants
    xdiff=pt_ref(ones(1,nb_val-ii),:)-tirages(liste_num,:);
    xdiff=xdiff./xnorm(ones(1,nb_val-ii),:);
    dist=normp(xdiff,lnorm);
    %on cherche le minimum
    [~,IXD_min]=min(dist);
    num_pt_add=liste_num(IXD_min(1));
    liste_num(IXD_min(1))=[];
    
    %ajout du pt au tirage
    tirages_trie(ii+1,:)=tirages(num_pt_add,:);
    
    %calcul du nouveau point de reference par calcul du barycentre des
    %points deja balaye
    nb_pts=ii+1;
    bary=1/nb_pts*sum(tirages_trie(1:nb_pts,:),1);
    pt_ref=pt_init+dbary*(bary-pt_init);
end
end