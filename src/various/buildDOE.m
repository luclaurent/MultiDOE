%% Building sampling
% L. LAURENT -- 17/12/2010 -- luc.laurent@lecnam.net
%
%Some criteria require the Matlab's toolbox "Random Numbers Generators" or
%the R software
%
%All sampling techniques provide sample points with values between 0 and 1.
%The convertion to the right space is done at the end of this file.
%
%% Syntax: gene_doe(doe)
%% INPUT variables:
% - type: Kind of DOE (doe.type): see the switch command below
% - ns: number of sample points
% - Xmin: lower bound of the design space
% - Xmax: upper bound of the design space
%   + All methods containing the string '_R' require the R software
%   (installed on the computer and accessible using the command line).
%   Libraries 'lhs' and 'R.matlab' must be installed on R
%   + All methods containing the string '_MANU' are saved sampling (they
%   are built one time are are reloaded from a .mat file)
%
%% OUTPUT variables
% - sampling: contains the sampling

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

function [sampling]=buildDOE(type,ns,Xmin,Xmax,opts)


fprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n')
fprintf('    >>> BUILDING SAMPLING <<<\n');
TimeCount=mesuTime;

% For obtaining an "actual" pseudo-random sampling
s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);

%recovering number of iteration if specified
if nargin>=5
    if isfield(opts,'iter');nbIter=opts.iter;else nbIter=5;end
else
    nbIter=5;
end

%number of generation for computing the scores
nbGene=20;

%default values
XminDef=0.*Xmin;XmaxDef=0.*Xmax+1;

%number of variables
np=numel(Xmin);

%% Show information
fprintf(' >> Kind of DOE: %s\n',type);
fprintf(' >> Number of sample points: ')
fprintf('%i ',ns);fprintf('\n');
fprintf(' >> Number of variables: %i\n',np);

