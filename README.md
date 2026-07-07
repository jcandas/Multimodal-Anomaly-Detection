# Multimodal-Anomaly-Detection

This code contains the implementation of the process described in
"Distribution-Free Stochastic Analysis and Robust Multilevel Vector Field Anomaly Detection"

Note that in this code I use several other matlab packages from various authors. I am thankful for the "Space Partitioning Trees" matlab code provided by Nakul Verma

http://cseweb.ucsd.edu/~naverma/SpatialTrees/index.html

Learning the structure of manifolds using random projections.
Y. Freund, S. Dasgupta, M. Kabra and N. Verma.
In Neural Information Processing Systems (NIPS), 2007.


--------------------------------------------------------------------------------------------------


The code in this repository can be used to replicate figures 5-12 in the linked paper.

To download the sentinel data used to create the figures in section 5:

1. Download the codebase (with the data) from dropbox at https://www.dropbox.com/scl/fo/rk1477kxv82z1edl2c63r/AIXCupboKu_JxDY0Bqd30uU?rlkey=ggsbdn1k17s3eyuurfamm284h&dl=0
2. Place "data" directory in the root directory of the repository

To initialise the code:

1. In matlab make sure you are in the source directory
2. Type "paths" to create all the necessary paths for the code.

The numerical results in the section 4: "Performance tests", pgs. 18-21, were obtained from this code. First, create a directory to house the generated datasets and results. By default, the scripts point to /data/gaussian_test, so you can create a folder titled "gaussian_test" in /data. The results are then obtained by executing the following commands from the directory /source/tests:


(1) createtraindataset

(2) createtestdataset

(3) testpcaeval

(4) testgaussianfull

The numerical results in the section 5: "Application: Forest degradation", pgs. 22-28, were obtained from this code. After downloading the sentinel data using the instructions above, you can obtain the results by executing the following commands from the directory /source/tests:


(5) testsentinelanomaly

(6) testsentinelanomalyVec

More details below



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Synthetic tests for scalar data:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

(1) We create the training set using this script:

/source/data/createtraindataset.m

The initialization file is:

/source/data/initKL2Dtrain.m

Here, we define several parameters:

parameters.KL.l: number of eigenfunctions of the stochastic process
Lc, Lp, L: parameters of the stochastic process
parameters.dataset.numexamples: number of realizations to include in the training set
parameters.dataset.outfile: filepath to save the dataset to

Note all the gaussian parameters are irrelevant as the gaussian height is by default set to 0



(2) We create the test set using this script:

/source/data/createtestdataset.m

The initialization file is:

/source/data/initKL2Dtest.m

Here, we define several parameters:

parameters.KL.l: number of eigenfunctions of the stochastic process
Lc, Lp, L: parameters of the stochastic process
parameters.dataset.numexamples: number of realizations per gaussian height to include in the test set
parameters.dataset.gaussmin/gaussmax: minimum and maximum randomly placed gaussian center (from 0 to 1)
parameters.dataset.gaussstd: standard deviation of inserted gaussians
parameters.dataset.outfile: filepath to save the dataset to
parameters.dtatset.heights: different gaussian heights to include in the dataset; by default, includes a height of zero as well as a variety of heights from 1e-4 to 2e-1

**Note, by default, the test set contains 200 example for each of 29 different gaussian heights. This gives a test set with 5,800 examples. It can take several hours to run our process on a test set this size, depending on available computational resources. If you are unsure about runtime, you may want to reduce the number of realizations per gaussian height, or number of different gaussian heights in the test set.



(3) To generate the results in Figure 6 from the pca-based method, we use the script:

source/tests/testpcaeval.m

The initialization file is:

/source/initialize/initpcatestfull.m

Here, we define several parameters:

parameters.KL.numEigen: number of eigenfunctions in the principal components
parameters.data.file: should be set to the filepath of the training set
parameters.data.test_file: should be set to the filepath of the test set
parameters.data.out_file: the filepath the output file should save to
parameters.data.thresh_file: the filepath the pce threshold should be saved to (usedin plotting)
parameters.stats.significance: significance level to use for detection



(5) To generate the results in Figure 6 from out method, we use the script:

source/test/testgaussianfull.m

The initialization file is:

/source/initialize/initgaussiantestfull.m

Here, we define several parameters:

parameters.KL.numEigen: number of eigenfunctions in the principal components
parameters.data.file: should be set to the filepath of the training set
parameters.data.test_file: should be set to the filepath of the test set
parameters.data.out_file: the filepath the output file should save to
parameters.stats.significance: significance level to use for detection
parameters.stats.nest: use a nested method (not included in the results of our paper)



To run our method on a single example in the test set, we use the script:

/source/tests/testgaussian.m

The initialization file is:

/source/initialize/initgaussiantest.m

Here, the parameters are the same as the full test, with the inclusion of:

parameters.data.test_idx: index of the test set to run our method on

Set to index 1-200 to run on a nominal example
Set to index eg. 5001-5200 to run on a sample with a relatively large gaussian



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sentinel Tests for scalar data:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


The sentinel data is contained in the following mat file:

/data/Combined/recalibratedData_Landsat_Sentinel2_full.mat

and the RGB data is in

/data/Combined/recalibratedData_Landsat_Sentinel2.mat


(5) To obtain the results for Figure 8 with sentinel data we use the following script:

/source/tests/testsentinelanomaly.m

The initialization file is:

/source/initialize/initlandsatsentinel.m

You can run the test on a particular day by uncommenting the particular day of interest and commenting the rest:

parameters.data.testdata = 121; % day 3704
%parameters.data.testdata = 104; % day 3484
%parameters.data.testdata = 82; % day 3344

Our results include the test run over all three of these days.



The anomaly sequence for Figures 9 is obtained by executing the command:

testsentinelanomalyALL

This code will create the anomaly maps for each pixel and for all the
time samples. The results are saved in a mat file:

../data/Combined/JointProcessed.mat



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Sentinel Tests for Vectorial data:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


(6) To obtain the results for Figure 11 with sentinel data, we use the following script:

/source/tests/testsentinelanomalyVec.m

The initialization file is:

/source/initialize/initlandsatsentinelVec.m

You can run the test on a particular day by uncommenting the particular day of interest and commenting the rest:

parameters.data.testdata = 121; % day 3704
%parameters.data.testdata = 104; % day 3484
%parameters.data.testdata = 82; % day 3344

Our results include the test run over all three of these days.



The anomaly sequence for Figure 12 for the vectorial data is
obtained by executing the command

testsentinelanomalyVecALL

This code will create the anomaly maps for each pixel and for all the
time samples. The results are saved in a mat file:

../data/Combined/Vectorial-SentinelProcessed.mat