clear all 
clc
close all
format compact
format bank

% 60 RPM = 1 rev/s = 1 Hz = 2pi rad/s
rpm2rads    = pi/30;
rads2rpm    = 30/pi;
in2cm       = 2.54; % 1in = 2.54cm
ft2cm       = 30.48; % 1ft = 30.48cm
cm2m        = 1/100;

height          = 0;
[T, a, P, rho]  = atmosisa(height);
density         = 1.225;    % at sea level kg/m3
% https://www.engineersedge.com/physics/viscosity_of_air_dynamic_and_kinematic_14483.htm
% density         = 1.225;                % [kg / m^3]
% kin_viscosity   = 1.48 * 10^(-5);       % viscosity / density = mu/rho = [m^2 / s]
% viscosity       = 1.81 * 10^(-5);       % [kg / m s]    
% Vsound          = 340;                  % [m / s] 
viscosity       = 1.81 * 10^(-5);       % [kg / m s]

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('sunada2005maximization')

omega_rads  = [40*pi 80*pi];
omega_RPM   = omega_rads*rads2rpm
omega_rads  = omega_RPM*rpm2rads
radius      = 17.5*cm2m
Vtip_ms     = radius * omega_rads
charL       = radius;
vel         = Vtip_ms;
M           = Vtip_ms/a
Re          = density * vel * charL / viscosity

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('mcalister2006experimental')

omega_RPM   = 800%[200 900]
omega_rads  = omega_RPM*rpm2rads
radius      = (48.7/2)*in2cm*cm2m
Vtip_ms     = radius * omega_rads
charL       = radius;
vel         = Vtip_ms;
M           = Vtip_ms/a
Re          = density * vel * charL / viscosity

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('bohorquez2007rotor')

omega_RPM   = [1900 2700]
omega_rads  = omega_RPM*rpm2rads
radius      = 11.2*cm2m
Vtip_ms     = radius * omega_rads
charL       = radius;
vel         = Vtip_ms;
M           = Vtip_ms/a
Re          = density * vel * charL / viscosity

disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
disp('prior2011empirical')

omega_RPM   = [555 7000]
omega_rads  = omega_RPM*rpm2rads
radius      = (25.4/2)*cm2m
Vtip_ms     = radius * omega_rads
charL       = radius;
vel         = Vtip_ms;
M           = Vtip_ms/a
Re          = density * vel * charL / viscosity















