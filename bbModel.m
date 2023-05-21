classdef bbModel
    properties
        Fcn, ...  % function handle for the black box model
        ParName, ParNumber, ...
        OutputName, OutputNumber, OutputType, ...
    end
    
    methods
        % construction method
        function obj = bbModel(FcnHandle,ParNumber,OutputNumber,varargin)
            
            if nargin < 3
                error('bbModel:NotEnoughInputs','There are not enough argumetn for bbModel');
            else
                % parse required arguments
                p = inputParser;
                validFcn = @(x) isa(x,'function_handle');
                addRequired(p,'FcnHandle',validFcn);
                addRequired(p,'ParNumber');
                addRequired(p,'OutputNumber');
                addParameter(p,'ParName',[]);
                addParameter(p,'OutputName',[]);
                addParameter(p,'OutputType',zeros(OutputNumber,1));
                
                parse(p,FcnHandle,ParNumber,OutputNumber,varargin{:});
                
                % parse extra name-value pair arguments
                
                obj.ParName = p.Results.ParName;
                obj.OutputName = p.Results.OutputName;
                obj.OutputType = p.Results.OutputType;
                
                % assign arguments to model properties
                obj.Fcn = FcnHandle;
                obj.ParNumber = ParNumber;
                obj.OutputNumber = OutputNumber;
            end
        end
        
        % single run of the black-box model
        function OutputValue = singleRun(obj,ParValue)
            nout = nargout(obj.Fcn);
            [temp{1:nout}] = obj.Fcn(ParValue);
            OutputValue = [temp{:}];
        end    
    end
end