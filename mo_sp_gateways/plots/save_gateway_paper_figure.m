function save_gateway_paper_figure(fig, output_name)
% Exporta figuras gateway paper en PDF y PNG 300 dpi.

this_file = mfilename('fullpath');
this_dir = fileparts(this_file);
project_root = fileparts(this_dir);
output_dir = fullfile(project_root, 'figures');
if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

pdf_path = fullfile(output_dir, [output_name '.pdf']);
png_path = fullfile(output_dir, [output_name '.png']);

try
    exportgraphics(fig, pdf_path, 'ContentType', 'vector', 'BackgroundColor', 'white');
    exportgraphics(fig, png_path, 'Resolution', 300, 'BackgroundColor', 'white');
catch
    saveas(fig, pdf_path);
    print(fig, png_path, '-dpng', '-r300');
end
end
