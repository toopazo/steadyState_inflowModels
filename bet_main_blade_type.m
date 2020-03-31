function bet_main_blade_type()

    clear all
    close all
    format compact
    clc
    
    lambda_c = 0;
    mu = 0;
    plot_run_blade_types(lambda_c, mu);
    close all;
    
    lambda_c = 0.02;
    mu = 0.2;
    plot_run_blade_types(lambda_c, mu);
    close all;
    
    return
    
    function plot_run_blade_types(lambda_c, mu)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        blade_st    = blade_model('constant_twist_blade', lambda_c, mu, true);
        bet_st      = bet_forces(blade_st);
        bet_st      = bet_forces_add_total(bet_st, true);
        plot_bet_st(bet_st, true);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        blade_st    = blade_model('ideally_twisted_blade', lambda_c, mu, false);
        bet_st      = bet_forces(blade_st);
        bet_st      = bet_forces_add_total(bet_st, true);
        plot_bet_st(bet_st, false);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        blade_st    = blade_model('linearly_twisted_blade', lambda_c, mu, false);
        bet_st      = bet_forces(blade_st);
        bet_st      = bet_forces_add_total(bet_st, true);
        plot_bet_st(bet_st, false);

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        plot_legend_and_save(bet_st.blade_st.casename, bet_st.r_arr);

    end 

    function plot_legend_and_save(str2, m_arr)
        str1 = 'bet_main_blade_type';
        legend_cell = {'constant twist', 'ideally twisted', 'linearly twisted'};

        nfig = 1;
        fig = figure(nfig);
        legend(legend_cell, 'Location','northwest');
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);

        nfig = 2;
        fig = figure(nfig);
        legend(legend_cell, 'Location','northwest');
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);

        nfig = 3;
        fig = figure(nfig);
        legend(legend_cell, 'Location','northwest');
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);

        nfig = 4;
        fig = figure(nfig);
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);

        nfig = 5;
        fig = figure(nfig);
        % legend(legend_cell, 'Location','northwest');    
        plot3D_rotorAxes(nfig, m_arr);       
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);

        nfig = 6;
        fig = figure(nfig);
        % legend(legend_cell, 'Location','northwest');    
        plot3D_rotorAxes(nfig, m_arr);        
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename); 
         
        nfig = 7;
        fig = figure(nfig);
        legend(legend_cell, 'Location','northwest');
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);  
        
        nfig = 8;
        fig = figure(nfig);
        legend(legend_cell, 'Location','northeast');
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);
   
        nfig = 9;
        fig = figure(nfig);
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);    
    end
end
