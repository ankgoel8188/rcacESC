classdef DDRCAC

    properties (Access = private)
        step;               % RCAC discrete-time step.
        lu;                 % Number of system inputs.
        lz;                 % Number of system outputs (cost functions).
        Nc;                 % RCAC controller order.
        lphi;               % Dimension of phi vector.
        ltheta;             % Dimension of theta vector.
        nu;                 % Normalization parameter.
        P;                  % RCAC covariance matrix.
        Rbar;               % Input weighting matrix, contains Ru.
        theta_buffer;       % Theta vector buffer.
        phi_buffer;         % Phi vector buffer
        u_buffer;           % Input buffer
        z_buffer;           % Performance variable buffer
        internal_u_buffer;  % Internal input buffer

        g_int;              %Ankit  9/25/23. Integrator state
    end
    
    methods (Access = public)
        function obj = DDRCAC(lu, lz, Nc, P0, Ru, nu)
            obj.step = 1;
            obj.lu = lu;
            obj.lz = lz;
            obj.Nc = Nc;
            obj.lphi = 2*Nc;
            obj.ltheta = 2*Nc*lu*lz;

            obj.lphi    = 3;    %Ankit  9/25/23. Hard coded PID structure
            obj.ltheta  = 3;    %Ankit  9/25/23. Hard coded PID structure

            obj.nu = nu;
            obj.P = P0*eye(obj.ltheta);
            obj.Rbar = blkdiag(eye(lz),Ru*eye(lu));
            obj.theta_buffer        = zeros(obj.ltheta,1);
            obj.phi_buffer  = zeros(((lu+1)*lu),obj.ltheta);
            obj.z_buffer            = zeros(lz,Nc); %[ z(k-1) ...]
            obj.u_buffer    = zeros(((lu+1)*lu),1);
            obj.internal_u_buffer   = zeros(lu*lz,Nc+1); %[ u(k-1) ...]

            obj.g_int   = 0; 
            %obj.phi_buffer  = zeros(((lu+1)*lu),3);
        end
        function [obj, u_out, theta_out] = oneStep(obj, u_in, z_in, Nf, freeze)
            
            obj.z_buffer(:,2:end) = obj.z_buffer(:,1:end-1);
            obj.internal_u_buffer(:,2:end) = obj.internal_u_buffer(:,1:end-1);
        
            z_in_norm = z_in./(ones(obj.lz,1) + obj.nu.*abs(z_in));
            obj.g_int = obj.g_int + z_in;                                       %Ankit  9/25/23. Integrator state
            if (obj.step>obj.Nc)
                obj.z_buffer(:,1) = z_in_norm;
            end

            %Construct PHI with internal, unconstrained u
            if 0
                PHI   = zeros(obj.lu,obj.ltheta); %Phi
                count = 1;

                for ii = 1:obj.lu
                    count_internal = 1;
                    phi_temp = zeros(1,obj.lphi*obj.lz);
                    for jj = 1:obj.lz
                        phi_temp(:,count_internal:(count_internal+obj.lphi-1)) = [obj.internal_u_buffer(ii+(jj-1)*obj.lu,2:obj.Nc+1) obj.z_buffer(jj,:)];
                        obj.internal_u_buffer(ii+(jj-1)*obj.lu,1) = phi_temp(:,count_internal:count_internal+obj.lphi-1)*obj.theta_buffer(count+count_internal-1:count+count_internal+obj.lphi-2 ,1);
                        phi_temp(:,count_internal:(count_internal+obj.lphi-1)) = [obj.internal_u_buffer(ii+(jj-1)*obj.lu,1:obj.Nc) obj.z_buffer(jj,:)];
                        count_internal = count_internal + obj.lphi;
                    end
                    PHI(ii,count:count+obj.lz*obj.lphi-1) = phi_temp;
                    count = count + obj.lz*obj.lphi;
                end
            else
                PHI = [z_in obj.g_int (obj.z_buffer(:,1)-obj.z_buffer(:,2)) ];  %Ankit  9/25/23. Hard coded PID
            end

            obj.u_buffer(obj.lu+1:end,:)       = obj.u_buffer(1:end-obj.lu,:);
            obj.u_buffer(1:obj.lu,:)           = u_in;
            
            obj.phi_buffer(obj.lu+1:end,:)     = obj.phi_buffer(1:end-obj.lu,:);
            obj.phi_buffer(1:obj.lu,:)         = PHI;
            
            PHI_filt = [zeros(obj.lz,obj.lu) Nf]*obj.phi_buffer;
            u_filt = [zeros(obj.lz,obj.lu) Nf]*obj.u_buffer;

            X = [PHI_filt;PHI];
            gamma_inv = obj.Rbar-obj.Rbar*(X/(inv(obj.P) + X'*obj.Rbar*X))*X'*obj.Rbar;
            Y = [ (PHI_filt*obj.theta_buffer + z_in_norm - u_filt);(PHI*obj.theta_buffer)];
            
            if (freeze > 0.5)
                 theta_out = obj.theta_buffer;
            else  
                 obj.P = obj.P - obj.P*X'*gamma_inv*X*obj.P;
                 theta_out = obj.theta_buffer - obj.P*X'*obj.Rbar*Y ;
            end
            
            obj.theta_buffer = theta_out;
            u_out = PHI*theta_out; 
            
            obj.step = obj.step + 1;
            if (obj.step > 2*obj.Nc)
               obj.step = 2*obj.Nc; 
            end

        end
    end

end