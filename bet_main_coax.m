function bet_main_coax()

    clear all
    close all
    format compact
    clc
    
    plot_run_coax();
    
    return
    
    function plot_run_coax()
        blade_type = 'constant_twist_blade';
        lambda_c = 0;
        mu = 0;
        omega_arr = 20:1:50;
        eta_T_arr = 0.1:0.1:3;
        
        blade_h_st  = blade_model(blade_type, lambda_c, mu, false);
        omega_h     = blade_h_st.omega;
        Thover      = blade_h_st.Thover;
        bet_h_st    = bet_forces(blade_h_st);        
        bet_h_st    = bet_forces_add_total(bet_h_st, false);
        T_h         = bet_h_st.total.T; 
        P_h         = bet_h_st.total.P;
        W           = 2*T_h;
        P_0         = W/(2*blade_h_st.rho*blade_h_st.rotArea);
            
        % for i=1:length(omega_arr)
        for i=1:length(eta_T_arr)
            
            eta_T       = eta_T_arr(i)
            T_u_target  = W*(eta_T)/(1+eta_T);
            T_l_target  = W - T_u_target;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [omegacoax_u, omegacoax_l] = bet_coax_downwash_find_omega(...
                blade_type, lambda_c, mu, T_u_target, T_l_target);
            
            [Tcoax_u, Qcoax_u, Pcoax_u, lambdacoax_u, ...
                Tcoax_l, Qcoax_l, Pcoax_l, lambdacoax_l] = ...
                bet_coax_downwash(blade_type, lambda_c, mu, omegacoax_u, omegacoax_l);                              
                
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [omegasbs_u, omegasbs_l] = bet_coax_sidebyside_find_omega(...
                blade_type, lambda_c, mu, T_u_target, T_l_target);
            
            [Tsbs_u, Qsbs_u, Psbs_u, lambdasbs_u, ...
                Tsbs_l, Qsbs_l, Psbs_l, lambdasbs_l] = ...
                bet_coax_sidebyside(blade_type, lambda_c, mu, omegasbs_u, omegasbs_l);                                       
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Tcoax_u_arr(i) = Tcoax_u;
            Tcoax_l_arr(i) = Tcoax_l;
%            Pcoax_u_arr(i) = Pcoax_u;
%            Pcoax_l_arr(i) = Pcoax_l;
            omegacoax_u_arr(i) = omegacoax_u;
            omegacoax_l_arr(i) = omegacoax_l;
            
            Tsbs_u_arr(i) = Tsbs_u;
            Tsbs_l_arr(i) = Tsbs_l;
%            Psbs_u_arr(i) = Psbs_u;
%            Psbs_l_arr(i) = Psbs_l;
            omegasbs_u_arr(i) = omegasbs_u;
            omegasbs_l_arr(i) = omegasbs_l;            
            
            eta_T_arr(i)    = eta_T;
            Pcoax_arr(i)    = Pcoax_u + Pcoax_l;
            Psbs_arr(i)     = Psbs_u + Psbs_l;
            kint_arr(i)     = (Pcoax_u + Pcoax_l)/(Psbs_u + Psbs_l);
           
            
        end
        
        nfig = 10;
        figure(nfig);
        subplot(2, 1, 1)        
        hold on;
        grid on;
        plot(eta_T_arr, Tcoax_u_arr, '-*');
        plot(eta_T_arr, Tcoax_l_arr, '-*');
        plot(eta_T_arr, (Tcoax_u_arr+Tcoax_l_arr), '-*');
        legend('coax u', 'coax l', 'coax W', 'Location','southeast');          
        xlabel('\eta_T');
        ylabel('Thrust N'); 
        ylim([0, 1.5*10^5]);
                  
        subplot(2, 1, 2)
        hold on;
        grid on;
        plot(eta_T_arr, Tsbs_u_arr, '-*');
        plot(eta_T_arr, Tsbs_l_arr, '-*');
        plot(eta_T_arr, (Tsbs_u_arr+Tsbs_l_arr), '-*');        
        legend('sbs u', 'sbs l', 'sbs W', 'Location','southeast');  
        xlabel('\eta_T');
        ylabel('Thrust N'); 
        ylim([0, 1.5*10^5]);              
        
        nfig = 11;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(eta_T_arr, omegacoax_u_arr, '-*');
        plot(eta_T_arr, omegacoax_l_arr, '-*');
        legend('coax u', 'coax l', 'Location','southeast');          
        xlabel('\eta_T');
        ylabel('\Omega rad/s');        
        
        subplot(2, 1, 2)
        hold on;
        grid on;        
        plot(eta_T_arr, omegasbs_u_arr, '-*');
        plot(eta_T_arr, omegasbs_l_arr, '-*');        
        legend('sbs u', 'sbs l', 'Location','southeast');     
        xlabel('\eta_T');
        ylabel('\Omega rad/s');        
        
        nfig = 12;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;    
        plot(omegacoax_u_arr, Tcoax_u_arr, '-*');
        plot(omegacoax_l_arr, Tcoax_l_arr, '-*');
        legend('coax u', 'coax l', 'Location','southeast');    
        xlabel('\Omega rad/s');
        ylabel('Thrust N');  
        
        subplot(2, 1, 2)
        hold on;
        grid on;    
        plot(omegasbs_u_arr, Tsbs_u_arr, '-*');
        plot(omegasbs_l_arr, Tsbs_l_arr, '-*');        
        legend('sbs u', 'sbs l', 'Location','southeast'); 
        xlabel('\Omega rad/s');
        ylabel('Thrust N');     
        
        nfig = 13;
        figure(nfig);
        hold on;
        grid on;
        plot(eta_T_arr, Pcoax_arr./P_h, '-*');
        plot(eta_T_arr, Psbs_arr./P_h, '-*');
        plot(eta_T_arr, kint_arr, '-*');
        legend('coax', 'sbs', 'kint', 'Location','southeast');
        xlabel('\eta_T');
        ylabel('Power W');     
        
        P_0
        P_h  
             
        plot_legend_and_save('');
        
    end
    function plot_legend_and_save(str2)
        str1 = 'bet_main_coax';
        
        pause(30);
        
        nfig = 10;
        fig = figure(nfig);
        % set(fig,'units', 'centimeters', 'position', [0, 0, 20, 10]);        
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);
        
        nfig = 11;
        fig = figure(nfig);
        % set(fig,'units', 'centimeters', 'position', [0, 0, 20, 10]);        
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);
        
        nfig = 12;
        fig = figure(nfig);
        % set(fig,'units', 'centimeters', 'position', [0, 0, 20, 10]);        
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);
        
        nfig = 13;
        fig = figure(nfig);
        % set(fig,'units', 'centimeters', 'position', [0, 0, 20, 10]);        
        filename = ['img/' str1 '_' str2 '_' num2str(nfig) '.jpg'];
        saveas(fig, filename);

    end
end
