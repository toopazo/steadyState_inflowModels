function blade_st = blade_model()

blade_st.Cla        = 2*pi;
% Cd0 is apporx Cl/10 => Cd0 = (Cla)*deg2rad(30)/10 = 0.3290
blade_st.Cd0        = (blade_st.Cla)*deg2rad(30)/10;   
blade_st.d1         = 0;
blade_st.d2         = 0;
blade_st.Nb         = 2;
blade_st.R          = 1;

nsections           = 21;
blade_st.nsections  = nsections;
blade_st.r_arr      = linspace(0, 1, nsections);

% rectangular blade 
chord               = 0.1;
blade_st.c_arr      = chord*ones(1, nsections);
blade_st.sigma_arr  = ( (blade_st.Nb*chord)/(pi*blade_st.R) )*ones(1, nsections);

% untwisted blade
% theta0              = deg2rad(20);
% blade_st.theta_arr  = theta0*ones(1, nsections);

blade_st.rho        = 1.225;
blade_st.omega      = 10*2*pi;       % 60 RPM = 1 RPsecond = 1 Hz = 2*pi rad/s

%close all;
%fig = figure
%hold on;
%plot(blade_st.r_arr, blade_st.c_arr); 
%plot(blade_st.r_arr, blade_st.sigma_arr);
%xlabel('radius')
%% ylabel('')
%legend('chord', 'solidity')
%grid on;
%asd = asd
% plot(r_arr, theta_arr)

end
