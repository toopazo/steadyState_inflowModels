function blade_st = blade_model(blade_type, lambda_c, mu, verbose)
    
    rpm2rads        = (pi/30);  % 60 RPM = 1 RPsecond = 1 Hz = 2*pi rad/s
    in2m            = (0.0254); 
    ft2m            = (0.3048);
    lb2kg           = (0.453592);
    
    rho_seal_level  = 1.225;   % kg/m3
    gravity         = 9.8;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % UH-60A
    
%    @article{yeo2004performance,
%      title={Performance analysis of a utility helicopter with standard and advanced rotors},
%      author={Yeo, Hyeonsoo and Bousman, William G and Johnson, Wayne},
%      journal={Journal of the American Helicopter Society},
%      volume={49},
%      number={3},
%      pages={250--270},
%      year={2004},
%      publisher={Vertical Flight Society}
%    }    
    
    % CT is between 0.0017 to 0.01, average being 0.008
    UH60A_R         = 26.83 * ft2m;             % m
    UH60A_chord     = 15 * in2m; % 1.75 * ft2m; % m
    UH60A_omega     = 27;                       % rad/s
    % UH60A_solidity  = 0.083;
    UH60A_Nb        = 4;
    UH60A_Cla       = 2*pi*0.9104; % 5.73
    UH60A_Cd0       = UH60A_Cla * deg2rad(20) / 25;
    
    % https://en.wikipedia.org/wiki/Sikorsky_UH-60_Black_Hawk
    UH60A_vehicleM  = 16260 * lb2kg;    %  kg
    UH60A_Pavail    = 2*1410*1000*0.80;  %  W   
   
    UH60A_ctb_theta0 = deg2rad(22.0335);    % deg2rad(22.0);
    UH60A_itb_theta0 = deg2rad(15.020);     % deg2rad(15.2);
    UH60A_ltb_theta0 = deg2rad(37.560);     % deg2rad(35.0);
    UH60A_ltb_theta1 = deg2rad(17.000);     % deg2rad(18.0);        
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
    % Vehicle properties
    blade_st.vehicleM   = UH60A_vehicleM;
    blade_st.Thover     = blade_st.vehicleM * gravity;
    blade_st.Pavail     = UH60A_Pavail;
    
    % Blade properties
    blade_st.Nb         = UH60A_Nb;
    blade_st.R          = UH60A_R;   
    blade_st.rotArea    = pi*blade_st.R^2;    
    blade_st.omega      = UH60A_omega;
    blade_st.Vtip       = blade_st.omega*blade_st.R;     
    
    % Airflow properties
    blade_st.rho        = rho_seal_level;
    blade_st.normf      = blade_st.rho * blade_st.rotArea * blade_st.Vtip^2;    
    blade_st.lambda_c   = lambda_c;
    blade_st.mu         = mu;
    blade_st.CT_target  = blade_st.Thover / blade_st.normf;
    blade_st.TPP_alpha  = atan( (blade_st.lambda_c + 10^-6) / (blade_st.mu) );  % atan(1/0) = 90 deg
    blade_st.TPP_alphad = rad2deg(blade_st.TPP_alpha);
    
    % Blade motion  
    blade_st.b0         = 0;
    blade_st.b1c        = -1*deg2rad(8)*0;
    blade_st.b1s        = +0*deg2rad(8)*0; 
    
    % Blade lift and drag
    blade_st.Cla        = UH60A_Cla;
    % Cd0 is apporx Cl/10 => Cd0 = (Cla)*deg2rad(30) / 10 = 0.3290
    blade_st.Cd0        = UH60A_Cd0;
    blade_st.d1         = 0;
    blade_st.d2         = 0;   

    % Number of sections and radius
    nsections           = 16;   
    % nsections = 16 => 
    %                   len(psi_arr) = 17
    %                   psi_arr = 0   22.5000   45.0000  ..  337.5000  360.0000
    ones_arr            = ones(1, nsections + 1);
    blade_st.nsections  = nsections;
    blade_st.r_arr      = linspace(0, 1, nsections + 1);
    blade_st.psi_arr    = linspace(0, 2*pi, nsections + 1);

    % Blade geometry (pitch, chord, solidity)
    blade_st.blade_type = blade_type;
        
    known_blade_type = false;
    if strfind(blade_type,'constant_twist_blade') == 1
        known_blade_type = true;
        % disp('[blade_model] constant twist blade')
        
        theta0str = extractBetween(blade_type,'constant_twist_blade_','rad');
        if isempty(theta0str)
            theta0 = UH60A_ctb_theta0;
        else
            theta0 = str2double(theta0str);
        end      
        blade_st.theta_arr  = theta0 .* ones_arr;
                    
        % chord and solidty
        blade_st.chord      = UH60A_chord;
        blade_st.solidity   = (blade_st.Nb * blade_st.chord) / (pi*blade_st.R);
        blade_st.c_arr      = blade_st.chord .* ones_arr;
        blade_st.sigma_arr  = blade_st.solidity .* ones_arr; 
    end    
    if strcmp(blade_type, 'ideally_twisted_blade')    
        known_blade_type = true;
        % disp('[blade_model] ideally twisted blade')
        blade_st.theta_arr = UH60A_itb_theta0 .* ones_arr ./ blade_st.r_arr;

        theta_max = deg2rad(70);
        ind_arr = find(blade_st.theta_arr >= theta_max);
        for ind = ind_arr
            blade_st.theta_arr(ind) = theta_max;
        end
        
        % chord and solidty
        blade_st.chord      = UH60A_chord;
        blade_st.solidity   = (blade_st.Nb * blade_st.chord) / (pi*blade_st.R);
        blade_st.c_arr      = blade_st.chord .* ones_arr;
        blade_st.sigma_arr  = blade_st.solidity .* ones_arr;
    end
    if strcmp(blade_type, 'linearly_twisted_blade')  
        known_blade_type = true;    
        % disp('[blade_model] linearly twisted blade')
        blade_st.theta_arr = linspace(...
            UH60A_ltb_theta0, UH60A_ltb_theta1, nsections + 1);
            
        % chord and solidty
        blade_st.chord      = UH60A_chord;
        blade_st.solidity   = (blade_st.Nb * blade_st.chord) / (pi*blade_st.R);
        blade_st.c_arr      = blade_st.chord .* ones_arr;
        blade_st.sigma_arr  = blade_st.solidity .* ones_arr;
    end
    if known_blade_type == false
        disp('[blade_model] unknown blade_type')
        blade_type
    end
    
    % Case name
    blade_st.casename   = ['mu' num2str(blade_st.mu) '_lc' num2str(blade_st.lambda_c)];
    blade_st.casename   = strrep(blade_st.casename,'.','p');    
    
    if verbose
