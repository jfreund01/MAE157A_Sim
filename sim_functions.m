% function sim_step[position, velocity, acceleration] = simulate_step(time, m, position, velocity, acceleration, angle_of_launch, drag_coefficient, g, rail_height, rail_length)
%     % Simulate one step of the motion
%     % find which range the is in for the thrust_profile to get the accurate thrust

%     thrust = m.thrust_profile(); % Get thrust from profile
%     drag = drag_coefficient * velocity^2; % Calculate drag force
%     net_force = thrust - drag - (m.mass * g); % Net force on the motor
%     acceleration = net_force / m.mass; % Calculate acceleration
%     velocity = velocity + acceleration * sim_time_step; % Update velocity
%     position = position + velocity * sim_time_step; % Update position
%     sim_step = struct('position', position, 'velocity', velocity, 'acceleration', acceleration);
%     time += sim_time_step; % Update time
% end

function thrust = get_thrust_from_profile(time_data, thrust_data, time)
    % Get thrust from the thrust profile based on the time
    % Assuming the profile is a table with time and thrust columns
    % Interpolate to find the thrust at the given time
    thrust = interp1(time_data, thrust_data, time);
end