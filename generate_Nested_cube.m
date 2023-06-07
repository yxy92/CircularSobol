function [SingleCube,TotalCube] = generate_Nested_cube(p,q,d,index)
    % p -> group number
    % q -> group size
    % d -> parameter number
    % index -> index of parameter
    
    % create latin hyper cube of dimension [p,q,d]
    rng('shuffle');
    SingleCube = reshape(lhsdesign(p*q,d),[p,q,d]);
    TotalCube = reshape(lhsdesign(p*q,d),[p,q,d]);
    
    % Cube for single Sobol index 
    for i=1:p       
        current_col = SingleCube(i,:,index);
        fixed_value = current_col(randi(q));
        SingleCube(i,:,index) = fixed_value*ones(q,1); % the i-th parameter is fixed      
    end

    % Cube for total Sobol index 
    for i=1:p
        current_mat = reshape(TotalCube(i,:,:),[q,d]);
        fixed_row = current_mat(randi(q),:); % fixed all parameters other than the ith
        fixed_values = fixed_row([1:index-1,index+1:end]);
        TotalCube(i,:,[1:index-1,index+1:end]) = repmat(fixed_values,[q,1]);
    end
end