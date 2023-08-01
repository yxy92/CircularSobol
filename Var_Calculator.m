function total_Var = Var_Calculator(modelfun,N,d,m,pd_list,OutputType,formula)
    % calculate variance of model output
    % modelfun -> function handle of the model
    % N -> sample size
    % d -> parameter number
    % m -> model output number
    % pd_list -> cell array of parameter distribution
    % OutputType -> boolean array of type of output, circular 1,
    % non-circular 0
    % formula -> 1 or 2 for different circular variance definition 

    Var_Parameter = generate_Var_Parameter(N,d,pd_list);
    Var_Output = zeros(N,m);
  
    % add parfor wait bar for running the Var sample
%     w = waitbar(0,'Start paralle running of the Var sample...');
%     D = parallel.pool.DataQueue;
%     afterEach(D, @parforWaitbar);

%     iteration = N;
    %parforWaitbar(w,iteration);
    
    parfor j=1:N
        Var_Output(j,:) = modelfun(Var_Parameter(j,:));
        %send(D,[]);
    end
    
%     close(w)
    %disp('Finished running the parameter sample for Variance calculation')
    
    % calculate variance 
    total_Var = var(Var_Output);
    
    for j=1:m
        if OutputType(j)
            switch formula
                case 1
                    total_Var(j) = 1-circ_r(Var_Output(:,j));
                case 2
                    total_Var(j) = 1-circ_r(Var_Output(:,j))^2;
            end
        end    
    end
    
end