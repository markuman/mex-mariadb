classdef mariadb
    properties
        hostname
        port
        username
        password
        database
        command
        is_octave
        output
    end
    methods
        function self = mariadb(varargin)
            
            p               = inputParser();
            p.CaseSensitive = true;
            p.FunctionName  = 'mariadb'; 
            % addParamValue is not recommended to use in matlab... however
            % addParameter is not implemented in octave yet, so we've to
            % use it
            p.addParamValue ('port',            3306,           @isnumeric);
            p.addParamValue ('hostname' ,       'localhost',    @ischar);
            p.addParamValue ('database',        '',             @ischar);
            p.addParamValue ('password',        'password',     @ischar);
            p.addParamValue ('username',        'root',         @ischar);
            p.parse (varargin{:});
            
            % init class variables
            self.port            = p.Results.port;
            self.hostname        = p.Results.hostname;
            self.database        = p.Results.database;
            self.password        = p.Results.password;
            self.username        = p.Results.username;
            self.is_octave       = true;
            self.output          = 'cell';
            
            if (exist('OCTAVE_VERSION', 'builtin') ~= 5) 
                self.is_octave = false;
            end
            
        end

        function retval = query(self, command)
            retval = mariadb_(self.hostname, self.port, self.username, self.password, command, self.database);
            s = size(retval);
           
            if numel(retval) > 0
                switch self.output
                    case 'cell'
                        if (s(1) == 1)
                          retval = cell();
                        end
                        return
                    case 'mat'
                        retval = self.to_mat(retval, s);
                        return
                    otherwise
                        return
                end % switch
            end % if numel
        end % query
        
        function retval = to_mat(self, c, s)
            if (s(1) == 1)
              retval = [];
            else  
              retval = cellfun(@(x) str2double(x), c);
            end % if s
        end % to_mat
    end % methods
end