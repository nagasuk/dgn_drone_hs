DGN Drone Hardware System
=========================

Overview
--------
This is FPGA-based hardware system to operate drone developed by DGN
Engineer Team.
This system is developed based on GSRD for [DE10-Nano][de10nano] provided by
Terasic Inc.

[de10nano]:https://www.terasic.com.tw/cgi-bin/page/archive.pl?Language=English&No=1046

1st Step after git clone
------------------------
For the first time, you should excecute a script of `dome1st.sh` to prepare
IP cores used by this system.

Make RBF
--------
You can get rbf-file by executing `cd project && make rbf`.

Requirement IP cores
--------------------
* [mBldcm][mBldcm] (Automatic download by `dome1st.sh`)

[mBldcm]:https://github.com/nagasuk/mBldcm

License
-------
Please see `LICENSE.md` file for details.

