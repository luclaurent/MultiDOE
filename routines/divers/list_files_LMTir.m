%% Listage des fichiers de la Toolbox LMTir
%% L. LAURENT -- 07/02/2014 -- laurent@lmt.ens-cachan.fr


%% A executer depuis la racine de la toolbox


function list=list_files_LMTir(dossier)
list={};
%parcours des dossiers listes dans la variable dossier
for ii=1:numel(dossier)
    %identification fichiers du dossier
    filedoss=list_file_doss(dossier{ii});
    %ajout nom dossier
    fun=@(x) sprintf('%s/%s',dossier{ii},x);
    filedoss_ok=cellfun(fun,filedoss,'UniformOutput',false);
    %ajout a la liste complete
    list={list{:},filedoss_ok{:}};
end
%ajout de la racine de la toolbox
filedoss_ok=list_file_doss('.');
%ajout a la liste complete
list={list{:},filedoss_ok{:}};


%on nettoye des fichiers a ne pas prendre en comtpe
blacklist={'.git',char(126),'m2html','.DS_Store'};

for jj=1:numel(blacklist)
    %motif a verifier
    verif=blacklist{jj};
    %recherche du motif
    kk=strfind(list,verif);
    
    if ~isempty(kk)
        %motif absent
        hh=cellfun(@isempty,kk);
        %retrait de la liste
        IX=find(hh);
        list={list{IX}};
    end
end
end

% listage fichier d'un dossier et identification fichiers
function [filedossier]=list_file_doss(doss)
%liste brute
list_brut=dir(doss);
%flag file
flag_file=~[list_brut.isdir];
%liste fichiers du dossier
filedossier={list_brut(flag_file).name};
end