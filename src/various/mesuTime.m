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

%% Script dedicated to the initiailisation, the measure and the display of the spent time
%% L.LAURENT -- 15/05/2012 -- luc.laurent@lecnam.net

classdef mesuTime < handle
    properties (Access = private)
        counterTicToc=[];
        tInit=[];
        tFinal=[];
        tElapsed=[];
        tCPUElapsed=[];
    end
    methods
        %constructor
        function obj=mesuTime()
            %initialization tic-toc count
            obj.counterTicToc=tic;
            %Measure initial CPU time
            obj.tInit=cputime;
        end
        %start the measure
        function start(obj)
            %Measure initial CPU time
            obj.tInit=cputime;
        end
        %stop the measure
        function stop(obj)
            %Measure initial CPU time
            obj.tElapsed=toc(obj.counterTicToc);
            %Elapsed time
            obj.tCPUElapsed=cputime-obj.tInit;
            %show the result
            show(obj);
        end
        %display the elapsed time
        function show(obj)
            fprintf(' - - - - - - - - - - - - - - - - - - - - \n')
            fprintf('  #### Time/CPU time (s): %4.2f s / %4.2f s\n',obj.tElapsed,obj.tCPUElapsed);
        end
    end
end

