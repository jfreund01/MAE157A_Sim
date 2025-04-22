% Launch    Rocket          Diameter [in]   Motor       Dry Mass [g]    Parachute Diameter [in]
% 1         Control Rocket  0.98            Estes A8-3  49              12
% 2         Control Rocket  1.38            Estes B4-4  89.2            12
% 3         Your Rocket     Measure         Estes A8-3  Measure         Measure
% 4         Your Rocket     Measure         Estes B4-4  Measure         Measure

% i. Trajectory with no drag
% ii. Trajectory with vehicle CD = 0.5 and parachute CD =1.5
% iii. Trajectory with vehicle CD =0.8 and parachute CD =2
% iv. Actual trajectory, using csv data from bruinlearn.


%% LAUNCH 1
%% INITIAL CONDITIONS %%
g = 9.81; % m/s^2
rail_length = 3; % m
air_density = 1.225; % kg/m^3
angle_of_launch = 0*pi/180; % rad
end_time = 20; % s

%% ROCKET DIMENSIONS AND COEFFICIENTS %%
diameter = 0.0508; % m
area = pi * diameter^2 /4; % m^2
C_d_parachute = 0;
two_stage = 1;
parachute_diameter = .3048 % m

nose_shape = 4; % elliptical
LN = .076; % m
D = .051; % m
XF1 = .305; % m
CR1 = .048; % m
CT1 = .025; % m
XS1 = .038; % m
S1 = .038; % m
N1 = 3; % m

XF2 = .415; % m
CR2 = .048; % m
CT2 = .025; % m
XS2 = .038; % m
S2 = .03; % m
N2 = 3; % m


[CD1, x_cp1, CD2, x_cp2] = rocket_aero(nose_shape, D, LN, XF1, CR1, CT1, XS1, ...
  S1, N1, XF2, CR2, CT2, XS2, S2, N2);

CD1 = .35;
CD2 = .31;

%% FIRST AND SECOND STAGE SETUP %%
first_stage_path = 'thrust_profiles/E35.txt';
second_stage_path = 'thrust_profiles/Apogee_E6.txt';

first_stage_total_mass = 0.374;  % kg, motors
second_stage_total_mass = 0.267; % kg, motors

% first_stage_mass = first_stage_mass / 2.205
% second_stage_mass = second_stage_mass / 2.205

first_stage_profile = load_thrust_profile(first_stage_path);
second_stage_profile = load_thrust_profile(second_stage_path);
ejection_charge = 2 % s
stage_delay = ejection_charge + first_stage_profile.time(end) % s

first_stage_motor_mass = 0.056; % kg
second_stage_motor_mass = 0.046; %kg

first_stage_mass = first_stage_total_mass - first_stage_motor_mass;
second_stage_mass = second_stage_total_mass - second_stage_motor_mass;

first_stage_propellant_mass = 0.026; % kg
second_stage_propellant_mass = 0.022; % kg

% first_stage_dry_mass = first_stage_mass - first_stage_motor_mass; % kg (first stage)
% second_stage_dry_mass = second_stage_mass - second_stage_propellant_mass; % kg (second stage)

first_stage_profile.time = first_stage_profile.time - first_stage_profile.time(1);
second_stage_profile.time = second_stage_profile.time - second_stage_profile.time(1) + stage_delay;

%% OBJECT CREATION %%
% subtract first time in profile from all other times
first_stage_motor = Motor(first_stage_motor_mass, first_stage_profile, ...
    first_stage_propellant_mass, stage_delay);
second_stage_motor = Motor(second_stage_motor_mass, second_stage_profile, ...
    second_stage_propellant_mass, 0);

rocket = Rocket(first_stage_mass, second_stage_mass, ...
    first_stage_motor, second_stage_motor, diameter, area, two_stage, ...
     CD1, CD2, C_d_parachute, parachute_diameter); % create rocket

sim = SimObject(rail_length, air_density, angle_of_launch, rocket, end_time); % create simulation

%% RUN SIMULATION AND PLOT %%
figure(1)
state_list = sim.run_simulation(); % run simulation
sim.off_rail_speed
subplot(4,1,1);
plot(state_list.time_list, state_list.y_pos_list, LineWidth=1.25)
title('Height (m) vs. time (s)')
grid on
grid minor

subplot(4,1,2);
plot(state_list.time_list, state_list.y_vel_list, LineWidth=1.25)
title('Vertical Velocity (m/s^2) vs. time (s)')
grid on
grid minor

subplot(4,1,3);
plot(state_list.time_list, state_list.y_accel_list, LineWidth=1.25)
title('Vertical Acceleration (m/s^2) vs. time (s)')
grid on
grid minor

subplot(4,1,4);
plot(state_list.time_list, state_list.y_drag_list, LineWidth=1.25)
title('Drag (N) vs. time (s)')
grid on
grid minor

% rocket_aero(nose_shape,D,LN,XF,CR,CT,XS,S,N,XF2,CR2,CT2,XS2,S2,N2)



    max_state = struct('Apogee', max(state_list.y_pos_list), ...
      'Max_Velocity', max(state_list.y_vel_list), ...
      'Max_Acceleration', max(state_list.y_accel_list), ...
      'Burnout_Velocity', sim.burnout_velocity, ...
      'Burnout_Altitude', sim.burnout_altitude, ...
      'Max_Drag', max(abs(state_list.y_drag_list)), ...
      'CD1', CD1, 'CD2', CD2, 'x_cp1', x_cp1, 'x_cp2', x_cp2)


