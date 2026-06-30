

% Multiple Target Validation

clear
clc
close all

run_simulation

% Project paths
scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
figuresDir = fullfile(projectDir, 'figures');
docsDir = fullfile(projectDir, 'docs');

if ~exist(figuresDir, 'dir')
    mkdir(figuresDir)
end

if ~exist(docsDir, 'dir')
    mkdir(docsDir)
end

% Test cases: [x_target, z_target]
testCases = [
     50    50
    100    50
    150    50
   -100    75
     75   125];

numCases = size(testCases, 1);

results = zeros(numCases, 8);

figure
hold on
grid on
axis equal

for k = 1:numCases

   
    x_target = testCases(k, 1);
    z_target = testCases(k, 2);

    
    out = sim(modelName, 'StopTime', num2str(t_final));

   
    t_data = out.x_out.Time(:);
    x_data = out.x_out.Data(:);
    z_data = out.z_out.Data(:);

    
    x_final = x_data(end);
    z_final = z_data(end);

   
    x_error = x_target - x_final;
    z_error = z_target - z_final;
    total_error = sqrt(x_error^2 + z_error^2);

    
    vx_est = gradient(x_data, t_data);
    vz_est = gradient(z_data, t_data);

    vx_final = vx_est(end);
    vz_final = vz_est(end);
    final_speed = sqrt(vx_final^2 + vz_final^2);

   
    results(k, :) = [
        x_target, z_target, ...
        x_final, z_final, ...
        x_error, z_error, ...
        total_error, final_speed
    ];

   
    plot(x_data, z_data, 'LineWidth', 2)

    
    plot(x_target, z_target, 'x', 'MarkerSize', 10, 'LineWidth', 2)
    plot(x_final, z_final, 's', 'MarkerSize', 7, 'LineWidth', 2)

end

xlabel('Horizontal Position x (m)')
ylabel('Altitude z (m)')
title('Multiple Target Validation')
grid on

exportgraphics(gcf, fullfile(figuresDir, 'multiple_target_validation.png'), 'Resolution', 300)

resultsTable = array2table(results, ...
    'VariableNames', { ...
    'x_target_m', ...
    'z_target_m', ...
    'x_final_m', ...
    'z_final_m', ...
    'x_error_m', ...
    'z_error_m', ...
    'total_error_m', ...
    'final_speed_m_per_s'});

disp(resultsTable)

writetable(resultsTable, fullfile(docsDir, 'multiple_target_validation_results.csv'))

disp('Multiple target validation complete.')
disp('Validation plot saved to figures folder.')
disp('Results table saved to docs folder.')