m1 = load_thrust_profile("thrust_profiles/E35.txt")
m2 = load_thrust_profile("thrust_profiles/Apogee_E6.txt")

delay = 1;

t1 = m1.time;
t2 = m2.time;
f1 = m1.thrust;
f2 = m2.thrust;
% --- Shift second-stage time so it starts after t1(end) + delay ---
t2_shifted = (t2 - t2(1)) + t1(end) + delay;

% --- Build the coast segment at zero thrust ---
t_delay = [t1(end); t1(end) + delay];
F_delay = [0; 0];

% --- Concatenate all segments ---
t_all = [t1(:); t_delay; t2_shifted(:)];
F_all = [f1(:); F_delay; f2(:)];

% --- Plot ---
figure;
plot(t_all, F_all, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Thrust (N)');
title('Two-Stage Thrust Profile - Quest E35-1, Apogee E6-8');
grid on;
xlim([0, t_all(end)]);