classdef Rocket < handle
    properties
        mass
        drag_coefficient {mustBeNumeric}
        diameter {mustBeNumeric}
        area {mustBeNumeric}
        first_stage_dry {mustBeNumeric}
        second_stage_dry {mustBeNumeric}
        first_motor % first stage motor
        second_motor % second stage motor

    end
    methods
        function obj = Rocket(first_stage_dry_mass, second_stage_dry_mass, ...
                 first_motor, second_motor, drag_coefficient, diameter, area)

            obj.mass = first_stage_dry_mass + second_stage_dry_mass ...
                + first_motor.mass + second_motor.mass;
            obj.first_stage_dry = first_stage_dry_mass;
            obj.second_stage_dry = second_stage_dry_mass;
            obj.first_motor = first_motor;
            obj.second_motor = second_motor;
            obj.drag_coefficient = drag_coefficient;
            obj.diameter = diameter;
            obj.area = area;
        end
    end
end
