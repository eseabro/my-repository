function maindriver()

    freqs = zeros(90,4);

    for i=1:4
        % Modify the line below to load in different kinds of mesh files. 
        inputs = load("Mesh"+i+".mat"); 
        
        % Define physical properties of structure
        EI = 1.286*10^4;
        EA = 6.987*10^6;
        RHO = 2.74;

        % Calculate number of nodes, elements, and degrees of freedom
        n_node = max(inputs.NOD, [], "all");
        s_NOD = size(inputs.NOD);
        n_elem = s_NOD(1);
        nDOF = 3*n_node;
    
        % Assemble mass and stiffness matrices
        [K, M] = assembly(inputs.X, inputs.Y, inputs.NOD, EA, EI, RHO, nDOF, n_elem);

        % Restrict matrices to degrees of freedom in use
        K_active = K(inputs.dof_active, inputs.dof_active);
        M_active = M(inputs.dof_active, inputs.dof_active);
        C = 10*M;
        C_active = C(inputs.dof_active, inputs.dof_active);

        % Perform free vibration analysis
        [lam, PHI] = freevibration(K_active,M_active);

        % Calculate natural frequencies
        freqs(1:length(lam),i) = sqrt(lam);

        % Define number of modes for each mesh
        m = [15, 18, 20, 21];

        % Define excitation at node P
        f = zeros(length(inputs.X)*3, 1);
        f(3*(i+1)-1) = 1;
        if i == 1
            f(9-1) = 1;
        end
        f = f(inputs.dof_active);

        % Define frequency vector for plotting
        freq_vec = [0:250];

        % Modal Analysis
        if i == 1 
            ma = length(lam);
        elseif i ==3 || i == 2 || i ==4
            ma = 25;
        end

        % Full Rank Analysis
        for omega=0:250
            u_forced_m_FR(:, omega+1) = modalfrfanalysis(omega, PHI, lam, f, length(lam));
            u_forced_d(:, omega+1) = directfrfanalysis(K_active, M_active, C_active, omega, f);

            % For the quasi-static approximation comparison
            u_forced_m5(:, omega+1) = modalfrfanalysis(omega, PHI, lam, f, 15);

        end

        % Iterate to compare number of modes used in modal analysis
        n = 1;
        for m = 5:5:ma
            % Perform modal analysis over range of omega values
            for omega=0:250
                u_forced_m(:, omega+1) = modalfrfanalysis(omega, PHI, lam, f, m);
            end
    
            % Restrict responses to node R
            R = 14 + 27*(i-1);
            u_f_m(i, :) = abs(u_forced_m(R, :));
            m_temp = abs(u_forced_m(R, :));
            u_forced_m = [];

            diff(i,n) = sqrt(sum((abs(u_forced_m_FR(R, :)) - m_temp).^2));
            n = n+1;
    
            % Plot results
            semilogy(freq_vec, m_temp, "DisplayName", "m="+{m})
            m_temp = [];
            hold on;

        end

        % Plot to compare approximation with different numbers of modes
        semilogy(freq_vec, abs(u_forced_m_FR(R, :)), "DisplayName", "Full Rank");
        legend("Location", "southwest")
        xlabel('\Omega [Hz]')
        ylabel('Displacement Response')
        title('Comparing accuracy of different numbers of modes')
        saveas(gcf,"Mesh"+i+"mode_nums.png") 
        hold off;



        % Plot to compare quasi-static approximation
        d_u = quasi_static(K_active, f, PHI, lam, u_forced_m5, 15);
        figure()
        semilogy(freq_vec, abs(u_forced_m_FR(R, :)), freq_vec, abs(u_forced_m5(R, :)), freq_vec, abs(d_u(R, :))); %"DisplayName", "Full Rank")
        legend("Modal Analysis m = full rank", "Modal Analysis m = 15", "Quasi-static m = 15", "Location", "southwest")
        xlabel('\Omega [Hz]')
        ylabel('Displacement Response')
        title('Comparing accuracy of quasi-static correction scheme')
        saveas(gcf,"Mesh"+i+"quasi_static.png") 
        hold off;


        % Plot results
        figure()
        semilogy(freq_vec, abs(u_forced_m_FR(R, :)), freq_vec, abs(u_forced_d(R, :)))
        legend('Modal analysis approach', 'Full-Order dynamic approach')
        xlabel('\Omega [Hz]')
        ylabel('Displacement Response')
        title('Comparing full-order and modal approaches')
        saveas(gcf,"Mesh"+i+"comparison.png")
        
        u_f_m(i,:) = abs(u_forced_m_FR(R, :));
        u_f_d(i,:) = abs(u_forced_d(R, :));

        % Reset variables
        u_forced_m = [];
        u_forced_m5 = [];
        u_forced_m_FR = [];
        u_forced_d = [];


    end

    % Compare results of the four meshes
    plot(freqs(1:12,:))
    legend('Mesh 1', 'Mesh 2', 'Mesh 3', 'Mesh 4')
    xlabel('Eigenmode Number')
    ylabel('Frequency [Hz]')
    title('Comparing convergence of the four meshes')




    % Compare 4-mesh dynamic
    figure()
    semilogy(freq_vec, u_f_d(1, :), freq_vec, u_f_d(2, :), freq_vec, u_f_d(3, :), freq_vec, u_f_d(4, :))
    legend('Mesh 1', 'Mesh 2', 'Mesh 3', 'Mesh 4')
    xlabel('\Omega [Hz]')
    ylabel('Displacement Response')
    title('Comparing full-order approach for the four meshes')

    % Compare 4-mesh modal
    figure()
    semilogy(freq_vec, u_f_m(1,:), freq_vec, u_f_m(2,:), freq_vec, u_f_m(3,:), freq_vec, u_f_m(4,:))
    legend('Mesh 1', 'Mesh 2', 'Mesh 3', 'Mesh 4')
    xlabel('\Omega [Hz]')
    ylabel('Displacement Response')
    title('Comparing modal approach for the four meshes')
end