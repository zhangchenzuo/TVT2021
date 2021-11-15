# TVT2021
The open source of data set and code for 2021 TVT paper *When the Gain of Predictive Resource Allocation for Content Delivery is Large?*

## intro
The open-source code includes the simulation of fixed user position and mobile user scenarios in the paper, as well as the simulation data obtained in the paper.

We are sorry that we cannot open source the traffic load data, because the data was collected in a campus region, and we are not permitted to make it public.

## UE fixed scenario
`UEfixedSimulation` is the main function of the simulation in the UE fixed scenario, including the simulation environment settings. This function can be used to analyze the influence of the length of prediction window, the file size of UE requested, and the mean and standard deviation of the bandwidth on the performance gain and the upper bound of the performance gain.

Specifically, `data_gen_position` generates the position of the user randomly distributed in the cell, and `channelcreatNew` obtains the channel information of the user in the prediction window. After obtaining statistical characteristics of the data rate or bandwidth, the numerical result of the PRA performance gain can be calculated according to the formula in the paper. The `QoSguarantee` function is used to simulate the minimum transmission time required with non-predictive transmission policy. The `Linp1` function is used to simulate the minimum transmission time required by PRA policy.

## UE move scenario
`UEmoveTraverseCell` is the main function of the simulation in the UE moves scenario. The function includes the setting of the simulation environment, which can be used to analyze the effect of the number of cells traversed, user speed, and different cell radius on the PRA performance gain.

The sub-function used in `UEmoveTraverseCell` the same as `UEfixedSimulation`.

## Simulation and numerical result in paper
The results of simulation and numerical result in the paper are in the `data` folder , 'plotFig' can be directly run to get the results in the paper.
