classdef RCAC_PID

    properties (Access = private)
        step;               % RCAC discrete-time step.
        lu;                 % Number of system inputs.
        lz;                 % Number of system outputs (cost functions).
        Nc_max;             % Maximum RCAC controller order.
        lphi;               % Dimension of phi vector.
        ltheta;             % Dimension of theta vector.
        Nf;                 % Target model filter.
        PID_flags;          % Determines whethe P, PI or PID is used
        nu;                 % Normalization parameter.
        P;                  % RCAC covariance matrix.
        Rbar;               % Input weighting matrix, contains Ru.
        theta_buffer;       % Theta vector buffer.
        phi_buffer;         % Phi vector buffer
        u_buffer;           % Input buffer
        z_buffer;           % Performance variable buffer
        internal_u_buffer;  % Internal input buffer
        integral_z;         % Integral variable
    end
    
    methods (Access = public)
        function obj = RCAC_PID(lu, lz, PID_flag, P0, Ru, nu, nf_diag)
            obj.step = 1;
            obj.lu = lu;
            obj.lz = lz;
            obj.lphi = zeros(lu,lz);
            obj.ltheta = 0;
            obj.PID_flags = zeros(lu,lz);
            for ii = 1:lu
                for jj = 1:lz
                    if PID_flag(ii,jj) == 1
                        obj.ltheta = obj.ltheta + 1;
                        obj.lphi(ii,jj)   = 1;
                        obj.PID_flags(ii,jj) = 1;
                    elseif PID_flag(ii,jj) == 2
                        obj.ltheta = obj.ltheta + 2;
                        obj.lphi(ii,jj)   = 2;
                        obj.PID_flags(ii,jj) = 2;
                    elseif PID_flag(ii,jj) == 3
                        obj.ltheta = obj.ltheta + 3;
                        obj.lphi(ii,jj)   = 3;
                        obj.PID_flags(ii,jj) = 3;
                    end
                end
            end
            obj.integral_z = zeros(lz,1);
            obj.Nc_max = max(abs(PID_flag(:)));
            obj.nu = nu;
            obj.P = P0*eye(obj.ltheta);
            obj.Rbar = blkdiag(eye(lz),Ru*eye(lu));
            obj.theta_buffer        = zeros(obj.ltheta,1);
            obj.phi_buffer  = zeros(((lu+1)*lu),obj.ltheta);
            obj.z_buffer            = zeros(lz,obj.Nc_max+2); %[ z(k-1) ...]
            obj.u_buffer    = zeros(((lu+1)*lu),1);
            obj.internal_u_buffer   = zeros(lu,lz,obj.Nc_max+1); %[ u(k-1) ...]
            obj.Nf = zeros(lz,lu*lu);
            for ii = 1:lu
                obj.Nf(:,1+(ii-1)*(lu+1)) = nf_diag(:,ii);
            end
        end
        function [obj, u_out, theta_out] = oneStep(obj, u_in, z_in, freeze)
            
            obj.z_buffer(:,2:end) = obj.z_buffer(:,1:end-1);
            obj.internal_u_buffer(:,2:end) = obj.internal_u_buffer(:,1:end-1);
        
            z_in_norm = z_in./(ones(obj.lz,1) + obj.nu.*abs(z_in));
                  
            if (obj.step>obj.Nc_max)
                obj.z_buffer(:,1) = z_in_norm;
            end

            %Construct PHI with internal, unconstrained u
            
            obj.integral_z = obj.integral_z + obj.z_buffer(:,2);
            PHI   = zeros(obj.lu,obj.ltheta); %Phi

            %Construct PHI
            count = 1;
            for iii = 1:obj.lu
                count_internal = 1;
                phi_temp = zeros(1,sum(obj.lphi(iii,:)));
                for jjj = 1:obj.lz
                        if obj.PID_flags(iii,jjj) == 1
                            phi_temp(:,count_internal:count_internal+obj.lphi(iii,jjj)-1) = obj.integral_z(jjj); %phi_i  P controller
                        elseif obj.PID_flags(iii,jjj) == 2
                            phi_temp(:,count_internal:count_internal+obj.lphi(iii,jjj)-1) = [obj.z_buffer(jjj,1) obj.integral_z(jjj) ]; %phi_i  PI controller
                        elseif obj.PID_flags(iii,jjj) == 3
                            phi_temp(:,count_internal:count_internal+obj.lphi(iii,jjj)-1) = [obj.z_buffer(jjj,1) obj.integral_z(jjj) (obj.z_buffer(jjj,1)-obj.z_buffer(jjj,2))]; %phi_i  PID controller
                            %phi_temp(:,count_internal:count_internal+lphi(iii,jjj)-1) =  integral_z(jjj);
                        end
                    count_internal = count_internal + obj.lphi(iii,jjj);
                end
                PHI(iii,count:count+size(phi_temp,2)-1) = phi_temp;
                count = count + size(phi_temp,2);
            end

            obj.u_buffer(obj.lu+1:end,:)       = obj.u_buffer(1:end-obj.lu,:);
            obj.u_buffer(1:obj.lu,:)           = u_in;
        
            obj.phi_buffer(obj.lu+1:end,:)     = obj.phi_buffer(1:end-obj.lu,:);
            obj.phi_buffer(1:obj.lu,:)         = PHI;
            
            PHI_filt = [zeros(obj.lz,obj.lu) obj.Nf]*obj.phi_buffer;
            u_filt = [zeros(obj.lz,obj.lu) obj.Nf]*obj.u_buffer;

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
            if (obj.step > 2*obj.Nc_max)
               obj.step = 2*obj.Nc_max; 
            end

        end
    end

end