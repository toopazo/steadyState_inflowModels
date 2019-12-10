function [x0, err] = bet_find_mass_Cd(...
    vehicle_st, medium_st, airspeed, fpang, target, xguess)

    addpath('/home/tzo4/Dropbox/tomas/pennState/avia/software/steadyState2D')

    options = optimset('Display','off');
    x0 = fsolve(@funzero, xguess, options);
    err = funzero(x0);
    
    function err = funzero(x)
        vehicle_st.mass = x(1); % 22;
        vehicle_st.Cd = x(2); % 0.7921;
        [...
            thrust      , ...
            pitch_deg   , ...
            aoa_deg     , ...
            fpang_deg     ...
            ] = steadyState2D_flightAngles(vehicle_st, medium_st, airspeed, fpang);
            
%        if vehicle_st.Cd < -0.0001
%            errCd = 0.8 - vehicle_st.Cd;
%        else    
%            errCd = 0;
%        end
        errCd = 0;
            
        err(1) = thrust - target(1) + errCd;
        err(2) = aoa_deg - target(2) + errCd;
    end
end
