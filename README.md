
# Multiplicity Automata Learning Library (MALL)

We apply a probably approximately correct learning algorithm for multiplicity automata to generate quantitative models of system behaviors with a statistical guarantee. Using the generated model, we give two analysis algorithms to estimate the minimum and average values of system behaviors. We show how to apply the learning algorithm even when the alphabet is not fixed. The experimental result is encouraging; the estimation made by our approach is almost as precise as the exact reference answer obtained by a brute-force enumeration.

For more detail information, please see our thesis "[Quantitative Analysis using Multiplicity Automata Learning](http://docdro.id/Mv8YkmH)."

1. <a href="#Download">Download</a>
1. <a href="#Install">Prerequisite & Installation</a>
1. <a href="#Use">Tutorial</a>
1. <a href="#Experiment">Experiment Results</a>

<a name="Download" />
## Download

MALL consists of the following 3 folders:

| Folder        | Description           |
| ------------- |---------------------|
| SRC/main           | The core library code in Matlab |
| SRC/experiment     | The experiment results presented in the thesis.  |
| SRC/enumeration |  The code to generate the enumeration results. |

You can download the latest version of MALL from git:

git clone https://github.com/fmlab-iis/ma-learning.git

<a name="Install" />
## Prerequisite & Installation

#### Prerequisites
1. Installed Matlab 2016a with [Symbolic Math Toolbox](https://www.mathworks.com/help/symbolic/index.html).
1. Perl 5.24.1

#### Installation
The codes on git are ready to use. You can simply add the path of the directory in the Matlab command window.

<a name="Use" />
## Tutorial

SRC means the path where you clone MALL.

### main/order_comp

```c++
[timeout, time_each, state, counter_mem, mem,eq_mem] = 
order_comp( order, distri, probability )
```

#### Description
The core function of this learning algorithm is the "order_comp"
This function is used in the learning of the target teacher.

#### Input Description
*order: This argument only valid in the Calculator experiment. It can decide the order of the calculator. When order = 1, the calculator keeps the nature order. On the contrary, if order = 1, the order of alphabet is scattered.

*distri: This argument decides the distribution of the equivalence queries. When distri = 0, the equivalence queries will generate the test membership queries in Monkey distribution. When distri = 1, it will be the uniform distribution. When distri = 2, it will be the fixed length distribution.

*probability: This argument is to decide the stop probability of different distributions. When distri = 0, this argument means the stop probability of Monkey distribution. When distri = 1 and 2, this argument means the equivalence queries' maximum length and fixed length.

#### Output Description

*timeout: This output whether the algorithm stops because of the timeout.

*time_each: This output the total time of the learning algorithm for one time.

*state: This output the iteration number.

*counter_mem: This output the number of membership queries when finding counter examples.

*mem: This output the number of membership queries besides from counter_mem.

*eq_mem: This output the number of membership queries while checking the equivalence queries.

#### Changing the experiments

There is an argument in "order_comp" called fun, which is in line 52 of the function. The different value of fun means different experiment.
*fun = 0: The oracle is a randomly generate matrix. 

*fun = 1: The oracle is the web experiment. 

*fun = 2: The oracle is the Calculator experiment. 

*fun = 3: The oracle is the Missionary & Cannibals experiment. 

*fun = 5: The oracle is the OS Scheduling experiment. 

#### Setting time out.

In line 13, there is an argument called "time_out_range", which can decide the time out value in seconds. The default value of this is set to 900 seconds.

### main/test

```c++
[average,max_value] = test(cat_num,order)
```

#### Description
This function is used to analyze the learned model of MA which can predict the average value and max value of the certain length.

#### Input Description
*cat_num: This input can decide the length that you want to predict.

#### Output Description

*average: This output the average value of the certain length.

*max_value: This output the maximum value of the certain length.

### Experiment

Open the Matlab

For the result of Table1, type the following command in Matlab command line: 
```c++
cd('SRC/experiment/Table1') 
experiment
```

For the result of Table2, type the following command in Matlab command line: 
```c++
cd('SRC/experiment/Table2') 
experiment
```

For the result of Table3, type the following command in Matlab command line: 
```c++
cd('SRC/experiment/Table3') 
experiment
```

For the result of Table4, type the following command in Matlab command line: 
```c++
cd('SRC/experiment/Table4') 
experiment
```

For the result of Table5, type the following command in Matlab command line: 
```c++
cd('SRC/experiment/Table5') 
experiment
```

For the result of Table6, type the following command in Matlab command line: 
```c++
cd('SRC/experiment/Table6') 
experiment
```

For the result of Table7, type the following command in Matlab command line: 
```c++
cd('SRC/experiment/Table7') 
experiment
```

### Enumeration

For the result of enumeration of Table 5, type the following command in Matlab command line: 
```c++
cd('SRC/enumeration/Table5') 
os_oracle
```

For the result of enumeration of Table 6, type the following command in Matlab command line: 
```c++
cd('SRC/enumeration/Table6') 
mc_oracle
```

For the result of enumeration of Table 7, type the following command in Matlab command line: 
```c++
cd('SRC/enumeration/Table7') 
web_oracle
```

<a name="Experiment" />
## Experiment Results

Here are some experiment results and detail information of the tables.

#### Table1
The following table is the experiment result of prediction of the Calculator experiment.
[Table1](https://raw.githubusercontent.com/fmlab-iis/ma-learning/master/image/1.png)

#### Table2
The following table is the experiment result of the Calculator experiment.
[Table2](https://raw.githubusercontent.com/fmlab-iis/ma-learning/master/image/2.png)

#### Table3
The following table is the experiment result of different distribution in the Calculator experiment.

[Table3](https://raw.githubusercontent.com/fmlab-iis/ma-learning/master/image/3.png)

#### Table4
The following table is the experiment result of Calculator experiment with different alphabet symbol size.

[Table4](https://raw.githubusercontent.com/fmlab-iis/ma-learning/master/image/4.png)

#### Table5
The following table is the Operating System Scheduling experiment.

[Table5](https://raw.githubusercontent.com/fmlab-iis/ma-learning/master/image/5.png)

#### Table6
The following table is the Ｍissionary & Cannibals experiment.

[Table6](https://raw.githubusercontent.com/fmlab-iis/ma-learning/master/image/6.png)

#### Table7
The following table is the Amount of Data Transmission in a Website experiment.

[Table7](https://raw.githubusercontent.com/fmlab-iis/ma-learning/master/image/7.png)
