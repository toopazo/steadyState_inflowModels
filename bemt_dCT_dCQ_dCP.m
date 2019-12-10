function [dCT dCQ dCP] = bemt_dCT_dCQ_dCP(sigma, phi, Cl, Cd, r, dr)
%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }

    % Simplifying assumptions
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
    
    dCT = 0.5*sigma*Cl*r^2*dr;
    dCQ = 0.5*sigma*( phi*Cl + Cd )*r^3*dr;
    dCP = dCQ;

end

