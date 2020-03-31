function plot3D_rotorAxes(nfig, r_arr)

    pm1_arr = linspace(-1, +1, length(r_arr));
    [X, Y] = meshgrid(pm1_arr, pm1_arr); 
    Z = X*0;

    fig = figure(nfig);
    surf(X, Y, Z.*0, 'FaceAlpha', 0.4); %,'EdgeColor','none')  % plot zero surface
    h = plot3D_arrow([0;0;0], [2;0;0], 'color', 'black', 'stemWidth', 0.02, 'facealpha', 0.5);
    text(2,0,0, 'tail');
    h = plot3D_arrow([0;0;0], [0;2;0], 'color', 'black', 'stemWidth', 0.02, 'facealpha', 0.5);
    text(0,2,0, 'right');    
    view(55, 20);
end
