function rho = get_density(h_m)
%USS_ATM_DENSITY  U.S. Standard Atmosphere 1976 density vs. geometric altitude
%
%   rho = uss_atm_density(h_m)
%
%   Input:
%     h_m   — geometric altitude [m] (scalar or vector)
%   Output:
%     rho   — air density [kg/m^3] at each altitude
%
%   Based on NASA TM X-74335.  Uses geopotential correction, piecewise lapse
%   rates, and ideal‑gas/hydrostatic relations.

  % constants
  g0   = 9.80665;           % m/s^2
  R    = 287.05287;         % J/(kg·K)
  r0   = 6356766;           % m, Earth radius for geopotential
  % layer base geopotential altitudes [m]
  hb   = [    0, 11000, 20000, 32000, 47000, 51000, 71000, 84852 ];
  % lapse rates in each layer [K/m]
  L    = [ -0.0065, 0, 0.001, 0.0028, -0.0028, 0, -0.002 ];
  % allocate base‑layer T0 & p0
  nL   = length(hb);
  T0   = zeros(1,nL);
  p0   = zeros(1,nL);
  T0(1)= 288.15;             % K at sea level
  p0(1)= 101325;             % Pa at sea level

  % precompute T0, p0 at top of each layer
  for k = 2:nL
    hDiff = hb(k)-hb(k-1);
    if L(k-1)==0
      p0(k) = p0(k-1)*exp(-g0*hDiff/(R*T0(k-1)));
    else
      p0(k) = p0(k-1)*( T0(k-1)/(T0(k-1)+L(k-1)*hDiff) )^(g0/(R*L(k-1)));
    end
    T0(k) = T0(k-1) + L(k-1)*hDiff;
  end

  % prepare output
  rho = zeros(size(h_m));

  % loop over each query altitude
  for i = 1:numel(h_m)
    h_geo = h_m(i);
    % convert to geopotential altitude
    h_gp  = r0*h_geo/(r0 + h_geo);
    % find layer index
    k     = find(h_gp>=hb,1,'last');
    if k==nL, k=nL-1; end

    % temperature at altitude
    T = T0(k) + L(k)*(h_gp - hb(k));

    % pressure at altitude
    if L(k)==0
      P = p0(k)*exp(-g0*(h_gp-hb(k))/(R*T0(k)));
    else
      P = p0(k)*( T/T0(k) )^(-g0/(R*L(k)));
    end

    % density
    rho(i) = P/(R*T);
  end
end
