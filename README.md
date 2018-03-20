# NWChem Compilation

My personal shell script for auto compile NWChem program on CentOS 6.x &amp; 7.x Linux-based. Don't trust the script but it works for me. However, this script could be adjusted and adapted to perform an installation on other Linux distribution as well. Moreover, if you have any problems you can visit the [Q&A forum of NWChem](http://www.nwchem-sw.org/index.php/Special:AWCforum).

### Requirement
* CentOS version 6.x or 7.x (or other Linux distro)
* NWChem version 6.6 or higher
* Python version 2.x
* OpenMPI or MPI package

### Installation
  * **(1)**  Install required package using command (root or sudo)
```
yum install python-devel gcc-gfortran openblas-devel openblas-serial64 openmpi-devel scalapack-openmpi-devel blacs-openmpi-devel elpa-openmpi-devel tcsh --enablerepo=epel
```
  * **(2)**  Create directory NWCHEM at */usr/local/src/*. Check all required package *Before Compile*.
```
mkdir /usr/local/src/NWCHEM
```
  * **(3)**  Download program source code of *nwchem-x.x.tar.gz* from NWChem website using **wget** command first. (I am using nwchem version 6.6 on the day I wrote this script). Save it at */usr/local/src/NWCHEM/* , then extract the program from tar file using command
```
tar -xf nwchem-x.x.tar.gz
```
  * **(4)**  Download a scripts to */usr/local/src/NWCHEM/nwchem-x.x*. Then run script [1_compile.sh](https://github.com/rangsimanketkaew/NWChem/blob/master/1_compile.sh). The compile process will take you about 30 minutes. After finishing and there's no any error, then run [2_path.sh](https://github.com/rangsimanketkaew/NWChem/blob/master/2_path.sh), respectively. More instruction can be found in script [1_compile.sh](https://github.com/rangsimanketkaew/NWChem/blob/master/1_compile.sh). ! <br />
  * **(5)**  Move to your home directory. Then create a **.nwchemrc** file which includes following commands. /home/$USER/.nwchemrc and running an example calculation optimization of azulene using DFT at M06-2X/6-31G(d) to check if NWChem is installed perfectly. <br /> 
  
```
  nwchem_basis_library /usr/local/nwchem/data/libraries/
  nwchem_nwpw_library /usr/local/nwchem/data/libraryps/
  ffield amber
  amber_1 /usr/local/nwchem/data/amber_s/
  amber_2 /usr/local/nwchem/data/amber_q/
  amber_3 /usr/local/nwchem/data/amber_x/
  amber_4 /usr/local/nwchem/data/amber_u/
  spce    /usr/local/nwchem/data/solvents/spce.rst
  charmm_s /usr/local/nwchem/data/charmm_s/
  charmm_x /usr/local/nwchem/data/charmm_x/
```
  * **(6)** Running a calculation of optimization of azulene using DFT at M06-2X/6-31G(d) to check if NWChem is installed perfectly.

Caveat! Note that the day I posted this script I was using NWChem version 6.6. So this way that I proposed should work with another version though.

---
**Optional: PATH SETTING.** Instead of running nwchem via direct path, you can make a alias path to call nwchem by using following command
```
export PATH=/usr/local/nwchem-6.6/bin/LINUX/nwchem:$PATH
```
If you want to call NWChem automatically for next time of login, each user have to make an environment path of nwchem by appending the following command to their personal $HOME/.bashrc file.
```
echo export PATH=/usr/local/nwchem-6.6/bin/LINUX/nwchem:$PATH >> /home/$USER/.bashrc
```
Then activate the .bashrc file
```
source /home/$USER/.bashrc
```
May try to logout and login again, so you should be ablt to call nwchem. If you have any problem, please ask google, he is your friend.

# Error & Fixing
While the system installs NWChem by using **make** or **configuration setting up** commands, you may be met an error which caused by calling library mistake. <br />
E.g. *libmpi_f90.so.1: cannot open*, you have to use the following command to fix the issue.
```
export LD_LIBRARY_PATH=/usr/local/openmpi/lib/:$LD_LIBRARY_PATH
source $HOME/.bashrc
```
---
Since you have run NWChem with MPI and suddenly see the following error
```
utilfname: cannot allocate
```
or
```
utilfname: cannot allocate:Received an Error in Communication
```
This error message is telling you that NWChem cannot allocate the memory with number of processors. The user must specify the amount of memory **PER** processor core that NWChem can possibly employs for a calculation. <br />
This issue can be easily fixed by adding a memory keyword into INPUT-FILE.nw, e.g.
```
memory 1 gb
```
If you run NWChem using command like this *"mpirun -np N nwchem INPUT-FILE.nw"*, this mean that the total of used memory for this calculation = (1 GB)*(N processors). <br />
However, safety first, you can limit the total of memory usage for calculation by specifying optional keyword of memory keyword, says
```
memory total 1 gb
```
More details about memory arrangement can be found this [website](http://www.nwchem-sw.org/index.php/Release66:Top-level#MEMORY)

# Running NWChem
let's try to run nwchem with some test files from **/usr/local/src/NWCHEM/nwchem-6.6/examples/** or **/usr/local/src/NWCHEM/nwchem-6.6/QA/tests** 
Running on standalone or cluster using OpenMPI (straightforward command)
```
mpirun -np N nwchem INPUT-FILE.nw >& OUTPUT-FILE.log
```
To run an OpenMPI program multithreaded 
```
mpirun -np N -map-by socket -bind-to socket nwchem INPUT-FILE.nw >& OUTPUT-FILE.log
```
However, the following command might be useful
```
export OMP_NUM_THREADS=M
```
where N and M = number of processors and threads (integer & positive number), respectively. Set number of threads = 1 is recommended if the cluster/machine do not do I/O or even you do not know. This value provides the best performance.
You can add optional to set the calculation for either single or multi-threaded process.
```
mpirun -genv OMP_NUM_THREADS M -np N nwchem INPUT-FILE.nw >& OUTPUT-FILE.log 
```
---
Running on MPI Cluster using MPICH
```
mpirun -np $NSLOTS nwchem INPUT-FILE.nw >& OUTPUT-FILE.log 
```
Running on MPI Cluster using MVAPICH2
```
mpirun -genv OMP_NUM_THREADS M -genv MV2_ENABLE_AFFINITY 0 -np N nwchem INPUT-FILE.nw >& OUTPUT-FILE.log 
```
The total number of cpu cores used for this calculation will be M x N.

## OpenMPI 1.6.5 Installation
[Please visit this website](http://lsi.ugr.es/~jmantas/pdp/ayuda/datos/instalaciones/Install_OpenMPI_en.pdf). Not only version 1.6.5, but also other version says 2.x are also used in conjunction with NWChem compilation as long as you set the linkink and compatible libraries correctly.

## OpenBLAS Installation
You may need to install OpenBLAS yourself. Download source file at [Download here](https://www.open-mpi.org/software/ompi/v1.6/) <br />
Explanation of installation is here [Installation guide](https://github.com/xianyi/OpenBLAS/wiki/Installation-Guide).

## More details
I also provide the script for alternative way to install and compile NWChem program which those scripts can be found on this repository. Additionally, apart from manually compiling NWChem through running script, using RPM could help you to install that via typing a few command. The binary rpm file of various flavor of NWChem v. 6.6, i.e. nwchem-common, nwchem-openmpi, nwchem-mpich, can be found at [PKGS.org](https://pkgs.org/download/nwchem) and [RPM Find](https://www.rpmfind.net/linux/rpm2html/search.php?query=nwchem&submit=Search+...). For more details you should visit [NWChem Compilation website](http://www.nwchem-sw.org/index.php/Compiling_NWChem) for more details.

## Contact info
E-mail: rangsiman1993(at)gmail.com and rangsiman_k(at)sci.tu.ac.th
