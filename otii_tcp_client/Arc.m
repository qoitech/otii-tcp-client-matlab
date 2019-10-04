classdef Arc
    properties
        connection
        device_id
    end

    properties(Constant)
        CALIBRATION_TIMEOUT = 5;
    end

    methods
        function obj = Arc(connection, device_id)
            obj.connection = connection;
            obj.device_id = device_id;
        end

        function calibrate(obj)
            data = struct('device_id', obj.device_id);
            obj.connection.send_command('arc_calibrate', data, OtiiClient.DEFAULT_TIMEOUT + Arc.CALIBRATION_TIMEOUT);
        end

        function enable_5v(obj, enable)
            data = struct('device_id', obj.device_id, 'enable', enable);
            obj.connection.send_command('arc_enable_5v', data);
        end

        function enable_channel(obj, channel, enable)
            data = struct('device_id', obj.device_id, ...
                          'channel', channel, ...
                          'enable', enable);
            obj.connection.send_command('arc_enable_channel', data);
        end

        function enable_exp_port(obj, enable)
            data = struct('device_id', obj.device_id, 'enable', enable);
            obj.connection.send_command('arc_enable_exp_port',data);
        end

        function enable_uart(obj, enable)
            data = struct('device_id', obj.device_id, 'enable', enable);
            obj.connection.send_command('arc_enable_uart',data);
        end

        function f = get_adc_resistor(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_adc_resistor', data);
            f = response.data.value;
        end

        function f = get_exp_voltage(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_exp_voltage', data);
            f = response.data.value;
        end

        function f = get_gpi(obj, pin)
            data = struct('device_id', obj.device_id, 'pin', pin);
            response = obj.connection.send_command('arc_get_gpi', data);
            f = response.data.value;
        end

        function f = get_main_voltage(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_main_voltage', data);
            f = response.data.value;
        end

        function f = get_max_current(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_max_current', data);
            f = response.data.value;
        end

        function f = get_range(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_range', data);
            f = response.data.range;
        end

        function f = get_rx(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_rx', data);
            f = response.data.value;
        end

        function f = get_supplies(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_supplies', data);
            f = response.data.supplies;
        end

        function f = get_supply(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_supply', data);
            f = response.data.supply_id;
        end

        function f = get_supply_parallel(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_supply_parallel', data);
            f = response.data.value;
        end

        function f = get_supply_series(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_supply_series', data);
            f = response.data.value;
        end

        function f = get_supply_soc_tracking(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_supply_soc_tracking', data);
            f = response.data.enabled;
        end

        function f = get_supply_used_capacity(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_supply_used_capacity', data);
            f = response.data.value;
        end

        function f = get_uart_baudeate(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_uart_baudeate', data);
            f = response.data.value;
        end

        function f = get_value(obj, channel)
            data = struct('device_id', obj.device_id, 'channel', channel);
            response = obj.connection.send_command('arc_get_value', data);
            f = response.data.value;
        end

        function f = get_version(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_get_version', data);
            f = response.data;
        end

        function f = is_connected(obj)
            data = struct('device_id', obj.device_id);
            response = obj.connection.send_command('arc_is_connected', data);
            f = response.data.connected;
        end

        function set_adc_resistor(obj, value)
            data = struct('device_id', obj.device_id, 'value', value);
            obj.connection.send_command('arc_set_adc_resistor', data);
        end

        function set_exp_voltage(obj, value)
            data = struct('device_id', obj.device_id, 'value', value);
            obj.connection.send_command('arc_set_exp_voltage', data);
        end

        function set_gpo(obj, value)
            data = struct('device_id', obj.device_id, 'value', value);
            obj.connection.send_command('arc_set_gpo', data);
        end

        function set_main(obj, enable)
            data = struct('device_id', obj.device_id, 'enable', enable);
            obj.connection.send_command('arc_set_main', data);
        end

        function set_main_current(obj, value)
            data = struct('device_id', obj.device_id, 'value', value);
            obj.connection.send_command('arc_set_main_current', data);
        end

        function set_main_voltage(obj, value)
            data = struct('device_id', obj.device_id, 'value', value);
            obj.connection.send_command('arc_set_main_voltage', data);
        end

        function set_max_current(obj, value)
            data = struct('device_id', obj.device_id, 'value', value);
            obj.connection.send_command('arc_set_max_current', data);
        end

        function set_power_regulation(obj, mode)
            data = struct('device_id', obj.device_id, 'mode', mode);
            obj.connection.send_command('arc_set_power_regulation', data);
        end

        function set_range(obj, range)
            data = struct('device_id', obj.device_id, 'range', range);
            obj.connection.send_command('arc_set_range', data);
        end

        function set_supply(obj, supply_id, series, parallel)
            data = struct('device_id', obj.device_id, ...
                          'supply_id', supply_id, ...
                          'series', series, ...
                          'parallel', parallel);
            obj.connection.send_command('arc_set_supply', data);
        end

        function set_supply_soc_tracking(obj, enable)
            data = struct('device_id', obj.device_id, 'enable', enable)
            obj.connection.send_command('arc_set_supply_soc_tracking', data);
        end

        function set_supply_used_capacity(obj, value)
            data = struct('device_id', obj.device_id, 'value', value)
            obj.connection.send_command('arc_set_supply_used_capacity', data);
        end

        function set_tx(obj, value)
            data = struct('device_id', obj.device_id, 'value', value)
            obj.connection.send_command('arc_set_tx', data);
        end

        function set_uart_baudrate(obj, value)
            data = struct('device_id', obj.device_id, 'value', value);
            obj.connection.send_command('arc_set_uart_baudrate', data);
        end

        function write_tx(obj, value)
            data = struct('device_id', obj.device_id, 'value', value)
            obj.connection.send_command('arc_write_tx', data);
        end
    end
end
