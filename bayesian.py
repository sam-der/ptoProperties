import matlab.engine
from mpl_toolkits import mplot3d
import numpy as np
import matplotlib.pyplot as plt
from skopt import Optimizer
from skopt.space import Real
import numpy as np

eng = matlab.engine.start_matlab()
search_space = [
    Real(low=5000000, high=75000000, prior='uniform', transform='identity', name='S'),
    Real(low=20000000, high=100000000, prior='uniform', transform='identity', name='D'),
    Real(low=10, high=10000, prior='uniform', transform='identity', name='P')
]

def pto(S, D, P):
    SDP = [S, D, P]
    powerOut = eng.ptoProperties(SDP, nargout=1)
    return powerOut

def optFunc(params):
    S, D, P = params
    return -pto(S, D, P)  # Negating to maximize

optimizer = Optimizer(
    dimensions=search_space,
    base_estimator="GP",  # Gaussian Process model (default)
    n_initial_points=5,    # Number of random points to sample before optimization
    random_state=42
)

n_iterations = 50
for i in range(n_iterations): #for loop needed? or existing method?
    suggested = optimizer.ask()
    
    score = optFunc(suggested)
    
    optimizer.tell(suggested, score)

best_params = optimizer.Xi[np.argmin(optimizer.yi)]  # Xi is the list of all evaluated points
best_score = np.min(optimizer.yi)  # Best score (maximized objective function)

print(f"Best Parameters: {best_params}")
print(f"Best Score: {best_score}")

#help function on optimizer results, see what else it gives us
#check minima with slopes
#change the range
#optimal number (heuristics) of initial points
#gradient search next
#scipy optimize method with constraints
#compare with bayes opt next week
#pros and cons
#count number of times it calls objective function (for timing)
#maybe plot search trajectory? connect with line plot
#comparison for 10 algorithms by next week?