
%% LAUNCH 1
%% INITIAL CONDITIONS %%
g = 9.81; % m/s^2
rail_length = 3; % m
angle_of_launch = 0*pi/180; % rad
end_time = 30; % s
time_step = 0.01; % s

%% ROCKET DIMENSIONS AND COEFFICIENTS %%
diameter = 0.0508; % m
area = pi * diameter^2 /4; % m^2
C_d_parachute = 2;
two_stage = 1;
parachute_diameter = .7 % m

% nose_shape = 4; % elliptical
% LN = .076; % m
% D = .051; % m
% XF1 = .305; % m
% CR1 = .048; % m
% CT1 = .025; % m
% XS1 = .038; % m
% S1 = .038; % m
% N1 = 3; % m
% 
% XF2 = .415; % m
% CR2 = .048; % m
% CT2 = .025; % m
% XS2 = .038; % m
% S2 = .03; % m
% N2 = 3; % m
% 
% 
% [CD1, x_cp1, CD2, x_cp2] = rocket_aero(nose_shape, D, LN, XF1, CR1, CT1, XS1, ...
%   S1, N1, XF2, CR2, CT2, XS2, S2, N2);

CD1 = .23; % override
CD2 = .20; % override

%% FIRST AND SECOND STAGE SETUP %%
first_stage_path = 'thrust_profiles/E35.txt';
second_stage_path = 'thrust_profiles/Apogee_E6.txt';

first_stage_total_mass = 0.332;  % kg, motors
second_stage_total_mass = 0.237; % kg, motors

% first_stage_mass = first_stage_mass / 2.205
% second_stage_mass = second_stage_mass / 2.205

first_stage_profile = load_thrust_profile(first_stage_path);
second_stage_profile = load_thrust_profile(second_stage_path);
ejection_charge_1 = 1 % s
ejection_charge_2 = 8 % s


first_stage_motor_mass = 0.056; % kg
second_stage_motor_mass = 0.046; %kg

first_stage_mass = first_stage_total_mass - first_stage_motor_mass;
second_stage_mass = second_stage_total_mass - second_stage_motor_mass;

first_stage_propellant_mass = 0.026; % kg
second_stage_propellant_mass = 0.022; % kg

% first_stage_dry_mass = first_stage_mass - first_stage_motor_mass; % kg (first stage)
% second_stage_dry_mass = second_stage_mass - second_stage_propellant_mass; % kg (second stage)

first_stage_profile.time = first_stage_profile.time - first_stage_profile.time(1);
second_stage_profile.time = second_stage_profile.time - second_stage_profile.time(1);


stage_delay_2 = second_stage_profile.time(end) + ejection_charge_2 + stage_delay_1


%% OBJECT CREATION %%
% subtract first time in profile from all other times
first_stage_motor = Motor(first_stage_motor_mass, first_stage_profile, ...
    first_stage_propellant_mass, stage_delay_1);
second_stage_motor = Motor(second_stage_motor_mass, second_stage_profile, ...
    second_stage_propellant_mass, stage_delay_2);

rocket = Rocket(first_stage_mass, second_stage_mass, ...
    first_stage_motor, second_stage_motor, diameter, area, two_stage, ...
     CD1, CD2, C_d_parachute, parachute_diameter); % create rocket

sim = SimObject(rail_length, angle_of_launch, rocket, end_time, time_step); % create simulation

%% RUN SIMULATION AND PLOT %%
state_list = sim.run_simulation(); % run simulation


important_states = struct(...
  'apogee', max(state_list.y_pos_list), ...
  'max_velocity', max(state_list.y_vel_list), ...
  'max_acceleration', max(state_list.y_accel_list), ...
  'first_burnout_time', state_list.first_motor_burnout, ...
  'second_motor_ignition', state_list.first_motor_ejection, ...
  'second_motor_burnout', state_list.second_motor_burnout, ...
  'apogee_time', state_list.apogee_time, ...
  'max_drag', max(abs(state_list.y_drag_list)), ...
  'cd1', CD1, 'cd2', CD2, 'x_cp1', x_cp1, 'x_cp2', x_cp2)




