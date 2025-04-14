classdef Rocket < handle
    properties
        mass {mustBeNumeric}
        drag_coefficient {mustBeNumeric}
        diameter {mustBeNumeric}
        area {mustBeNumeric}
        motor % motor object

    end
    methods
        function obj = Rocket(mass, motor, drag_coefficient, diameter, area)
            obj.mass = mass + motor.mass;
            obj.motor = motor;
            obj.drag_coefficient = drag_coefficient;
            obj.diameter = diameter;
            obj.area = area;
        end
    end
end
