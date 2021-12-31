Readme -
functions:-
poly_select - It is the main function that first performs cross validation on different degrees of model to get minimum error and then use that model to train and test data.
cross_validation -It contains the cross validation code
least_square_MS - It computes weight and least square error
import_data - It imports training data from "training.txt"
import_data_test - It imports test data from "testinputs.txt"
sin_inv_expand - It performs the sine inverse polynomial model computation
other expand functions - These functions are alternatives to sine inverse and can be used for computation, we just have to replace the occurances of sin_inv_expand function with that function.(There are 4 occurances)


To run the code use - [min,ypred,rtr,test] = poly_select(10)
Here K=10 is passed as argument to the function and the function returns the following -
min - the degree of polynomial with minimum error (max degree used = 10), the solution in all the tested cases lied below 10
ypred - list of prediction of y values on the test data (103 entries)
rtr - training error on the given model when run on whole training data
test - estimated test error


