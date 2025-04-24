% Launch Rocket Diameter [in] Motor Dry Mass [g]
% (with empty
% motor)
% Parachute Diameter [in]
% 1 Control Rocket 0.98 Estes B4-4 80 12
% 2 Control Rocket 1.38 Estes B4-4 70 12
% 3 Your Rocket Measure Estes A8-3 Measure Measure
% 4 Your Rocket Measure Estes B6-6 Measure Measure

% i. Trajectory with no drag
% ii. Trajectory with vehicle CD = 0.5 and parachute CD =1.5
% iii. Trajectory with vehicle CD =0.8 and parachute CD =2
% iv. Actual trajectory, using csv data from bruinlearn.


%% LAUNCH 1
%% INITIAL CONDITIONS %%
g = 9.81; % m/s^2
rail_length = 1.5; % m
angle_of_launch = 10*pi/180; % rad
end_time = 40; % s
time_step = .01 % s

%% FIRST AND SECOND STAGE SETUP %%
first_stage_path = 'thrust_profiles/A8.txt';
second_stage_path = 'thrust_profiles/empty.txt';

first_stage_mass = 0.080 + .006  % kg
second_stage_mass = first_stage_mass % kg

% first_stage_mass = first_stage_mass / 2.205
% second_stage_mass = second_stage_mass / 2.205

first_stage_profile = load_thrust_profile(first_stage_path);
second_stage_profile = load_thrust_profile(second_stage_path);
ejection_charge = 4 % s
stage_delay = ejection_charge + first_stage_profile.time(end) % s

first_stage_motor_mass = .019; % kg
second_stage_motor_mass = 0; %kg

first_stage_propellant_mass = .006; % kg
second_stage_propellant_mass = 0; % kg

first_stage_dry_mass = first_stage_mass - first_stage_motor_mass; % kg (first stage)
second_stage_dry_mass = second_stage_mass - second_stage_propellant_mass; % kg (second stage)

first_stage_profile.time = first_stage_profile.time - first_stage_profile.time(1);
second_stage_profile.time = second_stage_profile.time - second_stage_profile.time(1) + stage_delay;

%% ROCKET DIMENSIONS AND COEFFICIENTS %%
diameter = 0.035052; % m
area = pi * diameter^2 /4; % m^2
C_d_first = 0;
C_d_second = 0;
C_d_parachute = 2;
two_stage = 0;
parachute_diameter = .3048 % m

%% OBJECT CREATION %%
% subtract first time in profile from all other times
first_stage_motor = Motor(first_stage_motor_mass, first_stage_profile, ...
    first_stage_propellant_mass, stage_delay);
second_stage_motor = Motor(second_stage_motor_mass, second_stage_profile, ...
    second_stage_propellant_mass, 0);

rocket = Rocket(first_stage_dry_mass, second_stage_dry_mass, ...
    first_stage_motor, second_stage_motor, diameter, area, two_stage, ...
     C_d_first, C_d_second, C_d_parachute, parachute_diameter); % create rocket

sim = SimObject(rail_length, angle_of_launch, rocket, end_time, time_step); % create simulation

%% RUN SIMULATION AND PLOT %%
figure(1)
state_list = sim.run_simulation(); % run simulation
plot(state_list.time_list, state_list.y_pos_list, LineWidth=1.25, DisplayName='no drag')
title('Height (m) vs. time (s)')
grid on
grid minor
hold on

max_state = struct('Apogee', max(state_list.y_pos_list), ...
  'Max_Velocity', max(state_list.y_vel_list), ...
  'Max_Acceleration', max(state_list.y_accel_list))





%% LAUNCH 2

%% ROCKET DIMENSIONS AND COEFFICIENTS %%
C_d_first = 0.5;
C_d_second = 0.5;
C_d_parachute = 1.5;

%% OBJECT CREATION %%
% subtract first time in profile from all other times
first_stage_motor = Motor(first_stage_motor_mass, first_stage_profile, ...
    first_stage_propellant_mass, stage_delay);
second_stage_motor = Motor(second_stage_motor_mass, second_stage_profile, ...
    second_stage_propellant_mass, 0);

rocket = Rocket(first_stage_dry_mass, second_stage_dry_mass, ...
    first_stage_motor, second_stage_motor, diameter, area, two_stage, ...
     C_d_first, C_d_second, C_d_parachute, parachute_diameter); % create rocket

sim = SimObject(rail_length, angle_of_launch, rocket, end_time, time_step); % create simulation

%% RUN SIMULATION AND PLOT %%
state_list = sim.run_simulation(); % run simulation

plot(state_list.time_list, state_list.y_pos_list, LineWidth=1.25, DisplayName='Cd = 0.5')
title('Height (m) vs. time (s)')



%% LAUNCH 3

%% ROCKET DIMENSIONS AND COEFFICIENTS %%
C_d_first = 0.8;
C_d_second = 0.8;
C_d_parachute = 2.0;

%% OBJECT CREATION %%
% subtract first time in profile from all other times
first_stage_motor = Motor(first_stage_motor_mass, first_stage_profile, ...
    first_stage_propellant_mass, stage_delay);
second_stage_motor = Motor(second_stage_motor_mass, second_stage_profile, ...
    second_stage_propellant_mass, 0);

rocket = Rocket(first_stage_dry_mass, second_stage_dry_mass, ...
    first_stage_motor, second_stage_motor, diameter, area, two_stage, ...
     C_d_first, C_d_second, C_d_parachute, parachute_diameter); % create rocket

sim = SimObject(rail_length, angle_of_launch, rocket, end_time, time_step); % create simulation

%% RUN SIMULATION AND PLOT %%
state_list = sim.run_simulation(); % run simulation


plot(state_list.time_list, state_list.y_pos_list, LineWidth=1.25, DisplayName='Cd = 0.8')
title('Height (m) vs. time (s)')

exper = readtable("Untitled.txt")
scatter(exper{:, 1}, exper{:, 3})

legend();