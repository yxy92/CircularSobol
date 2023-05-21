% Toy_Model_Run.m
clear;


% construct the model
toy_model_4 = bbModel(@ToyModel_4,10,2,'OutputType',[1 1]);

% construct parameter distribution
uni_pd = makedist('Uniform','lower',0,'upper',2*pi);

params = repmat({uni_pd},10,1);  % Toy Model 1-3
%pd_list = repmat({pd},10,1); % Toy Model 4


% call CircularSobol
% tic
% % use nonCircular Sobol indices method
% [S1, ST] = CircularSobol(toy_model_1, params,'SampleSize',100,'formula',2);
% toc

tic
% use Circular Sobol indices method
[S1, ST] = CircularSobol(toy_model_4, params,'method','Circular','formula',1,...
                                    'SampleSize',100,'GroupNumber',100,'GroupSize',100);
toc