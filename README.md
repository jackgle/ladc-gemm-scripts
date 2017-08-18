
MATLAB scripts developed for processing and analysis of acoustic data. Pattern recognition and classification tools are the focus. Some assume a sample rate of 192 kHz.

Long-term passive acoustic monitoring has been implemented to support population models of endangered species. Techniques for mining large volumes of acoustic data are in development. 

## Examples

(1) Detect target patterns in a signal by matched filtering:

Load detect_test.mat from the 'test' directory into MATLAB. Run the 'run_patterndetect.m' script. Follow instructions from the command line. The extracted frames now held in the structure array can be viewed with view_struct.m 

(2) Extract features and perform clustering:

Load class_test.mat from the 'test' directory. Run 'run_clustering.m'.

![Screenshot](/test/testresults.png)
