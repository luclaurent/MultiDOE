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
folderStore='LHS_R';
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
        cmd=['mkdir ' folderStore];
        unix(cmd);
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
    fprintf(fid,stock_tir);
    %cole file
    fclose(fid);
    
    %enrichment procedure
elseif nargin==4
    %normalisation of the old sampling
    OldSamplingN=normSampling(oldSampling,Xmin,Xmax);
    %write .mat file of the old sampling
    save([folderStore '/' nameDataM],'OldSamplingN');
    %reload old sampling
    text_charg=sprintf('a<-readMat(''%s'')\n a<-a$nold.tir\n',nameDataM);
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
    fprintf(fid,stock_tir);
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
