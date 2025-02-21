# Verilog Pacman

> This project is a learning experience in Verilog/SystemVerilog with the goal of recreating a simple version of the game Pacman. 

## Learning Objectives: 
1. Understand SVA timescale
    > How this relates to system verification. The formatting follows: `timescale <\time_unit>/<\time_Precision> where time_unit refers to the measurement of delays and simulation time and time_precision specifies how delay values are rounded (resolution).
2. Wire vs. Reg
    > Procedures (always, initial, task, function) can only assign the reg data type. Continuous assignment can only update wire types. 
2. Assign statements
    > How this relates to both hardware design through continuous assignment of a wire as well as verification through the use of [\drive_strength] and [\delay] parameters
3. Begin/end Blocks
    > Sequential statements of logic and how this effects design. 
4. Blocking/non-blocking
    > How to effectively use these in design of combinational/sequential logic. Blocking ( = ) infers combinational logic. Non-blocking ( <= ) infers sequential logic. A Non-blocking assignment in an always block will take some delta time after execution to propagate. A blocking assignment in an always block will immediately take effect. It is advised to avoid mixing these two in the same always block, as this can introduce incorrect sequential/combinational logic when synthesizing (i.e. synthesizer may infer a sequential flip flop for blocking assignemts )
5. Time / Event Delays
    > Time delays in SVA aids in verification by allowing for a certain #<\num> time delay from when the simulator encounters a statement to when it actually executes. Event delays will not allow a statement to execute in simulation until the simulator encounters a certain simulation event (implicit : change of value on a net/variable, explicit : named event triggered in another procedure )
6. Assert Statements 
    >  A tool to validate behavior of a design. Types of assertions include immediate (i.e. assert (A == B), any results in a X,Z, or 0 will fail the assertion and provide an error to the simulator) and concurrent (check at any point during simulation that a specified property only results in TRUE, i.e. assert property (!(Read && Write)) will ensure that Read and Write variables are never high simultaneously). Another type of assert statement includes implication. There are also numerous tools such as $display, $error, $warning to print useful information to the simulation terminal upon failures in assertions. All of these will be continuously investigated throughout the development of Pac Man and there will be attempts to implement them in a useful manner alongside a fleshed out testbench. 


### Equipment Utilized 
[Digilent Basys 3 FPGA Board](https://digilent.com/reference/_media/basys3:basys3_rm.pdf)

### Software Utilized 
[Xilinx Vivado](https://docs.xilinx.com/search/all?content-lang=en-US)

### Books/Physical Resources: 
[Stuart Sutherland : RTL Modeling with SystemVerilog for Simulation and Synthesis: Using SystemVerilog for ASIC and FPGA Design](https://www.amazon.com/RTL-Modeling-SystemVerilog-Simulation-Synthesis/dp/1546776346)

[Ray Salemi : The UVM Primer](https://www.amazon.com/gp/product/B00GBD62HK?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00GBD62HK&linkCode=as2&tag=rayspicks)

### Online Resources: 
[Stuart Sutherland : Verilog HDL Quick Reference Guide](https://sutherland-hdl.com/pdfs/verilog_2001_ref_guide.pdf)

[Stuart Sutherland : Who Put Assertions In My RTL Code? And Why?](https://sutherland-hdl.com/papers/2015-SNUG-SV_SVA-for-RTL-Designers_paper.pdf)

[Chip Verify: SystemVerilog Tutorial](https://www.chipverify.com/tutorials/systemverilog)

[Nand Land : Blocking vs. Nonblocking in Verilog](https://nandland.com/blocking-vs-nonblocking-in-verilog/)

[The Spriters : Pac Man Graphics](https://www.spriters-resource.com/arcade/pacman/)

[The Pac Man Dossier](https://pacman.holenet.info/)