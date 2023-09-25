classdef grad_est_RLS
    
    properties (Access = private)
        lu;         % Number of system inputs.
        lz;          % Number of system outputs (cost functions).
        ind_vec;    % Vector of delay indices.
        d_max;      % Maximum delay index.
        u_buffer;   % Input buffer
        J_buffer;   % Cost buffer
        dJ_KF;      % Gradient and bias estimate.
        P_KF;       % Estimation covariance matrix.
        ii_KF;      % Number of estimator steps.
    end
    
    methods (Access = public)
        function obj = grad_est_RLS(lu, lz, indi, P0)
            % Initialization
            obj.lu = lu;
            obj.lz = lz;
            obj.ind_vec = flip([1 (indi+1)]);
            obj.d_max = 1+max(indi);
            obj.u_buffer = zeros(obj.lu,1+max(indi));
            obj.J_buffer = zeros(obj.lz,1+max(indi));
            obj.dJ_KF = zeros(lu+1,lz);
            obj.P_KF = P0;
            obj.ii_KF = 0;
        end
        function [obj, grad_est] = oneStep(obj,u, J, en)
            obj.u_buffer(:,2:end) = obj.u_buffer(:,1:end-1);
            obj.u_buffer(:,1) = u;
            obj.J_buffer(:,2:end) = obj.J_buffer(:,1:end-1);
            obj.J_buffer(:,1) = J;
            if en > 0.5
                if obj.ii_KF >= obj.d_max
                    u_vec = (obj.u_buffer(:,obj.ind_vec)).';
                    phi_km1 = [u_vec ones(1+obj.lu,1)];
                    for ii = 1:obj.lz
                        y_km1 = (obj.J_buffer(ii,obj.ind_vec)).';
                        KK = (obj.P_KF(:,:,ii)*phi_km1')/(eye(obj.lu + 1) + phi_km1*obj.P_KF(:,:,ii)*phi_km1');
                        obj.dJ_KF(:,ii) = obj.dJ_KF(:,ii) + KK*(y_km1 - phi_km1*obj.dJ_KF(:,ii));
                        obj.P_KF(:,:,ii) = (eye(1+obj.lu) - KK*phi_km1)*obj.P_KF(:,:,ii);
                    end
                else
                    obj.ii_KF = obj.ii_KF + 1;
                end
            end
            grad_est = obj.dJ_KF(1:obj.lu,:);
        end
    end

end