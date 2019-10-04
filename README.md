MultiDOE
=======

[![GitHub license](https://img.shields.io/github/license/luclaurent/MultiDOE.svg)](https://github.com/luclaurent/MultiDOE/blob/master/LICENSE.md)
 [![Github Releases](https://img.shields.io/github/release/luclaurent/MultiDOE.svg)](https://github.com/luclaurent/MultiDOE/releases) [![DOI](https://zenodo.org/badge/134069345.svg)](https://zenodo.org/badge/latestdoi/134069345)

This MATLAB/OCTAVE toolbox regroups many existing tools for generating sample points using many specific DOE techniques:

* Full factorial sampling
* Latin Hypercube Sampling 
* Optimal Latin Hypercube sampling
* Improved Hypercube Sampling
* Random Sampling

Many techniques proposed in this toolbox are based on 

* the [R software](https://cran.r-project.org/). More precisely, the library [lhs](https://cran.r-project.org/web/packages/lhs/index.html) is used. 
* the [IHS](https://people.sc.fsu.edu/~jburkardt/m_src/ihs/ihs.html) matlab's softwares proposed by [John Burkardt](http://people.sc.fsu.edu/~jburkardt/).
* the [LHS](http://www.mathworks.com/matlabcentral/fileexchange/4352-latin-hypercube-sampling/content/lhsu.m) proposed by Budiman Minasny.

*NOTICE*: sampling techniques based on the R software are only usable on a Unix OS.

Features
------
The MultiDOE toolbox is able to 

* generate sampling
* sort the sample points using many techniques
* add points to an existing sampling (based on the LHS and IHS procedures of the R software)
* normalize/renormalize the sample points to be well defined in the specified design space
* call automatically the R software (on Unix/Linux/OSX systems only)
* compute scores (minimal distances, discrepancy...), see for instance the [Franco's PhD thesis (2008)](https://tel.archives-ouvertes.fr/tel-00803107/)

Download
------

The toolbox can be downloaded [here](https://bitbucket.org/luclaurent/multidoe/downloads) or [here](https://github.com/luclaurent/multidoe/releases).

If you use `git`, you can clone the repository using the following command

    git clone --recursive git@bitbucket.org:luclaurent/multidoe.git MultiDOE

or 

    git clone --recursive git@github.com:luclaurent/MultiDOE.git MultiDOE

Citing this toolbox [![DOI](https://zenodo.org/badge/134069345.svg)](https://zenodo.org/badge/latestdoi/134069345)
------

If you use this toolbox please add a small reference to it. Check [here](https://doi.org/10.5281/zenodo.1249968) for the right citing form (depending on the version you used).


Requirements
------
The toolbox requires:

* the [Statistics and Machine Learning Toolbox](http://fr.mathworks.com/products/statistics/) of the Matlab's software (for the `lhsdesign` command called using `LHSD` keyword, optional)
* the R software installed on an UNIX/Linux/OSX system and the `R` command available on the command line (for obtaining LHS or IHS by using `IHS_R` or `LHS_R` commands) [optional] 
* the [lhs](https://cran.r-project.org/web/packages/lhs/index.html) and [R.matlab](https://cran.r-project.org/web/packages/R.matlab/index.html) packages installed on R (see for instance [How to Install a R Package](http://math.usask.ca/~longhai/software/installrpkg.html))
* the [graphviz software](www.graphviz.org) (the `dot` command must be available on the command line) for building the documentation [optional].

[Documentation](http://bit.ly/docmultidoe)
------
The automatic building of the documentation is based on the [m2html](http://www.artefact.tk/software/matlab/m2html/) software.

The obtained documentation is available [here](http://bit.ly/docmultidoe).


License ![GNU GPLv3](http://www.gnu.org/graphics/gplv3-88x31.png)
----

    MultiDOE - Toolbox for sampling a bounded space
    Copyright (C) 2016  Luc LAURENT <luc.laurent@lecnam.net>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.