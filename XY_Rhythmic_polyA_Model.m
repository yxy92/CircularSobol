% XY_Rhythmic_polyA_Model.m

function result = XY_Rhythmic_polyA_Model(par)

result = zeros(1,15);

% simulation time interval
tspan = [0 700];
% intial value
x0 = [0;0];

Tol=1e-5;
opts = odeset('RelTol',Tol,'AbsTol',Tol);

sol = ode45(@(t,x) ode_model(t,x,par),tspan,x0,opts);
t = linspace(600,648,2000); % extract a 48 h window
x=deval(sol,t);

L = x(1,:);% long-tailed
S = x(2,:);% short-tailed


%% interpolation to find the peak for LSR
LSR = L./S; % LS ratio
[maxls,maxlsindex]=max(LSR);
[minls,~]=min(LSR);

% calculate LSR rhythmicity
rals = (maxls-minls)/(maxls+minls);
meanls =  mean(LSR);
Pls=mod(t(maxlsindex),24);

result(1) = meanls;
result(2) = rals;
result(3) = Pls*2*pi/24;

%% interpolation to find the peak for total mRNA
ssmRNA = L+S; % total mRNA
[maxss,maxssindex]=max(ssmRNA);
[minss,~]=min(ssmRNA);

% calculate total mRNA rhythmicity
result(4) =  mean(ssmRNA);
result(5) = (maxss-minss)/(maxss+minss);
result(6)= mod(t(maxssindex),24)*2*pi/24;


%% interpolation to find the peak for long-tailed mRNA
[maxL,maxLindex]=max(L);
[minL,~]=min(L);

result(7)=mean(L);
result(8)=(maxL-minL)/(maxL+minL);
result(9)=mod(t(maxLindex),24)*2*pi/24;


%% interpolation to find the peak for short-tailed mRNA
[maxS,maxSindex]=max(S);
[minS,~]=min(S);

result(10)=mean(S);
result(11)=(maxS-minS)/(maxS+minS);
result(12)=mod(t(maxSindex),24)*2*pi/24;

%% interpolation to find the peak for SLR
SLR=S./L;
[maxSL,maxSLindex]=max(SLR);
[minSL,~]=min(SLR);

result(13)=mean(SLR);
result(14)=(maxSL-minSL)/(maxSL+minSL);
result(15)=mod(t(maxSLindex),24)*2*pi/24;


%% ode
function dxdt = ode_model(t,x,p)
% pass argument to parameter
omg = 2*pi/24;

Ktrsc = 1;
Atrsc = p(1);
Ptrsc= p(2);

KdeA= p(3);
AdeA = p(4);
PdeA = p(5);

KpolyA = p(6);
ApolyA = p(7);
PpolyA = p(8);

Kdgrd = p(9);
Adgrd = p(10);
Pdgrd = p(11);

dxdt = [0; 0];
L = x(1);
S = x(2);

dxdt(1) = Ktrsc*(1+Atrsc*cos(omg*(t-Ptrsc)))-KdeA*(1+AdeA*cos(omg*(t-PdeA)))*L+KpolyA*(1+ApolyA*cos(omg*(t-PpolyA)))*S;
dxdt(2) = KdeA*(1+AdeA*cos(omg*(t-PdeA)))*L -KpolyA*(1+ApolyA*cos(omg*(t-PpolyA)))*S -Kdgrd*(1+Adgrd*cos(omg*(t-Pdgrd)))*S;
end
end
