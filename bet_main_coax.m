function bet_main_coax()

    clear all
    close all
    format compact
    format short
    clc
    
    bet_coax_eta_T_arr();
    close all;   
    clear all;
    bet_coax_theta0_arr_equal_omega();
    close all;
    clear all;
    bet_coax_theta0_arr_equal_torque();   
    close all;
    clear all;    
    return
        
    function bet_coax_eta_T_arr()   
        blade_type = 'constant_twist_blade';
        lambda_c = 0;
        mu = 0;
        
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp('Given:')
        disp('  constant total thrust')
        disp('  constant twist blade')
        disp('  theta0_u = theta0')
        disp('  theta0_l = theta0')
        disp('  eta_T    = eta_T_arr(i)')        
        disp('Find:')
        disp('  omega_u and omega_l')              
                
        blade_h_st  = blade_model(blade_type, lambda_c, mu, false);      
        bet_h_st    = bet_forces(blade_h_st);        
        bet_h_st    = bet_forces_add_total(bet_h_st, false);        
        T_h         = bet_h_st.total.T; 
        Q_h         = bet_h_st.total.Q; 
        P_h         = sqrt(2)*2*bet_h_st.total.P;
        W           = 2*T_h;
        P_0         = W/(2*blade_h_st.rho*blade_h_st.rotArea);
        
        blade_st = blade_model(blade_type, lambda_c, mu, false); 
        bladecoax_u_st  = blade_st;
        bladecoax_l_st  = blade_st;  
        bladesbs_u_st   = blade_st;
        bladesbs_l_st   = blade_st;
    
        eta_T_arr   = 0.1:0.1:3;
        for i=1:length(eta_T_arr)
            
            eta_T       = eta_T_arr(i)
            T_u_target  = W*(eta_T)/(1+eta_T);
            T_l_target  = W - T_u_target;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [bladecoax_u_st, bladecoax_l_st] = bet_coax_match_thrust(...
                bladecoax_u_st, bladecoax_l_st, T_u_target, T_l_target);
            
            [Tcoax_u, Qcoax_u, Pcoax_u, lambdacoax_u_arr, ...
                Tcoax_l, Qcoax_l, Pcoax_l, lambdacoax_l_arr] = ...
                bet_coax_forces(bladecoax_u_st, bladecoax_l_st);
            omegacoax_u = bladecoax_u_st.omega;
            omegacoax_l = bladecoax_l_st.omega;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [bladesbs_u_st, bladesbs_l_st] = bet_sbs_match_thrust(...
                bladesbs_u_st, bladesbs_l_st, T_u_target, T_l_target);
            
            [Tsbs_u, Qsbs_u, Psbs_u, lambdasbs_u_arr, ...
                Tsbs_l, Qsbs_l, Psbs_l, lambdasbs_l_arr] = ...
                bet_sbs_forces(bladesbs_u_st, bladesbs_l_st);
            omegasbs_u = bladesbs_u_st.omega;
            omegasbs_l = bladesbs_l_st.omega;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Tcoax_u_arr(i)          = Tcoax_u;
            Tcoax_l_arr(i)          = Tcoax_l;
            Qcoax_u_arr(i)          = Qcoax_u;
            Qcoax_l_arr(i)          = Qcoax_l;
            omegacoax_u_arr(i)      = omegacoax_u;
            omegacoax_l_arr(i)      = omegacoax_l;
            eta_Tcoax_arr(i)        = Tcoax_u / Tcoax_l;
            eta_Qcoax_arr(i)        = Qcoax_u / Qcoax_l;
            eta_omegacoax_arr(i)    = omegacoax_u / omegacoax_l;            
            
            Tsbs_u_arr(i)       = Tsbs_u;
            Tsbs_l_arr(i)       = Tsbs_l;
            Qsbs_u_arr(i)       = Qsbs_u;
            Qsbs_l_arr(i)       = Qsbs_l;
            omegasbs_u_arr(i)   = omegasbs_u;
            omegasbs_l_arr(i)   = omegasbs_l; 
            eta_Tsbs_arr(i)     = Tsbs_u / Tsbs_l;
            eta_Qsbs_arr(i)     = Qsbs_u / Qsbs_l;
            eta_omegasbs_arr(i) = omegasbs_u / omegasbs_l;           
            
            % eta_T_arr(i)    = Tcoax_u / Tcoax_l;                     
            Pcoax_arr(i)    = Pcoax_u + Pcoax_l;
            Psbs_arr(i)     = Psbs_u + Psbs_l;
            kint_arr(i)     = (Pcoax_u + Pcoax_l)/(Psbs_u + Psbs_l);                       
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 10;
        figure(nfig);
        subplot(2, 1, 1)        
        hold on;
        grid on;
        plot(eta_Tcoax_arr, Tcoax_u_arr, '-*');
        plot(eta_Tcoax_arr, Tcoax_l_arr, '-*');
        plot(eta_Tcoax_arr, (Tcoax_u_arr+Tcoax_l_arr), '-*');
        legend('coax u', 'coax l', 'coax W', 'Location','southeast');          
        xlabel('\eta_T');
        ylabel('Thrust N'); 
        ylim([0, 2*10^5]);
                  
        subplot(2, 1, 2)
        hold on;
        grid on;
        plot(eta_Tsbs_arr, Tsbs_u_arr, '-*');
        plot(eta_Tsbs_arr, Tsbs_l_arr, '-*');
        plot(eta_Tsbs_arr, (Tsbs_u_arr+Tsbs_l_arr), '-*');        
        legend('sbs u', 'sbs l', 'sbs W', 'Location','southeast');  
        xlabel('\eta_T');
        ylabel('Thrust N'); 
        ylim([0, 2*10^5]);              
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 11;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(eta_Tcoax_arr, omegacoax_u_arr, '-*');
        plot(eta_Tcoax_arr, omegacoax_l_arr, '-*');
        % legend('coax u', 'coax l', 'Location','southeast');          
        xlabel('\eta_T');
        ylabel('\Omega rad/s');        
        ylim([0, 60]);
        yyaxis right
        plot(eta_Tcoax_arr, eta_omegacoax_arr, '-*');
        legend('coax u', 'coax l', '\eta_{\Omega}', 'Location','southeast');     
        ylabel('\eta_{\Omega}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.0]);   
        
        subplot(2, 1, 2)
        hold on;
        grid on;        
        plot(eta_Tsbs_arr, omegasbs_u_arr, '-*');
        plot(eta_Tsbs_arr, omegasbs_l_arr, '-*');        
        legend('sbs u', 'sbs l', 'Location','southeast');     
        xlabel('\eta_T');
        ylabel('\Omega rad/s');    
        ylim([0, 60]);
        yyaxis right
        plot(eta_Tsbs_arr, eta_omegasbs_arr, '-*');
        legend('sbs u', 'sbs l', '\eta_{\Omega}', 'Location','southeast');     
        ylabel('\eta_{\Omega}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.0]);               
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        xlim([0, 60]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;    
        plot(omegasbs_u_arr, Tsbs_u_arr, '-*');
        plot(omegasbs_l_arr, Tsbs_l_arr, '-*');        
        legend('sbs u', 'sbs l', 'Location','southeast'); 
        xlabel('\Omega rad/s');
        ylabel('Thrust N');     
        xlim([0, 60]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 13;
        figure(nfig);
        hold on;
        grid on;
        plot(eta_Tcoax_arr, Pcoax_arr./P_h, '-*');
        plot(eta_Tsbs_arr, Psbs_arr./P_h, '-*');
        xlabel('\eta_T');
        ylabel('Power W');    
        ylim([0, 2.5]);
        yyaxis right
        plot(eta_Tcoax_arr, kint_arr, '-*');
        legend('coax', 'sbs', 'k_{int}', 'Location','northeast');
        ylabel('k_{int}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.5]);        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 14;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(eta_Tcoax_arr, Qcoax_u_arr, '-*');
        plot(eta_Tcoax_arr, Qcoax_l_arr, '-*');
        % legend('coax u', 'coax l', 'Location','southeast');          
        xlabel('\eta_T');
        ylabel('Torque Nm');
        ylim([0, 3*10^5]);
        yyaxis right
        plot(eta_Tcoax_arr, eta_Qcoax_arr, '-*');
        legend('coax u', 'coax l', '\eta_Q', 'Location','north');     
        ylabel('\eta_Q');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 3]); 
        
        subplot(2, 1, 2)
        hold on;
        grid on;        
        plot(eta_Tsbs_arr, Qsbs_u_arr, '-*');
        plot(eta_Tsbs_arr, Qsbs_l_arr, '-*');        
        % legend('sbs u', 'sbs l', 'Location','southeast');     
        xlabel('\eta_T');
        ylabel('Torque Nm');
        ylim([0, 3*10^5]);         
        yyaxis right
        plot(eta_Tsbs_arr, eta_Qsbs_arr, '-*');
        legend('sbs u', 'sbs l', '\eta_Q', 'Location','north');     
        ylabel('\eta_Q');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 3]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        str1 = 'bet_coax_eta_T_arr';
        str2 = '';  
        nfig_arr = [10, 11, 12, 13, 14]; 
        delay = 120*1;  
        plot_save_nfig_arr(str1, str2, nfig_arr, delay);
    end
    
    function bet_coax_theta0_arr_equal_omega()
        blade_type = 'constant_twist_blade';
        lambda_c = 0;
        mu = 0;
        
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp('Given:')
        disp('  constant total thrust')
        disp('  constant twist blade')
        disp('  theta0_u = theta0_arr(i)')
        disp('  theta0_l = theta0_arr(i)')
        disp('  omega_u  = omega_l')
        disp('Find:')              
        disp('  omega_u and omega_l')
                
        blade_h_st  = blade_model(blade_type, lambda_c, mu, false);      
        bet_h_st    = bet_forces(blade_h_st);        
        bet_h_st    = bet_forces_add_total(bet_h_st, false);        
        T_h         = bet_h_st.total.T; 
        Q_h         = bet_h_st.total.Q; 
        P_h         = sqrt(2)*2*bet_h_st.total.P;
        W           = 2*T_h;
        P_0         = W/(2*blade_h_st.rho*blade_h_st.rotArea);
        
%        blade_st = blade_model(blade_type, lambda_c, mu, false); 
%        bladecoax_u_st  = blade_st;
%        bladecoax_l_st  = blade_st;
%        bladesbs_u_st   = blade_st;
%        bladesbs_l_st   = blade_st;                
            
        theta0_arr = deg2rad(10:2.5:35);
        for i=1:length(theta0_arr)
        
            theta0      = theta0_arr(i);
            blade_type  = ['constant_twist_blade' '_' num2str(theta0) 'rad']
            blade_st    = blade_model(blade_type, lambda_c, mu, false); 
            bladecoax_u_st  = blade_st;
            bladecoax_l_st  = blade_st;
            bladesbs_u_st   = blade_st;
            bladesbs_l_st   = blade_st;  
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [bladecoax_u_st, bladecoax_l_st] = bet_coax_match_weight(...
                bladecoax_u_st, bladecoax_l_st, W);             
            
            [Tcoax_u, Qcoax_u, Pcoax_u, lambdacoax_u_arr, ...
                Tcoax_l, Qcoax_l, Pcoax_l, lambdacoax_l_arr] = ...
                bet_coax_forces(bladecoax_u_st, bladecoax_l_st);
            omegacoax_u = bladecoax_u_st.omega;
            omegacoax_l = bladecoax_l_st.omega;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [bladesbs_u_st, bladesbs_l_st] = bet_sbs_match_weight(...
                bladesbs_u_st, bladesbs_l_st, W);              
            
            [Tsbs_u, Qsbs_u, Psbs_u, lambdasbs_u_arr, ...
                Tsbs_l, Qsbs_l, Psbs_l, lambdasbs_l_arr] = ...
                bet_sbs_forces(bladesbs_u_st, bladesbs_l_st);
            omegasbs_u = bladesbs_u_st.omega;
            omegasbs_l = bladesbs_l_st.omega;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Tcoax_u_arr(i)          = Tcoax_u;
            Tcoax_l_arr(i)          = Tcoax_l;
            Qcoax_u_arr(i)          = Qcoax_u;
            Qcoax_l_arr(i)          = Qcoax_l;
            omegacoax_u_arr(i)      = omegacoax_u;
            omegacoax_l_arr(i)      = omegacoax_l;
            eta_Tcoax_arr(i)        = Tcoax_u / Tcoax_l;
            eta_Qcoax_arr(i)        = Qcoax_u / Qcoax_l;
            eta_omegacoax_arr(i)    = omegacoax_u / omegacoax_l;            
            
            Tsbs_u_arr(i)       = Tsbs_u;
            Tsbs_l_arr(i)       = Tsbs_l;
            Qsbs_u_arr(i)       = Qsbs_u;
            Qsbs_l_arr(i)       = Qsbs_l;
            omegasbs_u_arr(i)   = omegasbs_u;
            omegasbs_l_arr(i)   = omegasbs_l;
            eta_Tsbs_arr(i)     = Tsbs_u / Tsbs_l; 
            eta_Qsbs_arr(i)     = Qsbs_u / Qsbs_l;
            eta_omegasbs_arr(i) = omegasbs_u / omegasbs_l;           
            
            % eta_T_arr(i)    = Tcoax_u / Tcoax_l;            
            Pcoax_arr(i)    = Pcoax_u + Pcoax_l;
            Psbs_arr(i)     = Psbs_u + Psbs_l;
            kint_arr(i)     = (Pcoax_u + Pcoax_l)/(Psbs_u + Psbs_l);                       
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 10;
        figure(nfig);
        subplot(2, 1, 1)        
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Tcoax_u_arr, '-*');
        plot(rad2deg(theta0_arr), Tcoax_l_arr, '-*');
        plot(rad2deg(theta0_arr), (Tcoax_u_arr+Tcoax_l_arr), '-*');
        % legend('coax u', 'coax l', 'coax W', 'Location','southeast');          
        xlabel('blade pitch \theta deg');
        ylabel('Thrust N'); 
        ylim([0, 2*10^5]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Tcoax_arr, '-*');
        legend('coax u', 'coax l', 'coax W', '\eta_T', 'Location','northeast');     
        ylabel('\eta_T');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 3]);        
                  
        subplot(2, 1, 2)
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Tsbs_u_arr, '-*');
        plot(rad2deg(theta0_arr), Tsbs_l_arr, '-*');
        plot(rad2deg(theta0_arr), (Tsbs_u_arr+Tsbs_l_arr), '-*');        
        % legend('sbs u', 'sbs l', 'sbs W', 'Location','southeast');  
        xlabel('blade pitch \theta deg');
        ylabel('Thrust N'); 
        ylim([0, 2*10^5]); 
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Tsbs_arr, '-*');
        legend('sbs u', 'sbs l', 'sbs W', '\eta_T', 'Location','northeast');     
        ylabel('\eta_T');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 3]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 11;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), omegacoax_u_arr, '-*');
        plot(rad2deg(theta0_arr), omegacoax_l_arr, '-*');
        % legend('coax u', 'coax l', 'Location','northeast');          
        xlabel('blade pitch \theta deg');
        ylabel('\Omega rad/s');  
        ylim([0, 60]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_omegacoax_arr, '-*');
        legend('coax u', 'coax l', '\eta_{\Omega}', 'Location','northeast');     
        ylabel('\eta_{\Omega}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.0]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;        
        plot(rad2deg(theta0_arr), omegasbs_u_arr, '-*');
        plot(rad2deg(theta0_arr), omegasbs_l_arr, '-*');        
        % legend('sbs u', 'sbs l', 'Location','northeast');     
        xlabel('blade pitch \theta deg');
        ylabel('\Omega rad/s');        
        ylim([0, 60]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_omegasbs_arr, '-*');
        legend('sbs u', 'sbs l', '\eta_{\Omega}', 'Location','northeast');     
        ylabel('\eta_{\Omega}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.0]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        ylim([0, 1.5*10^5]);
        xlim([0, 60]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;    
        plot(omegasbs_u_arr, Tsbs_u_arr, '-*');
        plot(omegasbs_l_arr, Tsbs_l_arr, '-*');        
        legend('sbs u', 'sbs l', 'Location','southeast'); 
        xlabel('\Omega rad/s');
        ylabel('Thrust N');     
        ylim([0, 1.5*10^5]);
        xlim([0, 60]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 13;
        figure(nfig);
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Pcoax_arr./P_h, '-*');
        plot(rad2deg(theta0_arr), Psbs_arr./P_h, '-*');
        xlabel('blade pitch \theta deg');
        ylabel('Power W');    
        ylim([0, 2.5]);
        yyaxis right
        plot(rad2deg(theta0_arr), kint_arr, '-*');
        legend('coax', 'sbs', 'k_{int}', 'Location','northeast');
        ylabel('k_{int}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.5]);        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 14;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Qcoax_u_arr, '-*');
        plot(rad2deg(theta0_arr), Qcoax_l_arr, '-*');
        % legend('coax u', 'coax l', 'Location','southeast');          
        xlabel('blade pitch \theta deg');
        ylabel('Torque Nm');
        ylim([0, 3*10^5]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Qcoax_arr, '-*');
        legend('coax u', 'coax l', '\eta_Q', 'Location','north');     
        ylabel('\eta_Q');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 2]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;        
        plot(rad2deg(theta0_arr), Qsbs_u_arr, '-*');
        plot(rad2deg(theta0_arr), Qsbs_l_arr, '-*');        
        % legend('sbs u', 'sbs l', 'Location','southeast');     
        xlabel('blade pitch \theta deg');
        ylabel('Torque Nm');    
        ylim([0, 4.0*10^5]);     
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Qsbs_arr, '-*');
        legend('sbs u', 'sbs l', '\eta_Q', 'Location','north');     
        ylabel('\eta_Q');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 2]);       
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        str1 = 'bet_coax_theta0_arr_equal_omega';
        str2 = '';  
        nfig_arr = [10, 11, 12, 13, 14]; 
        delay = 120*1;  
        plot_save_nfig_arr(str1, str2, nfig_arr, delay);
    end

    function bet_coax_theta0_arr_equal_torque()
        blade_type = 'constant_twist_blade';
        lambda_c = 0;
        mu = 0;
        
        disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%')
        disp('Given:')
        disp('  constant total thrust')
        disp('  constant twist blade')
        disp('  theta0_u = theta0_arr(i)')
        disp('  theta0_l = theta0_arr(i)')
        disp('  Q_u      = Q_l')
        disp('Find:')              
        disp('  omega_u and omega_l')
                
        blade_h_st  = blade_model(blade_type, lambda_c, mu, false);      
        bet_h_st    = bet_forces(blade_h_st);        
        bet_h_st    = bet_forces_add_total(bet_h_st, false);        
        T_h         = bet_h_st.total.T; 
        Q_h         = bet_h_st.total.Q; 
        P_h         = sqrt(2)*2*bet_h_st.total.P;
        W           = 2*T_h;
        P_0         = W/(2*blade_h_st.rho*blade_h_st.rotArea);
        
