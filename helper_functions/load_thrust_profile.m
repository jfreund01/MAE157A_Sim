%% EXTRA FUNCTIONS %%
function thrust_profile = load_thrust_profile(path)
    % Load thrust profile from a file
    thrust_profile = readtable(path);
end
