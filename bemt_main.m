clear
clc
close all

blade_st = blade_model();

rho             = 1.225;
omega           = 10*2*pi;       % 60 RPM = 1 RPsecond = 1 Hz = 2*pi rad/s

mu          = 0 / (omega*blade_st.R);   % horizontal vel
lambda_c    = 0 / (omega*blade_st.R);   % vertical vel

A = pi*blade_st.R^2;
Vtip = omega*blade_st.R;
CT_target   = 5 / (rho*A*Vtip^2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('constant twist blade')
blade_st.theta_arr  = deg2rad(20)*ones(1, blade_st.nsections);

% calculate
[r_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr] = ...
    bemt_forces(lambda_c, mu, blade_st, rho, omega); 
% plot
bemt_forces_plot(r_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('ideally twisted blade')
blade_st.theta_arr = 0.673*deg2rad(20)./blade_st.r_arr;

% calculate
[r_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr] = ...
    bemt_forces(lambda_c, mu, blade_st, rho, omega);
% plot
bemt_forces_plot(r_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('linearly twisted blade')
blade_st.theta_arr = linspace(deg2rad(35.5), deg2rad(15), blade_st.nsections);

% calculate
[r_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr] = ...
    bemt_forces(lambda_c, mu, blade_st, rho, omega);
% plot
bemt_forces_plot(r_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr);

%T =
%  225.6147
%Q =
%   60.3567
%P =
%   3.7923e+03
%T =
%  225.9448
%Q =
%   59.0599
%P =
%   3.7108e+03
%T =
%  226.0393
%Q =
%   59.5715
%P =
%   3.7430e+03


