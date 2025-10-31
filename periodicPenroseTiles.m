function jsonStr = periodicPenroseTiles()

figure
axesConainer = gca;
set(axesConainer,'NextPlot', 'add')
grid on
axis equal

thickColor = html2rgb("#aadcfb");
thingColor = html2rgb("#ffe24c");

thinShortHalfDiag = sin(2*pi/10/2);
thinLongHalfDiag = cos(2*pi/10/2);
thin = [1 0 -1 0; 0 1 0 -1].*[thinShortHalfDiag; thinLongHalfDiag];

thickShortHalfDiag = sin(2*pi/5/2);
thickLongHalfDiag = cos(2*pi/5/2);
thick = [1 0 -1 0; 0 1 0 -1] .* [thickLongHalfDiag; thickShortHalfDiag];
reflectLinePoints = [0 -1; 0 0] + [0; thinLongHalfDiag + thickShortHalfDiag];


% Fill the polygons
rhTn = thin;
plotThin(rhTn) % lower right

rhTk = thick - [thinShortHalfDiag + thickLongHalfDiag; 0];
plotThick(rhTk) % lower right left

c = [-thinShortHalfDiag; 0];
plotThick(rotate2D(rhTk, -2, c)) % lower right up

plotThick(reflect(rotate2D(rhTk, -2, c), reflectLinePoints))

plotThick(thick + [0; thinLongHalfDiag + thickShortHalfDiag]) % right center

rhTn = thin + [-thinShortHalfDiag - thickLongHalfDiag; thickShortHalfDiag + thinLongHalfDiag];
plotThin(rhTn)
c = [-thinShortHalfDiag - thickLongHalfDiag; thickShortHalfDiag];
plotThin(rotate2D(rhTn,3,c))

plotThin(reflect(rotate2D(rhTn,3,c), reflectLinePoints))


c=[-thickLongHalfDiag - 2 * thinShortHalfDiag - 1; thinLongHalfDiag + thickShortHalfDiag];

rhTk = thick + c - [thickLongHalfDiag; 0];
% plotThick(rhTk)
plotThick(rotate2D(rhTk,2,c))

plotThick(rotate2D(rotate2D(rhTk,2,c),2,[-thinShortHalfDiag - 2* thickLongHalfDiag-1;0]))
rhTkLowerLeft = rotate2D(rotate2D(rhTk,2,c),2,[-thinShortHalfDiag - 2* thickLongHalfDiag-1;0]);
plotThick(reflect(rhTkLowerLeft, reflectLinePoints))

plotThick(rotate2D(rhTk,-2,c))
plotThick(rotate2D(rhTk,-4,c))
plotThick(rotate2D(rhTk,-6,c))

plotThin(rotate2D(thin + [c(1); c(2) + thinLongHalfDiag] ,2,c))
plotThin(rotate2D(thin + [c(1); c(2) + thinLongHalfDiag] ,3,c))

% fetch polygons from axes children objects

polygons = axesConainer.Children;

tx = thinShortHalfDiag + 2*thickLongHalfDiag + 1 + 1 + thinShortHalfDiag;
ty = 2 * thinLongHalfDiag + 2 * thickShortHalfDiag;
plotTranspose(polygons, 0, ty)
plotTranspose(polygons, tx, ty)
plotTranspose(polygons, tx, 0)

plotTranspose(polygons, -tx, 0)
plotTranspose(polygons, -tx, ty)
plotTranspose(polygons, -tx, 2*ty)
plotTranspose(polygons, 0, 2*ty)
plotTranspose(polygons, tx, 2*ty)
plotTranspose(polygons, 2*tx, 2*ty)
plotTranspose(polygons, 2*tx, ty)
plotTranspose(polygons, 2*tx, 0)
plotTranspose(polygons, 2*tx, -ty)
plotTranspose(polygons, tx, -ty)
plotTranspose(polygons, 0, -ty)
plotTranspose(polygons, -tx, -ty)

