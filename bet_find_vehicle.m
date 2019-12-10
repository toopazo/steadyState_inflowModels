function vehicle_st = bet_find_vehicle(lambda_c, mu, Vtip, target_T, target_aoa_deg)

    medium_st.rho = 1.225;
    medium_st.gmagn = 9.81;
    
    vehicle_st.mass = 0.90*target_T/medium_st.gmagn;
    vehicle_st.S = 0.7;
    vehicle_st.Cd = 1.0;
    
    airspeed = sqrt( (lambda_c*Vtip)^2 + (mu*Vtip)^2 );
    fpang = 0;

%    fprintf('steadyState2D_flightAngles results \n');
%    [...
%        thrust      , ...
%        pitch_deg   , ...
%        aoa_deg     , ...
%        fpang_deg     ...
%        ] = steadyState2D_flightAngles(vehicle_st, medium_st, airspeed, fpang)

    xguess = [vehicle_st.mass, vehicle_st.Cd];
    fprintf('fzero guess: mass %.4f, Cd %.4f \n', xguess(1), xguess(2));
    target = [target_T, target_aoa_deg];
    fprintf('fzero target: T %.4f, alpha_deg %.4f \n', target(1), target(2));
    [x0, err] = bet_find_mass_Cd(...
        vehicle_st, medium_st, airspeed, fpang, target, xguess);
    fprintf('fzero results: mass %.4f, Cd %.4f \n', x0(1), x0(2));
    vehicle_st.mass = x0(1);
    vehicle_st.Cd = x0(2);
    % fprintf('fzero results: sum(err) %.4f \n', sum(err));

    % fprintf('vehicle_st:  \n');
    vehicle_st

    % fprintf('steadyState2D_flightAngles results \n');
    [...
        thrust      , ...
        pitch_deg   , ...
        aoa_deg     , ...
        fpang_deg     ...
        ] = steadyState2D_flightAngles(vehicle_st, medium_st, airspeed, fpang)

end
