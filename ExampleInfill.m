%% Example of use of the enrichment of IHS 
% L. LAURENT -- 06/01/2014 -- luc.laurent@lecnam.net

%initialize folders of the toolbox
initDirMultiDOE;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load configuration
doe=initDOE(3);
%
doe.Xmin=[-1 -2 -3];
doe.Xmax=[3 2 1];
doe.type='LHS_R'; %or LHS_R
doe.ns=5;
doe.sort.on=false; %w/o sorting
doe.disp=true;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%build DOE
sampling=buildDOE(doe);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%enrichment
doe.ns=2;
newSample=addSampleDOE(sampling,doe);
displayDOE(newSample,doe)