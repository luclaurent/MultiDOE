%     MultiDOE - Toolbox for sampling a bounded space
%     Copyright (C) 2016  Luc LAURENT <luc.laurent@lecnam.net>
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <http://www.gnu.org/licenses/>.
%     

%% Build DOE using R (IHS with)
% IHS: Improved Hypercube Sampling
% Ref: Beachkofski, B., Grandhi, R. (2002) Improved Distributed Hypercube Sampling American Institute of Aeronautics and Astronautics Paper 1274.
% L. LAURENT -- 14/01/2012 -- luc.laurent@lecnam.net


function [sampling,newSampling]=ihsR(Xmin,Xmax,ns,oldSampling)

%% INPUT:
%    - Xmin,Xmax: min and max bounds of the design space
%    - ns: number of required sampled points
%    - oldSampling: old sampling (for enrichment)
%% OUTPUT
%   - sampling: sample points
%   - newSampling: new sample points provided byy enrichment
%%

%path declaration for R software
setenv('DYLD_LIBRARY_PATH','/usr/local/bin/');

%%initialize options
% storing directory
folderStore='tmpDOE/IHS_R';
%name of the R script file
nameScript='ihs_R_';
extScript='.r';
%name of the R data file
nameDataR='dataR_';
nomDataM=nameDataR;
extDataR='.dat';
extDataM='.mat';
%pause time after executing R
timePause=0;

if nargin==4
    nsOld=size(oldSampling,1);
else
    nsOld=1;
end

% load dimensions (number of variables and sample points)
np=numel(Xmin);
%full name of the R script file
nameScript=[nameScript num2str(np) '_' num2str(ns+nsOld) extScript];
%full name of the R data file
nameDataR=[nameDataR num2str(np) '_' num2str(ns+nsOld) extDataR];
%full name of the R mat file
nomDataM=[nomDataM num2str(np) '_' num2str(ns+nsOld) extDataM];
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
    textInit=['a<-improvedLHS(' num2str(ns) ',' num2str(np) ')\n'];
    %create and open script file
    fid=fopen([folderStore '/' nameScript],'w','n','UTF-8');
    %write loading of the library
    fprintf(fid,loadLHS);
    %write initial sampling execution
    fprintf(fid,textInit);
    %write storage procedure
    fprintf(fid,storeSampling);
    %close file
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
    textInfill=sprintf('a<-augmentLHS(a,%i)\n',ns);
    %create and open script file
    fid=fopen([folderStore '/' nameScript],'w','n','UTF-8');
    %write loading of libraries
    fprintf(fid,loadLHS);
    fprintf(fid,loadRmat);
    %write procedure for loading old sampling
    fprintf(fid,textReLoad);
    %write enrichment
    fprintf(fid,textInfill);
    %write storage procedure
    fprintf(fid,storeSampling);
end

%%execute R script (R must be installed)
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
sampling=renormSampling(A,Xmin,Xmax);
%new sampling
newSampling=sampling(nsOld:end,:);
end

%function for normalization and renormalization of the sampling
function samplingN=normSampling(sampling,Xmin,Xmax)
nbs=size(sampling,1);
samplingN=(sampling-repmat(Xmin(:)',nbs,1))./repmat(Xmax(:)'-Xmin(:)',nbs,1);
end

function samplingRN=renormSampling(sampling,Xmin,Xmax)
nbs=size(sampling,1);
samplingRN=sampling.*repmat(Xmax(:)'-Xmin(:)',nbs,1)+repmat(Xmin(:)',nbs,1);
end
