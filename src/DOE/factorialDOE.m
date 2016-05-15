%% Fonction assurant la generation d'un plan factoriel en dimension n
% L. LAURENT -- 07/10/2011 -- luc.laurent@lecnam.net

function tir=factorial_design(nb_tir,Xmin,Xmax)


%nombre de variables prises en consideration
nb_var=numel(Xmin);
%reconditionnement
if length(nb_tir)==1
    nb_tir=nb_tir*ones(1,nb_var);
elseif length(nb_tir)~=1&&length(nb_tir)~=nb_var
    error('mauvaise definition nb de tirages pour plan factoriel (cf. factorial_design.m)');
end

%initialisation matrice stockage tirages
nb_tir_tot=prod(nb_tir);
tir=zeros(nb_tir_tot,nb_var);

%valeurs pour chaques variables
val_var=cell(nb_var,1);
for ii=1:nb_var
    val_var{ii}=linspace(Xmin(ii),Xmax(ii),nb_tir(ii));
end

% generation de la matrice des tirages
% parcours des variables
temp1=[];
for ii=1:nb_var
    if ii>1
        nb_ter_pre=prod(nb_tir(1:ii-1));
    else
        nb_ter_pre=1;
    end
    %parcours des valeurs par variables
    for jj=1:length(val_var{ii})
        temp=repmat(val_var{ii}(jj),nb_ter_pre,1);
        temp1=[temp1;temp];
    end
    temp2=repmat(temp1,prod(nb_tir(ii+1:end)),1);
    temp1=[];
    tir(:,ii)=temp2;
end

