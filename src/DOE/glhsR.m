%% Build DOE using R (LHS with initial sampling and enrichment)
%% LHS S-optimal (genere en utilisant un algo genetique)
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
% storign directory
folderStore='LHS_R';
%number of initial sampling
nbInitSampling=0;
%name of the R script file
nameScript='glhs_R_';
extScript='.r';
%name of the R data file
namedataR='dataR';
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
    %full name of the R sciprt file
    nameScript=[nameScript num2str(np) '_' num2str(ns) extScript];
    %fulle name of the R data file
    namedataR=[namedataR num2str(np) '_' num2str(ns) extDataR];
    
    %create storing folder if not existing
    if exist(folderStore,'dir')~=7
        cmd=['mkdir ' folderStore];
        unix(cmd);
    end
    
    %%write R script
    textInit=['a<-geneticLHS(' num2str(ns) ',' num2str(np) ','...
        num2str(initPop) ',' num2str(nbMut) ',' num2str(probMut) ')\n'];
    %infill process
    textInfill=['a<-optAugmentLHS(a,1,4)\n'];
    %load LHs library
    loadLHS='library(lhs)\n';
    %store sampling
    stock_tir=['write.table(a,file="' namedataR '",row.names=FALSE,col.names=FALSE)'];
    
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
    fprintf(fid,stock_tir);
    %close file
    fclose(fid);
    %%execute R (R must be installed)
    %check if avilable
    [e,t]=unix('which R');
    if e~=0
        error('R is not installed (not in the PATH)');
    else
        [~,t]=unix(['cd ' folderStore ' && R -f ' nameScript]);
        pause(timePause)
    end
    %read data file
    A=load([folderStore '/' namedataR]);
    %obtained sampling
    sampling=A(1:ns,:).*repmat(Xmax(:)'-Xmin(:)',ns,1)+repmat(Xmin(:)',ns,1);
    newSampling=[];
    
    %enricmehtn procedure
elseif nargin==5
    
    %number of sample points in the initial sampling
    nsOld=size(oldSampling,1);
    
    %read data file
    A=load([folderStore '/' namedataR]);
    
    %new sampling
    ind=nsOld+1:nsOld+nbInfill;
    newSampling=A(ind,:).*repmat(Xmax(:)'-Xmin(:)',nbInfill,1)+repmat(Xmin(:)',nbInfill,1);
    %all sample points
    sampling=[oldSampling;newSampling];
    
end
end
