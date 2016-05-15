%% Example of use of the MultiDOE toolbox
% L. LAURENT -- 06/01/2014 -- luc.laurent@lecnam.net

%initialize folders of the toolbox
initDirMultiDOE;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load configuration
doe=initDOE(3);
%
doe.Xmin=[-1 -2 -3];% -1 -2 -3 -1 -2 -3 -3];
doe.Xmax=[3 2 1];% 3 2 1 3 2 1 1];

% available sampling techniques :
% - ffact "full factorial"
% - LHS_R
% - OLHS_R
% - MMLHS_R
% - GLHS_R
% - IHS_R
% - HALTON
% - SOBOL
% - LHSD --> MATLAB (lhsdesign)
% - LHSD_CORRMIN
% - LHSD_MAXMIN
% - LHSD_NS
% - LHS 
% - IHS
% - LHS_O1
% - IHS_R_manu_infill
% - LHS_R_manu_infill
% - rand
% - perso

doe.type='LHS_manu';
doe.ns=30;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%build DOE
[sampling,infos]=buildDOE(doe);
sampling.sorted
sampling.unsorted