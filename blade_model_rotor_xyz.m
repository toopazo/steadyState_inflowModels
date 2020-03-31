function rotor_xyz = blade_model_rotor_xyz(psi_arr, r_arr, blade_st)

    num_dr      = length(r_arr);
    R           = blade_st.R;
    num_dpsi    = length(psi_arr);   
    
    rotor_xyz   = zeros(3, num_dpsi, num_dr); 
    for i = 1:num_dpsi
        psi     = psi_arr(i);
        beta    =  blade_st.b0 + blade_st.b1c*cos(psi) + blade_st.b1s*sin(psi);        
        for j = 1:num_dr
            r   = r_arr(j);
            x   = R .* r .* cos(psi) .* cos(beta);
            y   = R .* r .* sin(psi) .* cos(beta);
            z   = R .* r .* sin(beta);
            
            rotor_xyz(:, i, j) = [x;y;z];
        end
    end
    % rotor_xyz(:, 1, :)
end
