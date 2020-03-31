function [X, Y] = plot3D_polar(nfig, linspec, psi_arr, r_arr, val_arr)
    
    fig = figure(nfig);

    num_dr = length(r_arr);
    num_dpsi = length(psi_arr);
    
    for i = 1:num_dpsi
        psi = psi_arr(i);
        % [x, y] = pol2cart(psi_arr, r_arr);
        x_arr = r_arr .* cos(psi);
        y_arr = r_arr .* sin(psi);
        plot3(x_arr, y_arr, val_arr(i, :), linspec);
        X(i, :) = x_arr;
        Y(:, i) = transpose(y_arr);
    end     
end
