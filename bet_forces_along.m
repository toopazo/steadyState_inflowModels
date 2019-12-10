function [Tr, Qr, Pr, Tpsi, Qpsi, Ppsi] = bet_forces_along(dT_arr, dQ_arr, dP_arr)

    num_dr = size(dT_arr, 2);
    num_dpsi = size(dT_arr, 1);
    
    % For each dT(psi, r) take average along psi
    for j = 1:num_dr
        Tr(j) = mean(dT_arr(:, j));
        Qr(j) = mean(dQ_arr(:, j));
        Pr(j) = mean(dP_arr(:, j));
    end
        
    % For each dT(psi, r) integrate along r
    for i = 1:num_dpsi                
        Tpsi(i) = sum(dT_arr(i, :));
        Qpsi(i) = sum(dQ_arr(i, :));
        Ppsi(i) = sum(dP_arr(i, :));
    end         
    
end
