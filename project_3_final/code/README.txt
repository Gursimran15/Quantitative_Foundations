README

test.m - Run for Uniform Distribution
test_b.m - Run for bernoulli Distribution
test_n.m - Run for Normal Distribution
    
First Loop - Confidence Interval
Second Loop - for different theta
Third Loop - for different N 
Fourth Loop - For each N, getting 10000 samples of A and B(you can modify this value)

If we change the number of values in N, we will need to make changes to n and T as well. n will have all values in N repated t times and T will have each value in t continuously repeated n times. Size of n and T is size(t)xsize(N).

For making changes to t, we will similarly change n and T again.

The results are shown in a tabular form with N,theta and probability.
Based on these values we assume alpha value.

File testresults.txt has all the results we gathered while running experiments in an organized manner.

