classdef Rocket < handle
    % define important properties for rocket
    properties
        diameter {mustBeNumeric}
        area {mustBeNumeric}
        first_stage_mass {mustBeNumeric}
        second_stage_mass {mustBeNumeric}
        first_motor % first stage motor
        second_motor % second stage motor
        two_stage {mustBeNumericOrLogical}
        C_d_first;
        C_d_second;
        C_d_parachute;
        parachute_area;

    end
    methods
        function obj = Rocket(first_stage_mass, second_stage_mass, ...
                 first_motor, second_motor, diameter, area, two_stage, ... 
                 C_d_first, C_d_second, C_d_parachute, parachute_area)

            obj.first_stage_mass = first_stage_mass;
            obj.second_stage_mass = second_stage_mass;
            obj.first_motor = first_motor;
            obj.second_motor = second_motor;
            obj.diameter = diameter;
            obj.area = area;
            obj.two_stage = two_stage;
            obj.C_d_first = C_d_first;
            obj.C_d_second = C_d_second;
            obj.C_d_parachute = C_d_parachute;
            obj.parachute_area = parachute_area;
        end
    end
end
