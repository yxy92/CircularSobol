% Circular_Sobol_estimator.m

function [S1,ST] = Circular_Sobol_estimator(modelfun,params,InputNumber,OutputNumber,OutputType,Formula,SampleSize,GroupNumber,GroupSize)


% generate Nested Latin Unit Cube for each input parameter

p = GroupNumber;
q = GroupSize;
N = SampleSize;

d = InputNumber;
m = OutputNumber;

S1 = zeros(m,d);
ST = zeros(m,d);

%% calculate total variance of each model output
total_Var = Var_Calculator(modelfun,N,d,m,params,OutputType,Formula);


%% calculate Si and STi for individual parameters for each output

f = waitbar(0,'Start CircularSobol estimation ...');

for index = 1:d
    
    % update waitbar
    waitbar(index/d, f, sprintf('Progress: %d %%', floor(index/d*100)));
    
    %% generate parameters
    [SinglePar,TotalPar] = generate_Nested_Parameter(params,p,q,d,index);
      
    %% run the model
    Output_Single = zeros(p,q,m);
    Output_Total = zeros(p,q,m);
    
 
    parfor group_index = 1:p
        
        for row_index = 1:q
            tmp_par_single = reshape(SinglePar(group_index,row_index,:),[d,1]);
            tmp_par_total = reshape(TotalPar(group_index,row_index,:),[d,1]);
            
            Output_Single(group_index,row_index,:) = modelfun(tmp_par_single);
            Output_Total(group_index,row_index,:) = modelfun(tmp_par_total);            
        end
    end
    

    %% Sobol index calculation
    
    V1 = zeros(m,1);
    Vt = zeros(m,1);

    S1_tmp = zeros(m,1);
    ST_tmp = zeros(m,1);

    
    for Output_index = 1:m
        Current_Output_type = OutputType(Output_index);
        
        Current_Output_Single = reshape(Output_Single(:,:,Output_index),[p,q]);
        Current_Output_Total = reshape(Output_Total(:,:,Output_index),[p,q]);
        
        switch Current_Output_type
            case 0 % non-circular 
                
                mean_Single = zeros(p,1);
                mean_Total = zeros(p,1);
                for Group_index = 1:p
                    mean_Single(Group_index) = mean(Current_Output_Single(Group_index,:)); % regular mean
                    mean_Total(Group_index) = mean(Current_Output_Total(Group_index,:)); % regular mean
                end
                V1(Output_index) = var(mean_Single);
                Vt(Output_index) = total_Var(Output_index) - var(mean_Total);
 
            case 1 % circular
                vector_mean_Single = zeros(p,1);
                vector_mean_Total = zeros(p,1);
                switch Formula
                    case 1 % Formula 1 with V = 1-R
                        for Group_index = 1:p
                            % calculate mean resultant length 
                            vector_mean_Single(Group_index) = circ_r(Current_Output_Single(Group_index,:)'); 
                            vector_mean_Total(Group_index) = circ_r(Current_Output_Total(Group_index,:)');  
                        end
                                                    
                    case 2 % Formula 2 with V = 1-R^2
                        for Group_index = 1:p
                            % calculate mean resultant length squared
                            vector_mean_Single(Group_index) = circ_r(Current_Output_Single(Group_index,:)')^2; % 
                            vector_mean_Total(Group_index) = circ_r(Current_Output_Total(Group_index,:)')^2; % 
                        end
                end
                 
                V1(Output_index) = mean(vector_mean_Single) - (1-total_Var(Output_index)); % 
                Vt(Output_index) = total_Var(Output_index)- (mean(vector_mean_Total)-(1-total_Var(Output_index))); 
        end
    
        % calculate Sobol indices
        S1_tmp(Output_index) = V1(Output_index)/total_Var(Output_index);
        ST_tmp(Output_index) = Vt(Output_index)/total_Var(Output_index);
    end
    S1(:,index) = S1_tmp;
    ST(:,index) = ST_tmp;
    

end
close(f); % close wait bar
end