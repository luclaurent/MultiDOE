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

%% Build DOE using R (optimized LHS with initial sampling and enrichment)
%% LHS S-optimal (using Genetic algorithm)
%Refs:  - Stocki, R. (2005) A method to improve design reliability using optimal Latin hypercube sampling Computer Assisted Mechanics and Engineering Sciences 12, 87?105.
%       -Stein, M. (1987) Large Sample Properties of Simulations Using Latin Hypercube Sampling. Technometrics. 29, 143?151.
% L. LAURENT -- 02/01/2013 -- luc.laurent@lecnam.net



function [sampling,newSampling]=glhsR(Xmin,Xmax,ns,oldSampling,nbInfill)

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
%number of initial sampling
nbInitSampling=0;
%name of the R script file
nameScript='glhs_R_';
extScript='.r';
%name of the R data file
nameDataR='dataR';
extDataR='.dat';
%pause time after executing R
timePause=0;

%options genetic algorithm
%initial population
initPop=100;
%nb of mutations
nbMut=5;
%probability of mutation
probMut=0.25;

%building DOE
if nargin==3
    
    % load dimensions (number of variables and sample points)
    np=numel(Xmin);
    %full name of the R script file
    nameScript=[nameScript num2str(np) '_' num2str(ns) extScript];
    %full name of the R data file
    nameDataR=[nameDataR num2str(np) '_' num2str(ns) extDataR];
    
    %create storing folder if not existing
    if exist(folderStore,'dir')~=7
        mkdir(folderStore);
    end
    
    %%write R script
    textInit=['a<-geneticLHS(' num2str(ns) ',' num2str(np) ','...
        num2str(initPop) ',' num2str(nbMut) ',' num2str(probMut) ')\n'];
    %infill procedure
    textInfill=['a<-optAugmentLHS(a,1,4)\n'];
    %load LHS library
    loadLHS='library(lhs)\n';
    %store sampling
    storeSampling=['write.table(a,file="' nameDataR '",row.names=FALSE,col.names=FALSE)'];
    
    %create and open script file
    fid=fopen([folderStore '/' nameScript],'w','n','UTF-8');
    %write loading of the library
    fprintf(fid,loadLHS);
    %write initial sampling execution
    fprintf(fid,textInit);
    %write enrichment
    for ii=1:nbInitSampling
        fprintf(fid,textInfill);
    end
    %write storage procedure
    fprintf(fid,storeSampling);
    %close file
    fclose(fid);
    %%execute R (R must be installed)
    %check if available
    [e,~]=unix('which R');
    if e~=0
        error('R is not installed (not in the PATH)');
    else
        [~,~]=unix(['cd ' folderStore ' && R -f ' nameScript]);
        pause(timePause)
    end
    %read data file
    A=load([folderStore '/' nameDataR]);
    %obtained sampling
    sampling=A(1:ns,:).*repmat(Xmax(:)'-Xmin(:)',ns,1)+repmat(Xmin(:)',ns,1);
    newSampling=[];
    
    %enrichment procedure
elseif nargin==5
    
    %number of sample points in the initial sampling
    nsOld=size(oldSampling,1);
    
    %read data file
    A=load([folderStore '/' nameDataR]);
    
    %new sampling
    ind=nsOld+1:nsOld+nbInfill;
    newSampling=A(ind,:).*repmat(Xmax(:)'-Xmin(:)',nbInfill,1)+repmat(Xmin(:)',nbInfill,1);
    %all sample points
    sampling=[oldSampling;newSampling];
    
end
end
