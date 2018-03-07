# Practical PHI toolbox for integrated information analysis

######Jun Kitazono and Masafumi Oizumi (Araya Inc.)
######Email: kitazono@araya.org, oizumi@araya.org
######Last update: XX XX, 2018

##General description
This toolbox provides MATLAB codes for end-to-end computation for practical versions of integrated information theory.

**Computation of practical measures of integrated information**
This toolbox provides codes for computing practical measures of integrated information, namely, mutual information, stochastic interaction, <img src="https://latex.codecogs.com/gif.latex?\Phi^*" /> [1] and <img src="https://latex.codecogs.com/gif.latex?\Phi_G" /> [2]. Integrated information quantifies the amount of information that is integrated within a system. Please first look at “demo_phi.m”, which is a simple demonstration code, to see how the core functions should be used.

**Search for the minimum information partition**
The codes for searching the minimum information partition (see Tononi, 2008, Biol Bull for example) are provided. Three types of algorithms for the MIP search are provided, namely, the exhaustive search, Queranne’s algorithm and Replica exchange Markov chain Monte Carlo (REMCMC). Please first look at “demo_MIP_Gauss.m” and “demo_MIP_dis.m” which is a simple demonstration code, to see how the core functions should be used.

**Search for the complex**
Please first look at “demo_Complex_Gauss.m”, which is a simple demonstration code, to see how the core functions should be used.

This toolbox is an update of our previous version of toolbox, "phi_toolbox" available at figshare (doi:10.6084/m9.figshare.3203326). The main differences of the new version from phi_toolbox at figshare are summarized in the table below.


The toolbox contains “minFunc” written by Mark Schmidt, which is needed for solving unconstrained optimization. Please refer to the original webpage for the details.
http://www.cs.ubc.ca/~schmidtm/Software/minFunc.html
[Copyright 2005-2015 Mark Schmidt. All rights reserved.]

You can freely use this toolbox at your own risk. Please cite this toolbox (URL) and the papers listed below when the toolbox is used for your publication.Comments, bug reports, and proposed improvements are always welcome.



##Acknowledgement
We thank Shohei Hidaka, Japan Advanced Institute of Science and Technology, for providing us Queyranne’s algorithm codes. We also thank XXX for XXX.
This toolbox was made with a financial support by JST CREST Grant Number JPMJCR15E2, Japan.

##References
[1] Oizumi, M., Amari, S, Yanagawa, T., Fujii, N., & Tsuchiya, N. (2016). Measuring integrated information from the decoding perspective. PLoS Comput Biol, 12(1), e1004654. http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004654

[2] Oizumi, M., Tsuchiya, N., & Amari, S. (2016). Unified framework for information integration based on information geometry. Proceedings of the National Academy of Sciences, 113(51), 14817-14822. http://www.pnas.org/content/113/51/14817.short

[3] Hidaka, S., Oizumi, M. (2017). Fast and exact search for the partition with minimal information loss. arXiv, 1708.01444. https://arxiv.org/abs/1708.01444

[4] Kitazono, J., Kanai, R., Oizumi, M. (2018). Efficient algorithms for searching the minimum information partition in integrated information theory. Entropy, 20, 173. http://www.mdpi.com/1099-4300/20/3/173/html

[5] Oizumi, M., Kitazono., J., Kanai, R. (in prep.)