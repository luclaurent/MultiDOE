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
% sources available here:
% https://bitbucket.org/luclaurent/multidoe/
% https://github.com/luclaurent/multidoe/
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


Mfprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n');
Mfprintf('    >>> BUILDING SAMPLING <<<\n');
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
Mfprintf(' >> Kind of DOE: %s\n',type);
Mfprintf(' >> Number of sample points: ');
fprintf('%i ',ns);fprintf('\n');
Mfprintf(' >> Number of variables: %i\n',np);

samplingOK=false;
customSampling=false;

%%check if manual option is requested
flagManu=false;
if numel(type)>3
    strManu=type(end-3:end);
else
    strManu='';
end
%
if strcmp(strManu,'manu')
    flagManu=true;
    type=type(1:end-5);
    %recover sampling if available
    [sampling,saveFile]=checkDOE(type,np,ns);
    samplingOK=~isempty(sampling);
end


if ~samplingOK
    samplingOK=true;
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
            % Optimal Latin Hypercube Sampling with R (and initial enrichment)
        case 'OLHS_R'
            sampling=olhsR(XminDef,XmaxDef,prod(ns(:)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Maximin Latin Hypercube Sampling with R (and initial enrichment)
        case 'MMLHS_R'
            sampling=mmlhsR(XminDef,XmaxDef,prod(ns(:)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Genetic  Latin Hypercube Sampling with R (and initial enrichment)
        case 'GLHS_R'
            sampling=glhsR(XminDef,XmaxDef,prod(ns(:)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Improved Hypercube Sampling avec R (et preenrichissement)
        case 'IHS_R'
            sampling=ihsR(XminDef,XmaxDef,prod(ns(:)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Sampling using Halton sequence (Matlab's function)
        case 'HALTON'
            p = haltonset(np,'Skip',1e3,'Leap',1e2);
            p = scramble(p,'RR2');
            sampling=net(p,prod(ns(:)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Sampling using Sobol sequence (Matlab's function)
        case 'SOBOL'
            p = sobolset(np,'Skip',1e3,'Leap',1e2);
            p = scramble(p,'MatousekAffineOwen');
            sampling=net(p,prod(ns(:)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Latin Hypercube Sampling (Matlab's function)
        case 'LHSD'
            sampling=lhsdesign(prod(ns(:)),np,'iterations',nbIter);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Latin Hypercube Sampling (Matlab's function) with minimization of the correlation (see help)
        case 'LHSD_CORRMIN'
            sampling=lhsdesign(prod(ns(:)),np,'criterion','correlation','iterations',nbIter);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Latin Hypercube Sampling (Matlab's function) with maximin (see help)
        case 'LHSD_MAXMIN'
            sampling=lhsdesign(prod(ns(:)),np,'criterion','maximin','iterations',nbIter);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Latin Hypercube Sampling (Matlab's function) with Non-smooth (see help)
        case 'LHSD_NS'
            sampling=lhsdesign(prod(ns(:)),np,'smooth','off','iterations',nbIter);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Latin Hypercube Sampling (with uniform law)
        case 'LHS'
            sampling=lhsu(XminDef,XmaxDef,prod(ns(:)));
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Improved Hypercube Sampling
        case 'IHS'
            sampling=ihs(np,ns,5);
            sampling=sampling./ns;
            sampling=sampling';
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
            [sampling,saveFile]=checkDOE('lhs_o1',np,ns);
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
                save(saveFile,'sampling');
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % random sampling
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
            Mfprintf(['Undefined DOE method ' type ' (see ',mfilename,')']);
            samplingOK=false;
    end
end

%save sampling
if flagManu&&samplingOK
    save(saveFile,'sampling');
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
Mfprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n');
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
    Mfprintf(' !! Sampling does not exist \n');
    sampling=[];
end
end
