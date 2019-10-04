classdef Recording
    properties
        connection
        recording_id
    end

    methods
        function obj = Recording(connection, recording_id)
            obj.connection = connection;
            obj.recording_id = recording_id;
        end

        function downsample_channel(obj, device_id, channel, factor)
            data = struct('recording_id', obj.recording_id, ...
                          'device_id', device_id, ...
                          'channel', channel, ...
                          'factor', factor);
            obj.connection.send_command('recording_downsample_channel', data);
        end

        function f = get_channel_data_count(obj, device_id, channel)
            data = struct('recording_id', obj.recording_id, ...
                          'device_id', device_id, ...
                          'channel', channel);
            response = obj.connection.send_command('recording_get_channel_data_count', data);
            f = response.data.count;
        end

        function f = get_channel_data_index(obj, device_id, channel, timestamp)
            data = struct('recording_id', obj.recording_id, ...
                          'device_id', device_id, ...
                          'channel', channel, ...
                          'timestamp', timestamp);
            response = obj.connection.send_command('recording_get_channel_data_index', data);
            f = response.data.index;
        end

        function f = get_channel_data(obj, device_id, channel, index, count)
            data = struct('recording_id', obj.recording_id, ...
                          'device_id', device_id, ...
                          'channel', channel, ...
                          'index', index, ...
                          'count', count);
            response = obj.connection.send_command('recording_get_channel_data', data);
            f = response.data;
        end

        function f = is_running(obj)
            data = struct('recording_id', obj.recording_id);
            response = obj.connection.send_command('recording_is_running', data);
            f = response.data.running;
        end
    end
end
