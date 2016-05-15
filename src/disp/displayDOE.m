%% Procedure assurant l'affichage des tirages en nD
%% L. LUARENT -- 10/02/2012 -- luc.laurent@lecnam.net


function aff_doe(tirages,doe,manq)

%affichage ordre tirages
aff_txt=true;

%recuperation bornes espace de conception
if isfield(doe,'Xmin')&&isfield(doe,'Xmax')
    Xmin=doe.Xmin;
    Xmax=doe.Xmax;
elseif isfield(doe,'bornes')
    Xmin=doe.bornes(:,1);
    Xmax=doe.bornes(:,2);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%recherche et tri des manques d'information
liste_pts_ok=1:size(tirages,1);
liste_eval_manq=[];
liste_grad_manq=[];
liste_both_manq=[];
if nargin==3
    if manq.eval.on
        liste_eval_manq=unique(manq.eval.ix_manq(:));
        for ii=1:numel(liste_eval_manq)
            ix=find(liste_pts_ok==liste_eval_manq(ii));
            liste_pts_ok(ix)=[];
        end
    end
    if manq.grad.on
        liste_grad_manq=unique(manq.grad.ix_manq(:,1));
        for ii=1:numel(liste_grad_manq)
            ix=find(liste_pts_ok==liste_grad_manq(ii));
            liste_pts_ok(ix)=[];
            
        end
    end
    if manq.eval.on|| manq.grad.on
        liste_both_manq=intersect(liste_eval_manq,liste_grad_manq);
        for ii=1:numel(liste_both_manq)
            ix=find(liste_eval_manq==liste_both_manq(ii));
            liste_eval_manq(ix)=[];
            ix=find(liste_grad_manq==liste_both_manq(ii));
            liste_grad_manq(ix)=[];
        end
    end
end
%texte a afficher ou non%
f1 = @(x) sprintf('%i',x);
f2 = @(x) cellfun(f1, num2cell(x), 'UniformOutput', false);
liste_pts_ok_txt=f2(liste_pts_ok);
liste_eval_manq_txt=f2(liste_eval_manq);
liste_grad_manq_txt=f2(liste_grad_manq);
liste_both_manq_txt=f2(liste_both_manq);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%nombre de variables
nbv=numel(Xmin);

if doe.aff
    para=0.1;
    if nbv==1
        figure
        hold on
        yy=0.*tirages;
        %affichage points ou toutes les infos sont connues
        plottext(tirages(liste_pts_ok),yy(liste_pts_ok),...
            liste_pts_ok_txt,'o','k',7,aff_txt);
        %affichage points il manque une/des reponse(s)
         plottext(tirages(liste_eval_manq),yy(liste_eval_manq),...
            liste_eval_manq_txt,'rs','r',7,aff_txt);
        %affichage points il manque un/des gradient(s)
        plottext(tirages(liste_grad_manq),yy(liste_grad_manq),...
            liste_grad_manq_txt,'v','g',7,aff_txt);
        %affichage points il manque un/des gradient(s) et un/des
        %reponse(s) au m�me point
        plottext(tirages(liste_both_manq),yy(liste_both_manq),...
            liste_both_manq_txt,'d','d',7,aff_txt);
        hold off
        xmin=Xmin(:)';
        xmax=Xmax(:)';
        dep=xmax-xmin;
        axis([(xmin-para*dep) (xmax+para*dep) -1 1])
    elseif nbv==2
        
        xmin=Xmin(1);
        xmax=Xmax(1);
        ymin=Xmin(2);
        ymax=Xmax(2);
        depx=xmax-xmin;
        depy=ymax-ymin;
        figure
        hold on
        %affichage points ou toutes les infos sont connues
        plottext(tirages(liste_pts_ok,1),tirages(liste_pts_ok,2),...
            liste_pts_ok_txt,'o','k',7,aff_txt);
        %affichage points il manque une/des reponse(s)
        plottext(tirages(liste_eval_manq,1),tirages(liste_eval_manq,2),...
            liste_eval_manq_txt,'rs','r',7,aff_txt);
        %affichage points il manque un/des gradient(s)
        plottext(tirages(liste_grad_manq,1),tirages(liste_grad_manq,2),...
            liste_grad_manq_txt,'v','g',7,aff_txt);
        %affichage points il manque un/des gradient(s) et un/des
        %reponse(s) au m�me point
        plottext(tirages(liste_both_manq,1),tirages(liste_both_manq,2),...
            liste_both_manq_txt,'d','r',7,aff_txt);
        hold off
        axis([(xmin-para*depx) (xmax+para*depx) (ymin-para*depy) (ymax+para*depy)])
        line([xmin;xmin;xmax;xmax;xmax;xmax;xmax;xmin],[ymin;ymax;ymax;ymax;ymax;ymin;ymin;ymin])
    else
        figure
        it=0;
        Depx=Xmax(:)'-Xmin(:)';
        for ii=1:nbv
            for jj=1:nbv
                it=it+1;
                if ii~=jj
                    subplot(nbv,nbv,it)
                    hold on
                    %affichage points ou toutes les infos sont connues
                    plottext(tirages(liste_pts_ok,ii),tirages(liste_pts_ok,jj),...
                        liste_pts_ok_txt,'o','k',7,aff_txt);
                    %affichage points il manque une/des reponse(s)
                    plottext(tirages(liste_eval_manq,ii),tirages(liste_eval_manq,jj),...
                        liste_eval_manq_txt,'rs','r',7,aff_txt);
                    %affichage points il manque un/des gradient(s)
                    plottext(tirages(liste_grad_manq,ii),tirages(liste_grad_manq,jj),...
                        liste_grad_manq_txt,'v','g',7,aff_txt);
                    %affichage points il manque un/des gradient(s) et un/des
                    %reponse(s) au m�me point
                    plottext(tirages(liste_both_manq,ii),tirages(liste_both_manq,jj),...
                        liste_both_manq_txt,'d','r',7,aff_txt);
                    hold off
                    xmin=Xmin(ii);xmax=Xmax(ii);ymin=Xmin(jj);ymax=Xmax(jj);depx=Depx(ii);depy=Depx(jj);
                    axis([(xmin-para*depx) (xmax+para*depx) (ymin-para*depy) (ymax+para*depy)])
                    line([xmin;xmin;xmax;xmax;xmax;xmax;xmax;xmin],[ymin;ymax;ymax;ymax;ymax;ymin;ymin;ymin])
                else
                    subplot(nbv,nbv,it)
                    hist(tirages(:,ii))
                    xmin=Xmin(ii);xmax=Xmax(ii);depx=Depx(ii);depy=Depx(jj);
                    xlim([(xmin-para*depx) (xmax+para*depx)])
                end
            end
        end
    end
end
end

function plottext(X,Y,TXT,markM,colorM,sizeM,txt_on)
plot(X,Y,...
    markM,'MarkerEdgeColor',colorM,...
    'MarkerFaceColor',colorM,...
    'MarkerSize',sizeM);
if txt_on
    text(X,Y,...
        TXT,'VerticalAlignment','bottom');
end
end