%        fprintf('blade_model.m \n');
%        fprintf('  Blade properties \n');
%        fprintf('    blade flapping b0 %.2f deg, b1c %.2f deg, b1s %.2f deg \n', ...
%            rad2deg(blade_st.b0), rad2deg(blade_st.b1c), rad2deg(blade_st.b1s) );
%        fprintf('    rho = %.2f kg/m3, R = %.2f m, A = %.2f m2 \n', ...
%            blade_st.rho, blade_st.R, blade_st.rotArea );
%        fprintf('    Omega = %.2f rad/s, Vtip = %.2f m/s \n', ...
%            blade_st.omega, blade_st.Vtip );
%        fprintf('    Cla = %.2f, Cd0 = %.2f \n', ...
%                    blade_st.Cla, blade_st.Cd0 );            

%        fprintf('  Airflow velocity (far field) \n');
%        fprintf('    lambda_c %.4f, mu %.4f \n', blade_st.lambda_c, blade_st.mu);
%        fprintf('    TPP_alpha %.2f deg \n', rad2deg(blade_st.TPP_alpha));
%        fprintf('    CT_target %.4f \n', blade_st.CT_target);
%        fprintf('    Thover %.2f N \n', blade_st.Thover);

%        fprintf('  Case name \n');
%        fprintf('    casename %s \n', blade_st.casename);   
        blade_st
    end
    
end
