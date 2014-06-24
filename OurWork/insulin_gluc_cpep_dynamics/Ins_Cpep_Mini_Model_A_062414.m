function Ins_Cpep_Mini_Model_A_062414

%Fixed Ins_Mini_Model initial conditions & model parameters
h =93;
n = 0.18;
gamma1 = 0.0076;
I0 = 53;
y0 = 0;

%Fixed Cpep_Mini_Model initial conditions & model parameters
k01 = 0.05;
k21 = 0.201;
k12 = 0.052
gamma2 = 0.0142;
CP0 = 1010;
z0(1) = 0;
z0(2) = 0;
p = [h, n, gamma1, I0]
q = [h,k01, k21, k12, gamma2, CP0]

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %Input
% glucose concentration in plasma [mg/dL];
%time (minutes) glucose level (mg/dl)
tg = [ 0 92 
    2 350 
    4 287 
    6 251 
    8 240 
    10 216
    12 211 
    14 205
    16 196 
    19 192 
    22 172 
    27 163 
    32 142 
    42 124 
    52 105 
    62 92 
    72 84 
    82 77 
    92 82 
    102 81 
    122 82 
    142 82 
    162 85 
    182 90 ];
tspan = tg(:,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ode_options = [];
[t,y] = ode45(@ins_ode,tspan,y0,ode_options,tg,p);
[t,z] = ode45(@cpep_ode,tspan,z0,ode_options,tg,q);

ins = y;
cpep = z(:,1);

figure                % plot insulin-time profile
h1 = plot(tspan,ins,'-', 'Linewidth',2);
legend(h1,'simulated insulin-time profile');
xlabel('time'); ylabel('insulin level');
title('INSULIN MINMAL MODEL')

figure                % plot cpep-time profile
h2 = plot(tspan,cpep,'-', 'Linewidth',2);
legend(h2,'simulated cpeptide-time profile');
xlabel('time'); ylabel('Cpeptide level');
title('CPEPTIDE MINMAL MODEL')

figure                % plot insulin secretion rate-time profile
g = interp1(tg(:,1),tg(:,2),tspan)
CPSR = CP0 + gamma2.*(g-h).* tspan;
h3 = plot(tspan,CPSR,'-', 'Linewidth',2);
xlabel('time'); ylabel('insulin secretion rate');
title('INSULIN SECRETION RATE TIME PROFILE')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dy = ins_ode(t,y,tg,p)
%INS_ODE ODE's of insulin minimal model

h = p(1);
n = p(2);
gamma1 = p(3);
I0 = p(4);

g = interp1(tg(:,1),tg(:,2),t);  % using experimental glucose value over testing time

IDR = I0 + gamma1 * (g - h)* t
dy = - n * y + IDR               % plasma insulin secretion and kinetics model

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function dz = cpep_ode(t,z,tg,q)
%CPEP_ODE ODE's of C-peptide minimal model

h = q(1);
k01 = q(2);
k21 = q(3);
k12 = q(4);
gamma2 = q(5);
CP0 = q(6);

g = interp1(tg(:,1),tg(:,2),t);    % using experimental glucose value over testing time

CPSR = CP0 + gamma2*(g-h)* t;
dCP1 = -(k01 + k21)* z(1) + k12*z(2) + CPSR; % plasma c-peptide secretion and kinetics model
dCP2 = k21 * z(1) - k12*z(2);
dz = [dCP1;dCP2];




