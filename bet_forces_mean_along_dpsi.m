function Tr = bet_forces_mean_along_dpsi(T_arr)

    num_dr = size(T_arr, 2);
    num_dpsi = size(T_arr, 1);    
        
    % For each T(psi, r) take average along psi
    for j = 1:num_dr
        Tr(j) = mean(T_arr(:, j));
    end   
    
end
