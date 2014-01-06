x1_min=-2;
x1_max=2;
x2_min=-1;
x2_max=3;

tirages=ccdesign(2);


tirages(:,1)=x1_max*tirages(:,1);
tirages(:,2)=(x2_max-x2_min)/2*tirages(:,2)+(x2_max+x2_min)/2;