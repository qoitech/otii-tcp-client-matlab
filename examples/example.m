% Create an Otii project
if exist('client', 'var')
    delete(client);
end

client = OtiiClient('localhost', 1905);
otii = Otii(client);

try
    % Configure first available device
    devices = otii.get_devices();
    assert(~isempty(devices), 'No available devices');
    arc = devices(1);

    % Create a new project if needed
    project = otii.get_active_project();
    if isempty(project)
        project = otii.open_project('Testar.otii', true, true, @(progress) disp(progress));
        if isempty(project)
            project = otii.create_project();
        end
    end

    % arc.calibrate();
    arc.set_main_voltage(3.3);
    arc.set_max_current(0.5);
    arc.set_range('low');
    arc.set_exp_voltage(3.3);
    arc.enable_exp_port(true);
    arc.set_uart_baudrate(115200);
    arc.enable_uart(true);
    arc.enable_channel('mc', true);
    arc.enable_channel('me', true);
    arc.enable_channel('mv', true);
    arc.enable_channel('rx', true);

    % Record for a few seconds
    project.start_recording();
    otii.set_all_main(true);
    pause(2);
    otii.set_all_main(false);
    project.stop_recording();

    % Read recorded data
%    recordings = project.get_recordings();
%    recording = recordings(1);
    recording = project.get_last_recording();

    count = recording.get_channel_data_count(arc.device_id, 'mc');
    data = recording.get_channel_data(arc.device_id, 'mc', 0, 1000);

    timestamp = 0:0.25:249.75;
    plot(timestamp, data.values);

    % Save the project
    project.save('Testar.otii', true, true, @(progress) disp(progress));

catch ME
    disp(ME);
    for k = 1:length(ME.stack)
        disp(ME.stack(k));
    end
end

% Clean up
delete(client);
clear client
