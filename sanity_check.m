% sanity_check.m

clear;
clc;
% sampling parameter
Rhythmic_mRNA_model = bbModel(@Sarah_Rhythmic_mRNA,5,3,'OutputType',[0 0 0]);

p = 4; % group number
q = 10; % group size
d = 5; % number of parameters 
index = 2;

% create parameter distribution
size = 10000;

amp_pd = makedist('Uniform','lower',0,'upper',1);
phase_pd = makedist('Uniform','lower',0,'upper',24);

Kd_pd_log= makedist('Uniform','lower',-1.58,'upper',1.415);
Kd_pd = 10.^random(Kd_pd_log,[size,1]);

params = {amp_pd phase_pd Kd_pd amp_pd phase_pd};

%% parameter sampling

% unit cube 
[SingleCube,TotalCube] = generate_Nested_cube(p,q,d,index);

figure;
for j=1:p
   subplot(2,1,1)
   plot(1:q,SingleCube(j,:,index)','-x');
   hold on; 
   xlim([0 q+1]);
   ylim([0 1])
   title('Single Unit cube')
end    


for j=1:p
   subplot(2,1,2)
   plot(1:q,TotalCube(j,:,index)','-x');
   hold on; 
   xlim([0 q+1]);
   ylim([0 1])
   title('Total Unit cube')
end    

%% parameter space
[SinglePar,TotalPar] = generate_Nested_Parameter(params,p,q,d,index);

figure;
for j=1:p
   subplot(2,2,1)
   plot(1:q,SinglePar(j,:,index)','-x');
   hold on; 
   xlim([0 q+1]);  
   title('Single ith parameter')
   
   subplot(2,2,2)
   plot(1:q,TotalPar(j,:,index)','-x');
   hold on; 
   xlim([0 q+1]);
   title('Total ith parameter')
   
   subplot(2,2,3)
   plot(1:q,SinglePar(j,:,index+1)','-x');
   hold on; 
   xlim([0 q+1]);
   title('Total i+1 th parameter')
   
   subplot(2,2,4)
   plot(1:q,TotalPar(j,:,index+1)','-x');
   hold on; 
   xlim([0 q+1]);
   title('Total i+1 th parameter')
   
   
end    

% 