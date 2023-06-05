% Rhythmic_polyA_Model_Run.m


clear;

% construct the rhythmic polyA model
Rhythmic_polyA_model = bbModel(@XY_Rhythmic_polyA_Model,11,15,'OutputType',[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]);

% 1. Create Parameter Distribution

% create distribution for input paramters
Amp_pd = makedist('Uniform','lower',0,'upper',1);
Phase_pd = makedist('Uniform','lower',0,'upper',24);

% create parameter sample for rate constants
size = 100000;

Kdgrd_pd_log= makedist('Normal','mu',-1.1,'sigma',.23);
Kdgrd_pd = 10.^random(Kdgrd_pd_log,[size,1]);

KdeA_pd_log= makedist('Normal','mu',-.48,'sigma',.23);
KdeA_pd = 10.^random(KdeA_pd_log,[size,1]);

KpolyA_pd_log= makedist('Normal','mu',-.48,'sigma',.23);
KpolyA_pd = 10.^random(KpolyA_pd_log,[size,1]);

params = {Amp_pd Phase_pd KdeA_pd Amp_pd Phase_pd KpolyA_pd Amp_pd Phase_pd Kdgrd_pd Amp_pd Phase_pd};

% call CircularSobol
tStart = tic;
disp('Start running XY_Rhythmic_polyA model');

[S1, ST] = CircularSobol(Rhythmic_polyA_model, params,'method','Circular','SampleSize',10^5,'formula',1,...
                                                            'GroupNumber',10^2,'GroupSize',10^3,'plot',1);
tEnd = toc(tStart);
fprintf('The running took %s \n', duration([0, 0, tEnd]));