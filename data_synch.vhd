----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:20:55 12/09/2010 
-- Design Name: 
-- Module Name:    data_synch - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity data_synch is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           data_full : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out_v : in  STD_LOGIC;
           data_full_clk : out  STD_LOGIC_VECTOR (15 downto 0));
end data_synch;

architecture Behavioral of data_synch is
signal test : std_logic_vector(15 downto 0);
begin
 process(clk,rst)
  begin
	if RST = '1' then
	  test<=(OTHERS=>'0');

	    else if  data_out_v = '1' then
	     test<=data_full;
		 else
		  test<=(others=>'0');
	    end if;
		end if;
		data_full_clk<=test;
  end process;
  
	   



end Behavioral;

