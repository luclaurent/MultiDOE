%%%Fichier d'étude des plans d'expérience à deux variables de conception
%L LAURENT   --  05/03/2010   --  luc.laurent@ens-cachan.fr
clf;clc;close all; clear all;
addpath('lhs');
%%type de plan d'expérience
%plan factoriel: 'factorial_design'
%Latin Hypercube Sampling from uniform distribution: 'LHSU'
%Latin Hypercube Sampling from normal distribution: 'LHSN' 
%Box Behnken Design: BBD
%Central Composite Design: CCD
%Combined Design: CD
%Quasi Random Design: QRD
%Random Design: RD
doe.type='factorial_design';  


%nombre de tirages selon x1, x2 et/ou x3 ou total (LHS)
doe.nb_x1=10;
doe.nb_x2=10;
doe.nb_samples=25; %(LHS,BBD)
%nombre de variables
doe.nb_var=2; %(LHSN,BBD)
%valeurs moyennes des variables (LHSN)
doe.x1_mean=0;
doe.x2_mean=1;
%écart-type (LHSN)
doe.x1_sd=0.8;
doe.x2_sd=1;

%valeurs min et max
doe.x1_min=-2;
doe.x2_min=-1;
doe.x1_max=2;
doe.x2_max=3;





switch doe.type
    case 'factorial_design'
        tirages=factorial_design(doe.nb_x1,doe.nb_x2,doe.x1_min,doe.x1_max,doe.x2_min,doe.x2_max);
    case 'LHSU'
        xmin=[doe.x1_min,doe.x2_min];
        xmax=[doe.x1_max,doe.x2_max];
        tirages=lhsu(xmin,xmax,doe.nb_samples);
    case 'LHSN'
        xmean=[doe.x1_mean,doe.x2_mean];
        xsd=[doe.x1_sd,doe.x2_sd];
        tirages=latin_hs(xmean,xsd,doe.nb_samples,doe.nb_var);
    case 'BBD'
        range=[doe.x1_min doe.x1_max;doe.x2_min doe.x2_max];
        tirages=box_behnken(doe.nb_var,doe.nb_samples,range);
        tirages=tirages';
        
end


if(doe.nb_var==2)
    disp('Dimension 2');
    plot(tirages(:,1),tirages(:,2),'.')
elseif (doe.nb_var==3)
    disp('Dimension 3');
    plot3(tirages(:,1),tirages(:,2),tirages(:,3),'.')
else
    disp('Mauvaise dimension');
end


