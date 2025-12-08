function spatial_flux = SpatialFlux(flux, Nx, Ny)
% SpatialFlux   Converts the linear form of a 2D flux to a square form.
%   Varibles Nx and Ny are the *total* number of nodes in the x and y axes.
    spatial_flux = zeros(Ny, Nx);
    spatial_flux(2:Nx-1, 2:Ny-1) = reshape(flux, Nx - 2, Ny - 2);
end