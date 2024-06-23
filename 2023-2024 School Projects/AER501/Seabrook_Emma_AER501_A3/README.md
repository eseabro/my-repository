Emma Seabrook - 1005834563

To run part 1, optimizing the Michalewicz function, run the first section in maindriver.m
To run part 2, optimizing the truss, run the second section in maindriver.m.

The following parameters must be set at the beginning of each section:
    c = [array] containing the cooling schedule parameters to iterate over. 
    epsilon = [float] step-size to control magnitude of perturbations in move.m
    maxiter = [int] max number of iterations for simulated annealing function
    lb = [array] lower bounds for x
    ub = [array] upper bounds for x
    x0 = [array] initial guess for x
    Tstart = [int] start temperature for cooling. 
