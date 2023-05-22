# CircularSobol
<span style="color:black;font-weight:200;font-size:20px">
CircularSobol is a computational tool that calculates the circular Sobol indices 
tailored for oscillation models.
</span>

## Circular statistics Vs Non-circular statistics
<span style="color:black;font-weight:200;font-size:20px">
Angles by their nature have no maximum nor minimum values, therefore circular mean 
and circular variance are differently defined from their counterpart in 
non-circular statistics.
</span>

<img src="Circular_noncircular_Statistics.png"  width="800" height="200">



## Sobol indices
<span style="color:black;font-weight:200;font-size:20px">
Sobol's method or Sobol indices, is a global sensitivity analysis based on the decomposition of variance 
(orginal paper: I. M. Sobol′, 2001).
</span>

<img src="Sobolindices.png"  width="600" height="600">


## Circular Sobol indices for oscillation models
<span style="color:black;font-weight:200;font-size:20px">
CircularSobol combines the parameter sampling scheme from the Monte Carlo estimate algorithms
in the original Sobol's method and the definition of circular variance to more
accurately quantify the contribution of individual parameters to the variance in circular model
output.
</span>

<pre><code>
% MATLAB code (try run Toy_Model_Run.m in MATLAB)
% Example of calculating Sobol indices for toy models 

% 1st step: build a model using bbModel class

% check ToyModel_1.m
% ToyModel_1 
%     input -> double array of angles, [x1 x2 x3]
%     output -> double array of angles, [y1 y2]

% class bbModel 
%    input -> Function Handle
%          -> scalar, number of inputs
%          -> scalar, number of outputs
%          -> optional name-value pair, 'OutputType', boolean array
%             1:Circular, 0: non-Circular, default:[0...0]
                                       
toy_model_1 = bbModel(@ToyModel_1,3,2,'OutputType',[1 1]);

% 2nd step: define the parameter space of your model
% Use MATLAB built-in 'makedist' function or your own datasets

uni_pd = makedist('Uniform','lower',0,'upper',2*pi);
params_1 = repmat({uni_pd},3,1); % Toy Model 1-3

% 3rd step call the CircularSobol estimator of Sobol indices

% call CircularSobol (check argument syntax in CircularSobol.m)
tic
disp('Start running of toy models');
% use Circular Sobol indices method
% try use different formula, SampleSize, GroupNumber, GroupSize

[S1, ST] = CircularSobol(toy_model_1, params_1,'method','Circular','SampleSize',10^5,'formula',1,...
                                                            'GroupNumber',10^3,'GroupSize',10^3);
toc

</code></pre>
