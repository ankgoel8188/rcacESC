function opts = RCAC_PID_ESC_KF_SISO_define_opts()
    
    lu = 1;                 % Single input
    lz = 1;                 % Single output
    indi = 3;               % Delay for gradient estimation
    P0_G = 1e-3*eye(2);     % Initial KF covariance
    Q = 1e-1*eye(2);        % Q matrix for KF
    R = 1e2*eye(2);         % R marix for KF
    
    PID_flag = 2;           % P = 1, PI = 2, PID = 3.
    P0_C = 1e-1;            % Controller initial covariance
    Ru = 0.05;              % Controller output weight
    nu = 0.2;               % Normalization parameter for controller performance variable

    epsi = 1e-3;            % Minimal gradient norm

    opts = struct('lu',         lu,...
                  'lz',         lz,...
                  'indi',       indi,...
                  'P0_G',       P0_G,...
                  'Q',          Q,...
                  'R',          R,...
                  'PID_flag',   PID_flag,...
                  'P0_C',       P0_C,...
                  'Ru',         Ru,...
                  'nu',         nu,...
                  'epsi',       epsi);

end