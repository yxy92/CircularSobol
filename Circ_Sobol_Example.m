% an example of using CircularSobol
% Circ_Sobol_Example.m

clear;

% construct input arguments for toy model 1
pd = makedist('Uniform','lower',0,'upper',2*pi);
pd_list = repmat({pd},3,1);


toymodel_1 = bbModel(@ToyModel_1,pd_list);
params = ParSpace()

% Toy Model 1
[S1, ST] = CircularSobol(toymodel_1, params, varargin);

