classdef Motor < handle
    properties
        mass {mustBeNumeric}
        m_prop {mustBeNumeric}
        thrust_profile
        mass_profile
    end
    methods
        function obj = Motor(mass, thrust_profile, m_prop)
            obj.mass = mass;
            obj.thrust_profile = thrust_profile;
            obj.m_prop = m_prop;
            % integrate over thrust profile, then normalize for mass
            % profile
            cumulative_impulse = cumtrapz(obj.thrust_profile.time, obj.thrust_profile.thrust);
            total_impulse = cumulative_impulse(end);
            propellant_burned = obj.m_prop * (cumulative_impulse / total_impulse);
            obj.mass_profile.time = obj.thrust_profile.time;
            obj.mass_profile.mass = mass - propellant_burned;
        end
    end
end

