% Sobol_estimator.m

function [S1,ST] = Noncirc_Sobol_estimator(modelfun,params,InputNumber,OutputNumber,Formula,SampleSize)

N = SampleSize;
d = InputNumber;
m = OutputNumber;
% generate parameter for A,B and AB matrices
[par_A,par_B,par_AB] = generate_AB_Parameter(N,d,params);

% Run the model to generate output for A,B and AB parameters

fA = zeros(N,m);
fB = zeros(N,m);
fAB = zeros(N*d,m);


% add parfor wait bar for running A,B samples
w = waitbar(0,'Start paralle running of A,B samples...');
D = parallel.pool.DataQueue;
afterEach(D, @parforWaitbar);

iteration_A = N;
parforWaitbar(w,iteration_A);

parfor i=1:N
   fA(i,:) = modelfun(par_A(i,:)); 
   fB(i,:) = modelfun(par_B(i,:)); 
   
   send(D,[]);
end    

delete(w);
disp('Finished running the A,B samples')
% add parfor wait bar for running AB sample
w = waitbar(0,'Start paralle running of AB sample...');
D = parallel.pool.DataQueue;
afterEach(D, @parforWaitbar);

iteration_AB = d*N;
parforWaitbar(w,iteration_AB);

parfor j=1:d*N
    fAB(j,:) = modelfun(par_AB(j,:)); 
    
    send(D,[]);
end

delete(w);
disp('Finished running the AB sample')
%% calculate total variance using fA
Var = var(fA);


%% calculate Sobol index

V1 = zeros(m,d);
Vt = zeros(m,d);
switch Formula
    case 1 % Saltelli et al.     
        % V1 = sum(fB*(fAB-fA))/N
        % Vt = sum(fA-fAB)^2/2N
        for i=1:m
            for j=1:d
                V1(i,j) = dot(fB(:,i),fAB((j-1)*N+1:j*N,i)-fA(:,i))/N; 
                Vt(i,j) = norm(fA(:,i)-fAB((j-1)*N+1:j*N,i))^2/(2*N);
            end
        end
                
    case 2 % Jansen et al.
        % V1 = V - sum(fB-fAB)^2)/2N
        % Vt = sum(fA-fAB)^2/2N
        for i=1:m
            for j=1:d                
                V1(i,j) = Var(i) - norm(fB(:,i)-fAB((j-1)*N+1:j*N,i))^2/(2*N);
                Vt(i,j) = norm(fA(:,i)-fAB((j-1)*N+1:j*N,i))^2/(2*N);             
            end
        end      
end
% calculate 1st order and total Sobol indices
S1 = V1./Var';
ST = Vt./Var';


end