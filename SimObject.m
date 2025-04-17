classdef SimObject < handle
    properties
        rail_length {mustBeNumeric}
        air_density {mustBeNumeric}
        angle_of_launch {mustBeNumeric}
        time {mustBeNumeric}
        time_step {mustBeNumeric}
        end_time {mustBeNumeric}
        g {mustBeNumeric}
        off_rail_speed = 0;
        rocket % rocket object
        
        x_position = 0;
        x_velocity = 0;
        x_acceleration = 0;
        
        y_position = 0;
        y_velocity = 0;
        y_acceleration = 0;

    end
    methods
        function thrust = get_thrust_from_profile(obj)
            % Get thrust from the thrust profile based on the time
            % Assuming the profile is a table with time and thrust columns
            % Interpolate to find the thrust at the given time
            if (obj.time < obj.rocket.first_motor.stage_delay)
                thrust = interp1(obj.rocket.first_motor.thrust_profile.time, obj.rocket.first_motor.thrust_profile.thrust, obj.time, "linear", "extrap");
            else
                thrust = interp1(obj.rocket.second_motor.thrust_profile.time, obj.rocket.second_motor.thrust_profile.thrust, obj.time, "linear", "extrap");
            end
            
            if (thrust < 0)
                thrust = 0; % If time is out of bounds, return 0 thrust
            end
        end

        function C_d = get_drag_coefficient(obj)
            if (obj.time < obj.rocket.first_motor.stage_delay)
                C_d = 0.90; % first stage average C_d
            else
                C_d = 0.58; % second stage average C_d
            end
        end        
        
        function mass = get_mass(obj)
            if (obj.time < obj.rocket.first_motor.stage_delay)
                burned_mass = interp1(obj.rocket.first_motor.mass_profile.time, obj.rocket.first_motor.mass_profile.mass, obj.time, 'linear', 'extrap');
                if burned_mass < obj.rocket.first_motor.mass_profile.mass(end)
                    burned_mass = obj.rocket.first_motor.mass_profile.mass(end);
                end
                mass = obj.rocket.mass - burned_mass;
            else
                burned_mass = interp1(obj.rocket.second_motor.mass_profile.time, obj.rocket.second_motor.mass_profile.mass, obj.time, 'linear', 'extrap');
                if burned_mass < obj.rocket.second_motor.mass_profile.mass(end)
                    burned_mass = obj.rocket.second_motor.mass_profile.mass(end);
                end
                obj.rocket.mass;
                obj.rocket.first_motor.mass;
                obj.rocket.first_stage_dry;
                burned_mass;
                mass = obj.rocket.mass - obj.rocket.first_motor.mass - obj.rocket.first_stage_dry - burned_mass;
            end
        end

        function sim_step = simulate_step(obj)
            % Simulate one step of the motion
            
            % find which range the is in for the thrust_profile to get the accurate thrust
            obj.time = obj.time + obj.time_step; % Update time
            thrust = obj.get_thrust_from_profile(); % Get thrust from profile

            % get velocity vector and drag
            velocity_vector = [obj.x_velocity, obj.y_velocity];
            speed = norm(velocity_vector);
            
            if speed > 0
                drag_vector = 0.5 * obj.get_drag_coefficient * obj.rocket.area * obj.air_density * speed^2 * (-velocity_vector/speed);
            else
                drag_vector = [0, 0];
            end

            if (obj.y_position < obj.rail_length)
            % calculate net forces in each direction
                x_force = (thrust * sin(obj.angle_of_launch)) + drag_vector(1);
                y_force = (thrust * cos(obj.angle_of_launch)) - (obj.get_mass * obj.g) + drag_vector(2);
            else
                vel_dir = velocity_vector / norm(velocity_vector);
                x_force = (thrust * vel_dir(1)) + drag_vector(1);
                y_force = (thrust * vel_dir(2)) - (obj.get_mass * obj.g) + drag_vector(2);
            end


            obj.y_acceleration = y_force / obj.rocket.mass; % Calculate acceleration
            obj.y_velocity = obj.y_velocity + (obj.y_acceleration * obj.time_step); % Update velocity
            obj.y_position = obj.y_position + (obj.y_velocity * obj.time_step); % Update position
            
            obj.x_acceleration = x_force / obj.rocket.mass; % Calculate acceleration
            obj.x_velocity = obj.x_velocity + (obj.x_acceleration * obj.time_step); % Update velocity
            obj.x_position = obj.x_position + (obj.x_velocity * obj.time_step); % Update position
            
            sim_step = struct('y_position', obj.y_position, 'y_velocity', obj.y_velocity, ...
                'y_acceleration', obj.y_acceleration, 'time', obj.time, 'thrust', thrust, ...
                'x_position', obj.x_position, 'x_velocity', obj.x_velocity, 'x_acceleration', obj.x_acceleration); 
            % Create a struct to hold the simulation step data
            % time += sim_time_step; % Update time
        end

        function state_list = run_simulation(obj)
            n_steps = ceil(obj.end_time / obj.time_step) + 1;
            x_pos_list = zeros(1, n_steps);
            x_vel_list = zeros(1, n_steps);
            x_accel_list = zeros(1, n_steps);
            y_pos_list = zeros(1, n_steps);
            y_vel_list = zeros(1, n_steps);
            y_accel_list = zeros(1, n_steps);
            time_list = zeros(1, n_steps);
            for idx = 1:n_steps
                sim_state = obj.simulate_step;

                x_pos_list(idx) = sim_state.x_position;
                x_vel_list(idx) = sim_state.x_velocity;
                x_accel_list(idx) = sim_state.x_acceleration;
                y_pos_list(idx) = sim_state.y_position;
                y_vel_list(idx) = sim_state.y_velocity;
                y_accel_list(idx) = sim_state.y_acceleration;
                
                time_list(idx) = obj.time;
            end

            obj.off_rail_speed = interp1(y_pos_list, y_vel_list, 10, "linear")
            
            obj.off_rail_speed
            
            state_list = struct('y_pos_list', y_pos_list, 'y_vel_list', y_vel_list, ...
                'x_pos_list', x_pos_list, 'x_vel_list', x_vel_list, ...
                'x_accel_list', x_accel_list, 'y_accel_list', y_accel_list, ...
                'time_list', time_list);

        end

        function obj = SimObject(rail_length, air_density, angle_of_launch, rocket)
            obj.rail_length = rail_length;
            obj.air_density = air_density;
            obj.angle_of_launch = angle_of_launch;
            obj.rocket = rocket;
            obj.time = 0;
            obj.time_step = .01; % sim time step
            obj.g = 9.81; % m/s^2
            obj.end_time = 25; % s
        end

    end
end

