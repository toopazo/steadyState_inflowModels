function blade_st = bet_find_omega(blade_st, T_target)

    options = optimset('Display','off');
    xguess = blade_st.omega;
    x0 = fsolve(@funzero, xguess, options);
    % err = funzero(x0);
    
    disp('bet_find_omega')
    blade_st.omega = x0;
    bet_st  = bet_forces(blade_st);
    bet_st  = bet_forces_add_total(bet_st, true);
   
    function err = funzero(x)
        blade_st.omega = x;
        
        bet_st  = bet_forces(blade_st);
        bet_st  = bet_forces_add_total(bet_st, false);
        T       = bet_st.total.T;
        err = T - T_target;
    end
end
