function xs = get_xs(caseType, boron_ppm, burnup, group, reaction, xsTable)
% get_xs  Returns interpolated cross sections from parsed CSV table.
%
% caseType   = "base", "reflector", or "rodded"
% boron_ppm  = boron concentration (ppm)
% burnup     = burnup (MWd/kgU)      (ignored for reflector case)
% group      = energy group number   (1, 2, 3, ...)
% reaction   = "absorption", "capture", ...
% xsTable    = preloaded XS table (from readtable)
%
% xs         = interpolated cross section value

arguments
    caseType    (1,1) string
    boron_ppm   (1,1) double
    burnup      (1,1) double
    group       (1,1) double
    reaction    (1,1) string
    xsTable     table
end

% Filter row subset by region case
switch lower(caseType)
    case "base"
        sub = xsTable(strcmp(xsTable.region,"CELL"), :);

    case "reflector"
        % All RF* reflectors
        sub = xsTable(startsWith(xsTable.region,"RF"), :);

    case "rodded"
        % Up to you — assumes ROD or RD naming
        sub = xsTable(startsWith(xsTable.region,"ROD"), :);

    otherwise
        error("Unknown caseType: %s", caseType);
end

% Now filter by group
sub = sub(sub.group == group, :);

if isempty(sub)
    error("No matching rows in table for case=%s group=%d", caseType, group);
end

% --- REFLECTOR SPECIAL HANDLING -----------------------------------
% Reflectors have NO burnup dependence.
if caseType == "reflector"
    % Unique boron grid for this reflector
    B = sub.boron;
    Y = sub.(reaction);

    % Interpolate in boron only
    xs = interp1(B, Y, boron_ppm, "linear", "extrap");
    return;
end

% --- BASE / RODDED FULL 2D INTERPOLATION --------------------------
% For fuel-based cases, interpolate in BOTH boron and burnup.

% Extract grids
B   = sub.boron;
BU  = sub.burnup;
Y   = sub.(reaction);

% 2D scattered interpolation
F = scatteredInterpolant(B, BU, Y, 'linear', 'none');

% Evaluate
xs = F(boron_ppm, burnup);

end
