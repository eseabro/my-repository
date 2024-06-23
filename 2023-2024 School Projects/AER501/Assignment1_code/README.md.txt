Files for part A:
 - Part_A.m
 - assembly.m
 - elementmatrix.m
 - solve_k.m
 - postprocess.m
 - maindriver.m

To run part A: 
Open the Part_A.m file. This file contains the various test cases used in the assignment. In each test case, six variables are defined: areas, young, forces, nodal_coords, connec, and bcs. These are used as the inputs to the maindriver() function which will run the rest of the code. Further information about the format of these variables can be found in the docstring of the maindriver function. 


~~~~~~

Files for part B:
 - Part_B.m
 - f_calls.m
 - solve_coeff.m
 - calc_error.m

To run part B:
Simply open the Part_B file and click 'run'. Each task can be run separately by navigating to the appropriate section and using the 'run section' command in matlab. The first section will produce a plot displaying the values of u, u_g, and u_m for direct comparison. The second section produces a plot demonstrating the effect of the distance between collocation points on the accuracy of the approximation. The third section produces a plot demonstrating the effect of the shape parameter on the accuracy of the approximation. 

~~~~~

Files for the Bonus:
 - Bonus.m

To run bonus:
Open the bonus.m file and click 'run'. This will display two plots and print the L^2 norm of the error. 