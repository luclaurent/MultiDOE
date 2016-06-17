classdef multiDOE
    %MULTIDOE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        dimPB
        ns
        disp
        sort
        Xmin
        Xmax
        type
        sorted
        unsorted
        infos
    end
    
    methods
       %constructor
       function obj=multiDOE()
           retInit=initDOE;
          obj.dimPB=retInit.dimPB;
       end
       %delete
       function delete(obj)
           fprintf('Remove intance');
           clear obj;
       end
       %sampling
       function buildDOE(obj)
          [out,infos]=buildDOE(obj);
       end
       %define
       function define()
       end
       %display
       function disp()
       end
       %add points
       function addSample()
       end
       %compute scores
       function score()
           
       end
       %sort sampling
       function sort()
           
       end
    end
end

