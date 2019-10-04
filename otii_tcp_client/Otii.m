classdef Otii
    properties
        connection
    end

    methods(Access = public)
        function obj = Otii(connection)
            obj.connection = connection;
        end

        function f = create_project(obj)
            response = obj.connection.send_command('otii_create_project');
            if response.data.project_id == -1
                f = {};
            else
                f = Project(obj.connection, response.data.project_id);
            end
        end

        function f = get_active_project(obj)
            response = obj.connection.send_command('otii_get_active_project');
            if response.data.project_id == -1
                f = {};
            else
                f = Project(obj.connection, response.data.project_id);
            end
        end

        function f = get_devices(obj)
            response = obj.connection.send_command('otii_get_devices');
            devices = [];
            for d = 1:length(response.data.devices)
                arc = Arc(obj.connection, response.data.devices(d).device_id);
                devices = [devices; arc];
            end
            f = devices;
        end

        function f = open_project(obj, filename, force, progress, callback)
            data = struct('filename', filename, ...
                          'force', force, ...
                          'progress', progress);
            response = obj.connection.send_command('otii_open_project', data, Inf);
            if progress
                while strcmp(response.type, 'progress')
                    callback(response.progress_value);
                    response = obj.connection.read_reply();
                end
            end
            if response.data.project_id == -1
                f = {};
            else
                f = Project(obj.connection, response.data.project_id);
            end
        end

        function set_all_main(obj, mode)
            data = struct('enable', mode);
            obj.connection.send_command('otii_set_all_main', data);
        end
    end
end