figure(1)
plot(state_list.time_list, state_list.y_pos_list, LineWidth=1.5, ...
    Color='blue', DisplayName='Altitude (ft)')
xline(important_states.first_burnout_time, LineWidth=1.25, ...
    Color='green', DisplayName='First Stage Burnout')
xline(important_states.second_motor_ignition, LineWidth=1.25, ...
    Color='red', DisplayName='Second Stage Ignition')
xline(important_states.apogee_time, LineWidth=1.25, ...
    Color='magenta', DisplayName='Apogee')
xline(important_states.second_motor_burnout, LineWidth=1.25, ...
    Color='#FFA500', DisplayName='Second Stage Burnout')
title('Altitude (ft) vs. time (s)')
xlabel('time (s)')
ylabel('Altitude (ft)')
grid on
grid minor
legend();

figure(2)
plot(state_list.time_list, state_list.y_vel_list, LineWidth=1.25, ...
    DisplayName='Vertical Velocity (ft/s)')
xline(important_states.first_burnout_time, LineWidth=1.25, ...
    Color='green', DisplayName='First Stage Burnout')
xline(important_states.second_motor_ignition, LineWidth=1.25, ...
    Color='red', DisplayName='Second Stage Ignition')
xline(important_states.apogee_time, LineWidth=1.25, ...
    Color='magenta', DisplayName='Apogee')
xline(important_states.second_motor_burnout, LineWidth=1.25, ...
    Color='#FFA500', DisplayName='Second Stage Burnout')
title('Vertical Velocity (ft/s) vs. time (s)')
xlabel('time (s)')
ylabel('Vertical Velocity (ft/s)')
grid on
grid minor
legend();


figure(3)
plot(state_list.time_list, state_list.y_accel_list, LineWidth=1.25, ...
    DisplayName='Vertical Acceleration (ft/s^2)')
xline(important_states.first_burnout_time, LineWidth=1.25, ...
    Color='green', DisplayName='First Stage Burnout')
xline(important_states.second_motor_ignition, LineWidth=1.25, ...
    Color='red', DisplayName='Second Stage Ignition')
xline(important_states.apogee_time, LineWidth=1.25, ...
    Color='magenta', DisplayName='Apogee')
xline(important_states.second_motor_burnout, LineWidth=1.25, ...
    Color='#FFA500', DisplayName='Second Stage Burnout')
title('Vertical Acceleration (m/s^2) vs. time (s)')
xlabel('time (s)')
ylabel('Acceleration (ft/s^2)')
grid on
grid minor
legend();


figure(4)
plot(state_list.time_list, state_list.y_drag_list, LineWidth=1.25, ...
    DisplayName='Vertical Drag (ft/s^2)')
xline(important_states.first_burnout_time, LineWidth=1.25, ...
    Color='green', DisplayName='First Stage Burnout')
xline(important_states.second_motor_ignition, LineWidth=1.25, ...
    Color='red', DisplayName='Second Stage Ignition')
xline(important_states.apogee_time, LineWidth=1.25, ...
    Color='magenta', DisplayName='Apogee')
xline(important_states.second_motor_burnout, LineWidth=1.25, ...
    Color='#FFA500', DisplayName='Second Stage Burnout')
title('Drag (N) vs. time (s)')
xlabel('time (s)')
ylabel('Drag (N)')
grid on
grid minor
legend();


% rocket_aero(nose_shape,D,LN,XF,CR,CT,XS,S,N,XF2,CR2,CT2,XS2,S2,N2)



important_states = struct('Apogee', max(state_list.y_pos_list), ...
  'Max_Velocity', max(state_list.y_vel_list), ...
  'Max_Acceleration', max(state_list.y_accel_list), ...
  'First_Burnout_Time', state_list.first_motor_burnout, ...
  'Second_Motor_Ignition', state_list.first_motor_ejection, ...
  'Apogee_Time', state_list.apogee_time, ...
  'Max_Drag', max(abs(state_list.y_drag_list)), ...
  'CD1', CD1, 'CD2', CD2, 'x_cp1', x_cp1, 'x_cp2', x_cp2)


