function Var_Parameter = generate_Var_Parameter(N,d,pd_list) 
    % N -> sample size
    % d -> # of parameters
    % pd_list -> parameter distribution or allowable parameter values
    Var_Cube = lhsdesign(N,d);
    Var_Parameter = zeros(N,d);
    for i=1:d
        pd = pd_list{i};
        if isa(pd,'double')
            Var_Parameter(:,i) = datasample(pd,N);  % random sample with replacement
        else
            Var_Parameter(:,i) = icdf(pd,Var_Cube(:,i));
        end
    end
    
end