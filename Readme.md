# Practical Phi Toolbox for Integrated Information Analysis
Jun Kitazono and Masafumi Oizumi (The University of Tokyo)  
Email: c-kitazono@g.ecc.u-tokyo.ac.jp, c-oizumi@g.ecc.u-tokyo.ac.jp  
Last update: Mar XXth, 2020  

This toolbox provides MATLAB codes for end-to-end computation for practical versions of integrated information theory. This toolbox is an update of our previous version of the toolbox available at figshare (doi:10.6084/m9.figshare.3203326). In this new version, the algorithms for searching for complexes are newly implemented. The features available in this toolbox are summarized in the table below.


<table>
    <thead>
        <tr align='center'>
            <th colspan=8>Computation of practical measures of Phi</th> <th>MIP Search</th> <th>Complex Search</th>
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
            <td>star</td>
            <td>Geo</td>
            <td>MI</td>
            <td>SI</td>
            <td>star</td>
            <td>Geo</td>
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
This toolbox provides codes for computing practical measures of integrated information (PHI), namely, mutual information (Tononi, 2004), stochastic interaction (Ay, 2001, 2015; Barrett & Seth, 2011), integrated information based on mismatched decoding Φ^* [1] and geometric integrated information Φ_G [2]. Integrated information quantifies the amount of information that is integrated within a system. Please look at “demo_phi_Gauss.m” and “demo_phi_dis.m” to see how to use the core functions for PHI computation. 

### Search for minimum information partitions (MIPs)
The codes for searching for the minimum information partition (see Tononi, 2008, Biol Bull for example) are provided. Two types of algorithms for the MIP search are provided, namely, an exhaustive search, Queranne’s algorithm [3, 4]. Please look at “demo_MIP_Gauss.m” and “demo_MIP_dis.m” to see how to use the core functions for MIP search.


### Search for complexes
The codes for searching for complexes (See Balduzzi & Tononi, 2008, PLoS Comp. Biol. for example) are provided. Two types of algorithm are provided, namely, an exhaustive search and Hierarchical Partitioning for Complex search (HPC) [5]. Please look at “demo_Complex_Gauss.m” and “demo_Complex_dis.m” to see how to use the core functions for complex search. Please also look at “demos_HPC” folder containing codes for reproducing the simulations in Kitazono et al., 2020 [5] in which we propose HPC.

You can freely use this toolbox at your own risk. Please cite this toolbox (URL) and the papers listed below when the toolbox is used for your publication. Comments, bug reports, and proposed improvements are always welcome. 


This toolbox uses  
“colorcet.m” written by Peter Kovesi, which provides perceptually uniform color maps. See the link below for more details. 
https://peterkovesi.com/projects/colourmaps/  

“minFunc” written by Mark Schmidt, which is needed for solving unconstrained optimization. See the link below for more details. 
http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html
- In the case minFunc does not work due to a problem in mex files, please compile minFunc files by executing mexAll.m in PhiToolbox/tools/minFunc_2012 or please set Options.useMex = 0 in phi_G_Gauss-LBFGS.m, phi_star_dis.m and phi_star_Gauss.m. 


## Acknowledgement
We thank Shohei Hidaka for providing the codes for Queyranne’s algorithm. 


## References
[1] Oizumi, M., Amari, S, Yanagawa, T., Fujii, N., & Tsuchiya, N. (2016). Measuring integrated information from the decoding perspective. PLoS Comput Biol, 12(1), e1004654. http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004654

[2] Oizumi, M., Tsuchiya, N., & Amari, S. (2016). Unified framework for information integration based on information geometry. Proceedings of the National Academy of Sciences, 113(51), 14817-14822. http://www.pnas.org/content/113/51/14817.short

[3] Hidaka, S., Oizumi, M. (2017). Fast and exact search for the partition with minimal information loss. arXiv, 1708.01444. https://arxiv.org/abs/1708.01444

[4] Kitazono, J., Kanai, R., Oizumi, M. (2018). Efficient algorithms for searching the minimum information partition in integrated information theory. Entropy, 20, 173. 
http://www.mdpi.com/1099-4300/20/3/173

[5] Kitazono, J., Kanai, R., Oizumi, M. (2020). Efficient Search for Informational Cores in Complex Systems -Application to Brain Networks-. bioRxiv.

These papers are in the "papers" folder. 