rhombusToExport = axesConainer.Children;

for i = numel(rhombusToExport): -1 : 1
    rhombus = rhombusToExport(i);
    tiles(i).type = rhombus.UserData;
    tiles(i).points = [rhombus.XData'; rhombus.YData'];
end

jsonStr = jsonencode(tiles);

linePoints = [0 0; -4.5 9.7];
plotTransposeLine(linePoints, 0, 0)
plotTransposeLine(linePoints, tx, 0)
plotTransposeLine(linePoints, -tx, 0)

linePoints = [-9 9.8; 0 0];
plotTransposeLine(linePoints, 0, 0)
plotTransposeLine(linePoints, 0, ty)
plotTransposeLine(linePoints, 0, 2*ty)


    function plotThin(rhTn)
        fill(rhTn(1,:), rhTn(2,:), [0.2 0.6 0.8], 'FaceColor', thingColor, ...
            'FaceAlpha', 0.7, 'EdgeColor', 'black', 'LineWidth', 2, ...
            'UserData', 'THIN')
    end

    function plotThick(rhTk)
        fill(rhTk(1,:), rhTk(2,:), [0.2 0.6 0.8], 'FaceColor', thickColor, ...
            'FaceAlpha', 0.7, 'EdgeColor', 'black', 'LineWidth', 2, ...
            'UserData', 'THICK')
    end

end

function rgb = html2rgb(htmlColor)
    % htmlColor: string like '#FFD700' or 'FFD700'
    htmlColor = char(htmlColor);
    if startsWith(htmlColor, '#')
        htmlColor = htmlColor(2:end);
    end

    if numel(htmlColor) ~= 6
        error('Invalid HTML color string. Must be 6 hex digits.');
    end

    % Split into R, G, B hex pairs
    r = hex2dec(htmlColor(1:2)) / 255;
    g = hex2dec(htmlColor(3:4)) / 255;
    b = hex2dec(htmlColor(5:6)) / 255;

    rgb = [r, g, b];
end

function trans = plotTransposeLine(linePints, tx, ty)
    trans =  linePints + [tx; ty]; 

    plot(trans(1,:), trans(2,:), 'r-', 'LineWidth', 1.5)
end

function plotTranspose(polygons, tx, ty)
    for i = 1 : numel(polygons)
        poly = polygons(i);
        transposed = [poly.XData'; poly.YData'] + [tx; ty];
        fill(transposed(1,:), transposed(2,:), [0.2 0.6 0.8], ...
            'FaceColor', poly.FaceColor, 'FaceAlpha', poly.FaceAlpha, ...
            'EdgeColor', poly.EdgeColor, 'LineWidth', poly.LineWidth, ...
            'UserData', poly.UserData)
    end
end

function ref = reflect(polygon, p)
    % Reflect points polygon(x,y)  across line defined by p1(x1,y1) and p2(x2,y2)
    p1 = p(:,1);
    p2 = p(:,2);
    % Line direction vector
    n = (p2 - p1)/norm(p2 - p1);
    
    % For each point, translate to line origin
    trans = polygon - p1;
    
    % Project onto line direction
    proj = trans .* n;
    
    % Point on line closest to our point
    p_on_line = proj .* n;
    
    % Reflect: point_reflected = 2 * point_on_line - point_original
    ref = 2 * p_on_line - trans + p1;
end

function rot = rotate2D(polygon, times, center)
    x = polygon(1, :);
    y = polygon(2, :);

    x0 = center(1);
    y0 = center(2);
    
    theta = 2 * pi / 10 * times;
    % Translate to origin
    x_translated = x - x0;
    y_translated = y - y0;
    
    % Apply rotation
    x_rot = x_translated * cos(theta) - y_translated * sin(theta);
    y_rot = x_translated * sin(theta) + y_translated * cos(theta);
    
    % Translate back
    rot = [x_rot + x0; y_rot + y0];
end