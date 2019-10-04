classdef Project
    properties
        connection
        project_id
    end

    methods
        function obj = Project(connection, project_id)
            obj.connection = connection;
            obj.project_id = project_id;
        end

        function close(obj)
            data = struct('project_id', obj.project_id);
            obj.connection.send_command('project_close', data);
        end

        function crop_data(obj)
            data = struct('project_id', obj.project_id);
            obj.connection.send_command('project_crop', data, Inf);
        end

        function f = get_last_recording(obj)
            data = struct('project_id', obj.project_id);
            response = obj.connection.send_command('project_get_last_recording', data);
            f = Recording(obj.connection, response.data.recording_id);
        end

        function f = get_recordings(obj)
            data = struct('project_id', obj.project_id);
            response = obj.connection.send_command('project_get_recordings', data);
            recordings = [];
            for r = 1:length(response.data.recordings)
                recording_id = response.data.recordings(r).recording_id;
                recordings = [recordings; Recording(obj.connection, recording_id)];
            end
            f = recordings;
        end

        function save(obj, name, force, progress, callback)
            data = struct('project_id', obj.project_id, ...
                          'filename', name, ...
                          'force', force, ...
                          'progress', progress);
            response = obj.connection.send_command('project_save', data, Inf);
            if progress
                while strcmp(response.type, 'progress')
                    callback(response.progress_value);
                    response = obj.connection.read_reply();
                end
            end
            response.data;
        end

        function start_recording(obj)
            data = struct('project_id', obj.project_id);
            obj.connection.send_command('project_start_recording', data);
        end

        function stop_recording(obj)
            data = struct('project_id', obj.project_id);
            obj.connection.send_command('project_stop_recording', data);
        end
    end
end
