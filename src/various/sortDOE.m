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

%% Sorting of sample points
%% L. LAURENT -- 03/09/2013 -- luc.laurent@lecnam.net

function samplingSorted = sortDOE(sampling,doe)
%for normalization
Xmin=doe.Xmin;
Xmax=doe.Xmax;

infoSort=doe.sort;
%used norm
lnorm=infoSort.lnorm;
%number of sample points and design variables
[ns,np]=size(sampling);
%normalization
sampling=(sampling-repmat(Xmin(:)',ns,1))./repmat(Xmax(:)'-Xmin(:)',ns,1);

if infoSort.on
    samplingSorted=zeros(ns,np);
    sortOk=true;
    %various methods for sorting the sample points
    switch infoSort.type
        case {'v','variable'}
            %sorting wrt a variable
            if isfield(infoSort,'para')&&infoSort.para>0
                if infoSort.para<=size(sampling,1)
                    [~,ind]=sort(sampling(:,infoSort.para));
                    samplingSorted=sampling(ind,:);
                end
            end
        case {'nptp','normal_pt_to_pt'}
            % sorting with starting at a specific point (ptref or para) and by
            % looking from a point to another using a specific norm
            
            %initial point
            ptref=[];
            if isfield(infoSort,'ptref');if ~isempty(infoSort.ptref);ptref=infoSort.ptref;end, end
            if isfield(infoSort,'para');numPtRef=infoSort.para;else numPtRef=1;end
            if numPtRef<1||numPtRef>np;numPtRef=1;end
            
            %sorting
            if isempty(ptref)
                samplingSorted=nptp(sampling,lnorm,numPtRef,'exist',doe);
            else
                ptref=(ptref-Xmin(:)')./Xmax(:)';
                samplingSorted=nptp(sampling,lnorm,ptref,'don',doe);
            end
            
        case {'p','point'}
            %sorting by looking to the closest point to the barycenter of
            %the previous points
            
            %initial point
            ptref=[];
            if isfield(infoSort,'ptref');if ~isempty(infoSort.ptref);ptref=infoSort.ptref;end, end
            if isfield(infoSort,'para');numPtRef=infoSort.para;else numPtRef=1;end
            if numPtRef<1||numPtRef>np;numPtRef=1;end
            
            %sorting
            if isempty(ptref)
                samplingSorted=barypt(sampling,lnorm,numPtRef,'exist',doe);
            else
                ptref=(ptref-Xmin(:)')./Xmax(:)';
                samplingSorted=barypt(sampling,lnorm,ptref,'don',doe);
            end
            
        case {'c','center'}
            %same technique as 'p' but starting at the center of the
            %design space
            centerPt=(Xmax(:)'+Xmin(:)')./2;
            %sorting
            samplingSorted=barypt(sampling,lnorm,centerPt,'don',doe);
        case {'sac','sampling_center'}
            % same technique as 'p' but the initial point is chosen as the
            % center of a provided sampling
            minSampling=min(sampling);
            maxSampling=max(sampling);
            centerPt=(maxSampling+minSampling)./2;
            %sorring
            samplingSorted=barypt(sampling,lnorm,centerPt,'don',doe);
        case {'sc','start_center'}
            %same as nptp but starting at the center of the design space
            centerPt=(Xmax(:)'+Xmin(:)')./2;
            %sorting
            samplingSorted=nptp(sampling,lnorm,centerPt,'don',doe);
            
        case {'sasc','sampling_start_center'}
            %same as nptp but starting at the the initial point is chosen as the
            % center of a provided sampling
            minSampling=min(sampling);
            maxSampling=max(sampling);
            centerPt=(maxSampling+minSampling)./2;
            %sorting
            samplingSorted=nptp(sampling,lnorm,centerPt,'don',doe);
        otherwise
            sortOk=false;
            
    end
    
    if ~sortOk
        fprintf('###############################################################\n');
        fprintf('## ## Wrong parameter for sorting (sorting deactivated)  ## ##\n');
        fprintf('###############################################################\n');
    end
else
    samplingSorted=sampling;
end
%renormalization
samplingSorted=samplingSorted.*repmat(Xmax(:)'-Xmin(:)',ns,1)+repmat(Xmin(:)',ns,1);
end

%% norm of a vector (better behavior in comparison with the norm function of MATLAB)
function N=normp(X,type)
%check if an infinity norm is required
norminf=isinf(type);
ninf=false;
%absolute value of the components
Xabs=abs(X);

if norminf
    if -abs(type)==type;ninf=true;end
    
    if ninf
        %-Inf norm
        N=min(Xabs,[],2);
    else
        %Inf norm 
        N=max(Xabs,[],2);
    end
else
    %p-norm
    N=sum(Xabs.^type,2).^(1/type);
end
end

%%function for sorting points using an initial point chosen or provided by
%%the 'type' input variable
function samplingSorted=nptp(sampling,lnorm,infoPt,type,doe)
%number of sample point and variables
[ns,np]=size(sampling);
samplingSorted=zeros(ns,np);
%list of the number of points
listNnum=1:ns;
%depending on the kind of initial point
switch type
    case 'exist'
        %using an existing initial point
        numPtRef=infoPt;
        ptRef=sampling(numPtRef,:);
        samplingSorted(1,:)=ptRef;
        listNnum(numPtRef)=[];
        startFor=1;
    case 'don'
        %using a provided point
        ptRef=infoPt;
        startFor=0;
end
%for norming the points
xNorm=doe.Xmax(:)'-doe.Xmin(:)';
%sorting
for ii=startFor:ns-1
    %compute the distance between the reference point and the others
    xDiff=ptRef(ones(1,ns-ii),:)-sampling(listNnum,:);
    xDiff=xDiff./xNorm(ones(1,ns-ii),:);
    distS=normp(xDiff,lnorm);
    %look for the minimal distance
    [~,IXDmin]=min(distS);
    numPtRef=listNnum(IXDmin(1));
    listNnum(IXDmin(1))=[];
    
    %new refernce point
    ptRef=sampling(numPtRef,:);
    samplingSorted(ii+1,:)=ptRef;
end
end

%function for sorting sample points by considering the reference point as
%the barycenter of the previous points (the starting point can be chosen as
%an existing one or a provided point using the variable 'type')
function samplingSorted=barypt(sampling,lnorm,infoPt,type,doe)
%parameter for the distance of the barycenter
dBary=0.5;
%number of sample point and variables
[ns,np]=size(sampling);
samplingSorted=zeros(ns,np);
%list of the number of points
listNum=1:ns;
%depending on the kind of initial point
switch type
    case 'exist'
        %using an existing initial point
        numPtRef=infoPt;
        ptRef=sampling(numPtRef,:);
        ptInit=ptRef;
        samplingSorted(1,:)=ptRef;
        listNum(numPtRef)=[];
        startFor=1;
    case 'don'
        %using a provided point
        ptRef=infoPt;
        ptInit=ptRef;
        startFor=0;
end
%for norming the points
xnorm=doe.Xmax(:)'-doe.Xmin(:)';
%sorting
for ii=startFor:ns-1
     %compute the distance between the reference point and the others
    xDiff=ptRef(ones(1,ns-ii),:)-sampling(listNum,:);
    xDiff=xDiff./xnorm(ones(1,ns-ii),:);
    distS=normp(xDiff,lnorm);
    %look for the minimal distance
    [~,IXDmin]=min(distS);
    numPtAdd=listNum(IXDmin(1));
    listNum(IXDmin(1))=[];
    
    %add the point to the sampling
    samplingSorted(ii+1,:)=sampling(numPtAdd,:);
    
    %compute the new reference point using as the barycenter of the
    %sampling
    nb_pts=ii+1;
    baryPt=1/nb_pts*sum(samplingSorted(1:nb_pts,:),1);
    ptRef=ptInit+dBary*(baryPt-ptInit);
end
end