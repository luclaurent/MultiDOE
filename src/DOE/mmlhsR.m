%% Build DOE using R (optimized LHS with initial sampling and enrichment)
%% LHS maximin
%Refs: Beachkofski, B., Grandhi, R. (2002) Improved Distributed Hypercube Sampling American Institute of Aeronautics and Astronautics Paper 1274.
% L. LAURENT -- 02/01/2013 -- luc.laurent@lecnam.net



function [sampling,newSampling]=mmlhsR(Xmin,Xmax,ns,oldsampling,nbInfill)

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
folderStore='LHS_R';
%number of initial sampling
nbInitSampling=0;
%name of the R script file
nameScript='mmlhs_R_';
extScript='.r';
%name of the R data file
nameDataR='dataR_';
extDataR='.dat';
%pause time after executing R
timePause=0;

%number of permutations "Columnwise Pairwise"
nbPerm=numel(Xmin);
%stoping criterion
critStop=1e-2;

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
        cmd=['mkdir ' folderStore];
        unix(cmd);
    end
    
    %%write R script
    textInit=['a<-maximinLHS(' num2str(ns) ',' num2str(np) ','...
        num2str(nbPerm) ',' num2str(critStop) ')\n'];
    %procedure d'enrichissement
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
        error('R non installe (absent du PATH)');
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
    nsOld=size(oldsampling,1);
    %read data file
    A=load([folderStore '/' nameDataR]);
    %new sampling
    ind=nsOld+1:nsOld+nbInfill;
    newSampling=A(ind,:).*repmat(Xmax(:)'-Xmin(:)',nbInfill,1)+repmat(Xmin(:)',nbInfill,1);
    %all sample points
    sampling=[oldsampling;newSampling];
end
end
