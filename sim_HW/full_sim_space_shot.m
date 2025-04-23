% Max Thrust 4500 lbf
% Specific Impulse 300 s
% Dry mass 500 lbm
% Diameter 1.25 ft
% Drag Coefficient 0.75

%% LAUNCH 1
%% INITIAL CONDITIONS AND SIM SETUP VALUES %%
g = 9.81; % m/s^2
rail_length = 3; % m
air_density = 1.225; % kg/m^3
angle_of_launch = 0; % rad
apogee_list = [];
m_dot = 6.804; % kg/s
end_time = 200 % s
time_step = .01 % s

%% FIRST AND SECOND STAGE SETUP %%
% for propellant_mass = 80:.5:100
propellant_mass = 285;
    first_stage_path = 'thrust_profiles/space_shot.txt';
    second_stage_path = 'thrust_profiles/empty.txt';
    
    first_stage_mass = 226.796;  % kg
    second_stage_mass = first_stage_mass; % kg
    
    % first_stage_mass = first_stage_mass / 2.205
    % second_stage_mass = second_stage_mass / 2.205
    
    first_stage_profile = load_thrust_profile(first_stage_path);
    first_stage_profile.time(2) = propellant_mass / m_dot
    second_stage_profile = load_thrust_profile(second_stage_path);

    ejection_charge = 100000; % s
    stage_delay = ejection_charge + first_stage_profile.time(end); % s
    
    first_stage_motor_mass = 0; % kg
    second_stage_motor_mass = 0; %kg
    
    first_stage_propellant_mass = propellant_mass; % kg
    second_stage_propellant_mass = 0; % kg
    
    first_stage_dry_mass = first_stage_mass - first_stage_motor_mass; % kg (first stage)
    second_stage_dry_mass = second_stage_mass - second_stage_propellant_mass; % kg (second stage)
    
    first_stage_profile.time = first_stage_profile.time - first_stage_profile.time(1);
    second_stage_profile.time = second_stage_profile.time - second_stage_profile.time(1) + stage_delay;
    
    
    %% ROCKET DIMENSIONS AND COEFFICIENTS %%
    diameter = 0.381; % m
    area = pi * diameter^2 /4; % m^2
    C_d_first = 0.75;
    C_d_second = 0.75;
    C_d_parachute = 0.75;
    two_stage = 0;
    parachute_diameter = .3048; % m
    
    %% OBJECT CREATION %%
    % subtract first time in profile from all other times
    first_stage_motor = Motor(first_stage_motor_mass, first_stage_profile, ...
        first_stage_propellant_mass, stage_delay);
    second_stage_motor = Motor(second_stage_motor_mass, second_stage_profile, ...
        second_stage_propellant_mass, 0);
    
    rocket = Rocket(first_stage_mass + propellant_mass, second_stage_dry_mass, ...
        first_stage_motor, second_stage_motor, diameter, area, two_stage, ...
         C_d_first, C_d_second, C_d_parachute, parachute_diameter); % create rocket
    
    sim = SimObject(rail_length, angle_of_launch, rocket, end_time, time_step); % create simulation
    
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

    max_state = struct('Apogee', max(state_list.y_pos_list), ...
      'Max_Velocity', max(state_list.y_vel_list), ...
      'Max_Acceleration', max(state_list.y_accel_list), ...
      'Burnout_Velocity', sim.burnout_velocity, ...
      'Burnout_Altitude', sim.burnout_altitude, ...
      'Max_Drag', max(abs(state_list.y_drag_list)))
    
%     propellent_mass_list = [80:.5:100];
%     apogee_list = [apogee_list, max_state.Apogee];
% end
% 
% figure(1)
% plot(propellent_mass_list, apogee_list, LineWidth=1.25)
% yline(3.3e+5, Color='red', LineWidth=1.25, DisplayName='Karman Line')
% title("Propellant Mass (kg) vs. Apogee (ft) for Space Shot")
% xlabel("Propellant Mass (kg)")
% ylabel("Apogee (ft)")
% grid on
% grid minor
% 


