%     MultiDOE - Toolbox for sampling a bounded space
%     Copyright (C) 2016  Luc LAURENT <luc.laurent@lecnam.net>
%
% sources available here:
% https://bitbucket.org/luclaurent/multidoe/
% https://github.com/luclaurent/multidoe/
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

close all
init_rep
part=5;

nb_pt_min=5;
nb_pt_max=100;
nb_pt=nb_pt_min:5:nb_pt_max;

nb_iter=floor(linspace(1,50,7));
for dim_p=4
    for part=5
        dim_tir=dim_p;
        
        nb_tent=50;
        
        Xmin=-50;
        Xmax=100;
        
        doe.Xmin=Xmin*ones(1,dim_tir);
        doe.Xmax=Xmax*ones(1,dim_tir);
        doe.aff=false;
        
        type_tir={'LHS','LHS_R','IHS','IHS_R','GLHS_R',...
            'OLHS_R','MMLHS_R','LHS_O1',...
            'rand','LHSD','LHSD_NS','LHSD_MAXMIN',...
            'LHSD_CORRMIN','HALTON','SOBOL'};
        text_leg={'LHS','LHS R','IHS','IHS R','GLHS R',...
            'OLHS R','MMLHS R','LHS O1',...
            'rand','LHSD','LHSD NS','LHSD MAXMIN',...
            'LHSD CORRMIN','HALTON','SOBOL'};
        if part==1
            
            dminmin=zeros(numel(type_tir),numel(nb_pt));
            sumd=dminmin;recouv=dminmin;rapd=dminmin;avgd=dminmin;
            l2=dminmin;cl2=dminmin;ml2=dminmin;sl2=dminmin;wl2=dminmin;
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_pt)
                    doe.type=type_tir{ii};
                    doe.nb_samples=nb_pt(jj);
                    tirages=gene_doe(doe);
                    [uni,dispc]=score_doe(tirages);
                    dminmin(ii,jj)=uni.dist_min;
                    sumd(ii,jj)=uni.sum_dist;
                    recouv(ii,jj)=uni.recouv;
                    rapd(ii,jj)=uni.rap_dist;
                    avgd(ii,jj)=uni.avg_min_dist;
                    l2(ii,jj)=dispc.L2;
                    cl2(ii,jj)=dispc.CL2;
                    ml2(ii,jj)=dispc.ML2;
                    sl2(ii,jj)=dispc.SL2;
                    wl2(ii,jj)=dispc.WL2;
                end
            end
            save(['multi_doe_score_p1_' num2str(dim_tir) '.mat'])
            
            type_dess={'k','r','b','m','--k','--r','--b',...
                '--m','.-k','.-r','.-b','.-m',':k',':r',':b'};
            figure
            subplot(3,4,1)
            textleg=[];
            for ii=1:numel(type_tir)
                plot(nb_pt,dminmin(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('dist min')
            subplot(3,4,2)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,sumd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('Sum Inverse Dist')
            subplot(3,4,3)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,recouv(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('recouvrement')
            subplot(3,4,4)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,rapd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('Rapport dist')
            subplot(3,4,5)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,avgd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('Average min dist')
            subplot(3,4,6)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,l2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('L2 discrepancy')
            subplot(3,4,7)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,sl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('Symetric L2 discrepancy')
            subplot(3,4,8)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,cl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('Centered L2 discrepancy')
            subplot(3,4,9)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,ml2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('Modified L2 discrepancy')
            subplot(3,4,10)
            for ii=1:numel(type_tir)
                plot(nb_pt,wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('Wrap around L2 discrepancy')
            subplot(3,4,11)
            for ii=1:numel(type_tir)
                plot(nb_pt,ml2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            legend(text_leg)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif part==2
            dminmin=cell(numel(type_tir),numel(nb_pt));
            sumd=dminmin;recouv=dminmin;rapd=dminmin;avgd=dminmin;
            l2=dminmin;cl2=dminmin;ml2=dminmin;sl2=dminmin;wl2=dminmin;
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_pt)
                    for ll=1:nb_tent
                        doe.type=type_tir{ii};
                        doe.nb_samples=nb_pt(jj);
                        tirages=gene_doe(doe);
                        [uni,dispc]=score_doe(tirages);
                        dminmin{ii,jj}(ll)=uni.dist_min;
                        sumd{ii,jj}(ll)=uni.sum_dist;
                        recouv{ii,jj}(ll)=uni.recouv;
                        rapd{ii,jj}(ll)=uni.rap_dist;
                        avgd{ii,jj}(ll)=uni.avg_min_dist;
                        l2{ii,jj}(ll)=dispc.L2;
                        cl2{ii,jj}(ll)=dispc.CL2;
                        ml2{ii,jj}(ll)=dispc.ML2;
                        sl2{ii,jj}(ll)=dispc.SL2;
                        wl2{ii,jj}(ll)=dispc.WL2;
                    end
                end
            end
            moy_dminmin=zeros(numel(type_tir),numel(nb_pt));
            moy_sumd=moy_dminmin;moy_recouv=moy_dminmin;
            moy_rapd=moy_dminmin;moy_avgd=moy_dminmin;
            moy_l2=moy_dminmin;moy_cl2=moy_dminmin;
            moy_ml2=moy_dminmin;moy_sl2=moy_dminmin;
            moy_wl2=moy_dminmin;
            std_dminmin=moy_dminmin;
            std_sumd=moy_dminmin;std_recouv=moy_dminmin;
            std_rapd=moy_dminmin;std_avgd=moy_dminmin;
            std_l2=moy_dminmin;std_cl2=moy_dminmin;
            std_ml2=moy_dminmin;std_sl2=moy_dminmin;
            std_wl2=moy_dminmin;
            
            %calcul moyennes et écarts types
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_pt)
                    moy_dminmin(ii,jj)=mean(dminmin{ii,jj});
                    moy_sumd(ii,jj)=mean(sumd{ii,jj});
                    moy_recouv(ii,jj)=mean(recouv{ii,jj});
                    moy_rapd(ii,jj)=mean(rapd{ii,jj});
                    moy_avgd(ii,jj)=mean(avgd{ii,jj});
                    moy_l2(ii,jj)=mean(l2{ii,jj});
                    moy_cl2(ii,jj)=mean(cl2{ii,jj});
                    moy_ml2(ii,jj)=mean(ml2{ii,jj});
                    moy_sl2(ii,jj)=mean(sl2{ii,jj});
                    moy_wl2(ii,jj)=mean(wl2{ii,jj});
                    std_dminmin(ii,jj)=std(dminmin{ii,jj});
                    std_sumd(ii,jj)=std(sumd{ii,jj});
                    std_recouv(ii,jj)=std(recouv{ii,jj});
                    std_rapd(ii,jj)=std(rapd{ii,jj});
                    std_avgd(ii,jj)=std(avgd{ii,jj});
                    std_l2(ii,jj)=std(l2{ii,jj});
                    std_cl2(ii,jj)=std(cl2{ii,jj});
                    std_ml2(ii,jj)=std(ml2{ii,jj});
                    std_sl2(ii,jj)=std(sl2{ii,jj});
                    std_wl2(ii,jj)=std(wl2{ii,jj});
                    
                end
            end
            save(['multi_doe_score_p2_' num2str(dim_tir) '.mat'])
            
            type_dess={'k','r','b','m','--k','--r','--b',...
                '--m','.-k','.-r','.-b','.-m',':k',':r',':b'};
            figure
            subplot(3,4,1)
            textleg=[];
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_dminmin(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY dist min')
            subplot(3,4,2)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_sumd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Sum Inverse Dist')
            subplot(3,4,3)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_recouv(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY recouvrement')
            subplot(3,4,4)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_rapd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Rapport dist')
            subplot(3,4,5)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_avgd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Average min dist')
            subplot(3,4,6)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_l2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY L2 discrepancy')
            subplot(3,4,7)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_sl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Symetric L2 discrepancy')
            subplot(3,4,8)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_cl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Centered L2 discrepancy')
            subplot(3,4,9)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_ml2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Modified L2 discrepancy')
            subplot(3,4,10)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Wrap around L2 discrepancy')
            subplot(3,4,11)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,moy_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            legend(text_leg)
            
            %%%%%
            figure
            subplot(3,4,1)
            textleg=[];
            for ii=1:numel(type_tir)
                plot(nb_pt,std_dminmin(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD dist min')
            subplot(3,4,2)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_sumd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Sum Inverse Dist')
            subplot(3,4,3)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_recouv(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD recouvrement')
            subplot(3,4,4)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_rapd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Rapport dist')
            subplot(3,4,5)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_avgd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Average min dist')
            subplot(3,4,6)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_l2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD L2 discrepancy')
            subplot(3,4,7)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_sl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Symetric L2 discrepancy')
            subplot(3,4,8)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_cl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Centered L2 discrepancy')
            subplot(3,4,9)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_ml2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Modified L2 discrepancy')
            subplot(3,4,10)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Wrap around L2 discrepancy')
            subplot(3,4,11)
            
            for ii=1:numel(type_tir)
                plot(nb_pt,std_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            legend(text_leg)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif part==3
            type_tir={'LHSD','LHSD_NS','LHSD_MAXMIN',...
                'LHSD_CORRMIN'};
            text_leg={'LHSD','LHSD NS','LHSD MAXMIN',...
                'LHSD CORRMIN'};
            type_dess={'k','r','b','m','--k','--r','--b',...
                '--m','.-k','.-r','.-b','.-m',':k',':r',':b'};
            
            legendCell = cellstr(num2str(nb_iter', 'N=%d'));
            dminmin=cell(numel(type_tir),numel(nb_iter));
            sumd=dminmin;recouv=dminmin;rapd=dminmin;avgd=dminmin;
            l2=dminmin;cl2=dminmin;ml2=dminmin;sl2=dminmin;
            wl2=dminmin;
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_iter)
                    for ll=1:numel(nb_pt)
                        doe.type=type_tir{ii};
                        doe.nb_samples=nb_pt(ll);
                        doe.iter=nb_iter(jj);
                        tirages=gene_doe(doe);
                        [uni,dispc]=score_doe(tirages);
                        dminmin{ii,jj}(ll)=uni.dist_min;
                        sumd{ii,jj}(ll)=uni.sum_dist;
                        recouv{ii,jj}(ll)=uni.recouv;
                        rapd{ii,jj}(ll)=uni.rap_dist;
                        avgd{ii,jj}(ll)=uni.avg_min_dist;
                        l2{ii,jj}(ll)=dispc.L2;
                        cl2{ii,jj}(ll)=dispc.CL2;
                        ml2{ii,jj}(ll)=dispc.ML2;
                        sl2{ii,jj}(ll)=dispc.SL2;
                        wl2{ii,jj}(ll)=dispc.WL2;
                    end
                end
            end
            save(['multi_doe_score_p3_' num2str(dim_tir) '.mat'])
            for ii=1:numel(type_tir)
                figure('Name',type_tir{ii})
                subplot(3,4,1)
                textleg=[];
                for jj=1:numel(nb_iter)
                    plot(nb_pt,dminmin{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('dist min')
                subplot(3,4,2)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,sumd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('Sum Inverse Dist')
                subplot(3,4,3)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,recouv{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('recouvrement')
                subplot(3,4,4)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,rapd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                title('Rapport dist')
                subplot(3,4,5)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,avgd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('Average min dist')
                subplot(3,4,6)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,l2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('L2 discrepancy')
                subplot(3,4,7)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,sl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('Symetric L2 discrepancy')
                subplot(3,4,8)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,cl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('Centered L2 discrepancy')
                subplot(3,4,9)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,ml2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                title('Modified L2 discrepancy')
                subplot(3,4,10)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,wl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('wrap around L2 discrepancy')
                subplot(3,4,11)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,wl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                legend(legendCell)
                
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif part==4
            type_tir={'LHSD','LHSD_NS','LHSD_MAXMIN',...
                'LHSD_CORRMIN'};
            text_leg={'LHSD','LHSD NS','LHSD MAXMIN',...
                'LHSD CORRMIN'};
            type_dess={'k','r','b','m','--k','--r','--b',...
                '--m','.-k','.-r','.-b','.-m',':k',':r',':b'};
            
            legendCell = cellstr(num2str(nb_iter', 'N=%d'));
            dminmin=cell(numel(type_tir),numel(nb_iter));
            sumd=dminmin;recouv=dminmin;rapd=dminmin;avgd=dminmin;
            l2=dminmin;cl2=dminmin;ml2=dminmin;sl2=dminmin;
            wl2=dminmin;
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_iter)
                    for ll=1:numel(nb_pt)
                        for kk=1:nb_tent
                            doe.type=type_tir{ii};
                            doe.nb_samples=nb_pt(ll);
                            doe.iter=nb_iter(jj);
                            tirages=gene_doe(doe);
                            [uni,dispc]=score_doe(tirages);
                            dminmin{ii,jj}(ll,kk)=uni.dist_min;
                            sumd{ii,jj}(ll,kk)=uni.sum_dist;
                            recouv{ii,jj}(ll,kk)=uni.recouv;
                            rapd{ii,jj}(ll,kk)=uni.rap_dist;
                            avgd{ii,jj}(ll,kk)=uni.avg_min_dist;
                            l2{ii,jj}(ll,kk)=dispc.L2;
                            cl2{ii,jj}(ll,kk)=dispc.CL2;
                            ml2{ii,jj}(ll,kk)=dispc.ML2;
                            sl2{ii,jj}(ll,kk)=dispc.SL2;
                            wl2{ii,jj}(ll,kk)=dispc.WL2;
                        end
                    end
                end
            end
            moy_dminmin=cell(numel(type_tir),numel(nb_pt));
            moy_sumd=moy_dminmin;moy_recouv=moy_dminmin;
            moy_rapd=moy_dminmin;moy_avgd=moy_dminmin;
            moy_l2=moy_dminmin;moy_cl2=moy_dminmin;
            moy_ml2=moy_dminmin;moy_sl2=moy_dminmin;
            moy_wl2=moy_dminmin;
            std_dminmin=moy_dminmin;
            std_sumd=moy_dminmin;std_recouv=moy_dminmin;
            std_rapd=moy_dminmin;std_avgd=moy_dminmin;
            std_l2=moy_dminmin;std_cl2=moy_dminmin;
            std_ml2=moy_dminmin;std_sl2=moy_dminmin;
            std_wl2=moy_dminmin;
            
            %calcul moyennes et écarts types
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_iter)
                    for ll=1:numel(nb_pt)
                        moy_dminmin{ii,jj}(ll)=mean(dminmin{ii,jj}(ll,:));
                        moy_sumd{ii,jj}(ll)=mean(sumd{ii,jj}(ll,:));
                        moy_recouv{ii,jj}(ll)=mean(recouv{ii,jj}(ll,:));
                        moy_rapd{ii,jj}(ll)=mean(rapd{ii,jj}(ll,:));
                        moy_avgd{ii,jj}(ll)=mean(avgd{ii,jj}(ll,:));
                        moy_l2{ii,jj}(ll)=mean(l2{ii,jj}(ll,:));
                        moy_cl2{ii,jj}(ll)=mean(cl2{ii,jj}(ll,:));
                        moy_ml2{ii,jj}(ll)=mean(ml2{ii,jj}(ll,:));
                        moy_sl2{ii,jj}(ll)=mean(sl2{ii,jj}(ll,:));
                        moy_wl2{ii,jj}(ll)=mean(wl2{ii,jj}(ll,:));
                        std_dminmin{ii,jj}(ll)=std(dminmin{ii,jj}(ll,:));
                        std_sumd{ii,jj}(ll)=std(sumd{ii,jj}(ll,:));
                        std_recouv{ii,jj}(ll)=std(recouv{ii,jj}(ll,:));
                        std_rapd{ii,jj}(ll)=std(rapd{ii,jj}(ll,:));
                        std_avgd{ii,jj}(ll)=std(avgd{ii,jj}(ll,:));
                        std_l2{ii,jj}(ll)=std(l2{ii,jj}(ll,:));
                        std_cl2{ii,jj}(ll)=std(cl2{ii,jj}(ll,:));
                        std_ml2{ii,jj}(ll)=std(ml2{ii,jj}(ll,:));
                        std_sl2{ii,jj}(ll)=std(sl2{ii,jj}(ll,:));
                        std_wl2{ii,jj}(ll)=std(wl2{ii,jj}(ll,:));
                    end
                end
            end
            
            
            save(['multi_doe_score_p4_' num2str(dim_tir) '.mat'])
            for ii=1:numel(type_tir)
                figure('Name',type_tir{ii})
                subplot(3,4,1)
                textleg=[];
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_dminmin{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY dist min')
                subplot(3,4,2)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_sumd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY Sum Inverse Dist')
                subplot(3,4,3)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_recouv{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY recouvrement')
                subplot(3,4,4)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_rapd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                title('MOY Rapport dist')
                subplot(3,4,5)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_avgd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY Average min dist')
                subplot(3,4,6)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_l2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY L2 discrepancy')
                subplot(3,4,7)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_sl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY Symetric L2 discrepancy')
                subplot(3,4,8)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_cl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY Centered L2 discrepancy')
                subplot(3,4,9)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_ml2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                title('MOY Modified L2 discrepancy')
                subplot(3,4,10)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_wl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('MOY wrap around L2 discrepancy')
                subplot(3,4,11)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,moy_wl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                legend(legendCell)
                
            end
            for ii=1:numel(type_tir)
                figure('Name',type_tir{ii})
                subplot(3,4,1)
                textleg=[];
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_dminmin{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD dist min')
                subplot(3,4,2)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_sumd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD Sum Inverse Dist')
                subplot(3,4,3)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_recouv{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD recouvrement')
                subplot(3,4,4)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_rapd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                title('STD Rapport dist')
                subplot(3,4,5)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_avgd{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD Average min dist')
                subplot(3,4,6)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_l2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD L2 discrepancy')
                subplot(3,4,7)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_sl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD Symetric L2 discrepancy')
                subplot(3,4,8)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_cl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD Centered L2 discrepancy')
                subplot(3,4,9)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_ml2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                title('STD Modified L2 discrepancy')
                subplot(3,4,10)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_wl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                
                title('STD wrap around L2 discrepancy')
                subplot(3,4,11)
                
                for jj=1:numel(nb_iter)
                    plot(nb_pt,std_wl2{ii,jj},type_dess{jj},'LineWidth',2);
                    hold on
                end
                legend(legendCell)
                
            end
        elseif part==5
            type_tir={'LHSD','LHSD_NS','LHSD_MAXMIN',...
                'LHSD_CORRMIN'};
            text_leg={'LHSD','LHSD NS','LHSD MAXMIN',...
                'LHSD CORRMIN'};
            type_dess={'k','r','b','m','--k','--r','--b',...
                '--m','.-k','.-r','.-b','.-m',':k',':r',':b'};
            nb_iter=1:20;
            nb_pt=50;
            nb_tent=50;
            
            dminmin=cell(numel(type_tir),numel(nb_iter));
            sumd=dminmin;recouv=dminmin;rapd=dminmin;avgd=dminmin;
            l2=dminmin;cl2=dminmin;ml2=dminmin;sl2=dminmin;
            wl2=dminmin;
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_iter)
                    for ll=1:numel(nb_pt)
                        for kk=1:nb_tent
                            doe.type=type_tir{ii};
                            doe.nb_samples=nb_pt(ll);
                            doe.iter=nb_iter(jj);
                            tirages=gene_doe(doe);
                            [uni,dispc]=score_doe(tirages);
                            dminmin{ii,jj}(ll,kk)=uni.dist_min;
                            sumd{ii,jj}(ll,kk)=uni.sum_dist;
                            recouv{ii,jj}(ll,kk)=uni.recouv;
                            rapd{ii,jj}(ll,kk)=uni.rap_dist;
                            avgd{ii,jj}(ll,kk)=uni.avg_min_dist;
                            l2{ii,jj}(ll,kk)=dispc.L2;
                            cl2{ii,jj}(ll,kk)=dispc.CL2;
                            ml2{ii,jj}(ll,kk)=dispc.ML2;
                            sl2{ii,jj}(ll,kk)=dispc.SL2;
                            wl2{ii,jj}(ll,kk)=dispc.WL2;
                        end
                    end
                end
            end
            moy_dminmin=zeros(numel(type_tir),numel(nb_pt));
            moy_sumd=moy_dminmin;moy_recouv=moy_dminmin;
            moy_rapd=moy_dminmin;moy_avgd=moy_dminmin;
            moy_l2=moy_dminmin;moy_cl2=moy_dminmin;
            moy_ml2=moy_dminmin;moy_sl2=moy_dminmin;
            moy_wl2=moy_dminmin;
            std_dminmin=moy_dminmin;
            std_sumd=moy_dminmin;std_recouv=moy_dminmin;
            std_rapd=moy_dminmin;std_avgd=moy_dminmin;
            std_l2=moy_dminmin;std_cl2=moy_dminmin;
            std_ml2=moy_dminmin;std_sl2=moy_dminmin;
            std_wl2=moy_dminmin;
            
            %calcul moyennes et écarts types
            for ii=1:numel(type_tir)
                for jj=1:numel(nb_iter)
                    moy_dminmin(ii,jj)=mean(dminmin{ii,jj}(:));
                    moy_sumd(ii,jj)=mean(sumd{ii,jj}(:));
                    moy_recouv(ii,jj)=mean(recouv{ii,jj}(:));
                    moy_rapd(ii,jj)=mean(rapd{ii,jj}(:));
                    moy_avgd(ii,jj)=mean(avgd{ii,jj}(:));
                    moy_l2(ii,jj)=mean(l2{ii,jj}(:));
                    moy_cl2(ii,jj)=mean(cl2{ii,jj}(:));
                    moy_ml2(ii,jj)=mean(ml2{ii,jj}(:));
                    moy_sl2(ii,jj)=mean(sl2{ii,jj}(:));
                    moy_wl2(ii,jj)=mean(wl2{ii,jj}(:));
                    std_dminmin(ii,jj)=std(dminmin{ii,jj}(:));
                    std_sumd(ii,jj)=std(sumd{ii,jj}(:));
                    std_recouv(ii,jj)=std(recouv{ii,jj}(:));
                    std_rapd(ii,jj)=std(rapd{ii,jj}(:));
                    std_avgd(ii,jj)=std(avgd{ii,jj}(:));
                    std_l2(ii,jj)=std(l2{ii,jj}(:));
                    std_cl2(ii,jj)=std(cl2{ii,jj}(:));
                    std_ml2(ii,jj)=std(ml2{ii,jj}(:));
                    std_sl2(ii,jj)=std(sl2{ii,jj}(:));
                    std_wl2(ii,jj)=std(wl2{ii,jj}(:));
                end
                
            end
            
            
            save(['multi_doe_score_p5_' num2str(dim_tir) '.mat'])
            figure('Name',['Dim ' num2str(dim_p) ' - Nb points ' num2str(nb_pt)])
            subplot(3,4,1)
            for ii=1:numel(type_tir)
                textleg=[];
                plot(nb_iter,moy_dminmin(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY dist min')
            subplot(3,4,2)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_sumd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY Sum Inverse Dist')
            subplot(3,4,3)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_recouv(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY recouvrement')
            subplot(3,4,4)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_rapd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Rapport dist')
            subplot(3,4,5)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_avgd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY Average min dist')
            subplot(3,4,6)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_l2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY L2 discrepancy')
            subplot(3,4,7)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_sl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY Symetric L2 discrepancy')
            subplot(3,4,8)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_cl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY Centered L2 discrepancy')
            subplot(3,4,9)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_ml2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('MOY Modified L2 discrepancy')
            subplot(3,4,10)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('MOY wrap around L2 discrepancy')
            subplot(3,4,11)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,moy_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            legend(text_leg)
            
            
            figure('Name',['Dim ' num2str(dim_p) ' - Nb points ' num2str(nb_pt)])
            subplot(3,4,1)
            textleg=[];
            for ii=1:numel(type_tir)
                plot(nb_iter,std_dminmin(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD dist min')
            subplot(3,4,2)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_sumd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD Sum Inverse Dist')
            subplot(3,4,3)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_recouv(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD recouvrement')
            subplot(3,4,4)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_rapd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Rapport dist')
            subplot(3,4,5)
            
            for jj=1:numel(nb_iter)
                plot(nb_iter,std_avgd(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD Average min dist')
            subplot(3,4,6)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_l2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD L2 discrepancy')
            subplot(3,4,7)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_sl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD Symetric L2 discrepancy')
            subplot(3,4,8)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_cl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD Centered L2 discrepancy')
            subplot(3,4,9)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_ml2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            title('STD Modified L2 discrepancy')
            subplot(3,4,10)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            
            title('STD wrap around L2 discrepancy')
            subplot(3,4,11)
            
            for ii=1:numel(type_tir)
                plot(nb_iter,std_wl2(ii,:),type_dess{ii},'LineWidth',2);
                hold on
            end
            legend(text_leg)
            
            
            
        end
    end
end
