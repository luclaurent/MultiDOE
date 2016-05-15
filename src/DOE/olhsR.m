%% Build DOE using R (optimized LHS with initial sampling and enrichment)
%% LHS S-optimal (obtained with permutation of the columns)
%Refs: Stocki, R. (2005) A method to improve design reliability using optimal Latin hypercube sampling Computer Assisted Mechanics and Engineering Sciences 12, 87?105.
% L. LAURENT -- 02/01/2013 -- luc.laurent@lecnam.net



function [sampling,newSampling]=olhsR(Xmin,Xmax,ns,oldSampling,nbInfill)

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
nameScript='olhs_R_';
extScript='.r';
%name of the R data file
nameDataR='dataR_';
extDataR='.dat';
%pause time after executing R
timePause=0;
%number of permuations "Columnwise Pairwise"
nbPerm=numel(Xmin);
%stoping criterion
critStop=1e-2;

%building DOE
if nargin==3
    
    % load dimensions (number of variables and sample points)
    np=numel(Xmin);
    %full name of the R script file
    nameScript=[nameScript num2str(np) '_' num2str(ns) extScript];
    %fulle name of the R data file
    nameDataR=[nameDataR num2str(np) '_' num2str(ns) extDataR];
    
    create storing folder if not existing
    if exist(folderStore,'dir')~=7
        cmd=['mkdir ' folderStore];
        unix(cmd);
    end
    
    %%write R script
    textInit=['a<-optimumLHS(' num2str(nbs) ',' num2str(np) ','...
        num2str(nbPerm) ',' num2str(critStop) ')\n'];
    %infill procedure
    texttextInfill_enrich=['a<-optAugmentLHS(a,1,4)\n'];
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
        fprintf(fid,texttextInfill_enrich);
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
    sampling=A(1:nbs,:).*repmat(Xmax(:)'-Xmin(:)',nbs,1)+repmat(Xmin(:)',nbs,1);
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