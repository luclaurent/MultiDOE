Toolbox MultiDOE
=======

This Matlab toolbox regroups many existing tools for generating sample points using many specific DOE techniques:

* Full factorial sampling
* Latin Hypercube Sampling 
* Optimal Latin Hypercube sampling
* Improved Hypercube Sampling
* Random Sampling

Many techniques proposed in this toolbox are based on 

* the [R software](https://cran.r-project.org/). More precisely, the library [lhs](https://cran.r-project.org/web/packages/lhs/index.html) is used. 
* the [IHS](https://people.sc.fsu.edu/~jburkardt/m_src/ihs/ihs.html) matlab's softwares proposed by [John Burkardt](http://people.sc.fsu.edu/~jburkardt/)
* the [LHS](http://www.mathworks.com/matlabcentral/fileexchange/4352-latin-hypercube-sampling/content/lhsu.m) proposed by Budiman Minasny

Features
------
The MultiDOE toolbox are able to 

* generate sampling
* sort the sample points using many techniques
* add points to an existing sampling (based on the LHS and IHS procedures of the R software)
* normalize/renormalize the sample points to be well defined in the specified design space
* call automatically the R software (on Unix/Linux/OSX systems only)
* compute scores (minimal distances, discrepancy...), see for instance the [Franco's PhD thesis (2008)](https://tel.archives-ouvertes.fr/tel-00803107/)



Requirements
------
The toolbox requires:

* the [Statistics and Machine Learning Toolbox](http://fr.mathworks.com/products/statistics/) of the Matlab's software (for the `lhsdesign` command called using `LHSD` keyword, optional)
* the R software installed on an UNIX/Linux/OSX system and the `R` command available on the command line (for obtaining LHS or IHS called using `IHS_R` or `LHS_R` commands, optional)
* the [lhs](https://cran.r-project.org/web/packages/lhs/index.html) and [R.matlab](https://cran.r-project.org/web/packages/R.matlab/index.html) installed on R (see for instance [How to Install an R Package](http://math.usask.ca/~longhai/software/installrpkg.html))
* the [graphviz software](www.graphviz.org) (the `dot` command must be available on the command line) for building the documentation (optional).

Documentation
------
The automatic building of the documentation is based on the [m2html](http://www.artefact.tk/software/matlab/m2html/) software.

License
----

Copyright or © or Copr. Luc LAURENT (30/06/2016)
luc.laurent@lecnam.net

This software is a computer program whose purpose is to generate sampling
using dedicated techniques.

This software is governed by the CeCILL license under French law and
abiding by the rules of distribution of free software.  You can  use, 
modify and/ or redistribute the software under the terms of the CeCILL
license as circulated by CEA, CNRS and INRIA at the following URL
"http://www.cecill.info". 

As a counterpart to the access to the source code and  rights to copy,
modify and redistribute granted by the license, users are provided only
with a limited warranty  and the software's author,  the holder of the
economic rights,  and the successive licensors  have only  limited
liability. 

In this respect, the user's attention is drawn to the risks associated
with loading,  using,  modifying and/or developing or reproducing the
software by the user in light of its specific status of free software,
that may mean  that it is complicated to manipulate,  and  that  also
therefore means  that it is reserved for developers  and  experienced
professionals having in-depth computer knowledge. Users are therefore
encouraged to load and test the software's suitability as regards their
requirements in conditions enabling the security of their systems and/or 
data to be ensured and,  more generally, to use and operate it in the 
same conditions as regards security. 

The fact that you are presently reading this means that you have had
knowledge of the CeCILL license and that you accept its terms.

