% the main function that is called to calculate the circular Sobol indices
% for a mathematical model involving perodic quantities

% CircularSobol.m
% input -> model: bbModel object  
%       -> params : ParSpace object
%               
% output -> [S1, ST]
%        
%
%         -> S1: single Sobol indices matrix
%         -> ST: total Sobol indices matrix

function [S1, ST] = CircularSobol(model, params, varargin)

 % Check inputs
      if nargin < 2
          error('CircularSobol:NotEnoughInputs','There are not enough arguments for CircularSobol');
      end  
      
 % parse input arguments
     
     defaultPlot = 0;
     defaultProgress = 0;
     defaultMethod = 'Saltelli'; % AB sampling method, check wikipedia page of global sensitivity analysis
     defaultFormula = 1;
     defaultSampleSize = 10^5;
     defaultGroupNumber = 10^2;
     defaultGroupSize = 10^3;


     p = inputParser;
     validModel = @(x) isa(x,'bbModel');
     validParams = @(x) isa(x,'cell');
     addRequired(p,'model',validModel);
     addRequired(p,'params',validParams);
     addOptional(p,'method',defaultMethod);
     addOptional(p,'formula',defaultFormula);
     addOptional(p,'plot',defaultPlot);
     addOptional(p,'progress',defaultProgress)
     
     addParameter(p,'SampleSize',defaultSampleSize);
     addParameter(p,'GroupNumber',defaultGroupNumber);
     addParameter(p,'GroupSize',defaultGroupSize);
     
     parse(p,model,params,varargin{:});
 
 % specify argument for Sobol indices estimation
    modelfun= model.Fcn;
    InputNumber = model.ParNumber;
    OutputNumber = model.OutputNumber;
    OutputType = model.OutputType;
    Formula = p.Results.formula;
    Method = p.Results.method;
    SampleSize = p.Results.SampleSize;
    
    GroupNumber =   p.Results.GroupNumber;
    GroupSize =  p.Results.GroupSize;
    plot = p.Results.plot;
    progress = p.Results.progress;
    
    % display basic information of the simulation 
    if progress == 1
        disp('------------------------')
        disp(['You have chosen method ', Method]);
        disp(['You have chosen formula ', num2str(Formula)]);
        disp(['The sampleSize is ', num2str(SampleSize)]);
        disp(['The GroupNumber in nested sampling is ', num2str(GroupNumber)]);
        disp(['The GroupSize in nested sampling is ',  num2str(GroupSize)]);

        % display basic information of the model
        disp('------------------------')
        disp(['The function of the model is ', func2str(modelfun)]);
        disp(['There are ', num2str(InputNumber), ' parameters']);
        disp(['There are ', num2str(OutputNumber), ' model outputs']);
        disp(['The output types are ', num2str(OutputType)]);
        disp('------------------------')
    end
    
 % calulate Sobol indices 
     switch Method
        case 'Saltelli'
            [S1,ST] = Saltelli_estimator(modelfun,params,InputNumber,OutputNumber,Formula,SampleSize);
        case 'Nested'
            [S1,ST] = Nested_estimator(modelfun,params,InputNumber,OutputNumber,OutputType,Formula,SampleSize,...
                GroupNumber,GroupSize);
    end

 % barplot option
    if plot == 1
        SobolPlot(S1,ST);
    end
end