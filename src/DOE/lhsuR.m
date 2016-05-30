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

%% Build DOE using R (LHS with initial sampling and enrichment)
% L. LAURENT -- 14/01/2012 -- luc.laurent@lecnam.net


function [sampling,newSampling]=lhsuR(Xmin,Xmax,ns,oldSampling)

%% INPUT:
%    - Xmin,Xmax: min and max bounds of the design space
%    - ns: number of required sampled points
%    - oldSampling: old sampling (for enrichment)
%    - nbInfill: number of new required sample point (enrichment)
%% OUTPUT
%   - sampling: sample points
%   - newSampling: new sample points provided byy enrichment
%%

%path declaration for R software
setenv('DYLD_LIBRARY_PATH','/usr/local/bin/');

%%initialize options
% storing directory
folderStore='tmpDOE/LHS_R';
%name of the R script file
nameScript='lhsu_R_';
extScript='.r';
%name of the R data file
nameDataR='dataR_';
nameDataM=nameDataR;
extDataR='.dat';
extDataM='.mat';
%pause time after executing R
timePause=0;

if nargin==4
    nb_old=size(oldSampling,1);
else
    nb_old=1;
end

% load dimensions (number of variables and sample points)
np=numel(Xmin);
%full name of the R script file
nameScript=[nameScript num2str(np) '_' num2str(ns+nb_old) extScript];
%full name of the R data file
nameDataR=[nameDataR num2str(np) '_' num2str(ns+nb_old) extDataR];
%full name of the R mat file
nameDataM=[nameDataM num2str(np) '_' num2str(ns+nb_old) extDataM];
%load LHS library
loadLHS='library(lhs)\n';
%load R.matlab library
loadRmat='library(R.matlab)\n';
%store sampling
storeSampling=['write.table(a,file="' nameDataR '",row.names=FALSE,col.names=FALSE)\n'];

%building DOE
if nargin==3
    %create storing folder if not existing
    if exist(folderStore,'dir')~=7
        mkdir(folderStore);
    end
    
    %%write R script
    textInit=['a<-randomLHS(' num2str(ns) ',' num2str(np) ')\n'];
    %create and open script file
    fid=fopen([folderStore '/' nameScript],'w','n','UTF-8');
    %write loading of the library
    fprintf(fid,loadLHS);
    %write initial sampling execution
    fprintf(fid,textInit);
    %write storage procedure
    fprintf(fid,storeSampling);
    %cole file
    fclose(fid);
    
    %enrichment procedure
elseif nargin==4
    %normalisation of the old sampling
    OldSamplingN=normSampling(oldSampling,Xmin,Xmax);
    %write .mat file of the old sampling
    save([folderStore '/' nameDataM],varname(OldSamplingN));
    %reload old sampling
    text_charg=sprintf('a<-readMat(''%s'')\n a<-a$%s\n',nameDataM,varname(OldSamplingN));
    %write enrichment procedure
    text_enrich=sprintf('a<-augmentLHS(a,%i)\n',ns);
    %create and open script file
    fid=fopen([folderStore '/' nameScript],'w','n','UTF-8');
    %write loading of libraries
    fprintf(fid,loadLHS);
    fprintf(fid,loadRmat);
    %write procedure for loading old sampling
    fprintf(fid,text_charg);
    %write enrichment
    fprintf(fid,text_enrich);
    %write storage procedure
    fprintf(fid,storeSampling);
end

%%execute R script (R must be installed)
%check if available
[e,~]=unix('which R');
if e~=0
    error('R non installe (absent du PATH)');
else
    [~,~]=unix(['cd ' folderStore ' && R -f ' nameScript]);
    pause(timePause)
end
%read data file
A=load([folderStore '/' nameDataR]);
%tirage obtenu
sampling=denorm_tir(A,Xmin,Xmax);
%new sampling
newSampling=sampling(nb_old:end,:);
end

%function for normalization and renormalization of the sampling
function samplingN=normSampling(sampling,Xmin,Xmax)
nbs=size(sampling,1);
samplingN=(sampling-repmat(Xmin(:)',nbs,1))./repmat(Xmax(:)'-Xmin(:)',nbs,1);
end

function samplingRN=denorm_tir(sampling,Xmin,Xmax)
nbs=size(sampling,1);
samplingRN=sampling.*repmat(Xmax(:)'-Xmin(:)',nbs,1)+repmat(Xmin(:)',nbs,1);
end

%name of the variable to a string
function out = varname(var)
out = inputname(1);
end
