----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:33:41 06/14/2010 
-- Design Name: 
-- Module Name:    invert_rst - Behavioral 
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

entity invert_rst is
    Port ( RST_IN : in  STD_LOGIC;
	        start : in std_logic ;
			  clk : std_logic;
			  stop : in std_logic ;
           NOT_RST : out  STD_LOGIC);
end invert_rst;

architecture Behavioral of invert_rst is
signal transfer :  std_logic;

begin
	process(clk)
   begin
	if(clk'event and clk = '1') then
		if(stop = '1' or RST_IN = '1') then
			transfer<='0';
		elsif(start = '1') then
	        --transfer<=not(RST_IN);
	        transfer<='1'; -- latch
		end if;
	end if;
	end process;
	NOT_RST<=transfer;

end Behavioral;

