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

%% List all files of the GRENAT Toolbox
% L. LAURENT -- 07/02/2014 -- luc.laurent@lecnam.net


% To be executed at the root position of the toolbox


function listF=listFilesToolbox(dirT)
listF={};
%process all directories in the directory 'dirT'
for ii=1:numel(dirT)
    %find files in directories
    fileDir=listFileDir(dirT{ii});
    %add name of the directory
    fun=@(x) sprintf('%s/%s',dirT{ii},x);
    fileDirOk=cellfun(fun,fileDir,'UniformOutput',false);
    %add to the whole list
    listF={listF{:},fileDirOk{:}};
end
%add the root directory of the Toolbox
fileDirOk=listFileDir('.');
%add to the whole list
listF={listF{:},fileDirOk{:}};


%Files to avoid
blacklist={'.git',char(126),'m2html','.DS_Store',...
    'lightspeed','mmx','mtimesx','Multiprod',...
    'sqplab-0.4.5-distrib','toolbox','PSOt',...
    'base_monomes'};

for jj=1:numel(blacklist)
    %pattern to check
    checkF=blacklist{jj};
    %seek the pattern
    kk=strfind(listF,checkF);
    if ~isempty(kk)
        %missing pattern
        hh=cellfun(@isempty,kk);
        %remove from the list
        IX=find(hh);
        listF={listF{IX}};
    end
end
%manually addition
listF{end+1}='src/libs/PSOt/pso_Trelea_mod.m';
end


% list files in a directory 
function [filDir]=listFileDir(dirM)
%rawlist
rawList=dir(dirM);
%flag file
flag_file=~[rawList.isdir];
%list of files in the directory
filDir={rawList(flag_file).name};
end