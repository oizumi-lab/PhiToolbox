# Practical &Phi; Toolbox for Integrated Information Analysis
Jun Kitazono and Masafumi Oizumi (The University of Tokyo)  
Email: c-kitazono@g.ecc.u-tokyo.ac.jp, c-oizumi@g.ecc.u-tokyo.ac.jp 
 
This toolbox provides MATLAB codes for end-to-end computation in "practical versions" of integrated information theory: computing practical measures of integrated information, searching for minimum information partitions and complexes. These are key important concepts in integrated information theory and can be generally utilized for network analysis, i.e., evaluating how much information is integrated in a network, finding the optimal partition and the cores of the network. In general, these computations take a large amount of computation time, which has hindered the applicability of integrated information theory to real data. This toolbox enables us to analyze a network consisting of up to several hundred of elements by utilizing efficient algorithms. This toolbox is an update of our previous version of the toolbox available at figshare (doi:10.6084/m9.figshare.3203326). In this new version, the algorithms for searching for complexes are newly implemented. The features available in this toolbox are summarized in the table below.
 
<table>
   <thead>
       <tr align='center'>
           <th colspan=8>Computation of practical measures of &Phi;</th> <th>MIP Search</th> <th>Complex Search</th>
       </tr>
   </thead>
   <tbody>
       <tr align='center'>
           <td colspan=4>Gaussian distribution</td>
           <td colspan=4>Discrete distribution</td>
           <td rowspan=2></td>
           <td rowspan=2></td>
       </tr>
       <tr align='center'>
           <td>MI</td>
           <td>SI</td>
           <td>&Phi;<sub>*</sub></td>
           <td>&Phi;<sub>G</sub></td>
           <td>MI</td>
           <td>SI</td>
           <td>&Phi;<sub>*</sub></td>
           <td>&Phi;<sub>G</sub></td>
       </tr>
       <tr align='center'>
           <td>&#10003;</td> <!-- Gaussian -->
           <td>&#10003;</td>
           <td>&#10003;</td>
           <td>&#10003;</td>
           <td>&#10003;</td> <!-- Discrete -->
           <td>&#10003;</td>
           <td>&#10003;</td>
           <td></td>
           <td>&#10003;</td> <!-- MIP Search -->
           <td>&#10003;</td> <!-- Complex Search -->
       </tr>
   </tbody>
</table>
 
## General description
 
### Computation of practical measures of integrated information
The codes for computing practical measures of integrated information (&Phi;), namely, mutual information (Tononi, 2004), stochastic interaction (Ay, 2001, 2015; Barrett & Seth, 2011), integrated information based on mismatched decoding &Phi;<sub>*</sub> [1] and geometric integrated information &Phi;<sub>G</sub> [2]. Integrated information quantifies the amount of information that is integrated within a system. For quantifying integrated information, we need to assume what distribution data obeys. Two options are available for a probability distribution with which integrated information is computed, which are Gaussian distribution and discrete distribution. Please look at “demo_phi_Gauss.m” and “demo_phi_dis.m” to see how to use the core functions for PHI computation.
 
### Search for minimum information partitions (MIPs)
The codes for searching for the minimum information partition (MIP) (see Tononi, 2008, Biol Bull for example). Two types of algorithms for the MIP search are provided, namely, an exhaustive search and Queyranne’s algorithm (Queyranne, 1998). An exhaustive search is applicable for all the measures of integrated information but it takes a large amount of computation time. If the number of elements in a system is larger than several dozen, the computation is practically impossible. Queyranne's algorithm can exactly and effectively find the MIP only when mutual information is used as a measure of integrated information [3]. It enables us to find the MIP in a relatively large system (consisting of several hundreds of elements) in a practical amount of time. Queyranne's algorithm can be also used for approximately finding the MIP even when other measures are used [4]. Please look at “demo_MIP_Gauss.m” and “demo_MIP_dis.m” to see how to use the core functions for MIP search.
 
### Search for complexes
The codes for searching for complexes (See Balduzzi & Tononi, 2008, PLoS Comp. Biol. for example). Two types of algorithm are provided, namely, an exhaustive search and Hierarchical Partitioning for Complex search (HPC) that we proposed in [5]. An exhaustive search is applicable for all the measures of integrated information but it takes an extremely large amount of computation time. As a remedy for the computational intractability, HPC can exactly and effectively find complexes when mutual information is used as a measure of integrated information [5]. It enables us to find complexes in a relatively large system (consisting of several hundred elements) in a practical amount of time. HPC does not necessarily find all of the complexes or well approximated complexes when other measures are used. Please look at “demo_Complex_Gauss.m” and “demo_Complex_dis.m” to see how to use the core functions for complex search. Please also look at “demos_HPC” folder containing codes for reproducing the simulations in [5].
 
You can freely use this toolbox at your own risk. Please cite this toolbox (URL) and the papers listed below when the toolbox is used for your publication. Comments, bug reports, and proposed improvements are always welcome. 
 
 
### Misc.
This toolbox uses 
- “colorcet.m” written by Peter Kovesi, which provides perceptually uniform color maps. See the link below for more details. 
https://peterkovesi.com/projects/colourmaps/ 
 
- “minFunc” written by Mark Schmidt, which is needed for solving unconstrained optimization. See the link below for more details. 
http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html
 
 
## Trouble shooting
- *Invalid MEX File Errors*. In the case you get "Invalid MEX-file" error messages related to minFunc, please compile minFunc files by executing mexAll.m in PhiToolbox/tools/minFunc_2012 or please set Options.useMex = 0 in phi_G_Gauss-LBFGS.m, phi_star_dis.m and phi_star_Gauss.m.
 
 
## Acknowledgment
We thank Shohei Hidaka (JAIST) for providing the codes for Queyranne’s algorithm. We thank Yuma Aoki, Ayaka Kato, Genji Kawakita, Daiki Kiyooka, Kaio Misawa for testing the toolbox for usability.
 
## References
[1] Oizumi, M., Amari, S, Yanagawa, T., Fujii, N., & Tsuchiya, N. (2016). Measuring integrated information from the decoding perspective. PLoS Comput Biol, 12(1), e1004654. http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004654
 
[2] Oizumi, M., Tsuchiya, N., & Amari, S. (2016). Unified framework for information integration based on information geometry. Proceedings of the National Academy of Sciences, 113(51), 14817-14822. http://www.pnas.org/content/113/51/14817.short
 
[3] Hidaka, S., Oizumi, M. (2017). Fast and exact search for the partition with minimal information loss. arXiv, 1708.01444. https://arxiv.org/abs/1708.01444
 
[4] Kitazono, J., Kanai, R., Oizumi, M. (2018). Efficient algorithms for searching the minimum information partition in integrated information theory. Entropy, 20, 173.
http://www.mdpi.com/1099-4300/20/3/173
 
[5] Kitazono, J., Kanai, R., Oizumi, M. (2020). Efficient search for informational cores in complex systems: Application to brain networks. bioRxiv.
 
These papers are in the "papers" folder.





