classdef bbModel
    properties
        ParName, ParValue, OutputName, OutputType, OutputValue 
    end
    
    methods
        
        % construction method
        function obj = bbModel(val)
            if nargin == 1
                obj.ParValue = val;
            end
        end
        
        % single run of the black-box model
        function Output = singleRun(obj,FcnHandle)
            nout = nargout(FcnHandle);
            [temp{1:nout}] = FcnHandle(obj.ParValue);
            Output = [temp{:}];
        end    
    end
end