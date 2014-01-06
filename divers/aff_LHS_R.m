%% Affichage LHS/IHS issus de R avec enrichissement
% L. LAURENT -- 14/01/2012 -- laurent@lmt.ens-cachan.fr
close all
%dimension [1 2 3 4 5 6 7 8 9 10] nombre de variables
dim=2;
%nb echantillons [2 5 10 15 20 30 50] initiaux (avant enrichissement)
nbs_min=30;
%type de tirages 'LHS' ou 'IHS'
tir_type='LHS';

fich=[tir_type '_R/' num2str(dim) 'd_' num2str(nbs_min) '.mat'];
fprintf('%s\n',fich)
load(fich)

aff=true;
if aff
if dim==1
    figure;
    hold on
    for ii=1:nbs_min
        plot(t(ii),2,'r*','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
    end
    iter=1;
    for ii=(nbs_min+1):nbs_max
        plot(tt(ii),2,'bo','MarkerSize',10);
        F(iter)=getframe;
        iter=iter+1;
    end
    hold off
elseif dim==2
    figure;
    hold on
    for ii=1:nbs_min
        plot(t(ii,1),t(ii,2),'ro','MarkerSize',10,'MarkerEdgeColor','r','MarkerFaceColor','r')
    end
    iter=1;
    for ii=(nbs_min+1):nbs_max
        plot(tt(ii,1),tt(ii,2),'bo','MarkerSize',10);
        F(iter)=getframe;
        iter=iter+1;
    end
else
    h=figure
    it=0;
    para=0.1;
    Depx=Xmax-Xmin;iter=1;
    for ll=1:nbs_min       
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
    for ll=(nbs_min+1):nbs_max   
        fprintf('%g ',ll);
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