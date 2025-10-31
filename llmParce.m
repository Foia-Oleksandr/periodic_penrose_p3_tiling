function llmParce()
tbl = readtable("Rhombus_vertices__edge_1_.csv");

figure
set(gca,'NextPlot', 'add')
grid on
axis equal

x = [tbl.v1x tbl.v2x tbl.v3x tbl.v4x];
y = [tbl.v1y tbl.v2y tbl.v3y tbl.v4y];

for i = 1 : height(tbl)
    if tbl.kind(i) == "thick"
        color = "blue";
    else
        color = "yellow";
    end

    fill(x(i, :), y(i, :), [0.2 0.6 0.8], 'FaceColor', color, 'FaceAlpha', 0.7, 'EdgeColor', "black", 'LineWidth', 2)
end

end