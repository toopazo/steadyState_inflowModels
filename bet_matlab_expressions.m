clear all
clc

syms r lambda mu psi beta betadot omega R

U_T = (omega*R)*( r + mu*sin(psi) )
U_P = (omega*R)*( lambda + r*betadot/omega + mu*beta*cos(psi) )
U_R = (omega*R)*( mu*cos(psi) )


syms N_b rho c C_D Cla theta dr
dL = 0.5*rho*c*Cla*( theta * U_T^2 - U_P*U_T ) * R * dr;
dT = N_b * dL;

phidL_dD = 0.5*rho*c*Cla*( theta*U_P*U_T - U_P^2 + (C_D/Cla)*U_T^2 ) * R*dr;
dQ = N_b * R*r * phidL_dD;


normf = R^2 * N_b * 0.5*rho*c*Cla;
dT_norm = dT / ( normf )
% dT_norm = simplify(dT_norm)

dT2_norm = dr*( -R*omega^2*(r + mu*sin(psi))*(lambda + (betadot*r)/omega + beta*mu*cos(psi)) + R*omega^2*theta*(r + mu*sin(psi))^2);
check = simplify(dT_norm - dT2_norm)

dQ_norm = dQ / ( normf*R^2 )
% dQ_norm = simplify(dQ_norm)

dQ2_norm = dr*r*( (C_D*omega^2*(r + mu*sin(psi))^2)/Cla ...
    - omega^2*(lambda + (betadot*r)/omega + beta*mu*cos(psi))^2 ...
    + omega^2*theta*(r + mu*sin(psi))*(lambda + (betadot*r)/omega ...
    + beta*mu*cos(psi)));
check = simplify(dQ_norm - dQ2_norm)



%% 20% enfermos => hospital
%% pobtot = 300000000
%pobtot = 18000000
%tasahosp = 0.2
%pob = pobtot * 0.6 * tasahosp
%cphab = 2.2 * 1.5
%ncamas = pobtot * cphab/1000 % 4000 %numero camas en chile 
%dtiempo = 1 % semana tiempo en el hospital
%nmeses = (pob / ncamas ) / 4%52


