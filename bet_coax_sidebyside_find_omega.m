function [omega_u, omega_l] = bet_coax_downwash_find_omega(...
    blade_type, lambda_c, mu, T_u_target, T_l_target)

    options = optimset('Display','off');
    xguess = [27; 27];
    x0 = fsolve(@funzero, xguess, options);
    
    % disp('bet_coax_downwash_find_omega')
    err = funzero(x0);
    omega_u = x0(1);
    omega_l = x0(2);
%    [T_u, Q_u, P_u, lambda_u, T_l, Q_l, P_l, lambda_l] = ...
%        bet_coax_sidebyside(blade_type, lambda_c, mu, omega_u, omega_l);
   
    function err = funzero(x)
        omega_u = x(1);
        omega_l = x(2);
        
        [T_u, Q_u, P_u, lambda_u, T_l, Q_l, P_l, lambda_l] = ...
            bet_coax_sidebyside(blade_type, lambda_c, mu, omega_u, omega_l);
                
        err_u = T_u - T_u_target;
        err_l = T_l - T_l_target;
        err = [err_u; err_l];
    end
end
