%% Building sampling
%% L. LAURENT -- 17/12/2010 -- luc.laurent@lecnam.net

%Some criteria require the Matlab's toolbox "Random Numbers Generators" or
%the R software

%All sampling techniques provide sample points with values between 0 and 1.
%The convertion to the right sapce is done at the end of this file.

%% Syntax: gene_doe(doe)
%% INPUT variables:
% -doe: structure obtaind with initDOE and complete manually

%   + Kind of DOE (doe.type): see the switch command below
%   + All methods containing the string '_R' require the R software
%   (installed on the computer and accessible using the command line).
%   Libraries 'lhs' and 'R.matlab' must be installed on R
%   + All methods containing the string '_MANU' are saved sampling (they
%   are built one time are are reloaded from a .mat file)
%   + Many sorting methods are available using doe.sort (see sortDOE.m)

%% OUTPUT variables
% - out: contains the sampling (sorted and unsorted)
% -infoSampling(optional): many information about the sampling


function [out,infoSampling]=buildDOE(doe)


fprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n')
fprintf('    >>> BUILDING SAMPLING <<<\n');
[tMesu,tInit]=mesuTime;

% For obtaining an "actual" pseudo-random sampling
s = RandStream('mt19937ar','Seed','shuffle');
RandStream.setGlobalStream(s);

%recovering the required number of sample points
nsUndef=true;
if isfield(doe,'ns')
    if ~isempty(doe.ns)
        ns=doe.ns;
        nsUndef=false;
    end
end
if nsUndef;
    error(['Undefined number of sample points ''doe.ns'' (',mfilename,')']);
end

%recovering number of iteration if specified
if isfield(doe,'iter');nbIter=doe.iter;else nbIter=5;end

%number of generation for computing the scores
nbGene=20;

%recovering bounds of the design sapce
boundsUndef=true;
if isfield(doe,'Xmin')&&isfield(doe,'Xmax')
    if ~isempty(doe.Xmin)&&~isempty(doe.Xmax)
        Xmin=doe.Xmin;
        Xmax=doe.Xmax;
        boundsUndef=false;
    end
elseif isfield(doe,'bornes')
    if ~isempty(doe.bornes)
        Xmin=doe.bornes(:,1);
        Xmax=doe.bornes(:,2);
        doe.Xmin=Xmin;doe.Xmax=Xmax;
        boundsUndef=false;
    end
end
if boundsUndef
    error(['Undefined bounds of the design space ''doe.Xmin'' an ''doe.Xmax'' (',mfilename,')']);
end

%default values
XminDef=0.*Xmin;XmaxDef=0.*Xmax+1;

%number ofvariables
np=numel(Xmin);

%default sorting options
if ~isfield(doe,'sort');doe.sort=[];end
if ~isfield(doe.sort,'on');doe.sort.on=false;end
if ~isfield(doe.sort,'lnorm');doe.sort.lnorm=2;end

%% Show information
fprintf(' >> Kind of DOE de tirages: %s\n',doe.type);
fprintf(' >> Number of sample points: ')
fprintf('%i ',ns);fprintf('\n');
fprintf(' >> Number of variables: %i\n',np);

samplingOK=true;
customSampling=false;
%depending on the chosen DOE technique
switch doe.type
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % full factorial
    case 'ffact'
        if numel(ns)==1
            ns=ns^np;
        end
        sampling=fullFactDOE(ns,XminDef,XmaxDef);
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
        sampling=ihs(np,ns,5,17);
        sampling=sampling./ns;
        sampling=sampling';
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 'IHS_manu'
         %recover sampling if available
        [sampling,fich]=checkDOE('ihs',np,ns);
        if isempty(sampling)
            sampling=ihs(np,ns,5,17);
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
            uni=score_doe(samplingTMP{ii});
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
                uni=score_doe(samplingTMP{ii});
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
        sampling=doe.manu;
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
    
    %if two output variables, other information will be stored
    if nargout==2
        if doe.sort.on
            infoSampling.tirages_non_trie=sampling;
        end
        %compute scores of the sampling
        [infoSampling.uniform,infoSampling.discrepance]=calcScore(sampling);
    end
    %sorting of the sampling
    sortedSampling=sortDOE(sampling,doe);
    
    %shwo sampling
    displayDOE(sortedSampling,doe)
else
    sortedSampling=[];
end

%output
out.sorted=sortedSampling;
out.unsorted=sampling;

mesuTime(tMesu,tInit);
fprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n')
end


%function for checking if a sampling already exists
function [sampling,fich]=checkDOE(nameFile,np,ns)

%check if the storage folder exists
if exist('TIR_MANU','dir')~=7
    unix('mkdir TIR_MANU');
end

%if the sampling exists, it will be loaded
fi=['TIR_MANU/' nameFile '_man_' num2str(np) '_'  num2str(ns)];
fich=[fi '.mat'];
if exist(fich,'file')==2
    st=load(fich);
    sampling=st.sampling;
else
    fprintf('Sampling does not exist \n');
    sampling=[];
end
end

