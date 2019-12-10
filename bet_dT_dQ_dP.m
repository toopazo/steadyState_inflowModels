function [dT dQ dP] = bet_dT_dQ_dP(UT, UP, UR, c, Cla, Cd, theta, Nb, rho, omega, y, dy)
%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }

    % Simplifying assumptions
    % UR is always zero in hover
    % UR impact on lift is ignored in forward flight
    % UR impact on drag is relevant in forward flight
    % phi = UP / UT (small angle approx)
    % dD * phi = 0 (negligible)    

    % Derived equations
    % lambda = phi * r is valid for small angle phi
    % alpha = theta - phi
    % dr = dy / R
    
    % rho   = air density
    % c     = blade chord     
    % Cla   = lift-curve slope
    % theta = blade pitch
    % Cd    = coeff of drag
    % c*dy  = reference area
    dL = 0.5 * rho * c * Cla * ( theta*UT^2 - UP*UT ) * dy ;
    dD = 0.5 * rho * c * Cd * ( UT^2 + UP^2 ) * dy ;    

    phi = UP / UT;
    dT = Nb * dL;
    dQ = Nb * (phi*dL + dD)*y;
    dP = dQ * omega;    

end

