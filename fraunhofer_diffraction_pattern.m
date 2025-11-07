function fraunhofer_diffraction_pattern()
% Parameters
d = 50;
g = 400;

% Create grid
x = linspace(-d, d, g);
y = linspace(-d, d, g);
[X, Y] = meshgrid(x, y);

% Compute the function f(x, y)
Z = zeros(size(X));
for j = 0:4
    Z = Z + exp(1i * (X * cos(2*pi*j/5) + Y * sin(2*pi*j/5)));
end
F = -log(abs(Z).^2);

% Plot density (similar to Maple's densityplot)
figure;
imagesc(x, y, F);
axis equal off;                % scaling=CONSTRAINED, axes=NONE
set(gca, 'YDir', 'normal');    % Correct y-direction
colormap(parula);              % You can change the colormap
colorbar;                      % Optional: show color scale

end