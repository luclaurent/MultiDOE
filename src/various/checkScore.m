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

%test score
clear all
close all

Xmin=0;
Xmax=1;

nbt=100;

dim=2;

if dim==1
    
    
    for ii=0:nbt
        tir=[Xmin Xmin+ii/nbt*(Xmax-Xmin)  Xmax]';
        [uni,dispc]=score_doe(tir);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
        morris(ii+1)=uni.morris;
    end
    figure
    subplot(341)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(342)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(343)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(344)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(345)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(346)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(347)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(348)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(349)
    plot(0:nbt,sumd,'k')
    title('sum invers dist')
        subplot(3410)
    plot(0:nbt,morris,'k')
    title('morris')
    
    
elseif dim==2
    conf1=[1,0;0,1;-1,0;0,-1];
    conf2=[1 1;-1 1;-1 -1;1 -1];
    conf3=[conf2;0,0];
    Xmax=4;
    %%%%% conf1
    %cas1
    for ii=0:nbt
        conft=conf1;
        conft(2,2)=conft(2,2)-1+ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
        morris(ii+1)=uni.morris;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
         subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'.r')
    line([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'Color','r','LineWidth',2)
    %cas2
    
    for ii=0:nbt
        conft=conf1;
        conft(2,2)=conft(2,2)-1+ii/nbt*Xmax;
        conft(4,2)=conft(4,2)+1-ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
        morris(ii+1)=uni.morris;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
         subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'.r')
    plot([conf1(2,1);conft(4,1)],[conf1(4,2);conft(4,2)],'.r')
    line([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'Color','r','LineWidth',2)
    line([conf1(4,1);conft(4,1)],[conf1(4,2);conft(4,2)],'Color','r','LineWidth',2)
    
    %cas3
    
    for ii=0:nbt
        conft=conf1;
        conft(2,1)=conft(2,1)-ii/nbt*Xmax;
        conft(4,1)=conft(4,1)-ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
         subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'.r')
    plot([conf1(2,1);conft(4,1)],[conf1(4,2);conft(4,2)],'.r')
    line([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'Color','r','LineWidth',2)
    line([conf1(4,1);conft(4,1)],[conf1(4,2);conft(4,2)],'Color','r','LineWidth',2)
    %cas4
    
    for ii=0:nbt
        conft=conf1;
        conft(2,1)=conft(2,1)-ii/nbt*Xmax;
        conft(4,1)=conft(4,1)+ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
     subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
         subplot(3,4,11)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'.r')
    plot([conf1(2,1);conft(4,1)],[conf1(4,2);conft(4,2)],'.r')
    line([conf1(2,1);conft(2,1)],[conf1(2,2);conft(2,2)],'Color','r','LineWidth',2)
    line([conf1(4,1);conft(4,1)],[conf1(4,2);conft(4,2)],'Color','r','LineWidth',2)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% conf2
    %cas1
    for ii=0:nbt
        conft=conf2;
        conft(1,1)=conft(1,1)-1+ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
     subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf2(1,1)-1;conft(1,1)],[conf2(1,2);conft(1,2)],'.r')
    line([conf2(1,1)-1;conft(1,1)],[conf2(1,2);conft(1,2)],'Color','r','LineWidth',2)
    
    
    %cas2
    
    for ii=0:nbt
        conft=conf2;
        conft(1,1)=conft(1,1)-1+ii/nbt*Xmax;
        conft(3,1)=conft(3,1)+1-ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
     subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf2(1,1)-1;conft(1,1)],[conf2(1,2);conft(1,2)],'.r')
    plot([conf2(3,1)+1;conft(3,1)],[conf2(3,2);conft(3,2)],'.r')
    line([conf2(1,1)-1;conft(1,1)],[conf2(1,2);conft(1,2)],'Color','r','LineWidth',2)
    line([conf2(3,1)+1;conft(3,1)],[conf2(3,2);conft(3,2)],'Color','r','LineWidth',2)
    
    %cas3
    
    for ii=0:nbt
        conft=conf2;
        conft(1,1)=conft(1,1)-1+ii/nbt*Xmax;
        conft(1,2)=conft(1,2)-1+ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
     subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf2(1,1)-1;conft(1,1)],[conf2(1,2)-1;conft(1,2)],'.r')
    line([conf2(1,1)-1;conft(1,1)],[conf2(1,2)-1;conft(1,2)],'Color','r','LineWidth',2)
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%% conf3
    %cas1
    for ii=0:nbt
        conft=conf3;
        conft(1,1)=conft(1,1)-1+ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
     subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf3(1,1)-1;conft(1,1)],[conf3(1,2);conft(1,2)],'.r')
    line([conf3(1,1)-1;conft(1,1)],[conf3(1,2);conft(1,2)],'Color','r','LineWidth',2)
    
    
    %cas2
    
    for ii=0:nbt
        conft=conf3;
        conft(1,1)=conft(1,1)-1+ii/nbt*Xmax;
        conft(3,1)=conft(3,1)+1-ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
     subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf3(1,1)-1;conft(1,1)],[conf3(1,2);conft(1,2)],'.r')
    plot([conf3(3,1)+1;conft(3,1)],[conf3(3,2);conft(3,2)],'.r')
    line([conf3(1,1)-1;conft(1,1)],[conf3(1,2);conft(1,2)],'Color','r','LineWidth',2)
    line([conf3(3,1)+1;conft(3,1)],[conf3(3,2);conft(3,2)],'Color','r','LineWidth',2)
    
    %cas3
    
    for ii=0:nbt
        conft=conf3;
        conft(1,1)=conft(1,1)-1+ii/nbt*Xmax;
        conft(1,2)=conft(1,2)-1+ii/nbt*Xmax;
         [uni,dispc]=score_doe(conft);
        
        dminmin(ii+1)=uni.dist_min;
        sumd(ii+1)=uni.sum_dist;
        recouv(ii+1)=uni.recouv;
        rapd(ii+1)=uni.rap_dist;
        avgd(ii+1)=uni.avg_min_dist;
        l2(ii+1)=dispc.L2;
        cl2(ii+1)=dispc.CL2;
        ml2(ii+1)=dispc.ML2;
        sl2(ii+1)=dispc.SL2;
    end
    figure
    subplot(3,4,1)
    plot(0:nbt,l2,'k')
    title('L2')
    subplot(3,4,2)
    plot(0:nbt,cl2,'k')
    title('CL2')
    subplot(3,4,3)
    plot(0:nbt,ml2,'k')
    title('ML2')
    subplot(3,4,4)
    plot(0:nbt,sl2,'k')
    title('SL2')
    subplot(3,4,5)
    plot(0:nbt,dminmin,'k')
    title('Dist min')
    subplot(3,4,6)
    plot(0:nbt,recouv,'k')
    title('recouv')
    subplot(3,4,7)
    plot(0:nbt,rapd,'k')
    title('rap dist')
    subplot(3,4,8)
    plot(0:nbt,avgd,'k')
    title('avg min dist')
    subplot(3,4,9)
    plot(0:nbt,sumd,'k')
     title('sum inverse dist')
     subplot(3,4,10)
    plot(0:nbt,morris,'k')
     title('morris')
    subplot(3,4,11)
    plot(conft(:,1),conft(:,2),'.b')
    hold on
    plot([conf3(1,1)-1;conft(1,1)],[conf3(1,2)-1;conft(1,2)],'.r')
    line([conf3(1,1)-1;conft(1,1)],[conf3(1,2)-1;conft(1,2)],'Color','r','LineWidth',2)
    
    
end


