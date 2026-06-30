
% Run this script after running run_simulation.m

scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
figuresDir = fullfile(projectDir, 'figures');

if ~exist(figuresDir, 'dir')
    mkdir(figuresDir)
end


t_data = out.x_out.Time(:);
x_data = out.x_out.Data(:);
z_data = out.z_out.Data(:);

% Final position error
x_final = x_data(end);
z_final = z_data(end);

x_error = x_target - x_final;
z_error = z_target - z_final;
total_error = sqrt(x_error^2 + z_error^2);

fprintf('\nFinal Position Results:\n')
fprintf('Final x position: %.3f m\n', x_final)
fprintf('Final z position: %.3f m\n', z_final)
fprintf('x error: %.3f m\n', x_error)
fprintf('z error: %.3f m\n', z_error)
fprintf('Total position error: %.3f m\n', total_error)

% 1. X-Z trajectory plot
figure
plot(x_data, z_data, 'LineWidth', 2)
hold on
plot(x_data(1), z_data(1), 'o', 'MarkerSize', 8, 'LineWidth', 2)
plot(x_target, z_target, 'x', 'MarkerSize', 12, 'LineWidth', 3)
plot(x_data(end), z_data(end), 's', 'MarkerSize', 8, 'LineWidth', 2)

xlabel('Horizontal Position x (m)')
ylabel('Altitude z (m)')
title('2D Rocket Trajectory')
legend('Trajectory', 'Start', 'Target', 'Final Position', 'Location', 'best')
grid on
axis equal

xlim([min(x_data)-20, max(x_data)+20])
ylim([0, max(z_data)+20])

exportgraphics(gcf, fullfile(figuresDir, 'trajectory.png'), 'Resolution', 300)

% 2. Position response plot
figure
plot(t_data, x_data, 'LineWidth', 2)
hold on
plot(t_data, z_data, 'LineWidth', 2)
yline(x_target, '--', 'x target')
yline(z_target, '--', 'z target')

xlabel('Time (s)')
ylabel('Position (m)')
title('Position Response')
legend('x position', 'z position', 'x target', 'z target', 'Location', 'best')
grid on

exportgraphics(gcf, fullfile(figuresDir, 'position_response.png'), 'Resolution', 300)


% 3. Pitch response plot
try
    theta_data = out.theta_out.Data(:);

    figure
    plot(t_data, rad2deg(theta_data), 'LineWidth', 2)
    hold on

    try
        theta_cmd_data = out.theta_cmd_out.Data(:);
        plot(t_data, rad2deg(theta_cmd_data), '--', 'LineWidth', 2)
        legend('Actual pitch \theta', 'Commanded pitch \theta_{cmd}', 'Location', 'best')
    catch
        legend('Actual pitch \theta', 'Location', 'best')
    end

    xlabel('Time (s)')
    ylabel('Pitch Angle (deg)')
    title('Pitch Response')
    grid on

    exportgraphics(gcf, fullfile(figuresDir, 'pitch_response.png'), 'Resolution', 300)

catch
    disp('theta_out was not found, so pitch plot was skipped.')
end


% 4. Gimbal command plot
try
    delta_data = out.delta_out.Data(:);

    figure
    plot(t_data, rad2deg(delta_data), 'LineWidth', 2)
    xlabel('Time (s)')
    ylabel('Gimbal Angle \delta (deg)')
    title('Gimbal Command')
    grid on

    exportgraphics(gcf, fullfile(figuresDir, 'gimbal_command.png'), 'Resolution', 300)

catch
    disp('delta_out was not found, so gimbal plot was skipped.')
end


% 5. Thrust command plot
try
    T_cmd_data = out.T_cmd_out.Data(:);

    figure
    plot(t_data, T_cmd_data, 'LineWidth', 2)
    xlabel('Time (s)')
    ylabel('Thrust Command T_{cmd} (N)')
    title('Thrust Command')
    grid on

    exportgraphics(gcf, fullfile(figuresDir, 'thrust_command.png'), 'Resolution', 300)

catch
    disp('T_cmd_out was not found, so thrust plot was skipped.')
end

disp('Plots generated and saved to the figures folder.')