classdef multiDOE
    %% multiDOE class for manipulating sampling
    % L. LAURENT -- 26/06/2016 -- luc.laurent@lecnam.net
    
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
    
    properties
        dimPB=[];
        ns=[];
        Xmin=[];
        Xmax=[];
        type=[];
        dispOn=false;
        sortInfo=[];
        sorted=[];
        unsorted=[];
        infos=[];
        scoreVal=[];
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
    end
    
    methods
        %constructor
        function obj=multiDOE(dimPBIn,typeIn,nsIn,XminIn,XmaxIn)
            %load default configuration
            retInit=initDOE(dimPBIn);
            obj.dimPB=retInit.dimPB;
            obj.ns=retInit.ns;
            obj.Xmin=retInit.Xmin;
            obj.Xmax=retInit.Xmax;
            obj.type=retInit.type;
            obj.sortInfo=retInit.sort;
            obj.dispOn=retInit.disp;
            %specific configuration
            if nargin>0;obj.dimPB=dimPBIn;end
            if nargin>1;obj.type=typeIn;end
            if nargin>2;obj.ns=nsIn;end
            if nargin>4;obj.Xmin=XminIn;obj.Xmax=XmaxIn;end
            %build sampling
            obj=build(obj);
            %compute scores
            obj.scoreVal=score(obj);
            %display
            show(obj);
        end
        %delete
        function delete(obj)
            fprintf('Remove instance');
            clear obj;
        end
        %check data
        function isOk=check(obj)
            isOk=true;
            if isempty(obj.dimPB);
                isOk=false;
                fprintf('>> Undefined dimension of the DOE\n');
            end
            if isempty(obj.ns);
                isOk=false;
                fprintf('>> Undefined number of sample points\n');
            end
            if isempty(obj.Xmin);
                isOk=false;
                fprintf('>> Undefined lower bound of the design space\n');
            end
            if isempty(obj.Xmax);
                isOk=false;
                fprintf('>> Undefined lower bound of the design space\n');
            end
            if isempty(obj.type);
                isOk=false;
                fprintf('>> Undefined type of DOE\n');
            end
        end
        %sampling
        function obj=build(obj)
            if check(obj)
                obj.unsorted=buildDOE(obj.type,obj.ns,obj.Xmin,obj.Xmax);
                obj.sorted=sort(obj);
            end
        end
        %display
        function show(obj)
            displayDOE(obj.sorted,obj);
        end
        %add points
        function obj=addSample()
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
            fprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n')
            fprintf('Available techniques for sampling\n')
            for itT=1:numel(obj.sampleAvail)
                fprintf('%s\n',obj.sampleAvail{itT});
            end
            fprintf('=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=#=\n')
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

