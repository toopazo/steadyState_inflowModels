clear
clc
close all

blade_st = blade_model();

A = pi*blade_st.R^2;
Vtip = blade_st.omega*blade_st.R;

lambda_c    = 0*2 / (Vtip);   % vertical vel
mu          = 0*10 / (Vtip);   % horizontal vel
fprintf('lambda_c %.4f, mu %.4f \n', lambda_c, mu);

TPP_alpha = atan(lambda_c / (mu+10^-6)); 
fprintf('TPP_alpha %.2f \n', rad2deg(TPP_alpha));

CT_guess = 225 / (blade_st.rho*A*Vtip^2);
fprintf('CT_guess %.2f \n', CT_guess);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('constant twist blade')
blade_st.theta_arr  = deg2rad(20.1)*ones(1, blade_st.nsections);

% calculate
[...
    r_arr           , ...
    psi_arr         , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...    
    lambda_i_arr       ...
    ] = bet_forces(lambda_c, mu, blade_st, CT_guess);
% plot
bet_forces_plot(r_arr, psi_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr);
% print 
bet_forces_print(dT_arr, dQ_arr, dP_arr, lambda_i_arr, blade_st);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('ideally twisted blade')
blade_st.theta_arr = 0.673*deg2rad(20)./blade_st.r_arr;

% calculate
[...
    r_arr           , ...
    psi_arr         , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...    
    lambda_i_arr       ...
    ] = bet_forces(lambda_c, mu, blade_st, CT_guess);
% plot
bet_forces_plot(r_arr, psi_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr);
% print 
bet_forces_print(dT_arr, dQ_arr, dP_arr, lambda_i_arr, blade_st);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp('linearly twisted blade')
blade_st.theta_arr = linspace(deg2rad(35.5), deg2rad(15), blade_st.nsections);

% calculate
[...
    r_arr           , ...
    psi_arr         , ...
    dT_arr          , ...
    dQ_arr          , ...
    dP_arr          , ...    
    lambda_i_arr       ...
    ] = bet_forces(lambda_c, mu, blade_st, CT_guess);
% plot
bet_forces_plot(r_arr, psi_arr, dT_arr, dQ_arr, dP_arr, lambda_i_arr);
% print 
bet_st = bet_forces_print(dT_arr, dQ_arr, dP_arr, lambda_i_arr, blade_st);

fprintf('Find vehicle that would fit the specs (assuming fpang = 0) \n');
target_T = bet_st.T;
target_aoa_deg = rad2deg(TPP_alpha);
vehicle_st = bet_find_vehicle(lambda_c, mu, Vtip, target_T, target_aoa_deg);

% text(xp_end, yp_end, zp_end, textstr, 'FontSize', 10, ...
%             'HorizontalAlignment','left') % , 'BackgroundColor', 'w')

%    lambda_c 0.0318, mu 0.1592 
%    constant twist blade
%    TPP_alpha 11.31 
%    T 207.12, Q 59.14, P 3716.16 
%    CT 0.0136, CQ 0.0039, CP 0.0039 
%    ideally twisted blade
%    TPP_alpha 11.31 
%    T 234.76, Q 59.41, P 3732.90 
%    CT 0.0155, CQ 0.0039, CP 0.0039 
%    linearly twisted blade
%    TPP_alpha 11.31 
%    T 211.70, Q 59.26, P 3723.61 
%    CT 0.0139, CQ 0.0039, CP 0.0039 

%    lambda_c 0.0000, mu 0.0000 
%    constant twist blade
%    TPP_alpha 0.00 
%    T 226.99, Q 61.14, P 3841.55 
%    CT 0.0149, CQ 0.0040, CP 0.0040 
%    ideally twisted blade
%    TPP_alpha 0.00 
%    T 225.94, Q 59.65, P 3748.01 
%    CT 0.0149, CQ 0.0039, CP 0.0039 
%    linearly twisted blade
%    TPP_alpha 0.00 
%    T 226.04, Q 60.16, P 3780.17 
%    CT 0.0149, CQ 0.0040, CP 0.0040 


