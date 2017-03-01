----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:39:22 03/01/2017 
-- Design Name: 
-- Module Name:    enable_reg - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enable_reg is
    Port ( clk : in  STD_LOGIC;
           inp : in  STD_LOGIC;
           outp : out  STD_LOGIC);
end enable_reg;

architecture Behavioral of enable_reg is

begin

process(clk)
  begin
 	if(clk = '1' and clk'event) then
	  
	   outp<=  inp;
	end if;
 end process;


end Behavioral;

