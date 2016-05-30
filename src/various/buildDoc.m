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

%% Build documentation (using m2html library)
% L. LAURENT -- 07/02/2014 -- luc.laurent@lecnam.net

%load paths
dirPath=initDirMultiDOE;

%% Build documentation

%add configurtation to bash (for finding 'dot' script of graphviz)
setenv('BASH_ENV','~/.bash_profile');

%directory to be analysed
analyseDir='MultiDOE';
%ignoring directory
%ignDir={'};

%list of files
listFiles=listFilesToolbox(dirPath);
%add path to all files
listFiles=cellfun(@(x) sprintf('%s/%s',analyseDir,x),listFiles,'UniformOutput',false);

cd ..
%execute generation of the doc (Graphviz is optional)
m2html('mfiles',listFiles,...
    'htmldir',[analyseDir '/doc'],...
    'recursive','on',...
    'global','on',...
    'globalHypertextLinks','on',...
    'index','menu',...
    'template','frame',...
    'index','menu',...
    'download','off',...
    'graph','on')
cd(analyseDir)
%%%%%%
