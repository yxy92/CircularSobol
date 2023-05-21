function [SinglePar,TotalPar] = generate_Nested_Parameter(pd_list,p,q,d,index)
    % generate single and total latin hyper cube
    [SingleCube,TotalCube] = generate_Nested_cube(p,q,d,index);
     
    SinglePar = zeros(p,q,d);
    TotalPar = zeros(p,q,d);

    for j=1:p % each group
        for k=1:d % each parameter
            pd = pd_list{k};
            if ~isa(pd,'double') % use icdf to sample from matlab based distribution if pd is not dataset
                SinglePar(j,:,k) = icdf(pd,SingleCube(j,:,k));
                TotalPar(j,:,k)= icdf(pd,TotalCube(j,:,k)); 
            else
                % sample from given data points
                if k == index
                    SinglePar(j,:,k) = datasample(pd,1)*ones(q,1); % fixed ith parameter within each group
                    TotalPar(j,:,k) = datasample(pd,q); % vary ith parameter within each group
                else
                    SinglePar(j,:,k) = datasample(pd,q); % vary other parameter within each group
                    TotalPar(j,:,k) = datasample(pd,1)*ones(q,1); % fix other parameters within each group
                end
            end
        end
    end    
end