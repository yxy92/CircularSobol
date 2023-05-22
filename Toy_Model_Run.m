% Toy_Model_Run.m
clear;


% construct the toy models
toy_model_1 = bbModel(@ToyModel_1,3,2,'OutputType',[1 1]);
toy_model_2 = bbModel(@ToyModel_2,3,2,'OutputType',[1 1]);
toy_model_3 = bbModel(@ToyModel_3,3,2,'OutputType',[1 1]);
toy_model_4 = bbModel(@ToyModel_4,10,2,'OutputType',[1 1]);

% construct parameter distribution
uni_pd = makedist('Uniform','lower',0,'upper',2*pi);

params_1 = repmat({uni_pd},3,1); % Toy Model 1-3
params_2 = repmat({uni_pd},10,1);  % Toy Model 4

% call CircularSobol
tic
disp('Start running of toy models');
% use nonCircular Sobol indices method
disp('')
[S1, ST] = CircularSobol(toy_model_2, params_1,'method','nonCircular','SampleSize',10^4,'formula',1,...
                                                            'GroupNumber',10^2,'GroupSize',10^2);
toc


% tic
% disp('Start running of toy model 4');
% % use Circular Sobol indices method
% [S1, ST] = CircularSobol(toy_model_4, params_2,'method','Circular','formula',1,...
%                                     'SampleSize',100,'GroupNumber',100,'GroupSize',100);
% toc