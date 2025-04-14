%% INITIAL CONDITIONS %%
path = 'thrust_profiles/F12.txt';
profile = load_thrust_profile(path);
angle_of_launch = 0; % rad
drag_coefficient = 0.74; % drag coefficient
motor_mass = .103; % kg
propellant_mass =.060 % kg
dry_mass = .331; % kg
g = 9.81; % m/s^2
rail_height = 0; % m
rail_length = 10; % m
diameter = 0.0468; % m
area = pi * diameter^2 /4; % m^2
air_density = 1.225; % kg/m^3


% subtract first time in profile from all other times
profile.time = profile.time - profile.time(1);

motor = Motor(motor_mass, profile, propellant_mass); % create motor
rocket = Rocket(dry_mass, motor, drag_coefficient, diameter, area); % create rocket
sim = SimObject(rail_height, rail_length, air_density, angle_of_launch, rocket); % create simulation
state_list = sim.run_simulation(); % run simulation
xplot(state_list.x_pos_list, state_list.y_pos_list)

max_state = struct('Apogee', max(state_list.y_pos_list), ...
    'Max_Velocity', max(state_list.y_vel_list), ...
    'Max_Acceleration', max(state_list.y_accel_list))

function thrust_profile = load_thrust_profile(path)
    % Load thrust profile from a file
    thrust_profile = readtable(path);
end

