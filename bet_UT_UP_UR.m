function [UT UP UR] = bet_UT_UP_UR(r, lambda, mu, beta, betadot, psi, omega, R)
%    @book{leishman2006principles,
%      title={Principles of helicopter aerodynamics with CD extra},
%      author={Leishman, Gordon J},
%      year={2006},
%      publisher={Cambridge university press}
%    }

    UT = (omega*R) * ( r + mu*sin(psi) ) ;
    UP = (omega*R) * ( lambda + r*betadot/omega + mu*beta*cos(psi) ) ;
    UR = (omega*R) * ( mu*cos(psi) ) ;

end

