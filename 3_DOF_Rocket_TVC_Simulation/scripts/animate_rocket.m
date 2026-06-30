
% Run this script after running run_simulation.m

if ~exist('out', 'var')
    error('Simulation output "out" was not found. Run run_simulation first.')
end

scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
mediaDir = fullfile(projectDir, 'media');

if ~exist(mediaDir, 'dir')
    mkdir(mediaDir)
end

videoFile = fullfile(mediaDir, 'rocket_animation.mp4');

x_data = out.x_out.Data(:);
z_data = out.z_out.Data(:);
theta_data = out.theta_out.Data(:);
t_data = out.x_out.Time(:);


% Animation settings
numFrames = 450;               
animationDuration = 25;       
idx = round(linspace(1, length(x_data), numFrames));

frameRate = round(numFrames / animationDuration);


% Rocket geometry
L = 10;    % rocket length
W = 3;     % rocket width

% Rocket body shape in local coordinates
% a = along rocket axis, b = side-to-side
a_body = [-L/2,  L*0.20,  L/2,  L*0.20, -L/2];
b_body = [-W/2, -W/2,     0,     W/2,    W/2];

% Flame shape in local coordinates
a_flame = [-L/2, -L/2 - 5, -L/2];
b_flame = [-W*0.35, 0, W*0.35];


% Create figure
fig = figure;
set(fig, 'Color', 'w')
set(fig, 'Position', [100 100 900 700])

hold on
grid on
axis equal

% Plot full trajectory lightly in background
plot(x_data, z_data, '--', 'LineWidth', 1)

% Plot start, target, and final position
plot(x_data(1), z_data(1), 'o', 'MarkerSize', 8, 'LineWidth', 2)
plot(x_target, z_target, 'x', 'MarkerSize', 12, 'LineWidth', 3)
plot(x_data(end), z_data(end), 's', 'MarkerSize', 8, 'LineWidth', 2)

xlabel('Horizontal Position x (m)')
ylabel('Altitude z (m)')
title('2D Rocket Takeoff Animation')
legend('Trajectory', 'Start', 'Target', 'Final Position', 'Location', 'best')

xlim([min(x_data)-25, max(x_data)+25])
ylim([0, max(z_data)+25])

% Animated trail
trail = animatedline('LineWidth', 2);

% Rocket body and flame
rocket_patch = patch(0, 0, [0.2 0.2 0.2]);
flame_patch = patch(0, 0, [1 0.4 0]);

% Text readout
infoText = text(min(x_data)-20, max(z_data)+15, '', ...
    'FontSize', 11, 'FontWeight', 'bold');

v = VideoWriter(videoFile, 'MPEG-4');
v.FrameRate = frameRate;
open(v);


% Animation loop
for k = 1:length(idx)

    i = idx(k);

    x = x_data(i);
    z = z_data(i);
    theta = theta_data(i);

    % theta is measured from vertical
    x_body = x + a_body*sin(theta) + b_body*cos(theta);
    z_body = z + a_body*cos(theta) - b_body*sin(theta);

    % Transform flame shape
    x_flame = x + a_flame*sin(theta) + b_flame*cos(theta);
    z_flame = z + a_flame*cos(theta) - b_flame*sin(theta);

    % Update rocket body and flame
    set(rocket_patch, 'XData', x_body, 'YData', z_body)
    set(flame_patch, 'XData', x_flame, 'YData', z_flame)

    % Update trail
    addpoints(trail, x, z)

    % Update text
    infoText.String = sprintf('t = %.1f s   x = %.1f m   z = %.1f m   theta = %.2f deg', ...
        t_data(i), x, z, rad2deg(theta));

    drawnow

    % Save current frame to video
    frame = getframe(fig);
    writeVideo(v, frame);

end

close(v);

fprintf('Animation saved to:\n%s\n', videoFile)