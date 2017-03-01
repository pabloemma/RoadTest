--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:19:53 02/28/2017
-- Design Name:   
-- Module Name:   C:/ML605/RoadTest_V2.01/RoadTestTB.vhd
-- Project Name:  RoadTest_V2.01
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RoadTest
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY RoadTestTB IS
END RoadTestTB;
 
ARCHITECTURE behavior OF RoadTestTB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RoadTest
    PORT(
         RST_IN : IN  std_logic;
         sys_clk_in_pn : IN  std_logic_vector(1 downto 0);
         FNAL_clock : IN  std_logic;
         PUSH_IN : IN  std_logic;
         PUSH_STOP_in : IN  std_logic;
         dip_switch : IN  std_logic_vector(7 downto 0);
         bank1_p : OUT  std_logic_vector(31 downto 0);
         bank1_n : OUT  std_logic_vector(31 downto 0);
         bank2_p : OUT  std_logic_vector(31 downto 0);
         bank2_n : OUT  std_logic_vector(31 downto 0);
         DarkPhotonBank_p : OUT  std_logic_vector(105 downto 0);
         DarkPhotonBank_n : OUT  std_logic_vector(105 downto 0);
         led_buff_ML605 : OUT  std_logic_vector(7 downto 0);
         led_buff_out : OUT  std_logic_vector(7 downto 0);
         line1 : OUT  std_logic_vector(31 downto 0);
         line2 : OUT  std_logic_vector(31 downto 0);
         line3 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RST_IN : std_logic := '0';
   signal sys_clk_in_pn : std_logic_vector(1 downto 0) := (others => '0');
   signal FNAL_clock : std_logic := '0';
   signal PUSH_IN : std_logic := '0';
   signal PUSH_STOP_in : std_logic := '0';
   signal dip_switch : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal bank1_p : std_logic_vector(31 downto 0);
   signal bank1_n : std_logic_vector(31 downto 0);
   signal bank2_p : std_logic_vector(31 downto 0);
   signal bank2_n : std_logic_vector(31 downto 0);
   signal DarkPhotonBank_p : std_logic_vector(105 downto 0);
   signal DarkPhotonBank_n : std_logic_vector(105 downto 0);
   signal led_buff_ML605 : std_logic_vector(7 downto 0);
   signal led_buff_out : std_logic_vector(7 downto 0);
   signal line1 : std_logic_vector(31 downto 0);
   signal line2 : std_logic_vector(31 downto 0);
   signal line3 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant FNAL_clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RoadTest PORT MAP (
          RST_IN => RST_IN,
          sys_clk_in_pn => sys_clk_in_pn,
          FNAL_clock => FNAL_clock,
          PUSH_IN => PUSH_IN,
          PUSH_STOP_in => PUSH_STOP_in,
          dip_switch => dip_switch,
          bank1_p => bank1_p,
          bank1_n => bank1_n,
          bank2_p => bank2_p,
          bank2_n => bank2_n,
          DarkPhotonBank_p => DarkPhotonBank_p,
          DarkPhotonBank_n => DarkPhotonBank_n,
          led_buff_ML605 => led_buff_ML605,
          led_buff_out => led_buff_out,
          line1 => line1,
          line2 => line2,
          line3 => line3
        );

  -- Clock process definitions
   FNAL_clock_process :process
   begin
		FNAL_clock <= '0';
		wait for FNAL_clock_period/2;
		FNAL_clock <= '1';
		wait for FNAL_clock_period/2;
   end process;

 --    -- Clock process definitions for lvds
--   clock_process :process
--   begin
--		sys_clk_in_pn(1) <= '0';
--		sys_clk_in_pn(0) <= '1';
--		wait for clock_period/2;
--		sys_clk_in_pn(1) <= '1';
--		sys_clk_in_pn(0) <= '0';
--		wait for clock_period/2;
--   end process;

  -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 20 ns;	
	   RST_IN<='1';
		wait for 100 ns;
		RST_IN<='0';
		wait for 10 ns; --let it settle;
		dip_switch<="00000001";
 		

      --wait for clock_period*10;
		wait for 10 ns;
		push_in <='1';
		wait for 1000 ns;
		push_in <='0';

--		wait for 10 ns;
--		--push_stop_in<='1';
--		dip_switch<="00000001";
--		wait for 900 ns;
--		rst_in<='1';
--		wait for 100 ns;
--		rst_in<='0';
--		wait for 1000 ns;
--		push_stop_in<='1';

      -- insert stimulus here 

      wait;
 


   end process;

END;




