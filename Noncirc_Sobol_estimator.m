% Sobol_estimator.m

function [S1,ST] = Noncirc_Sobol_estimator(modelfun,params,InputNumber,OutputNumber,Formula,SampleSize)

N = SampleSize;
d = InputNumber;
m = OutputNumber;
% generate parameter for A,B and AB matrices
[par_A,par_B,par_AB] = generate_AB_Parameter(N,d,params);

% Run the model to generate output for A,B and AB parameters

fA = cell(N,m);
fB = cell(N,m);
fAB = cell(N*d,m);


% add parfor wait bar for running A,B samples
D = parallel.pool.DataQueue;
afterEach(D, @nUpdateWaitbar);
h = waitbar(0,'Start paralle running of A,B samples...');
parindex = 1;

parfor i=1:N
   [fA{i,:}] = modelfun(par_A(i,:)); 
   [fB{i,:}] = modelfun(par_B(i,:)); 
   
   send(D,i);
end    

close(h);

% add parfor wait bar for running AB sample
D = parallel.pool.DataQueue;
afterEach(D, @nUpdateWaitbarAB);
h = waitbar(0,'Start paralle running of AB sample...');
parindex = 1;

parfor j=1:d*N
    [fAB{j,:}] = modelfun(par_AB(j,:)); 
    
    send(D,j);
end

close(h)

%% calculate total variance using fA
fA = cell2mat(fA);
fB = cell2mat(fB);
fAB = cell2mat(fAB);

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

%% parfor wait bar update functions 
function nUpdateWaitbar(~)
    waitbar(parindex/N, h);
    parindex = parindex + 1;
end

function nUpdateWaitbarAB(~)
    waitbar(parindex/N*d, h);
    parindex = parindex + 1;
end

end