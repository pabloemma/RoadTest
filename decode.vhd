----------------------------------------------------------------------------------
-- Company: 
-- Engineer: andi klein
-- 
-- Create Date:    09:04:18 02/28/2017 
-- Design Name: 
-- Module Name:    decode - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: This routines takes the hit vector from the track
-- and decodes it such that we will have as return the different stations
-- this we can then put onto ribbons.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.ALL;




entity decode is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
			  ena : in  std_logic; -- hopefully to get rid of the bit 0 problem
           hit_vector : in  STD_LOGIC_VECTOR (19 downto 0);
           quadrant : out  STD_LOGIC_VECTOR (3 downto 0);
           sta1 : out  STD_LOGIC_VECTOR (79 downto 0);
           sta2 : out  STD_LOGIC_VECTOR (49 downto 0);
           sta4 : out  STD_LOGIC_VECTOR (31 downto 0));
end decode;

architecture Behavioral of decode is
--signal q : natural range 0 to 3;
signal test1 : natural ;
begin
--q<=to_integer(unsigned(hit_vector(19 downto 18)));
process(clk,rst)
	begin

			 quadrant <=(others=>'0');
			 sta1 <=(others=>'0');
			 sta2 <=(others=>'0');
			 sta4 <=(others=>'0');

	-- make sure we do not have a latch
	  if(clk'event and clk = '1' and ena = '1') then

	  
	     if(rst = '1') then -- set everything to 0
		    quadrant <=(others=>'0');
			 sta1 <=(others=>'0');
			 sta2 <=(others=>'0');
			 sta4 <=(others=>'0');
		  else
		  test1<=to_integer(unsigned(hit_vector(19 downto 18)));
	     quadrant <= std_logic_vector(shift_left(resize(unsigned'("1"), quadrant'length), to_integer(unsigned(hit_vector(19 downto 18)))));
	     -- alternative way: quadrant<=std_logic_vector(to_unsigned(2**(to_integer(unsigned(hit_vector(19 downto 18)))),quadrant'length));
        sta1 <= std_logic_vector(shift_left(resize(unsigned'("1"), sta1'length), to_integer(unsigned(hit_vector(17 downto 11)))));
        sta2 <= std_logic_vector(shift_left(resize(unsigned'("1"), sta2'length), to_integer(unsigned(hit_vector(10 downto 5)))));
        sta4 <= std_logic_vector(shift_left(resize(unsigned'("1"), sta4'length), to_integer(unsigned(hit_vector(5 downto 0)))));
		  
         end if;
		end if;
  end process;
end Behavioral;

