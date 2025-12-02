function [crit, flux] = SolveCore(layout, mats, dx, dy)
% SolveCore Solves a core described by `layout` and `mats`
%
%   layout: 2D matrix holding the material ID for each node
%   mats: struct with the following components:
%       fiss: fission cross section
%       nu: number of neutrons per fission
%       diff: diffusion coefficient
%       rm: removal cross section
%       sct: downscattering cross section
%   dx: width of 1 node in the x direction
%   dy: width of 1 node in the y direction

    groups = size(mats(1).fiss, 1);

    M =  zeros(groups * span);
    F =  zeros(groups * span);
    Sc = zeros(groups * span);

    for g = 1:groups
        mat_area = (1 + span * (g - 1)):(span * g);
        A_g = CreateLossMat(layout, mats, dx, dy, g);
        F_g = CreateFissMat(layout, mats, g);
        M(mat_area, mat_area) = A_g;
        F(1:SPAN, mat_area) = F_g;

        if g ~= groups
            S_g = CreateSctrMat(layout, mats, g);
            Sc(SPAN + mat_area, mat_area) = S_g;
        end
    end

    A = sparse(M - Sc);
    F = sparse(F);

    opts.tol = 1e-8;
    opts.maxit = 1000;
    opts.isreal = true;
    nev = 1;

    [flux, D] = eigs(F, A, nev, 'largestreal', opts);
    crit = real(D(1,1));
    flux = real(flux(:,1));
end