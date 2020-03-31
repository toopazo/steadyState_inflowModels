function [dolMxpsi_arr, dolMypsi_arr, dolMzpsi_arr] = bet_forces_dolM(bet_st)
    
    % Unpack bet_st results
    blade_st        = bet_st.blade_st;
    psi_arr         = bet_st.psi_arr;
    r_arr           = bet_st.r_arr;
    T_arr           = bet_st.T_arr;
    Q_arr           = bet_st.Q_arr;
    lambda_i_arr    = bet_st.lambda_i_arr;
    
    % Get sectional position [x; y; z]
    rotor_xyz   = blade_model_rotor_xyz(psi_arr, r_arr, blade_st); 
    num_dpsi    = length(psi_arr);
    num_dr      = length(r_arr);
    
    % Calculate moment
    dolM_arr = zeros(3, num_dpsi, num_dr);
    for i = 1:num_dpsi
        x_arr = squeeze( rotor_xyz(1, i, :) );
        y_arr = squeeze( rotor_xyz(2, i, :) );
        z_arr = squeeze( rotor_xyz(3, i, :) );
        for j = 1:num_dr
            x = x_arr(j);
            y = y_arr(j);
            z = z_arr(j);
            Tij = T_arr(i, j);
            
            dolM = cross( [x; y; z], [0; 0; Tij] );
            dolM_arr(:, i, j) = dolM;
        end
    end   
    
    % Calculate net mean moment
    dolMx_arr = squeeze(dolM_arr(1, :, :));
    dolMy_arr = squeeze(dolM_arr(2, :, :));
    dolMz_arr = squeeze(dolM_arr(3, :, :));
    
    dolMxpsi_arr    = bet_forces_sum_along_dr(dolMx_arr);
    dolMypsi_arr    = bet_forces_sum_along_dr(dolMy_arr);
    dolMzpsi_arr    = bet_forces_sum_along_dr(dolMz_arr);
    
%    mean_dolMx = mean(dolMxpsi_arr);
%    mean_dolMy = mean(dolMypsi_arr);
%    mean_dolMz = mean(dolMzpsi_arr);
%    
%    dolM = [mean_dolMx; mean_dolMy; mean_dolMz];

end
