clear
clc
close all

% 2D 3DOF Rocket Takeoff Simulation with Thrust Vector Control

% Target position
x_target = 8;      % desired horizontal position, m
z_target = 113;      % desired altitude, m

% Rocket parameters
m = 100;             % mass, kg
Iyy = 500;           % pitch moment of inertia, kg*m^2
g = 9.81;            % gravity, m/s^2
lever_arm = 2;       % distance from CG to thrust line, m

% Initial input values
T_const = 2000;      % constant thrust value used for early testing, N
delta_const = 0;     % constant gimbal value used for early testing, rad


% Simulation time
t_final = 60;        % seconds


% Controller gains
Kz = 0.08;           % altitude proportional gain
Kvz = 0.5;           % vertical velocity damping gain

Kvx = 0.025;         % horizontal velocity damping gain
Kx = 0.002;          % horizontal position gain

% Run Simulink model
modelName = 'rocket_3dof';

scriptDir = fileparts(mfilename('fullpath'));
projectDir = fileparts(scriptDir);
modelDir = fullfile(projectDir, 'model');
modelPath = fullfile(modelDir, [modelName '.slx']);

disp("Looking for model here:")
disp(modelPath)

if ~isfile(modelPath)
    error('Could not find model file here: %s', modelPath)
end

addpath(modelDir)
load_system(modelPath)

out = sim(modelName, 'StopTime', num2str(t_final));

disp('Simulation complete.')