%        blade_st = blade_model(blade_type, lambda_c, mu, false); 
%        bladecoax_u_st  = blade_st;
%        bladecoax_l_st  = blade_st;
%        bladesbs_u_st   = blade_st;
%        bladesbs_l_st   = blade_st;                
            
        theta0_arr = deg2rad(10:2.5:35);
        for i=1:length(theta0_arr)
        
            theta0      = theta0_arr(i);
            blade_type  = ['constant_twist_blade' '_' num2str(theta0) 'rad']
            blade_st    = blade_model(blade_type, lambda_c, mu, false); 
            bladecoax_u_st  = blade_st;
            bladecoax_l_st  = blade_st;
            bladesbs_u_st   = blade_st;
            bladesbs_l_st   = blade_st;  
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [bladecoax_u_st, bladecoax_l_st] = bet_coax_match_torque(...
                bladecoax_u_st, bladecoax_l_st, W);             
            
            [Tcoax_u, Qcoax_u, Pcoax_u, lambdacoax_u_arr, ...
                Tcoax_l, Qcoax_l, Pcoax_l, lambdacoax_l_arr] = ...
                bet_coax_forces(bladecoax_u_st, bladecoax_l_st);
            omegacoax_u = bladecoax_u_st.omega;
            omegacoax_l = bladecoax_l_st.omega;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [bladesbs_u_st, bladesbs_l_st] = bet_sbs_match_torque(...
                bladesbs_u_st, bladesbs_l_st, W);              
            
            [Tsbs_u, Qsbs_u, Psbs_u, lambdasbs_u_arr, ...
                Tsbs_l, Qsbs_l, Psbs_l, lambdasbs_l_arr] = ...
                bet_sbs_forces(bladesbs_u_st, bladesbs_l_st);
            omegasbs_u = bladesbs_u_st.omega;
            omegasbs_l = bladesbs_l_st.omega;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            Tcoax_u_arr(i)          = Tcoax_u;
            Tcoax_l_arr(i)          = Tcoax_l;
            Qcoax_u_arr(i)          = Qcoax_u;
            Qcoax_l_arr(i)          = Qcoax_l;
            omegacoax_u_arr(i)      = omegacoax_u;
            omegacoax_l_arr(i)      = omegacoax_l;
            eta_Tcoax_arr(i)        = Tcoax_u / Tcoax_l;
            eta_Qcoax_arr(i)        = Qcoax_u / Qcoax_l;
            eta_omegacoax_arr(i)    = omegacoax_u / omegacoax_l;            
            
            Tsbs_u_arr(i)       = Tsbs_u;
            Tsbs_l_arr(i)       = Tsbs_l;
            Qsbs_u_arr(i)       = Qsbs_u;
            Qsbs_l_arr(i)       = Qsbs_l;
            omegasbs_u_arr(i)   = omegasbs_u;
            omegasbs_l_arr(i)   = omegasbs_l;
            eta_Tsbs_arr(i)     = Tsbs_u / Tsbs_l; 
            eta_Qsbs_arr(i)     = Qsbs_u / Qsbs_l;
            eta_omegasbs_arr(i) = omegasbs_u / omegasbs_l;           
            
            % eta_T_arr(i)    = Tcoax_u / Tcoax_l;            
            Pcoax_arr(i)    = Pcoax_u + Pcoax_l;
            Psbs_arr(i)     = Psbs_u + Psbs_l;
            kint_arr(i)     = (Pcoax_u + Pcoax_l)/(Psbs_u + Psbs_l);                       
        end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 10;
        figure(nfig);
        subplot(2, 1, 1)        
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Tcoax_u_arr, '-*');
        plot(rad2deg(theta0_arr), Tcoax_l_arr, '-*');
        plot(rad2deg(theta0_arr), (Tcoax_u_arr+Tcoax_l_arr), '-*');
        % legend('coax u', 'coax l', 'coax W', 'Location','southeast');          
        xlabel('blade pitch \theta deg');
        ylabel('Thrust N'); 
        ylim([0, 2*10^5]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Tcoax_arr, '-*');
        legend('coax u', 'coax l', 'coax W', '\eta_T', 'Location','northeast');     
        ylabel('\eta_T');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 3]);        
                  
        subplot(2, 1, 2)
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Tsbs_u_arr, '-*');
        plot(rad2deg(theta0_arr), Tsbs_l_arr, '-*');
        plot(rad2deg(theta0_arr), (Tsbs_u_arr+Tsbs_l_arr), '-*');        
        % legend('sbs u', 'sbs l', 'sbs W', 'Location','southeast');  
        xlabel('blade pitch \theta deg');
        ylabel('Thrust N'); 
        ylim([0, 2*10^5]); 
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Tsbs_arr, '-*');
        legend('sbs u', 'sbs l', 'sbs W', '\eta_T', 'Location','northeast');     
        ylabel('\eta_T');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 3]);                        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 11;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), omegacoax_u_arr, '-*');
        plot(rad2deg(theta0_arr), omegacoax_l_arr, '-*');
        % legend('coax u', 'coax l', 'Location','northeast');          
        xlabel('blade pitch \theta deg');
        ylabel('\Omega rad/s');  
        ylim([0, 60]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_omegacoax_arr, '-*');
        legend('coax u', 'coax l', '\eta_{\Omega}', 'Location','northeast');     
        ylabel('\eta_{\Omega}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';  
        ylim([0, 2.0]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;        
        plot(rad2deg(theta0_arr), omegasbs_u_arr, '-*');
        plot(rad2deg(theta0_arr), omegasbs_l_arr, '-*');        
        % legend('sbs u', 'sbs l', 'Location','northeast');     
        xlabel('blade pitch \theta deg');
        ylabel('\Omega rad/s');        
        ylim([0, 60]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_omegasbs_arr, '-*');
        legend('sbs u', 'sbs l', '\eta_{\Omega}', 'Location','northeast');     
        ylabel('\eta_{\Omega}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.0]);                
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        ylim([0, 1.5*10^5]);
        xlim([0, 60]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;    
        plot(omegasbs_u_arr, Tsbs_u_arr, '-*');
        plot(omegasbs_l_arr, Tsbs_l_arr, '-*');        
        legend('sbs u', 'sbs l', 'Location','southeast'); 
        xlabel('\Omega rad/s');
        ylabel('Thrust N');     
        ylim([0, 1.5*10^5]);
        xlim([0, 60]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 13;
        figure(nfig);
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Pcoax_arr./P_h, '-*');
        plot(rad2deg(theta0_arr), Psbs_arr./P_h, '-*');
        xlabel('blade pitch \theta deg');
        ylabel('Power W');    
        ylim([0, 2.5]);
        yyaxis right
        plot(rad2deg(theta0_arr), kint_arr, '-*');
        legend('coax', 'sbs', 'k_{int}', 'Location','northeast');
        ylabel('k_{int}');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k'; 
        ylim([0, 2.5]);
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        nfig = 14;
        figure(nfig);
        subplot(2, 1, 1)
        hold on;
        grid on;
        plot(rad2deg(theta0_arr), Qcoax_u_arr, '-*');
        plot(rad2deg(theta0_arr), Qcoax_l_arr, '-*');
        % legend('coax u', 'coax l', 'Location','southeast');          
        xlabel('blade pitch \theta deg');
        ylabel('Torque Nm');
        ylim([0, 3*10^5]);
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Qcoax_arr, '-*');
        legend('coax u', 'coax l', '\eta_Q', 'Location','north');     
        ylabel('\eta_Q');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 2]);
        
        subplot(2, 1, 2)
        hold on;
        grid on;        
        plot(rad2deg(theta0_arr), Qsbs_u_arr, '-*');
        plot(rad2deg(theta0_arr), Qsbs_l_arr, '-*');        
        % legend('sbs u', 'sbs l', 'Location','southeast');     
        xlabel('blade pitch \theta deg');
        ylabel('Torque Nm');    
        ylim([0, 4.0*10^5]);     
        yyaxis right
        plot(rad2deg(theta0_arr), eta_Qsbs_arr, '-*');
        legend('sbs u', 'sbs l', '\eta_Q', 'Location','north');     
        ylabel('\eta_Q');
        ax = gca;
        ax.YAxis(1).Color = 'k';
        ax.YAxis(2).Color = 'k';
        ylim([0, 2]);       
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        str1 = 'bet_coax_theta0_arr_equal_torque';
        str2 = '';  
        nfig_arr = [10, 11, 12, 13, 14]; 
        delay = 120*1;  
        plot_save_nfig_arr(str1, str2, nfig_arr, delay);
    end
end
