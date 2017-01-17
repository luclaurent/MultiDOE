    %% multiDOE class for manipulating sampling
    % L. LAURENT -- 26/06/2016 -- luc.laurent@lecnam.net
    %
    % A multiDOE object can be created using the following syntax:
    % multiDOE(dimPBIn,typeIn,nsIn,XminIn,XmaxIn)
    % where:
    %  - dimPBIn: number of design variables
    %  - typeIn: type of DOE (default: LHS)
    %  - nsIn: number of sample points
    %  - XminIn,XmaxIn: lower and upper bounds of the design space
    %
    % Each property can be set manually 
    % for instance:
    % <obj>.dimPB=3
    % <obj>.type='LHS'
    % <obj>.ns=30
    %
    % The smple points can be obtained using 
    % <obj>.sorted or <obj>.unsorted
    %
    % The method 'show' allows to plot the sample points in any dimension

    
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

classdef multiDOE < handle
    
    properties
        dimPB=[];
        ns=[];
        Xmin=[];
        Xmax=[];
        type=[];
        dispOn=false;
        sortInfo=struct('on',true,'type','sac','para',1,'ptref',[],'lnorm',2);
        sorted=[];
        unsorted=[];
        scoreVal=[];
        funTest=''; %test function used
    end
    properties (Access = private)
        runDOE=true; %flag for checking if sampling is obsolete
        okData=false; %flag for checking if sufficient data is available
    end
    properties (Constant)
        qnorm=2; % options for computing the scores of a sampling
        sampleAvail={'ffact','LHS_R','LHS_R_manu','OLHS_R','OLHS_R_manu',...
            'MMLHS_R','MMLHS_R_manu','GLHS_R','GLHS_R_manu','IHS_R',...
            'IHS_R_manu','HALTON','HALTON_manu','SOBOL','SOBOL_manu',...
            'LHSD','LHSD_manu','LHSD_CORRMIN','LHSD_CORRMIN_manu',...
            'LHSD_MAXMIN','LHSD_MAXMIN_manu','LHSD_NS','LHSD_NS_manu',...
            'LHS','LHS_manu','IHS','IHS_manu','LHS_O1','LHS_O1_manu',...
            'rand'}
        sampleAvailTxt={'Full Factorial Sampling',...
            'Latin Hypercube Sampling using R',...
            'LHS using R and storage on mat file',...
            'Optimal LHS using R',...
            'idem with storage on mat file',...
            'MaxiMin LHS using R',...
            'idem with  and storage on mat file',...
            'Optimal LHS using genetic algorithm (based on R)',...
            'idem with and storage on mat file',...
            'Improved Hypercube Sampling based on R',...
            'idem with and storage on mat file',...
            'Sampling using Halton''s sequence',...
            'idem with and storage on mat file',...
            'Sampling using Sobol''s sequence',...
            'idem with and storage on mat file',...
            'LHS using Matlab''s function lhsdesign',...
            'idem with and storage on mat file',...
            'LHS using Matlab''s function and minimization of the correlation',...
            'idem with and storage on mat file',...
            'LHS using Matlab''s function and minimization of the MaxiMin criterion',...
            'idem with and storage on mat file',...
            'LHS using Matlab''s function and Non-Smooth criterion',...
            'idem with and storage on mat file',...
            'LHS classical function (included in the toolbox)',...
            'idem with and storage on mat file',...
            'Improved Hypercube Sampling',...
            'idem with and storage on mat file',...
            'LHS with minimization of the inter-sample distances',...
            'idem with and storage on mat file',...
            'Random sampling'};
        sortAvail={'v','variable','nptp','normal_pt_to_pt',...
            'p','point','c','center','sac','sampling_center',...
            'sc','start_center','sasc','sampling_start_center'};
        sortTxt={'(number) Sort along a specific design variable',...
            'idem',...
            '(number of the point (using para) or define point (ptref))',...
            'Start from a point and look for the closest unsorted one',...
            '(number of the point (using para) or define point (ptref))'...
            'Sorting by looking to the closest point to the barycenter of the previous points',...
            'Same as ''p'' but starting at the center of the design space',...
            'idem',...
            'Same as ''p'' but starting at the center of sampling points',...
            'idem',...
            'Same as ''nptp'' but starting at the center of the design space',...
            'idem',...
            'Same as ''nptp'' but starting at the center of sampling points',...
            'idem'};
    end
    
    methods
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %constructor
        function obj=multiDOE(dimPBIn,typeIn,nsIn,XminIn,XmaxIn,funTest)
            %load directories on the path
            initDirMultiDOE;
            %if the design space if given directly
            spaceD=[];
            if size(dimPBIn,2)==2
                dimPBOk=size(dimPBIn,1);
                spaceD=dimPBIn;
            else
                dimPBOk=dimPBIn;
            end
            %load default configuration
            if nargin>5
                retInit=initDOE(dimPBOk,[],spaceD,funTest,false);
            else
                retInit=initDOE(dimPBOk,[],spaceD,[],false);
            end
            %specific configuration
            obj.dimPB=retInit.dimPB;
            if nargin>1;if ~isempty(typeIn);obj.type=typeIn;end,end
            if nargin>2;if ~isempty(nsIn);obj.ns=nsIn;end,end             
            if nargin>4;
                if ~isempty(XminIn)&&~isempty(XmaxIn)
                    obj.Xmin=XminIn;obj.Xmax=XmaxIn;
                end
            else
                obj.Xmin=retInit.Xmin;obj.Xmax=retInit.Xmax;
            end
            %specified the test function
            if ~isempty(retInit.funT);obj.funTest=retInit.funT;end
            %load default configuration
            obj.sortInfo=retInit.sort;
            %active display
            obj.dispOn=retInit.disp;
            %build sampling
            obj=build(obj);
            %if all is ok, continue
            if obj.okData
                %compute scores
                 obj.scoreVal=score(obj);
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%setter
        %flag for obsolete sampling
        function set.runDOE(obj,runIn)
            obj.runDOE=runIn;
        end
        %number of sample points
        function set.ns(obj,nsIn)
            %check the kind of input data
            obj.ns=nsIn(:);
            initRunDOE(obj,true);
            Mfprintf('++ Number of sample points: %i\n',obj.ns);
        end
        %number of design variables
        function set.dimPB(obj,dimIn)
            %check the kind of input data
            obj.dimPB=dimIn(:);
            initRunDOE(obj,true);
            Mfprintf('++ Number of design variables: %i\n',obj.dimPB);
        end
        %load lower bound
        function set.Xmin(obj,XminIn)
            %check the kind of input data
            if size(XminIn,1)==1||size(XminIn,2)==1
                obj.Xmin=XminIn(:);
                initRunDOE(obj,true);
            else
                Mfprintf('>> Wrong input data: lower bound must be a vector\n');
            end
            Mfprintf('++ Current Lower bound: ');
            fprintf('%+4.2f|',obj.Xmin);fprintf('\n');
        end
        %load upper bound
        function set.Xmax(obj,XmaxIn)
            %check the kind of input data
            if size(XmaxIn,1)==1||size(XmaxIn,2)==1
                obj.Xmax=XmaxIn(:);
                initRunDOE(obj,true);
            else
                Mfprintf('>> Wrong input data: upper bound must be a vector\n');
            end
            Mfprintf('++ Current Upper bound: ');
            fprintf('%+4.2f|',obj.Xmax);fprintf('\n');
        end
        %load type
        function set.type(obj,typeIn)
            %check the type is available
            if any(ismember(typeIn,obj.sampleAvail))
                obj.type=typeIn;
                initRunDOE(obj,true);
            else
                Mfprintf('>> Wrong input data: the type of sample must be\n chosen along the following list\n');
                obj.availableType();
            end
            Mfprintf('++ Type of DOE: ');
            fprintf('%s',obj.type);fprintf('\n');
        end
        %load sortInfo
        function set.sortInfo(obj,structIn)
            % look up the previous value
            oldVal = obj.sortInfo;
            % loop through fields to check what has changed
            fields = fieldnames(structIn);
            for fn = fields(:)' %'#
                %turn cell into string for convenience
                field2check = fn{1};
                if isfield(oldVal,field2check)
                    % simply assign the fields you don't care about
                    obj.sortInfo.(field2check) = structIn.(field2check);
                end
            end
        end        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%getter
        %get sorted
        function sorted=get.sorted(obj)
                if obj.runDOE&&obj.okData
                    %build sampling
                    obj=build(obj);
                    %compute scores
                    obj.scoreVal=score(obj);
                end
                sorted=obj.sorted;
        end
        %get unsorted
        function unsorted=get.unsorted(obj)
            if obj.runDOE&&obj.okData
                %build sampling
                obj=build(obj);
                %compute scores
                obj.scoreVal=score(obj);
            end
            unsorted=obj.unsorted;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %function for loading configuration associated with a test function
        function loadConf(obj,funTest)
            %load configuration
            retInit=initDOE(obj.dimPB,[],[],funTest,false);
            %defining properties
            obj.funTest=retInit.funT;
            obj.Xmin=retInit.Xmin;
            obj.Xmax=retInit.Xmax;
        end
        %function for initializing runDOE
        function initRunDOE(obj,flag)
            obj.runDOE=flag;
        end
        %check data
        function isOk=check(obj)
            isOk=true;
            if isempty(obj.dimPB)
                isOk=false;
                Mfprintf('>> Undefined dimension of the DOE\n');
            end
            if isempty(obj.ns)
                isOk=false;
                Mfprintf('>> Undefined number of sample points\n');
            end
            if isempty(obj.Xmin)
                isOk=false;
                Mfprintf('>> Undefined lower bound of the design space\n');
            end
            if isempty(obj.Xmax)
                isOk=false;
                Mfprintf('>> Undefined lower bound of the design space\n');
            end
            if isempty(obj.type)
                isOk=false;
                Mfprintf('>> Undefined type of DOE\n');
            end
            obj.okData=isOk;
        end
        %sampling
        function obj=build(obj)
            if check(obj)&&obj.runDOE
                obj.runDOE=false;
                obj.unsorted=buildDOE(obj.type,obj.ns,obj.Xmin,obj.Xmax);
                obj.sorted=sort(obj);
            end
        end
        %display unsorted
        function show(obj)
            displayDOE(obj.unsorted,obj);
        end
        %display sorted
        function showSorted(obj)
            displayDOE(obj.sorted,obj);
        end
        %add points
        function obj=addSample(obj,NumberAdd)
            if nargin<2;NumberAdd=1;end
            Mfprintf('++ Add %g new sample points\n',NumberAdd);
            %build new sample points
            newSamplePts=addSampleDOE(obj.unsorted,NumberAdd,obj);
            %if  new sample points
            if ~isempty(newSamplePts)
                obj.unsorted=newSamplePts;
                obj.sorted=sort(obj);
                obj.ns=obj.ns+1;
                obj.runDOE=false;
                %compute scores
                obj.scoreVal=score(obj);
            else
                Mfprintf('No sample points added\n');
                obj=[];
            end
        end
        %manually add points
        function addManuSample(obj,ptsIn)
            if ~isempty(ptsIn)
                szP=size(ptsIn);
                if szP(2)==obj.dimPB
                    Mfprintf('++ Add %i sample point(s) manually: \n',szP(1));
                    Mfprintf(repmat([repmat(' %g',1,szP(2)) '\n'],szP(1),1),ptsIn);
                    %add new points
                    obj.unsorted=[obj.unsorted;ptsIn];
                    obj.sorted=sort(obj);
                    obj.ns=obj.ns+1;
                    obj.runDOE=false;
                    %compute scores
                    obj.scoreVal=score(obj);
                else
                    Mfprintf('Wrong dimension of the points\n');
                    Mfprintf('No sample points added\n');
                end
            else
                Mfprintf('No sample points added\n');
            end
        end
        %compute scores
        function scoreVal=score(obj)
            if nargin==2
                q=obj.qnorm;
            else
                q=2;
            end
            [scoreVal.uniform,scoreVal.discrepancy]=calcScore(obj.unsorted,q);
        end
        %sort sampling
        function sorted=sort(obj)
            sorted=sortDOE(obj.unsorted,obj);
        end
        %list available techniques
        function availableType(obj)
            Mfprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n');
            Mfprintf('Available techniques for sampling\n');
            dispTableTwoColumns(obj.sampleAvail,obj.sampleAvailTxt);
            Mfprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n');
        end
        %list available sorting techniques
        function availableSort(obj)
            Mfprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n');
            Mfprintf('Available techniques for sorting the sample points\n');
            dispTableTwoColumns(obj.sortAvail,obj.sortTxt);
            Mfprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n');
        end
        %define sort configuration
        function sortConf(obj,varargin)
            %accepted keyword
            keyOk={'on','type','para','ptref','lnorm'};
            execOk=true;
            %two kind of input variables list (with keywords or not)
            %depend on the first argument: boolean for classical list of
            %argument or string if the use of keywords
            if isa(varargin{1},'logical')              
                if nargin>1;obj.sortInfo=struct('on',varargin{1});end
                if nargin>2
                    if ismember(varargin{2},obj.sortAvail)
                        obj.sortInfo=struct('type',varargin{2});
                    else
                        execOk=false;
                    end
                end
                if nargin>3;obj.sortInfo=struct('para',varargin{3});end
                if nargin>4;obj.sortInfo=struct('ptref',varargin{4});end
                if nargin>5;obj.sortInfo=struct('lnorm',varargin{5});end
            elseif isa(varargin{1},'char')
                if mod(nargin-1,2)==0
                    for itV=1:2:nargin-1
                        %load key and associated value
                        keyTxt=varargin{itV};
                        keyVal=varargin{itV+1};
                        %check if the keyword is usable
                        if ismember(keyTxt,keyOk)
                            %in the case of the type definition
                            if strcmp(keyTxt,'type')
                                %if the chosen type is avilable
                                if ismember(keyVal,obj.sortAvail)
                                    obj.sortInfo=struct(keyTxt,keyVal);
                                else
                                    execOk=false;
                                end
                            else
                                obj.sortInfo=struct(keyTxt,keyVal);
                            end
                        else
                            execOk=false;
                        end
                    end
                else
                    execOk=false;
                end
            else
                execOk=false;
            end
            %display error message if wrong syntax
            if ~execOk
                Mfprintf('Wrong syntax for the method\n');
                Mfprintf('sortConf(bool,type,ptref,para,lnorm)\n');
                Mfprintf('or sortConf(''key1'',val1,''key2'',val2...)\n');
                availableSort(obj);
            end            
        end
        %compare two sampling
        function iseq=eq(doeA,doeB)
            iseq=false;
            if all(doeA.unsorted==doeB.unsorted)
                iseq=true;
            end
        end
        %overload isfield
        function isF=isfield(doe,field)
            isF=isprop(doe,field);
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%function display table with two columns of text
function dispTableTwoColumns(tableA,tableB)
%size of every components in tableA
sizeA=cellfun(@numel,tableA);
maxA=max(sizeA);
%space after each component
spaceA=maxA-sizeA+3;
spaceTxt=' ';
%display table
for itT=1:numel(tableA)
    Mfprintf('%s%s%s\n',tableA{itT},spaceTxt(ones(1,spaceA(itT))),tableB{itT});
end
end
