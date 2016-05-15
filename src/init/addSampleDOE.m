%% Function for adding new points in an existing sampling
%% L. LAURENT -- 04/12/2011 -- luc.laurent@lecnam.net

% the enrichment requires the library 'R.matlab' in R software

function newSampling=addSampleDOE(oldSampling,doe)

Xmin=doe.Xmin;
Xmax=doe.Xmax;

ns=doe.ns;

%extract the right information
if isstruct(oldSampling);
    oldSampling=oldSampling.unsorted;
end

% depending on the initial sampling
switch doe.type
    case 'LHS_R'
        [newSampling]=lhsuR(Xmin,Xmax,ns,oldSampling);
    case 'IHS_R'
        [newSampling]=ihsR(Xmin,Xmax,ns,oldSampling);
    otherwise
        fprintf('>>>> Only LHS_R et IHS_R sampling \n allow enrichment\n')
        newSampling=[];
end