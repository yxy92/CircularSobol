% Sarah_Rhythmic_mRNA.m


function result = Sarah_Rhythmic_mRNA(par)
% Numerical simulation of the model of rhythmic mRNA expression by Sarah Luck et al. 2012

% input -> double array, par = [Atrsc, Ptrsc, Kdgrd, Adgrd, Pdgrd]
% output -> double array, result = [meanSS,ampSS,phaseSS]

result = zeros(1,3);
% simulation time interval
tspan = [0 700];
% intial value
x0 = 0;

Tol=1e-5;
opts = odeset('RelTol',Tol,'AbsTol',Tol);

sol = ode45(@(t,x) ode_model(t,x,par),tspan,x0,opts);
t = linspace(600,648,500); % extract a 48 h window
x=deval(sol,t);

%% interpolation to find the peak for total mRNA
tss=linspace(600,648,2000);
ssq=interp1(t,x,tss,'pchip');
[maxss,maxssindex]=max(ssq);
[minss,~]=min(ssq);

% calculate total mRNA rhythmicity
result(1) =  mean(ssq);
result(2) = (maxss-minss)/(maxss+minss);
result(3)= mod(tss(maxssindex),24)*2*pi/24;

%% ode
function dxdt = ode_model(t,x,p)
% pass argument to parameter
omg = 2*pi/24;

Ktrsc = 1;
Atrsc = p(1);
Ptrsc= p(2);

Kdgrd = p(3);
Adgrd = p(4);
Pdgrd = p(5);

dxdt = Ktrsc*(1+Atrsc*cos(omg*(t-Ptrsc)))-Kdgrd*(1+Adgrd*cos(omg*(t-Pdgrd)))*x;
end
end