classdef OtiiClient < handle
    properties
        trans_id
        t
    end

    properties(Constant)
        DEFAULT_TIMEOUT = 3
    end

    methods
        function obj = OtiiClient(address, port)
            obj.trans_id = 0;
            obj.t = tcpip(address, port, 'Timeout', OtiiClient.DEFAULT_TIMEOUT);
            fopen(obj.t);
            obj.read_reply();
        end

        function delete(obj)
            fclose(obj.t);
            delete(obj.t);
        end

        function f = send_command(obj, cmd, data, timeout)
            new_trans_id = obj.get_new_trans_id();
            if exist('data', 'var') && ~isempty(data)
                command = struct('type', 'request', ...
                                 'cmd', cmd, ...
                                 'trans_id', new_trans_id, ...
                                 'data', data);
            else
                command = struct('type', 'request', ...
                                 'cmd', cmd, ...
                                 'trans_id', new_trans_id);
            end
            json = jsonencode(command);
            fprintf(obj.t, json);

            if exist('timeout', 'var')
                set(obj.t, 'Timeout', timeout);
            end

            f = obj.read_reply();

            if exist('timeout', 'var')
                set(obj.t, 'Timeout', OtiiClient.DEFAULT_TIMEOUT);
            end

            if f.trans_id ~= new_trans_id
                error("Unexpected trans_id");
            end
        end

        function f = read_reply(obj)
            completed = false;
            json = '';
            % Add timeout
            while ~completed
                readCount = 1;
                if obj.t.BytesAvailable > 0
                    readCount = obj.t.BytesAvailable;
                end
                data = fscanf(obj.t, "%c", readCount);
                if ~isempty(data)
                    json = strcat(json, data);
                    completed = data(length(data)) == newline;
                else
                    error('Timeout');
                end
            end

            response = jsondecode(json);
            if response.type == "error"
                disp(json);
                error(response.errorcode);
            end

            f = response;
        end
    end

    methods(Access = private)
        function f = get_new_trans_id(obj)
            obj.trans_id = obj.trans_id + 1;
            f = num2str(obj.trans_id);
        end
    end
end
