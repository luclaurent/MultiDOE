%% Computation of the score associated to a sampling
% L. LAURENT -- 19/12/2012 -- luc.laurent@lecnam.net

function [uniform,discrepancy]=calcScore(sampling,q)

% norme use for computing the distance
if nargin==1
    q=2;
end

%number of points and variables
ns=size(sampling,1);
np=size(sampling,2);

%the sampling is reduced to the unit hypercube (space [0,1]^d)
minSampling=min(sampling);
maxSampling=max(sampling);
p=1./(maxSampling-minSampling);
c=-minSampling.*p;
samplingN=sampling.*repmat(p,ns,1)+repmat(c,ns,1);

% Compute inter-sample points distance + multiplicity(see Forrester,Sobester&Keane
% 2008)
[distM,distV,distU,pairS]=calcDist(sampling,q);
%meme calculs sur les valeurs normees
[distNM,distNV,distNU,paireNS]=calcDist(samplingN,q);

%remove diagonals
distM(logical(eye(ns)))=NaN;
distNM(logical(eye(ns)))=NaN;
%% with raw data
%minimal distance of each sample points
minDistPt=min(distM);
%average minimal distance 
minDistAvg=mean(minDistPt);
%minimal distance
uniform.minDist=distU(1);
%sum of the inverse of the distances (see Leary et al. 2004)
uniform.sumDist=sum(1./distU(:).^2);
%%criteria for the PhD thesis of Jessica FRANCO 2008
%average minimal distance 
uniform.avgMinDist=minDistAvg;
%%
%£ with normalized data
%minimal distance of each sample points
minDistPtN=min(distNM);
%average minimal distance
minDistAvg=mean(minDistPtN);
%minimal distance (maximin)
uniform.minDistN=distNU(1);
%sum of the inverse of the distances (see Leary et al. 2004)
uniform.sumDistN=sum(1./distNU(:).^2);
%%criteria for the PhD thesis of Jessica FRANCO 2008
%measure of the covering/uniformity
uniform.cover=1/minDistAvg*...
    (1/ns*sum(minDistPtN-minDistAvg)^2)^.5;
%ratio of the distances
uniform.distRatio=distNU(end)/distNU(1);
%average minimal distance 
uniform.avgMinDistN=minDistAvg;

%criteria from Morris & Mitechll 1995
uniform.morris=sum(pairS.*distU.^(-q))^(1/q);
uniform.morrisN=sum(paireNS.*distNU.^(-q))^(1/q);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Discrepancy
%(formulas from Fang et al., Uniform Design: Theory and Application
%2000 & and from Jessica Franco)

if nargout>=2
    %value in [0,1]^d
    sampling=samplingN;
    %initialize
    samplingM=reshape(sampling,ns,1,np);
    samplingM=repmat(samplingM,[1 ns 1]);
    ind=[2 1 3];
    samplingMB=permute(samplingM,ind);
    samplingMC=samplingM-0.5;
    samplingMBC=samplingMB-0.5;
    
    % L2-discrepancy
    part1=prod(1-sampling.^2,2);
    maxSampling=max(samplingM,samplingMB);
    prodm=prod(1-maxSampling,3);
    part2=sum(prodm(:));
    %     part2=0;
    %     for ii=1:nb_val
    %         for jj=1:nb_val
    %             tmp=1;
    %             for ll=1:nb_var
    %                 tmp=tmp*(1-max(tirages(ii,ll),tirages(jj,ll)));
    %             end
    %             part2=part2+tmp;
    %         end
    %     end
    
    discrepancy.L2=3^(-np)-...
        2^(1-np)/ns*sum(part1)...
        +1/ns*part2;
    
    % Centered L2-discrepancy
    part1=prod(1+0.5*abs(sampling-0.5)-0.5*(sampling-0.5).^2,2);
    opt=1+0.5*abs(samplingMC)+0.5*abs(samplingMBC);
    prodm=prod(opt,3);
    part2=sum(prodm(:));
    %     part2=0;
    %     for ii=1:nb_val
    %         for jj=1:nb_val
    %             tmp=1;
    %             for ll=1:nb_var
    %                 tmp=tmp*(1+0.5*abs(tirages(ii,ll)-0.5)+...
    %                     0.5*abs(tirages(jj,ll)-0.5));
    %             end
    %             part2=part2+tmp;
    %         end
    %     end
    
    
    discrepancy.CL2=(13/12)^np-2/ns*sum(part1)+...
        1/ns^2*part2;
    
    % Symetric L2-discrepancy
    part1=prod(1+2*sampling-2*sampling.^2,2);
    opt=1+0.5*abs(samplingMC)+0.5*abs(samplingMBC)-...
        0.5*abs(samplingMC-samplingMBC);
    prodm=prod(opt,3);
    part2=sum(prodm(:));
    %     part2=0;
    %     for ii=1:nb_val
    %         for jj=1:nb_val
    %             tmp=1;
    %             for ll=1:nb_var
    %                 tmp=tmp*(1+0.5*abs(tirages(ii,ll)-0.5)+...
    %                     0.5*abs(tirages(jj,ll)-0.5)-...
    %                     0.5*abs(tirages(ii,ll)-tirages(jj,ll)));
    %             end
    %             part2=part2+tmp;
    %         end
    %     end
    
    discrepancy.SL2=(4/3)^np-...
        2/ns*sum(part1)+...
        2^np/ns^2*part2;
    
    % Modified L2-discrepancy
    part1=prod(3-sampling.^2,2);
    opt=1-abs(samplingM-samplingMB);
    prodm=prod(opt,3);
    part2=sum(prodm(:));
    %     part2=0;
    %     for ii=1:nb_val
    %         for jj=1:nb_val
    %             tmp=1;
    %             for ll=1:nb_var
    %                 tmp=tmp*(1-abs(tirages(ii,ll)-tirages(jj,ll)));
    %             end
    %             part2=part2+tmp;
    %         end
    %     end
    discrepancy.ML2=(4/3)^np-...
        2^(1-np)/ns*sum(part1)+...
        1/ns^2*part2;
    
    % wrap around L2-discrepancy
    part1=abs(samplingM-samplingMB);
    opt=3/2-part1.*(1-part1);
    prodm=prod(opt,3);
    part2=sum(prodm(:));
    discrepancy.WL2=ns*(-(4/3)^np+...
        1/ns^2*part2);
    
    
end
