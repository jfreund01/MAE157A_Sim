%% INITIAL CONDITIONS %%
g = 9.81; % m/s^2
rail_length = 3; % m
air_density = 1.225; % kg/m^3
angle_of_launch = 0; % rad

%% FIRST AND SECOND STAGE SETUP %%
first_stage_path = 'thrust_profiles/F15.txt';
second_stage_path = 'thrust_profiles/E9.txt';

second_stage_mass = 0.455 % lbs
first_stage_mass = 0.918 % kg

second_stage_mass = second_stage_mass / 2.205
first_stage_mass = first_stage_mass / 2.205

first_stage_profile = load_thrust_profile(first_stage_path);
second_stage_profile = load_thrust_profile(second_stage_path);
stage_delay = 3.5 %s

first_stage_motor_mass = .102; % kg
second_stage_motor_mass = .057; %kg

first_stage_propellant_mass =.060; % kg
second_stage_propellant_mass =.036; % kg

first_stage_dry_mass = first_stage_mass - first_stage_motor_mass; % kg (first stage)
second_stage_dry_mass = second_stage_mass - second_stage_motor_mass; % kg (second stage)

first_stage_profile.time = first_stage_profile.time - first_stage_profile.time(1);
second_stage_profile.time = second_stage_profile.time - second_stage_profile.time(1) + stage_delay;

%% ROCKET DIMENSIONS %%
diameter = 0.0500; % m
area = pi * diameter^2 /4; % m^2
drag_coefficient = 0.62; % drag coefficient


%% OBJECT CREATION %%
% subtract first time in profile from all other times
first_stage_motor = Motor(first_stage_motor_mass, first_stage_profile, ...
    first_stage_propellant_mass, stage_delay);
second_stage_motor = Motor(second_stage_motor_mass, second_stage_profile, ...
    second_stage_propellant_mass, 0);

rocket = Rocket(first_stage_dry_mass, second_stage_dry_mass, ...
    first_stage_motor, second_stage_motor, drag_coefficient, diameter, area); % create rocket

sim = SimObject(rail_length, air_density, angle_of_launch, rocket); % create simulation

%% RUN SIMULATION AND PLOT %%
state_list = sim.run_simulation(); % run simulation
plot(state_list.x_pos_list, state_list.y_pos_list)

max_state = struct('Apogee', max(state_list.y_pos_list) * 3.28, ...
  'Max_Velocity', max(state_list.y_vel_list), ...
  'Max_Acceleration', max(state_list.y_accel_list))

%% EXTRA FUNCTIONS %%
function thrust_profile = load_thrust_profile(path)
    % Load thrust profile from a file
    thrust_profile = readtable(path);
end