samplingOK=true;
customSampling=false;
%depending on the chosen DOE technique
switch type
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % full factorial
    case 'ffact'        
        sampling=fullFactDOE(ns,XminDef,XmaxDef);
        if numel(ns)==1
            ns=ns^np;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Latin Hypercube Sampling with R (and initial enrichment)
    case 'LHS_R'
        sampling=lhsuR(XminDef,XmaxDef,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'LHS_R_manu'
        %recover sampling if available
        [sampling,fich]=checkDOE('lhsuR',np,ns);
        if isempty(sampling)
            sampling=lhsuR(XminDef,XmaxDef,prod(ns(:))); 
            save(fich,'sampling');
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Optimal Latin Hypercube Sampling with R (and initial enrichment)
    case 'OLHS_R'
        sampling=olhsR(XminDef,XmaxDef,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'OLHS_R_manu'
        %recover sampling if available
        [sampling,fich]=checkDOE('olhsR',np,ns);
        if isempty(sampling)
            sampling=olhsR(XminDef,XmaxDef,prod(ns(:)));
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Maximin Latin Hypercube Sampling with R (and initial enrichment)
    case 'MMLHS_R'
        sampling=mmlhsR(XminDef,XmaxDef,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'MMLHS_R_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('mmlhsR',np,ns);
        if isempty(sampling)
            sampling=mmlhsR(XminDef,XmaxDef,prod(ns(:))); 
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Genetic  Latin Hypercube Sampling with R (and initial enrichment)
    case 'GLHS_R'
        sampling=glhsR(XminDef,XmaxDef,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'GLHS_R_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('glhsR',np,ns);
        if isempty(sampling)
            sampling=glhsuR(XminDef,XmaxDef,prod(ns(:))); 
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Improved Hypercube Sampling avec R (et preenrichissement)
    case 'IHS_R'
        sampling=ihsR(XminDef,XmaxDef,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'IHS_R_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('ihsR',np,ns);
        if isempty(sampling)
            sampling=ihsR(XminDef,XmaxDef,prod(ns(:))); 
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Sampling using Halton sequence (Matlab's function)
    case 'HALTON'
        p = haltonset(np,'Skip',1e3,'Leap',1e2);
        p = scramble(p,'RR2');
        sampling=net(p,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Halton with storage of the data
    case 'HALTON_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('halton',np,ns);
        if isempty(sampling)
            p = haltonset(np,'Skip',1e3,'Leap',1e2);
            p = scramble(p,'RR2');
            sampling=net(p,prod(ns(:)));
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Sampling using Sobol sequence (Matlab's function)
    case 'SOBOL'
        p = sobolset(np,'Skip',1e3,'Leap',1e2);
        p = scramble(p,'MatousekAffineOwen');
        sampling=net(p,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Sobol with storage of the data
    case 'SOBOL_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('sobol',np,ns);
        if isempty(sampling)
            p = sobolset(np,'Skip',1e3,'Leap',1e2);
            p = scramble(p,'MatousekAffineOwen');
            sampling=net(p,prod(ns(:)));
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Latin Hypercube Sampling (Matlab's function)
    case 'LHSD'
        sampling=lhsdesign(prod(ns(:)),np,'iterations',nbIter);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LHS with storage of the data
    case 'LHSD_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('lhsd',np,ns);
        if isempty(sampling)
            sampling=lhsdesign(prod(ns(:)),np,'iterations',nbIter);
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Latin Hypercube Sampling (Matlab's function) with minimization of the correlation (see help)
    case 'LHSD_CORRMIN'
        sampling=lhsdesign(prod(ns(:)),np,'criterion','correlation','iterations',nbIter);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       % LHS with storage of the data
    case 'LHSD_CORRMIN_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('lhsdcorrmin',np,ns);
        if isempty(sampling)
            sampling=lhsdesign(prod(ns(:)),np,'criterion','correlation','iterations',nbIter);
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Latin Hypercube Sampling (Matlab's function) with maximin (see help)
    case 'LHSD_MAXMIN'
        sampling=lhsdesign(prod(ns(:)),np,'criterion','maximin','iterations',nbIter);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LHS with storage of the data
    case 'LHSD_MAXMIN_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('lhsdmaxmin',np,ns);
        if isempty(sampling)
            sampling=lhsdesign(prod(ns(:)),np,'criterion','maximin','iterations',nbIter);
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Latin Hypercube Sampling (Matlab's function) with Non-smooth (see help)
    case 'LHSD_NS'
        sampling=lhsdesign(prod(ns(:)),np,'smooth','off','iterations',nbIter);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LHS with storage of the data
    case 'LHSD_NS_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('lhsdns',np,ns);
        if isempty(sampling)
            sampling=lhsdesign(prod(ns(:)),np,'smooth','off','iterations',nbIter);
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Latin Hypercube Sampling (with uniform law)
    case 'LHS'
        sampling=lhsu(XminDef,XmaxDef,prod(ns(:)));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LHS with storage of the data
    case 'LHS_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('lhsu',np,ns);
        if isempty(sampling)
            sampling=lhsu(XminDef,XmaxDef,prod(ns(:)));
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Improved Hypercube Sampling
    case 'IHS'
        sampling=ihs(np,ns,5);
        sampling=sampling./ns;
        sampling=sampling';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'IHS_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('ihs',np,ns);
        if isempty(sampling)
            sampling=ihs(np,ns,5);
            sampling=sampling./ns;
            sampling=sampling';
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Latin Hypercube Sampling (with uniform law) with minimization of
        % distance of the inter-sample points
    case 'LHS_O1'
        samplingTMP=cell(1,nbGene);
        sc=zeros(1,nbGene);
        %nbGene sampling are generated
        for ii=1:nbGene
            samplingTMP{ii}=lhsu(XminDef,XmaxDef,prod(ns(:)));
            %compute score
            uni=calcScore(samplingTMP{ii});
            sc(ii)=uni.sumDist;
        end
        [~,IX]=min(sc);
        sampling=samplingTMP{IX};
        clear samplingTMP;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % LHS_O1 with storange of the data
    case 'LHS_O1_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('lhs_o1',np,ns);
        if isempty(sampling)
            samplingTMP=cell(1,nbGene);
            sc=zeros(1,nbGene);
            %nbGene sampling are generated
            for ii=1:nbGene
                samplingTMP{ii}=lhsu(XminDef,XmaxDef,prod(ns(:)));
                %compute score
                uni=calcScore(samplingTMP{ii});
                sc(ii)=uni.sumDist;
            end
            [~,IX]=min(sc);
            sampling=samplingTMP{IX};
            clear samplingTMP
            save(fich,'sampling');
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % randm sampling
    case 'rand'
        sampling=rand(prod(ns(:)),np);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %manually defined sampling
    case 'custom'
        sampling=opts.manu;
        customSampling=true;
        disp('/!\ Manual sampling (cf. initDOE.m)');
    otherwise
        error(['Undefined DOE methods (',mfilename,')']);
        samplingOK=false;
end

if samplingOK
    if ~customSampling
        % correction of the sampling for obtaining sampling defined on the
        % right design space
        sampling=sampling.*repmat(Xmax(:)'-Xmin(:)',prod(ns(:)),1)+repmat(Xmin(:)',prod(ns(:)),1);
    end   
else
    sampling=[];
end

TimeCount.stop;
fprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n')
end


%%function for checking if a sampling already exists
function [sampling,fich]=checkDOE(nameFile,np,ns)

%check if the storage folder exists
if exist('tmpDOE/TIR_MANU','dir')~=7
    mkdir('tmpDOE/TIR_MANU');
end

%if the sampling exists, it will be loaded
fi=['tmpDOE/TIR_MANU/' nameFile '_man_' num2str(np) '_'  num2str(ns)];
fich=[fi '.mat'];
if exist(fich,'file')==2
    st=load(fich);
    sampling=st.sampling;
else
    fprintf('Sampling does not exist \n');
    sampling=[];
end
end

