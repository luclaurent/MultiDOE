%% Infill study
% L. LAURENT -- 14/01/2012 -- luc.laurent@lecnam.net

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

close all
%dimension
for ii=[1 2 3 4 5 6 7 8 9 10]
    dim=ii;
    dispOn=false;
    %bounds
    uB=10;
    lB=-10;
    %nb echantillons
    for jj=[2 5 10 15 20 30 50]
        nsMin=jj;
        nsMax=150;
        
        
        Xmin=repmat(lB,1,dim);
        Xmax=repmat(uB,1,dim);
        %initialize DOE
        [t,nt]=ihsR(Xmin,Xmax,nsMin);
        %execute enrichment
        [tt,ntt]=ihsR(Xmin,Xmax,nsMin,t,nsMax);
        fich=['IHS_R/' num2str(dim) 'd_' num2str(nsMin) '.mat'];
        Mfprintf('%s\n',fich);
        save(fich)
    end
end

if dispOn
    if dim==1
        figure;
        hold on
        for ii=1:nsMin
            plot(t(ii),2,'r*','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
        end
        iter=1;
        for ii=(nsMin+1):nsMax
            plot(tt(ii),2,'bo','MarkerSize',10);
            F(iter)=getframe;
            iter=iter+1;
        end
        hold off
    elseif dim==2
        figure;
        hold on
        for ii=1:nsMin
            plot(t(ii,1),t(ii,2),'ro','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
        end
        iter=1;
        for ii=(nsMin+1):nsMax
            plot(tt(ii,1),tt(ii,2),'bo','MarkerSize',10);
            F(iter)=getframe;
            iter=iter+1;
        end
    else
        h=figure
        it=0;
        para=0.1;
        Depx=Xmax-Xmin;iter=1;
        for ll=1:nsMin
            for ii=1:dim
                for jj=1:dim
                    it=it+1;
                    if ii~=jj
                        subplot(dim,dim,it)
                        hold on
                        plot(tt(ll,ii),tt(ll,jj),'ro','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
                        hold off
                        xmin=Xmin(ii);xmax=Xmax(ii);ymin=Xmin(jj);ymax=Xmax(jj);depx=Depx(ii);depy=Depx(jj);
                        axis([(xmin-para*depx) (xmax+para*depx) (ymin-para*depy) (ymax+para*depy)])
                        line([xmin;xmin;xmax;xmax;xmax;xmax;xmax;xmin],[ymin;ymax;ymax;ymax;ymax;ymin;ymin;ymin])
                    end
                end
            end
            it=0;
        end
        for ll=(nsMin+1):nsMax
            Mfprintf('%g ',ll);
            for ii=1:dim
                for jj=1:dim
                    it=it+1;
                    if ii~=jj
                        subplot(dim,dim,it)
                        hold on
                        plot(tt(ll,ii),tt(ll,jj),'bo','MarkerSize',10);
                        hold off
                        xmin=Xmin(ii);xmax=Xmax(ii);ymin=Xmin(jj);ymax=Xmax(jj);depx=Depx(ii);depy=Depx(jj);
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