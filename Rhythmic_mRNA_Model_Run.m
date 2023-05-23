% Rhythmic_mRNA_Model_Run.m
% Circular Sobol indices for a model of rhythmic mRNA expression by Sarah Luck et al. 2012


clear;

% construct the Sarah_Rhythmic_mRNA model
Rhythmic_mRNA_model = bbModel(@Sarah_Rhythmic_mRNA,5,3,'OutputType',[0 0 1]);

% create parameter distribution
size = 10000;

amp_pd = makedist('Uniform','lower',0,'upper',1);
phase_pd = makedist('Uniform','lower',0,'upper',24);

Kd_pd_log= makedist('Uniform','lower',-1.58,'upper',1.415);
Kd_pd = 10.^random(Kd_pd_log,[size,1]);

params = {amp_pd phase_pd Kd_pd amp_pd phase_pd};


% call CircularSobol
tic
disp('Start running Sarah_Rhythmic_mRNA model');
% use nonCircular Sobol indices method

[S1, ST] = CircularSobol(Rhythmic_mRNA_model, params,'method','nonCircular','SampleSize',10^3,'formula',2,...
                                                            'GroupNumber',10^3,'GroupSize',10^3);
toc