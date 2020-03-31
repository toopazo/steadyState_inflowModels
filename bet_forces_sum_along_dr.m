function Tpsi = bet_forces_sum_along_dr(T_arr)

    num_dr = size(T_arr, 2);
    num_dpsi = size(T_arr, 1);    
        
    % For each T(psi, r) add along r
    for i = 1:num_dpsi                
        Tpsi(i) = sum(T_arr(i, :));
    end         
    
end
