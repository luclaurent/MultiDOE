% Copyright or © or Copr. Luc LAURENT (30/06/2016)
% luc.laurent@lecnam.net
% 
% This software is a computer program whose purpose is to generate sampling
% using dedicated techniques.
% 
% This software is governed by the CeCILL license under French law and
% abiding by the rules of distribution of free software.  You can  use, 
% modify and/ or redistribute the software under the terms of the CeCILL
% license as circulated by CEA, CNRS and INRIA at the following URL
% "http://www.cecill.info". 
% 
% As a counterpart to the access to the source code and  rights to copy,
% modify and redistribute granted by the license, users are provided only
% with a limited warranty  and the software's author,  the holder of the
% economic rights,  and the successive licensors  have only  limited
% liability. 
% 
% In this respect, the user's attention is drawn to the risks associated
% with loading,  using,  modifying and/or developing or reproducing the
% software by the user in light of its specific status of free software,
% that may mean  that it is complicated to manipulate,  and  that  also
% therefore means  that it is reserved for developers  and  experienced
% professionals having in-depth computer knowledge. Users are therefore
% encouraged to load and test the software's suitability as regards their
% requirements in conditions enabling the security of their systems and/or 
% data to be ensured and,  more generally, to use and operate it in the 
% same conditions as regards security. 
% 
% The fact that you are presently reading this means that you have had
% knowledge of the CeCILL license and that you accept its terms.

%% Showing LHS/IHS obtained with R with enrichment
% L. LAURENT -- 14/01/2012 -- luc.laurent@lecnam.net
close all
%dimension [1 2 3 4 5 6 7 8 9 10] number of variables
np=2;
%nb of initial sample points [2 5 10 15 20 30 50] (before enrichment)
nsMin=30;
%type of DOE 'LHS' or 'IHS'
doeType='LHS';

fich=[doeType '_R/' num2str(np) 'd_' num2str(nsMin) '.mat'];
fprintf('%s\n',fich)
load(fich)

dispOn=true;
if dispOn
    if np==1
        figure;
        hold on
        for ii=1:nsMin
            plot(t(ii),2,'r*','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
        end
        iter=1;
        for ii=(nsMin+1):nbs_max
            plot(tt(ii),2,'bo','MarkerSize',10);
            F(iter)=getframe;
            iter=iter+1;
        end
        hold off
    elseif np==2
        figure;
        hold on
        for ii=1:nsMin
            plot(t(ii,1),t(ii,2),'ro','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
        end
        iter=1;
        for ii=(nsMin+1):nbs_max
            plot(tt(ii,1),tt(ii,2),'bo','MarkerSize',10);
            F(iter)=getframe;
            iter=iter+1;
        end
    else
        h=figure;
        it=0;
        para=0.1;
        depX=Xmax-Xmin;iter=1;
        for ll=1:nsMin
            for ii=1:np
                for jj=1:np
                    it=it+1;
                    if ii~=jj
                        subplot(np,np,it)
                        hold on
                        plot(tt(ll,ii),tt(ll,jj),'ro','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
                        hold off
                        xmin=Xmin(ii);xmax=Xmax(ii);ymin=Xmin(jj);ymax=Xmax(jj);depx=depX(ii);depy=depX(jj);
                        axis([(xmin-para*depx) (xmax+para*depx) (ymin-para*depy) (ymax+para*depy)])
                        line([xmin;xmin;xmax;xmax;xmax;xmax;xmax;xmin],[ymin;ymax;ymax;ymax;ymax;ymin;ymin;ymin])
                    end
                end
            end
            it=0;
        end
        for ll=(nsMin+1):nbs_max
            fprintf('%g ',ll);
            for ii=1:np
                for jj=1:np
                    it=it+1;
                    if ii~=jj
                        subplot(np,np,it)
                        hold on
                        plot(tt(ll,ii),tt(ll,jj),'bo','MarkerSize',10);
                        hold off
                        xmin=Xmin(ii);xmax=Xmax(ii);ymin=Xmin(jj);ymax=Xmax(jj);depx=depX(ii);depy=depX(jj);
                        axis([(xmin-para*depx) (xmax+para*depx) (ymin-para*depy) (ymax+para*depy)])
                        line([xmin;xmin;xmax;xmax;xmax;xmax;xmax;xmin],[ymin;ymax;ymax;ymax;ymax;ymin;ymin;ymin])
                    end
                end
            end
            it=0;
            F(iter)=getframe(h);
            iter=iter+1;
        end
        
    end
    movie(F)
end